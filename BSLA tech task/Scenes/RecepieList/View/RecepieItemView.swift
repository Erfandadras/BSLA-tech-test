//
//  RecepieItemView.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecepieItemView: View {
    let data: UIRecepieItemModel
    var bookmarkAction: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 12) {
                WebImage(url: data.imageURL) { image in
                    image.resizable()
                        .cornerRadius(8)
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
                .frame(maxWidth: 120)
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 14) {
                    Text(data.name)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(data.description)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                }// text VStacl
                .frame(maxWidth: .infinity)
                
                Button {
                    bookmarkAction(data.id)
                } label: {
                    Image(systemName: data.bookmark ? "bookmark.fill" : "bookmark")
                }
                .tint(.gray)

            }//Hstack
            .padding()
            .frame(maxWidth: .infinity)
            
        } // VStack
    }
}

#Preview {
    RecepieItemView(data: .init(id: 0, name: "name", description: "description")) { _ in
        
    }
}
