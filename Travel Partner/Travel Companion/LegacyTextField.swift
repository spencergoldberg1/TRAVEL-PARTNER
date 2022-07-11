//
//  LegacyTextField.swift
//  Travel Companion
//
//  Created by Spencer Goldberg on 7/1/22.
//

import SwiftUI
import UIKit

/// A SwiftUI wrapper around UITextField. Allows for customization directly within the
/// SwiftUI view by calling the completion property `configuration`
///
///     LegacyTextField(text: $tableName) { textField in
///         textField.keyboardType = .numberPad
///         textField.font = UIFont(name: Font.regular_400, size: 17)
///         textField.textColor = .white
///         textField.addToolBarDoneButton()
///         textField.placeholderAttributes(
///             placeholderText: "table number here...",
///             attributes: [
///                 .foregroundColor : UIColor(Colors.textField),
///                 .font : UIFont(name: Font.italic, size: 17)!,
///                 .kern : 0.16
///             ])
///     }
///     .frame(maxWidth: .infinity, maxHeight: 30.pixelsToPoints)
///
struct LegacyTextField: UIViewRepresentable {
    @Binding var text: String
    var onUpdate: ((UITextField) -> Void)? = nil
    let configuration: (UITextField) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        // Make sure to define your own frame in your SwiftUI view
        // using the frame modifier
        let textField = UITextField(frame: .zero)
        configuration(textField)
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChangeSelection(_:)), for: .editingChanged)
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if let onUpdate = onUpdate {
            DispatchQueue.main.async {
                onUpdate(uiView)
            }
        }
        
        uiView.text = self.text
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: LegacyTextField
        
        init(_ parent: LegacyTextField) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            self.parent.text = textField.text ?? ""
        }
    }
}

// MARK: - Convenient Helper Configurations
extension UITextField {
    
    /// Customize the placeholder text
    func placeholderAttributes(placeholderText: String, attributes: [NSAttributedString.Key : Any]) {
        self.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                        attributes: attributes)
    }
    
    /// Adds a toolbar with a done button above the keyboard for a UITextField
    func addToolBarDoneButton() {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolbar
    }
    
    func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry

        if let existingText = text, isSecureTextEntry {
            // When toggling to secure text, all text will be purged if the user
            // continues typing unless we intervene. This is prevented by first
            // deleting the existing text and then recovering the original text.
            deleteBackward()
            
            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }

        // Reset the selected text range since the cursor can end up in the wrong
        // position after a toggle because the text might vary in width
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}

