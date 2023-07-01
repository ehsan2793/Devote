//
//  HideKeyboardExtention.swift
//  Devote
//
//  Created by Ehsan Rahimi on 7/1/23.
//

import SwiftUI

#if canImport(UIKit)
    extension View {
        func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
#endif
