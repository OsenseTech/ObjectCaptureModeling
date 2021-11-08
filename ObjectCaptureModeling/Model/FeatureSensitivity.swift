//
//  FeatureSensitivity.swift
//  ObjectCaptureModeling
//
//  Created by Mac mini on 2021/11/8.
//

import Foundation

struct FeatureSensitivity: Option {
    let name: String
    let description: String
}

let featureSensitivity = [FeatureSensitivity(name: "normal", description: "無"),
                          FeatureSensitivity(name: "high", description: "Set to high if the scanned object does not contain a lot of discernible structures, edges or textures.")]
