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
    @StateObject var model = Photogrammetry()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("資料夾名稱")
                    .font(.headline)
                TextField("資料夾名稱", text: $folderName)
                    .frame(width: 200)
                Button("選擇") {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = true
                    panel.canChooseFiles = false
                    if panel.runModal() == .OK {
                        self.folderName = panel.url?.lastPathComponent ?? "<none>"
                    }
                }
            }
            OptionView(name: "精細程度", options: detailLevel, selectedIndex: $detailLevelIndex)
            OptionView(name: "表面紋路", options: featureSensitivity, selectedIndex: $featureSensitivityIndex)
            OptionView(name: "照片順序", options: sampleOrder, selectedIndex: $sampleOrdingIndex)
            
            HStack {
                Button("開始建模") {
                    model.folder = folderName
                    model.detail = Photogrammetry.Request.Detail(rawValue: detailLevelIndex)!
                    if featureSensitivityIndex == 0 {
                        model.featureSensitivity = .normal
                    } else {
                        model.featureSensitivity = .high
                    }
                    
                    if sampleOrdingIndex == 0 {
                        model.sampleOrdering = .sequential
                    } else {
                        model.sampleOrdering = .unordered
                    }
                    
                    let queue = DispatchQueue(label: "come.osensetech.modeling")
                    queue.async {
                        model.run()
                    }
                }
                Button("停止") {
                    model.cancel()
                }
            }
            
            Text("處理進度：\(model.fractionComplete * 100) %")
            Text(model.message)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}