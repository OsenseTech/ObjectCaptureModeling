//
//  ContentView.swift
//  ObjectCaptureModeling
//
//  Created by Mac mini on 2021/11/4.
//

import SwiftUI

struct ContentView: View {
    
    @State var detailLevel: DetailLevel = .preview
    @State var folderName = ""
    @StateObject var model = Photogrammetry()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("資料夾名稱")
                TextField("資料夾名稱", text: $folderName, prompt: Text("folderName"))
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
            Text("\(model.fractionComplete)")
            Button("開始建模") {
                model.folder = folderName
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
