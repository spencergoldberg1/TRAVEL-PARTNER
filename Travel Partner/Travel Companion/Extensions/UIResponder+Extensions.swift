//
//  UIResponder+Extensions.swift
//  Food_Preference
//

import UIKit

extension UIResponder {
    
    /// Returns the UIResponder's parent viewcontroller
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}

