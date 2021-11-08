//
//  DetailLevel.swift
//  ObjectCaptureModeling
//
//  Created by Mac mini on 2021/11/4.
//

import Foundation

struct DetailLevel: Option {
    let name: String
    let description: String
}

let detailLevel = [DetailLevel(name: "preview", description: "Preview produces as quickly as possible a low-quality geometry to help validate geometry before the more computationally expensive models are produced."),
                   DetailLevel(name: "reduced", description: "Reduced detail optimizes for memory and network transmision bandwidth."),
                   DetailLevel(name: "medium", description: "Medium detail offers a compromise between `.reduced` and `.full`"),
                   DetailLevel(name: "full", description: "Full detail optimizes for the maximal mesh and texture detail the system can produce targeting interactive use."),
                   DetailLevel(name: "raw", description: "For high-end production use cases, raw detail will provide unprocessed assets that allow professional artists using physically-based rendering ray-tracers to achieve maximum quality results.")]
