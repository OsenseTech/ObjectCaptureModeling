//
//  BindingExtension.swift
//  ObjectCaptureModeling
//
//  Created by Mac mini on 2021/11/12.
//

import Foundation
import SwiftUI

extension Binding {
    
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
    
}
