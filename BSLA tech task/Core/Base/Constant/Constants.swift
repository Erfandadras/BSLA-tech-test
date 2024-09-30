//
//  Constants.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//

import UIKit

struct K {
    struct size {
        static var bounds = UIScreen.main.bounds
        static var portrait: CGSize {
            let width = bounds.width > bounds.height ? bounds.height : bounds.width
            let height = bounds.width > bounds.height ? bounds.width : bounds.height
            return CGSize(width: width, height: height)
        }
        
        static var landscape: CGSize {
            let width = bounds.width > bounds.height ? bounds.height : bounds.width
            let height = bounds.width > bounds.height ? bounds.width : bounds.height
            return CGSize(width: height, height: width)
        }
    }
}
