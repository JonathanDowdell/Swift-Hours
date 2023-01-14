//
//  View+Etx.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/13/23.
//

import SwiftUI

extension View {
    func pressAction(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(PressActions(onPress: {
            onPress()
        }, onRelease: {
            onRelease()
        }))
    }
}
