//
//  ContentView.swift
//  ObjectCaptureModeling
//
//  Created by Mac mini on 2021/11/4.
//

import SwiftUI

struct ContentView: View {
    
    @State var folderName = ""
    @State var detailLevelIndex: Int = 0
    @State var featureSensitivityIndex: Int = 0
    @State var sampleOrdingIndex: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            DirectoryView(folderName: $folderName)
            
            OptionView(name: "精細程度", options: detailLevel, selectedIndex: $detailLevelIndex)
            OptionView(name: "表面紋路", options: featureSensitivity, selectedIndex: $featureSensitivityIndex)
            OptionView(name: "照片順序", options: sampleOrder, selectedIndex: $sampleOrdingIndex)
            
            ModelingView(folderName: folderName, detailLevelIndex: detailLevelIndex, featureSensitivityIndex: featureSensitivityIndex, sampleOrdingIndex: sampleOrdingIndex)
            ConvertView(folderName: $folderName)
        }
        .padding()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
    }
}
