//
//  EmotionClassifierViewModel.swift
//  TCC-IFSP
//
//  Created by Gabriel Amaral on 10/02/26.
//

import SwiftUI
import Vision
import CoreML
import UIKit
import ImageIO

@Observable
class EmotionClassifierViewModel {
    
    var selectedImage: UIImage?
    var classificationLabel: String = "Select an image to classify."
    var didFlagImage: Bool = false
    
    private var model: VNCoreMLModel?
    private var lastDetectedEmotion: String = "unknown"
    
    init() {
        do {
            let config = MLModelConfiguration()
            let coreMLModel = try EmotionClassifier(configuration: config).model
            self.model = try VNCoreMLModel(for: coreMLModel)
        } catch {
            print("Failed to load CoreML model: \(error)")
        }
    }
    
    @MainActor
    func detect(image: UIImage) {
        self.selectedImage = image
        self.classificationLabel = "Analyzing..."
        
        guard let rawCIImage = CIImage(image: image) else {
            self.classificationLabel = "Failed to process image."
            return
        }
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        
        let ciImage = rawCIImage.oriented(orientation)
        
        let faceDetectionRequest = VNDetectFaceRectanglesRequest { [weak self] request, error in
            guard let self = self else { return }
            
            if error != nil {
                self.updateClassification("Face detection error.")
                return
            }
            
            guard let faces = request.results as? [VNFaceObservation],
                  let face = faces.max(by: { $0.boundingBox.width * $0.boundingBox.height < $1.boundingBox.width * $1.boundingBox.height }) else {
                self.updateClassification("No face found.")
                return
            }
            
            let size = ciImage.extent.size
            let rawFaceRect = VNImageRectForNormalizedRect(face.boundingBox, Int(size.width), Int(size.height))
            
            let paddingX = rawFaceRect.width * 0.2
            let paddingY = rawFaceRect.height * 0.2
            
            var expandedRect = CGRect(
                x: rawFaceRect.origin.x - (paddingX / 2),
                y: rawFaceRect.origin.y - (paddingY / 2),
                width: rawFaceRect.width + paddingX,
                height: rawFaceRect.height + paddingY
            )
            
            expandedRect = expandedRect.intersection(ciImage.extent)
            
            let croppedCIImage = ciImage.cropped(to: expandedRect)
            
            let context = CIContext()
            guard let finalCGImage = context.createCGImage(croppedCIImage, from: croppedCIImage.extent) else {
                self.updateClassification("Failed to crop face.")
                return
            }
            
            self.classifyEmotion(cgImage: finalCGImage)
        }
        
        Task.detached(priority: .userInitiated) {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
            try? handler.perform([faceDetectionRequest])
        }
    }
    
    private func classifyEmotion(cgImage: CGImage) {
        guard let model = model else { return }
        
        let classificationRequest = VNCoreMLRequest(model: model) { [weak self] request, _ in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                self?.updateClassification("Could not classify.")
                return
            }
            
            self?.handleClassificationResults(topResult)
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up)
        
        do {
            try handler.perform([classificationRequest])
        } catch {
            print("Classification error: \(error)")
        }
    }
    
    private func handleClassificationResults(_ topResult: VNClassificationObservation) {
        let confidence = String(format: "%.0f", topResult.confidence * 100)
        let normalizedLabel = topResult.identifier.lowercased().trimmingCharacters(in: .whitespaces)
        
        DispatchQueue.main.async {
            if topResult.confidence < 0.6 {
                self.lastDetectedEmotion = "unknown"
                self.classificationLabel = "Uncertain (\(confidence)%)"
                return
            }
            
            switch normalizedLabel {
            case "happy", "felicidade":
                self.lastDetectedEmotion = "happy"
                self.classificationLabel = "Happy (\(confidence)%)"
                
            case "surprise", "surpresa":
                self.lastDetectedEmotion = "surprise"
                self.classificationLabel = "Surprise (\(confidence)%)"
                
            default:
                self.lastDetectedEmotion = "unknown"
                self.classificationLabel = "\(normalizedLabel.capitalized) (\(confidence)%)"
            }
        }
    }
    
    private func updateClassification(_ text: String) {
        DispatchQueue.main.async {
            self.classificationLabel = text
        }
    }
}

extension EmotionClassifierViewModel {
    
    func flagCurrentImage() {
        guard let image = selectedImage else { return }
        let fileName = "\(lastDetectedEmotion)_\(UUID().uuidString).jpg"
        exportImageToFiles(image, fileName: fileName)
        triggerSoftHaptic()
        
        withAnimation {
            didFlagImage = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation {
                self.didFlagImage = false
            }
        }
    }
    
    private func exportImageToFiles(_ image: UIImage, fileName: String) {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: tempURL)
            
            let picker = UIDocumentPickerViewController(forExporting: [tempURL])
            picker.shouldShowFileExtensions = true
            
            UIApplication.shared.connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .first?
                .rootViewController?
                .present(picker, animated: true)
            
        } catch {
            print(error)
        }
    }
    
    private func triggerSoftHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}
