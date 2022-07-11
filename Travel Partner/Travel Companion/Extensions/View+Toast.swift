//
//  View+Toast.swift
//  Food_Preference
//
//  Created by Zachary Goldstein on 8/19/21.
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//

import SwiftUI

extension View {
    
    /// Presents a toast with static content that slides down from the top of the screen on top of the navigation bar.
    ///
    ///     struct ToastsExample: View {
    ///         @State var isPresented: Bool = false
    ///         var body: some View {
    ///             Button("Display error toast") {
    ///                 isPresented.toggle()
    ///             }
    ///             .toast($isPresented, role: .error) {
    ///                 Text("An unexpected error has occurred")
    ///                 Image(systemName: "xmark.octagon.fill")
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the toast
    ///   - role: The style of the toast to be presented. Is light gray by default.
    ///   - timeout: The time interval for how long the toast is presented on the screen. Defaults to 3 seconds.
    ///   - label: A closure that returns the label of the toast
    func toast<Label: View>(_ isPresented: Binding<Bool>, role: Toast<Label>.Role = .default, timeout: Double = 3, @ViewBuilder label: @escaping () -> Label) -> some View {
        self.modifier(ToastModifier<AnyEquatable, Label>(isPresented, role: role, timeout: timeout, label: label))
    }
    
    /// Presents a toast using the given item as a data source for the toast's label.
    ///
    ///     struct ToastItemExample: View {
    ///         @State var message: String?
    ///         var body: some View {
    ///             Button("Display error toast") {
    ///                 message = "John has acknowledged your request"
    ///             }
    ///             .toast(item: $message, timeout: 5) { item in
    ///                 Text(item)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the toast.
    ///     When `item` is non-`nil`, the system passes the item's content to
    ///     the modifier's closure. You display this content in a toast that you
    ///     create that the system displays to the user. if the `item` is set to `nil`
    ///     while the toast is presenting, it will be dismissed.
    ///   - role: The style of the toast to be presented. Is light gray by default.
    ///   - timeout: The time interval for how long the toast is presented on the screen. Defaults to 3 seconds.
    ///   - label: A closure that returns the label of the toast
    func toast<Item: Equatable, Label: View>(item: Binding<Item?>, role: Toast<Label>.Role = .default, timeout: Double = 3, label: @escaping (Item) -> Label) -> some View {
        self.modifier(ToastModifier<Item, Label>(item: item, role: role, timeout: timeout, label: label))
    }
}

private struct AnyEquatable: Equatable {}

private struct ToastModifier<Item: Equatable, Label: View>: ViewModifier {
    
    @Environment(\.viewController) private var vc
    
    @Binding private var isPresented: Bool
    @Binding private var item: Item?
    @State private var toast: Toast<Label>?
    @State private var delegate: ToastTransitionController? = nil
    
    private var role: Toast<Label>.Role
    private var timeout: Double
    private var label: (Item) -> Label
    
    init(item: Binding<Item?>, role: Toast<Label>.Role, timeout: Double, @ViewBuilder label: @escaping (Item) -> Label) {
        self._isPresented = Binding(
            get: { item.wrappedValue != nil ? true : false },
            set: {
                if !$0 {
                    item.wrappedValue = nil
                }
            }
        )
        
        self.role = role
        self.timeout = timeout
        self._item = item
        self.label = label
        
        if let item = item.wrappedValue {
            self._toast = .init(initialValue: Toast(role: role, timeout: timeout, label: { label(item) }))
        }
    }
    
    init(_ isPresented: Binding<Bool>, role: Toast<Label>.Role, timeout: Double, @ViewBuilder label: @escaping () -> Label) {
        self._isPresented = isPresented
        self.role = role
        self.timeout = timeout
        self._item = .constant(nil)
        self.label = { _ in label() }
        self._toast = .init(initialValue: Toast(role: role, timeout: timeout, label: label))
    }
    
    func body(content: Content) -> some View {
        Group {
            content
                .onChange(of: item) { value in
                    if let value = value {
                        self.toast = .init(role: role, timeout: timeout, label: { label(value) })
                    }
                }
                .onChange(of: isPresented) { value in
                    if value {
                        
                        self.delegate = ToastTransitionController()
                        
                        if let toast = toast, let delegate = delegate {
                            if vc?.presentedViewController != nil && !(vc?.isBeingDismissed ?? true) {
                                vc?.dismiss(animated: true) {
                                    vc?.present(delegate: delegate) {
                                        toast
                                            .onDisappear {
                                                isPresented = false
                                                self.delegate = nil
                                            }
                                    }
                                }
                            }
                            else {
                                vc?.present(delegate: delegate) {
                                    toast
                                        .onDisappear {
                                            isPresented = false
                                            self.delegate = nil
                                        }
                                }
                            }
                        }
                    }
                    else if !(vc?.presentedViewController?.isBeingPresented ?? false) {
                        vc?.dismiss(animated: true) { self.delegate = nil }
                    }
                }
        }
    }
}
