//
//  ConvertView.swift
//  ObjectCaptureModeling
//
//  Created by Mac mini on 2021/11/9.
//

import SwiftUI

struct ConvertView: View {
    
    @Binding var folderPath: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("轉檔") {
                convert2glb(folderPath: folderPath)
            }
        }
    }
    
}

func convert2glb(folderPath: String) {
    let arguments = ["/opt/homebrew/bin/obj2gltf", "-i", "\(folderPath)/baked_mesh.obj", "-o", "\(folderPath)/baked_mesh.glb"]
    
    do {
        try Process.execute("/opt/homebrew/bin/node", arguments: arguments)
    } catch {
        print("發生錯誤：\(error.localizedDescription)")
    }
}

struct ConvertView_Previews: PreviewProvider {
    static var previews: some View {
        ConvertView(folderPath: .constant(""))
    }
}
