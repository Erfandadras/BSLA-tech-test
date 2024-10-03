//
//  RecepieListView.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import SwiftUI

struct RecepieListView: View {
    // MARK: - properties
    @StateObject var viewModel: RecepieListVM
    @State var search: String = ""
    private let offlineDataSource: OfflineRecepiesDataSourceRepo
    // MARK: - init
    init() {
        var client: NetworkClient
#if DEBUG
        client = MockRecepieListNetworkClient()
#else
        client = RecepieListNetworkClient() // user for
#endif
        offlineDataSource = OfflineRecepiesDataSource()
        let dataSource = RecepieDataSource(client: client,
                                           offlineDataSource: offlineDataSource)
        let viewModel = RecepieListVM(dataSource: dataSource)
        dataSource.delegate = viewModel
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    // MARK: - view
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack{
                    SwiftUICustomSearchBar(searchText: $search, searching: $viewModel.searching,searchAction: { keyword in
                        viewModel.search(with: keyword)
                    } , filterAction: { keyword in
                        viewModel.filterData(with: keyword)
                    })
                    
                    NavigationLink {
                        BookmarksRecipeView(offlineDataSource: offlineDataSource)
                    } label: {
                        Text("Bookmark")
                    }

                }
                .padding(.horizontal, 24)
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.data) { item in
                            NavigationLink {
                                NavigationLazyView(RecipeDetailView(id: item.id))
                                    
                            } label: {
                                RecepieItemView(data: item) { id in
                                    withAnimation {
                                        viewModel.bookmark(recepie: id)
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }// scrollView
                .refreshable {
                    viewModel.refresh()
                }
            }// Vstack
            .onAppear {
                self.viewModel.getData()
            }
        }
    }
}


// MARK: - search bar
struct SwiftUICustomSearchBar: View {
    @Binding var searchText: String
    @Binding var searching: Bool
    var searchAction: (String) -> Void
    var filterAction: (String) -> Void
    
    var body: some View {
        HStack {
            //
            TextField("", text: $searchText, prompt: Text("Search")
                .foregroundColor(.gray))
            .textCase(.lowercase)
            .onChange(of: searchText, perform: { value in
                withAnimation {
                    filterAction(value)                    
                }
            })
            .font(.system(size: 15))
            .tint(.black)
            .foregroundStyle(.black)
            
            if searching {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                Button {
                    if !searchText.isEmpty {
                        searchAction(searchText)
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                }.tint(.gray)
            }
            
        }
        .padding(.horizontal, 8)
        .frame(alignment: .center)
        .padding(.vertical, 8)
        .background(.gray.opacity(0.25))
        .cornerRadius(8)
    }
}


#Preview {
    RecepieListView()
}
