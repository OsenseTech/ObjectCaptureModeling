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
    @State var isAutoConvertEnabled: Bool = false
    @StateObject var model = Photogrammetry()
    private let queue = DispatchQueue(label: "come.osensetech.modeling")
    
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
                    configModel()
                    queue.async {
                        model.run()
                    }
                }
                Toggle("生成模型完接著轉檔", isOn: $isAutoConvertEnabled)
                Spacer()
                Button("停止") {
                    model.cancel()
                }
            }
            Button("轉檔") {
                convert2glb(folderName: folderName)
            }
            Divider()
            Text("處理進度：\(model.fractionComplete * 100) %")
            Text(model.message)
        }
        .padding()
        .onReceive(model.$isCompleted) { _ in
            if isAutoConvertEnabled && model.isCompleted {
                convert2glb(folderName: folderName)
            }
        }
    }
    
    func convert2glb(folderName: String) {
        let path = "/Users/macmini/Pictures/ObjectCapture/\(folderName)"
        let arguments = ["/opt/homebrew/bin/obj2gltf", "-i", "\(path)/baked_mesh.obj", "-o", "\(path)/baked_mesh.glb"]
        
        do {
            try Process.execute("/opt/homebrew/bin/node", arguments: arguments)
        } catch {
            print("發生錯誤：\(error.localizedDescription)")
        }
    }
    
    func configModel() {
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
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
    }
}
