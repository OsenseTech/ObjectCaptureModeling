//
//  ProcessExtension.swift
//  ObjectCaptureModeling
//
//  Created by Mac mini on 2021/11/8.
//

import Foundation

extension Process {
    
    public static func execute(_ command: String, arguments: [String]) throws {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: command)
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        do {
            try task.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: String.Encoding.utf8) {
                print(output)
            }
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
}
