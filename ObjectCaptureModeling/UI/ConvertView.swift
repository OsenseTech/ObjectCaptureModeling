//
//  ConvertView.swift
//  ObjectCaptureModeling
//
//  Created by Mac mini on 2021/11/9.
//

import SwiftUI

struct ConvertView: View {
    
    @Binding var folderName: String
    @State var isConvertGLBEnabled = true
    @State var isConvertUSDZEnabled = true
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle(".glb", isOn: $isConvertGLBEnabled)
            Toggle(".usdz", isOn: $isConvertUSDZEnabled)
            Button("轉檔") {
                if isConvertGLBEnabled {
                    convert2glb(folderName: folderName)
                }
                
                if isConvertUSDZEnabled {
                    convert2usdz(folderName: folderName)
                }
            }
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

func convert2usdz(folderName: String) {
    
}

struct ConvertView_Previews: PreviewProvider {
    static var previews: some View {
        ConvertView(folderName: .constant(""))
    }
}
