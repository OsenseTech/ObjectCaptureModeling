//
//  DirectoryView.swift
//  ObjectCaptureModeling
//
//  Created by Mac mini on 2021/11/9.
//

import SwiftUI

struct DirectoryView: View {
    
    @Binding var folderName: String

    var body: some View {
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
    }
    
}

struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryView(folderName: .constant(""))
    }
}
