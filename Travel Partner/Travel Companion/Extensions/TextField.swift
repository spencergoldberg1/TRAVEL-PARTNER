//
//  TextField.swift
//  Food_Preference
//
//  Created by Peter Khouly on 7/15/21.
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder()
                .opacity(shouldShow ? 1 : 0)
                .animation(.none)
            
            self
        }
    }
}
