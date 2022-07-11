//
//  DummyUIView+Customizer.swift
//  Food_Preference
//
//  Created by Zachary Goldstein on 8/11/21.
//  Copyright © 2021 Cocobolo Group. All rights reserved.
//

import SwiftUI
import UIKit

class DummyUIView: UIView {
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

struct DummyUIViewRepresentable<T: UIView>: UIViewRepresentable {
    let customization: (T) -> Void
    private let tag = UUID().hashValue
    
    func makeUIView(context: Context) -> DummyUIView {
        let dummyView = DummyUIView()
        dummyView.accessibilityLabel = "DummmyUIView"
        dummyView.tag = tag
        return dummyView
    }
    
    func updateUIView(_ uiView: DummyUIView, context: UIViewRepresentableContext<Self>) {
        // We must wait for view hierarchy to be fully built before finding the sibling view
        DispatchQueue.main.async {
            if let sibling = uiView.sibling() as? T {
                customization(sibling)
            }
        }
    }
    
}

extension DummyUIView {
    
    /// Finds and returns the view's next sibling from the view hierarchy
    func sibling<T: UIView>() -> T? {
        guard let rootViews = self.superview?.superview?.subviews else {
            return nil
        }
        
        guard var index = rootViews.firstIndex(where: { $0.subviews.first?.tag == self.tag }) else {
            return nil
        }
        
        index = index.advanced(by: 1)
        
        while index < rootViews.endIndex {
            if let sibling = rootViews[index].subviews.first as? T {
                return sibling
            }
            index = rootViews.index(after: index)
        }
        
        return nil
    }
}
