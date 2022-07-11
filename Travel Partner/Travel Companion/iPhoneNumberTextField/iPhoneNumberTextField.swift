//
//  iPhoneNumberTextField.swift
//  Food_Preference
//
//  Created by Zachary Goldstein on 8/26/21.
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//

import SwiftUI
import UIKit
import PhoneNumberKit

class PhoneNumberTextFieldWithPadding: PhoneNumberTextField {
    var textPadding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}

struct iPhoneNumberTextField: UIViewRepresentable {
    private typealias Colors = Constants.Colors.Views.iPhoneNumberTextField
    
    @Binding var text: String
    @Binding var isValidNumber: Bool
    let makeUIVIew: (PhoneNumberTextFieldWithPadding) -> Void
    @State private var selectedRegion: Region?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PhoneNumberTextField {
        let textField = PhoneNumberTextFieldWithPadding()
        textField.textColor = UIColor(Colors.textColor)
        textField.layer.cornerRadius = 8
        textField.withExamplePlaceholder = true
        //textField.numberPlaceholderColor = UIColor.gray
        textField.withFlag = false
        textField.delegate = context.coordinator
        textField.withPrefix = false
        textField.tintColor = .black
        textField.withDefaultPickerUI = false
        textField.isPartialFormatterEnabled = true
        textField.text = text
        textField.attributedPlaceholder = NSAttributedString(
            string: "(201) 555-0123",
            attributes: [NSAttributedString.Key.foregroundColor: Constants.Colors.placeholder]
        )
        textField.textContentType = .telephoneNumber
        
        // flagButton
        let flagButton = UIHostingController(
            rootView:
                FlagButton(selectedRegion: $selectedRegion) {
                    updateUIView(textField, context: context)
                }
        )

        flagButton.view.frame = CGRect(x: 0, y: 0, width: 58, height: 56)
        textField.leftViewMode = .always
        textField.leftView = flagButton.view
        textField.leftView?.backgroundColor = .clear
        
        DispatchQueue.main.async { [weak textField] in
            guard let textField = textField else { return }
            
            if let dialCode = textField.phoneNumberKit.countryCode(for: textField.currentRegion) {
                self.selectedRegion = Region(code: textField.currentRegion, dialCode: dialCode)
            }
        }
        
        makeUIVIew(textField)
        
        return textField
    }
    
    func updateUIView(_ textField: PhoneNumberTextField, context: Context) {
        DispatchQueue.main.async { [weak textField] in
            guard let textField = textField else { return }
            guard let selectedRegion = selectedRegion else { return }
            guard textField.partialFormatter.defaultRegion != selectedRegion.code else { return }
            
            textField.partialFormatter.defaultRegion = selectedRegion.code
            textField.text = ""
            text = ""
            textField.updatePlaceholder()
            textField.attributedPlaceholder = NSAttributedString(
                string: "(201) 555-0123",
                attributes: [NSAttributedString.Key.foregroundColor: Constants.Colors.placeholder]
            )
        }
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: iPhoneNumberTextField
        
        init(_ parent: iPhoneNumberTextField) {
            self.parent = parent
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let textField = textField as? PhoneNumberTextField else { return true }
            
            var finalText: String
            
            if string.isEmpty {
                finalText = textField.text?.dropLast(range.length).description ?? ""
            }
            else {
                finalText = (textField.text ?? "") + string
            }
            
            let isValidNumber = textField.phoneNumberKit.isValidPhoneNumber(
                finalText,
                withRegion: textField.partialFormatter.defaultRegion
            )
            
            if isValidNumber,
               !finalText.starts(with: "+"),
               let dialCode = textField.phoneNumberKit.countryCode(for: textField.partialFormatter.defaultRegion) {
                finalText = "+\(dialCode) \(finalText)"
            }
                        
            parent.text = finalText
            parent.isValidNumber = isValidNumber
            
            return true
        }
    }
}

private struct FlagButton: View {
    private typealias Colors = Constants.Colors.Views.iPhoneNumberTextField.FlagButton
    
    @Binding var selectedRegion: Region?
    let onSelectedChange: () -> Void
    
    @State private var isPresented = false
    
    var body: some View {
        Button(action: { isPresented.toggle() }) {
            HStack(spacing: 0) {
                if let selectedRegion = selectedRegion {
                    Text(selectedRegion.flagEmoji)
                        .font(.system(size: 30))
                }
                
                Image(systemName: "chevron.down")
                    .foregroundColor(Colors.chevronIconColor)
                    .font(.system(size: 10))
            }
            .frame(maxWidth: 58, maxHeight: .infinity)
            .background(Color(.white))
            .cornerRadius(8, corners: [.bottomLeft, .topLeft])
        }
        .fullScreenCover(isPresented: $isPresented) {
            RegionPicker(selection: $selectedRegion)
        }
        .onChange(of: selectedRegion) { _ in
            onSelectedChange()
        }
    }
}
