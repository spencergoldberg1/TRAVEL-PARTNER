//
//  View+Customizer.swift
//  Food_Preference
//
//  Created by Zachary Goldstein on 8/11/21.
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//

import SwiftUI

extension View {
    
    /// Injects a dummy `UIView` into the view hierarchy in order to find a SwiftUI's underlying UIKit component
    ///
    /// This function accesses the UIKit component by searching through the view hierarchy and relies on the hierarchy to
    /// be built in a specific order. This could break in future versions of SwiftUI if Apple changes how the view hierarchy is built.
    /// Only tested for SwiftUI's `TextField` and `TextField`. Note that most SwiftUI components do not use a UIKit component under
    /// the hood, such as the `Text`, `Image`, and `Button` components. In this case, this function will not work for
    /// those SwiftUI components.
    func customize<T: UIView>(_ customization: @escaping (T) -> Void) -> some View {
        return self.background(
            DummyUIViewRepresentable(customization: customization)
        )
    }
}

extension TextField {
    
    /// Extra helper function for the customize function so you don't have to specify the UIKit component
    /// being targeted. Must be first modifier chained to the `TextField`.
    func customize(_ customization: @escaping (UITextField) -> Void) -> some View {
        return self.background(
            DummyUIViewRepresentable(customization: customization)
        )
    }
}

extension TextEditor {
    /// Extra helper function for the customize function so you don't have to specify the UIKit component
    /// being targeted. Must be first modifier chained to the `TextEditor`.
    func customize(_ customization: @escaping (UITextView) -> Void) -> some View {
        return self.background(
            DummyUIViewRepresentable(customization: customization)
        )
    }
}
