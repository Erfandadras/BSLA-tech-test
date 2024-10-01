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
    // MARK: - init
    init() {
        let client = RecepieListNetworkClient()
        let mockClient = MockRecepieListNetworkClient()
        let dataSource = RecepieDataSource(client: mockClient)
        _viewModel = .init(wrappedValue: RecepieListVM(dataSource: dataSource))
    }
    
    // MARK: - view
    var body: some View {
        VStack {
            Spacer()
            SwiftUICustomSearchBar(searchText: $search, searching: $viewModel.searching,searchAction: { keyword in
                viewModel.search(with: keyword)
            } , filterAction: { keyword in
                viewModel.filterData(with: keyword)
            })
            .padding(.horizontal, 24)
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.data) { item in
                        RecepieItemView(data: item) { id in
                            
                        }
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
