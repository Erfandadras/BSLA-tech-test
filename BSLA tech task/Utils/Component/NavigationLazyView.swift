//
//  NavigationLazyView.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 10/3/24.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
