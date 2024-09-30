//
//  RecepieListView.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import SwiftUI

struct RecepieListView: View {
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(0...40, id: \.description) { index in
                        RecepieItemView(data: .init(name: "title \(index)",
                                                    description: "description \(index)"))
                    }
                }
            }// scrollView
        }// Vstack
    }
}

#Preview {
    RecepieListView()
}
