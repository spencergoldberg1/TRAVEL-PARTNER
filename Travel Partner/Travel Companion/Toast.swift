//
//  Toast.swift
//  Travel Companion
//
//  Created by Spencer Goldberg on 7/1/22.
//

//
//  Toast.swift
//  Food_Preference
//
//  Created by Zachary Goldstein on 8/19/21.
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//

import SwiftUI

struct Toast<Label: View>: View {
    typealias Colors = Constants.Colors.Views.Toast
    
    enum Role: Equatable {
        case `default`
        case success
        case warning
        case destructive, error
        case custom(bgColor: Color, textColor: Color)
        
        func get() -> (bgColor: Color, textColor: Color) {
            switch self {
            case .default:
                return (bgColor: Colors.Default.backgroundColor, textColor: Colors.Default.textColor)
                
            case .success:
                return (bgColor: Colors.Success.backgroundColor, textColor: Colors.Success.textColor)
                
            case .warning:
                return (bgColor: Colors.Warning.backgroundColor, textColor: Colors.Warning.textColor)
                
            case .destructive, .error:
                return (bgColor: Colors.Error.backgroundColor, textColor: Colors.Error.textColor)
                
            case .custom(bgColor: let bgColor, textColor: let textColor):
                return (bgColor: bgColor, textColor: textColor)
            }
        }
    }
        
    @Environment(\.viewController) var vc
    
    private let timeout: Double
    private let bgColor: Color
    private let textColor: Color
    @ViewBuilder var label: Label
    
    init(role: Role, timeout: Double, @ViewBuilder label: @escaping () -> Label) {
        let roleValues = role.get()
        self.bgColor = roleValues.bgColor
        self.textColor = roleValues.textColor
        self.timeout = timeout
        self.label = label()
    }
        
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(bgColor)
                        .shadow(color: Colors.shadow, radius: 3, x: 0, y: 3)
                    
                    HStack {
                        label
                            .minimumScaleFactor(0.8)
                            .foregroundColor(textColor)
                            .font(.system(size: 17, weight: .medium))
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 10)
                }
                .gesture(
                    DragGesture()
                        .onEnded { _ in
                            if !(vc?.isBeingDismissed ?? false) {
                                vc?.dismiss(animated: true)
                            }
                        }
                )
            }
            .frame(width: UIScreen.main.bounds.width * 0.90, height: 49)
        }
        .onAppear {
            guard timeout > 0 else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
                vc?.dismiss(animated: true)
            }
        }
    }
}

