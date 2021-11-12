//
//  DirectoryView.swift
//  ObjectCaptureModeling
//
//  Created by Mac mini on 2021/11/9.
//

import SwiftUI

enum ImageSource: String, CaseIterable {
    case googleDrive = "Google Drive"
    case local = "本機"
}

struct DirectoryView: View {
    
    @Binding var imageSource: ImageSource
    @Binding var folderName: String

    var body: some View {
        VStack(alignment: .leading) {
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
            Picker(selection: $imageSource, label: Text("圖片來源").font(.headline)) {
                ForEach(ImageSource.allCases, id:\.self) { option in
                    Text(option.rawValue)
                }
            }
            .pickerStyle(.radioGroup)
        }
    }
    
}

struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryView(imageSource: .constant(.googleDrive), folderName: .constant(""))
    }
}
