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
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
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
                
                VStack(alignment: .leading) {
                    Text(data.name)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(data.description)
                        .font(.title2)
                        .multilineTextAlignment(.leading)
                }// text VStacl
                .frame(maxWidth: .infinity)
            }//Hstack
            .padding()
            .frame(maxWidth: .infinity)
            
        } // VStack
    }
}
