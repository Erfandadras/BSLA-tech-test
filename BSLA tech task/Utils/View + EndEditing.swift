//
//  View + EndEditing.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 10/4/24.
//

import SwiftUI

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
