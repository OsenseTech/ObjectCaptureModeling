//
//  SampleOrdering.swift
//  ObjectCaptureModeling
//
//  Created by Mac mini on 2021/11/8.
//

import Foundation

struct SampleOrder: Option {
    let name: String
    let description: String
}

let sampleOrder = [SampleOrder(name: "sequential", description: "Setting to sequential may speed up computation if images are captured in a spatially sequential pattern."),
                   SampleOrder(name: "unordered", description: "無")]
