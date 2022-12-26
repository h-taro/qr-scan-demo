//
//  CameraViewRepresentable.swift
//  qr-scan-demo
//
//  Created by 平石　太郎 on 2022/12/26.
//

import Combine
import AVFoundation
import SwiftUI

struct DidOutputObjects {
    let output: AVCaptureMetadataOutput
    let metadataObjects: [AVMetadataObject]
}

struct CameraViewRepresentable: UIViewRepresentable {
    private let didOutputSubject: PassthroughSubject<DidOutputObjects, Never>
    
    init(didOutputSubject: PassthroughSubject<DidOutputObjects, Never>) {
        self.didOutputSubject = didOutputSubject
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UICameraView {
        let view = UICameraView()
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UICameraView, context: Context) {
    }
    
    class Coordinator: NSObject, UICameraViewDelegate {
        
        let parent: CameraViewRepresentable
        
        init(_ parent: CameraViewRepresentable) {
            self.parent = parent
        }
        
        func didOutput(_ output: AVCaptureMetadataOutput, metadataObjects: [AVMetadataObject]) {
            parent.didOutputSubject.send(.init(output: output, metadataObjects: metadataObjects))
        }
    }
}

