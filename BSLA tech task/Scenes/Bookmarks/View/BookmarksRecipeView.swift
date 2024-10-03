//
//  BookmarksRecipeView.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 10/3/24.
//

import SwiftUI

struct BookmarksRecipeView: View {
    // MARK: - properties
    @StateObject var viewModel: BookmarksRecipeVM
    
    // MARK: - init
    init(offlineDataSource: OfflineRecepiesDataSourceRepo) {
        let dataSource = BookmarksRecipeDataSource(offlineDataSource: offlineDataSource)
        _viewModel = .init(wrappedValue: BookmarksRecipeVM(dataSource: dataSource))
    }
    
    var body: some View {
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
        .onAppear {
            viewModel.getData()
        }
    }
}
