//
//  CheckBoxStyle.swift
//  Devote
//
//  Created by Ehsan Rahimi on 7/2/23.
//

import SwiftUI

struct CheckBoxStyle: ToggleStyle {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .pink : .gray)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }//: HSTACK
    }
}

// MARK: PREVIEW

struct CheckBoxStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle(isOn: .constant(true), label: {Text("Place Holder")})
            .toggleStyle(CheckBoxStyle())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
