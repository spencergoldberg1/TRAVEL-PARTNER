//
//  Text.swift
//  Food_Preference
//
//  Created by Spencer Goldberg on 4/4/22.
//  Copyright © 2022 Cocobolo Group. All rights reserved.
//

import SwiftUI

extension Text {

    func SFProDisplayText43(color: Color?) -> some View {
        self.foregroundColor(color)
            .font(.system(size: 43, weight: .bold))
    }
    
    func SFProDisplayText36(color: Color?) -> some View {
        self.foregroundColor(color)
            .font(.system(size: 36, weight: .medium))
    }
    
    func subheader(color: Color?) -> some View {
        self.foregroundColor(color)
            .font(.system(size: 30, weight: .medium))
    }
    
    func body(color: Color?) -> some View {
        self.foregroundColor(color)
            .font(.system(size: 25, weight: .regular))
    }
    
    func body2(color: Color?) -> some View {
        self.foregroundColor(color)
            .font(.system(size: 20, weight: .regular))
    }
    
    func body3(color: Color?) -> some View {
        self.foregroundColor(color)
            .font(.system(size: 17, weight: .semibold))
    }
    
    func buttons(color: Color?) -> some View {
        self.foregroundColor(color)
            .font(.system(size: 17, weight: .regular))
    }
}
