//
//  ContentView.swift
//  ObjectCaptureModeling
//
//  Created by Mac mini on 2021/11/4.
//

import SwiftUI

struct ContentView: View {
    
    @State var imageSource: ImageSource = .googleDrive
    @State var folderName = ""
    @State var folderPath = ""
    @State var detailLevelIndex: Int = 0
    @State var featureSensitivityIndex: Int = 0
    @State var sampleOrdingIndex: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            DirectoryView(imageSource: $imageSource.onChange(changeImageSource), folderName: $folderName.onChange(changeFolderName))
            
            OptionView(name: "精細程度", options: detailLevel, selectedIndex: $detailLevelIndex)
            OptionView(name: "表面紋路", options: featureSensitivity, selectedIndex: $featureSensitivityIndex)
            OptionView(name: "照片順序", options: sampleOrder, selectedIndex: $sampleOrdingIndex)
            
            ModelingView(detailLevelIndex: detailLevelIndex,
                         featureSensitivityIndex: featureSensitivityIndex,
                         sampleOrdingIndex: sampleOrdingIndex,
                         folderPath: $folderPath)
            ConvertView(folderPath: $folderPath)
        }
        .padding()
    }
    
    private func changeImageSource(_ source: ImageSource) {
        if source == .googleDrive {
            folderPath = "/Users/macmini/Google Drive/我的雲端硬碟/3D建模照片上傳/\(folderName)"
        } else {
            folderPath = "/Users/macmini/Pictures/ObjectCapture/\(folderName)"
        }
    }
    
    private func changeFolderName(_ folderName: String) {
        if imageSource == .googleDrive {
            folderPath = "/Users/macmini/Google Drive/我的雲端硬碟/3D建模照片上傳/\(folderName)"
        } else {
            folderPath = "/Users/macmini/Pictures/ObjectCapture/\(folderName)"
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
    }
}
