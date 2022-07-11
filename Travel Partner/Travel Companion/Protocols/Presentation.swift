//
//  Presentation.swift
//  Food_Preference
//

import SwiftUI

/// Conforms a `View` to the `Presentation` protocol
///
/// Any modals or popups that use `View/present<Modal>(isPresented:content:)`
/// must conform to this protocol
protocol Presentation: View {
    var onDismiss: () -> Void { get set }
}
