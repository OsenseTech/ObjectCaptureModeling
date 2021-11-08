//
//  OptionView.swift
//  ObjectCaptureModeling
//
//  Created by Mac mini on 2021/11/8.
//

import SwiftUI

protocol Option: Hashable {
    var name: String { get }
    var description: String { get }
}

struct OptionView<T: Option>: View {
    
    var name: String
    var options: [T]
    @Binding var selectedIndex: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Picker(selection: $selectedIndex, label: Text(name).font(.headline)) {
                ForEach(options.indices) { index in
                    Text(options[index].name)
                }
            }
            .pickerStyle(.radioGroup)
            
            Text(options[selectedIndex].description)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
        }
    }
}

struct OptionView_Previews: PreviewProvider {
    static var previews: some View {
        OptionView(name: "detail level", options: detailLevel, selectedIndex: .constant(0))
    }
}
