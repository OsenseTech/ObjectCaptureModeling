//
//  Photogrammetry.swift
//  ObjectCaptureModeling
//
//  Created by Mac mini on 2021/11/5.
//

import Foundation
import RealityKit
import os
import SwiftUI

private let logger = Logger(subsystem: "com.apple.sample.photogrammetry",
                            category: "Photogrammetry")

class Photogrammetry: ObservableObject {
    
    typealias Configuration = PhotogrammetrySession.Configuration
    typealias Request = PhotogrammetrySession.Request
    
    var folderPath: String = ""
        
    var detail: Request.Detail = .preview
    
    var featureSensitivity: Configuration.FeatureSensitivity = .normal
    
    var sampleOrdering: Configuration.SampleOrdering = .sequential
    
    @Published var fractionComplete: Double = 0.0
    
    @Published var isCompleted: Bool = false
    
    var message: String {
        set {
            DispatchQueue.main.async {
                self._message = newValue
            }
        }
        
        get {
            self._message
        }
    }
    
    @Published var _message: String = ""
    
    private var session: PhotogrammetrySession?
        
    func run() {
        guard self.session?.isProcessing != true else {
            message = "已經在生成另一個模型了"
            return
        }
        let inputFolderUrl = URL(fileURLWithPath: folderPath, isDirectory: true)
        let configuration = makeConfigurationFromArguments()
        logger.log("Using configuration: \(String(describing: configuration))")
        
        var maybeSession: PhotogrammetrySession? = nil
        do {
            maybeSession = try PhotogrammetrySession(input: inputFolderUrl,
                                                     configuration: configuration)
            logger.log("Successfully created session.")
            message = "Successfully created session."
        } catch {
            logger.error("Error creating session: \(String(describing: error))")
            message = "Error creating session: \(String(describing: error))"
        }
        guard let session = maybeSession else {
            return
        }
        
        self.session = session
        
        let waiter = Task {
            do {
                for try await output in session.outputs {
                    switch output {
                        case .processingComplete:
                            logger.log("Processing is complete!")
                            message = "Processing is complete!"
                            DispatchQueue.main.async {
                                self.isCompleted = true
                            }
                        case .requestError(let request, let error):
                            logger.error("Request \(String(describing: request)) had an error: \(String(describing: error))")
                            message = "Request \(String(describing: request)) had an error: \(String(describing: error))"
                        case .requestComplete(let request, let result):
                            self.handleRequestComplete(request: request, result: result)
                        case .requestProgress(let request, let fractionComplete):
                            self.handleRequestProgress(request: request, fractionComplete: fractionComplete)
                        case .inputComplete:  // data ingestion only!
                            logger.log("Data ingestion is complete.  Beginning processing...")
                            message = "Data ingestion is complete.  Beginning processing..."
                        case .invalidSample(let id, let reason):
                            logger.warning("Invalid Sample! id=\(id)  reason=\"\(reason)\"")
                            message = "Invalid Sample! id=\(id)  reason=\"\(reason)\""
                        case .skippedSample(let id):
                            logger.warning("Sample id=\(id) was skipped by processing.")
                            message = "Sample id=\(id) was skipped by processing."
                        case .automaticDownsampling:
                            logger.warning("Automatic downsampling was applied!")
                        case .processingCancelled:
                            logger.warning("Processing was cancelled.")
                            message = "Processing was cancelled."
                        @unknown default:
                            logger.error("Output: unhandled message: \(output.localizedDescription)")
                            message = "Output: unhandled message: \(output.localizedDescription)"
                    }
                }
            } catch {
                logger.error("Output: ERROR = \(String(describing: error))")
                message = "Output: ERROR = \(String(describing: error))"
            }
        }
        
        // The compiler may deinitialize these objects since they may appear to be
        // unused. This keeps them from being deallocated until they exit.
        withExtendedLifetime((session, waiter)) {
            // Run the main process call on the request, then enter the main run
            // loop until you get the published completion event or error.
            do {
                let request = makeRequestFromArguments()
                logger.log("Using request: \(String(describing: request))")
                try session.process(requests: [ request ])
                DispatchQueue.main.async {
                    self.isCompleted = false
                }
                // Enter the infinite loop dispatcher used to process asynchronous
                // blocks on the main queue. You explicitly exit above to stop the loop.
                RunLoop.main.run()
            } catch {
                logger.critical("Process got error: \(String(describing: error))")
                message = "Process got error: \(String(describing: error))"
            }
        }
    }
    
    func cancel() {
        session?.cancel()
    }
    
    /// Creates the session configuration by overriding any defaults with arguments specified.
    private func makeConfigurationFromArguments() -> PhotogrammetrySession.Configuration {
        var configuration = PhotogrammetrySession.Configuration()
        configuration.sampleOrdering = sampleOrdering
        configuration.featureSensitivity = featureSensitivity
        
        return configuration
    }
    
    /// Creates a request to use based on the command-line arguments.
    private func makeRequestFromArguments() -> PhotogrammetrySession.Request {
        let outputUrl = URL(fileURLWithPath: folderPath)
        return PhotogrammetrySession.Request.modelFile(url: outputUrl, detail: detail)
    }
    
    /// Called when the the session sends a request completed message.
    private func handleRequestComplete(request: PhotogrammetrySession.Request,
                                              result: PhotogrammetrySession.Result) {
        logger.log("Request complete: \(String(describing: request)) with result...")
        switch result {
            case .modelFile(let url):
                logger.log("\tmodelFile available at url=\(url)")
            default:
                logger.warning("\tUnexpected result: \(String(describing: result))")
        }
    }
    
    /// Called when the sessions sends a progress update message.
    private func handleRequestProgress(request: PhotogrammetrySession.Request, fractionComplete: Double) {
        DispatchQueue.main.async {
            self.fractionComplete = fractionComplete
        }

        logger.log("Progress(request = \(String(describing: request))) = \(fractionComplete)")
    }
    
}
