//
//  CameraViewModel.swift
//  ProjetoIdosos
//
//  Created by Turma02-6 on 04/04/25.
//

import Foundation
import CoreImage

@Observable
class CameraViewModel {
    
    var currentFrame: CGImage?
    
    private let cameraManager = CameraManager()
    
    init() {
        Task {
            await handleCameraPreviews()
        }
    }
    
    func handleCameraPreviews() async {
        for await image in cameraManager.previewStream {
            Task { @MainActor in
                currentFrame = image
            }
        }
    }
}
