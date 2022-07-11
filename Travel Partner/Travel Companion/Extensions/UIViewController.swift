//
//  UIViewController.swift
//  Food_Preference
//
//  Created by Jonathan Yataco  on 6/10/21.
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//

import UIKit
import SwiftUI

extension UIViewController {
    /// Used to present the passed in SwiftUI over all other elements of the app. Good for modals.
    func present<Content: View>(style: UIModalPresentationStyle = .automatic, transitionStyle: UIModalTransitionStyle = .coverVertical, @ViewBuilder builder: () -> Content) {
        let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
        toPresent.modalPresentationStyle = style
        toPresent.modalTransitionStyle = transitionStyle
        toPresent.rootView = AnyView(
            builder()
                .environment(\.viewController, toPresent)
        )
        
        toPresent.view.backgroundColor = .clear
        self.present(toPresent, animated: true, completion: nil)
    }
    
    /// Present a modal using a custom transitioning delegate
    func present<Content: View>(delegate: UIViewControllerTransitioningDelegate, @ViewBuilder builder: () -> Content) {
        let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
        toPresent.modalPresentationStyle = .custom
        toPresent.transitioningDelegate = delegate
        debugPrint(builder())
        toPresent.rootView = AnyView(
            builder()
                .environment(\.viewController, toPresent)
        )
        self.present(toPresent, animated: true, completion: nil)
    }
}
