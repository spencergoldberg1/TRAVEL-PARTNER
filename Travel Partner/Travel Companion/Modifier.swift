//
//  Modifier.swift
//  Travel Companion
//
//  Created by Spencer Goldberg on 7/1/22.
//

import SwiftUI

/// Presents a modal to the user over the current view.
///
/// See `View/present<Modal>(isPresented:modal:)` for more details on
/// how to present a modal.
struct PresentModifier<Modal: View>: ViewModifier {
    @Environment(\.viewController) private var viewController: UIViewController?
    
    @Binding var isPresented: Bool
    let style: UIModalPresentationStyle
    let transitionStyle: UIModalTransitionStyle
    let modal: Modal
    
    init(style: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle, isPresented: Binding<Bool>, modal: Modal) {
        self.modal = modal
        self._isPresented = isPresented
        self.style = style
        self.transitionStyle = transitionStyle
    }
    
    private func present<Modal: View>(style: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle, _ modal: @escaping () -> Modal) {
        self.viewController?.present(style: style, transitionStyle: transitionStyle, builder: modal)
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .onChange(of: isPresented) { value in
                    if value {
                        present(style: style, transitionStyle: transitionStyle) {
                            modal.onDisappear {
                                self.isPresented = false
                            }
                        }
                    }
                }
        }
    }
}

