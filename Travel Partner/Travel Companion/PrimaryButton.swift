//
//  PrimaryButton.swift
//  Travel Companion
//
//  Created by Spencer Goldberg on 7/1/22.
//

import SwiftUI

struct PrimaryButton: View {
    let textColor: Color
    let backgroundColor: Color
    let text: String
    let action: () -> ()
    
    init(
        textColor: Color = Constants.Colors.Buttons.Primary.textColor,
        backgroundColor: Color = Constants.Colors.Buttons.Primary.backgroundColor,
        text: String,
        action: @escaping () -> ()
    ) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.text = text
        self.action = action
    }
    
    @Environment(\.isEnabled) private var isEnabled
    
    private var computedBackgroundColor: SwiftUI.Color {
        isEnabled ?
        Constants.Colors.Buttons.Primary.backgroundColor :
            Constants.Colors.Buttons.Primary.disabledBackgroundColor
    }
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 17, weight: .semibold))
                .frame(minWidth: 0, maxWidth: .infinity)
        }
        .frame(height: 48)
        .foregroundColor(textColor)
        .background(computedBackgroundColor)
        .cornerRadius(10)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PrimaryButton(text: "Save") { }
            PrimaryButton(text: "Save") { }
                .disabled(true)
        }
        .fixedSize(horizontal: false, vertical: true)
        .previewLayout(PreviewLayout.sizeThatFits)
    }
}

