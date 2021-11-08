//
//  ContentView.swift
//  ObjectCaptureModeling
//
//  Created by Mac mini on 2021/11/4.
//

import SwiftUI

struct ContentView: View {
    
    @State var folderName = ""
    @State var detailLevel: DetailLevel = .preview
    @State var featureSensitivity: FeatureSensitivity = .normal
    @State var sampleOrding: SampleOrdering = .sequential
    @StateObject var model = Photogrammetry()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("資料夾名稱")
                    .font(.headline)
                TextField("資料夾名稱", text: $folderName, prompt: Text(""))
                    .frame(width: 200)
                Button("選擇資料夾") {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = true
                    panel.canChooseFiles = false
                    if panel.runModal() == .OK {
                        self.folderName = panel.url?.lastPathComponent ?? "<none>"
                    }
                }
            }
            HStack {
                Picker(selection: $detailLevel, label: Text("精細程度").font(.headline)) {
                    ForEach(DetailLevel.allCases, id: \.self) { detailLevel in
                        Text(detailLevel.rawValue)
                    }
                }
                .pickerStyle(.radioGroup)
            }
            
            HStack {
                Picker(selection: $featureSensitivity, label: Text("表面紋路").font(.headline)) {
                    ForEach(FeatureSensitivity.allCases, id: \.self) { featureSensitivity in
                        Text(featureSensitivity.rawValue)
                    }
                }
                .pickerStyle(.radioGroup)
            }
            
            HStack {
                Picker(selection: $sampleOrding, label: Text("照片順序").font(.headline)) {
                    ForEach(SampleOrdering.allCases, id: \.self) { ordering in
                        Text(ordering.rawValue)
                    }
                }
                .pickerStyle(.radioGroup)
            }
            
            Text("完成比例：\(model.fractionComplete)")
            Button("開始建模") {
                model.folder = folderName
                switch detailLevel {
                case .preview:
                    model.detail = .preview
                case .reduced:
                    model.detail = .reduced
                case .medium:
                    model.detail = .medium
                case .full:
                    model.detail = .full
                case .raw:
                    model.detail = .raw
                }
                switch featureSensitivity {
                case .normal:
                    model.featureSensitivity = .normal
                case .high:
                    model.featureSensitivity = .high
                }
                switch sampleOrding {
                case .sequential:
                    model.sampleOrdering = .sequential
                case .unordered:
                    model.sampleOrdering = .unordered
                }
                model.run()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
