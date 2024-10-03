//
//  RecipeDetailView.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 10/2/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeDetailView: View {
    @StateObject private var viewModel: RecipeDetailVM

    // MARK: - init
    init(id: Int) {
        print(id)
        let client = ReipeNetworkClient()
        let mockClient = MockReipeNetworkClient()
        let dataSource = RecipeDetailDataSource(id: id, client: client)
        _viewModel = .init(wrappedValue: RecipeDetailVM(dataSource: dataSource))
    }
    
    var body: some View {
        if let data = viewModel.recepie {
            ScrollView {
                HStack {
                    Spacer()
                    Text(data.name)
                    Spacer()
                }
                
                WebImage(url: data.image) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(1.77, contentMode: .fit)
                        .foregroundColor(.gray)
                }
                .resizable()
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5)) // Fade Transition
                .scaledToFill()
                .aspectRatio(1.77, contentMode: .fit)
                .frame(maxWidth: .infinity)
                VStack(spacing: 16) {
                    HStack {
                        Text(data.serving)
                        Spacer()
                        Text(data.beReadyIn)
                        Spacer()
                    }
                    //                    .frame(maxWidth: K.size.bounds.width)
                    
                    Text(data.detail)
                }// detail stack
                .padding()
                
                HStack {
                    Text("Ingredients")
                        .font(.title)
                    Spacer()
                }.padding(.horizontal)
                
                LazyVStack {
                    ForEach(0...10, id: \.hashValue) { i in
                        HStack{
                            Text("index \(i)")
                            Spacer()
                        }
                    }
                }
                .padding()
            }// ScrollView
        } else {
            ProgressView()
                .progressViewStyle(.circular)
                .onAppear {
                    viewModel.loadData()
                }
        }
    }
}
