//
//  ModelingView.swift
//  ObjectCaptureModeling
//
//  Created by Mac mini on 2021/11/9.
//

import SwiftUI

struct ModelingView: View {
    
    var detailLevelIndex = 0
    var featureSensitivityIndex = 0
    var sampleOrdingIndex = 0
    @Binding var folderPath: String
    @State var isAutoConvertEnabled: Bool = false
    @StateObject var model = Photogrammetry()
    
    private let queue = DispatchQueue(label: "come.osensetech.modeling")
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button("開始建模") {
                    configModel()
                    queue.async {
                        model.run()
                    }
                }
                Toggle("生成模型後接著轉 .glb", isOn: $isAutoConvertEnabled)
                Spacer()
                Button("停止") {
                    model.cancel()
                }
            }
            Text("處理進度：\(model.fractionComplete * 100) %")
            Text(model.message)
        }
        .onReceive(model.$isCompleted) { _ in
            if isAutoConvertEnabled && model.isCompleted {
                convert2glb(folderPath: folderPath)
            }
        }
    }
    
    func configModel() {
        model.folderPath = folderPath
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

struct ModelingView_Previews: PreviewProvider {
    static var previews: some View {
        ModelingView(folderPath: .constant(""))
    }
}
