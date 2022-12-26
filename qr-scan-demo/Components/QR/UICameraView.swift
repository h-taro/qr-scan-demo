//
//  UICameraView.swift
//  qr-scan-demo
//
//  Created by 平石　太郎 on 2022/12/26.
//

import THLogger
import UIKit
import AVFoundation

class UICameraView: UIView {
    private let metadataOutput = AVCaptureMetadataOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var captureSession: AVCaptureSession = .init()
    private var videoDevice: AVCaptureDevice? = .default(for: .video)
    
    weak var delegate: UICameraViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        do {
            try configurePreviewLayer()
        } catch {
            THLogger.error(error)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
}

// MARK: - CONFIGURE
extension UICameraView {
    private func configurePreviewLayer() throws {
        guard let videoDevice = videoDevice else { return }
        
        let input = try AVCaptureDeviceInput(device: videoDevice)
        captureSession.addInput(input)
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.metadataObjectTypes = [.qr]
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        }
        
        captureSession.beginConfiguration()
        if captureSession.canSetSessionPreset(.photo) {
            captureSession.sessionPreset = .photo
        }
        captureSession.commitConfiguration()
        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
        
        previewLayer = .init(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer!)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension UICameraView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        delegate?.didOutput(output, metadataObjects: metadataObjects)
    }
}
