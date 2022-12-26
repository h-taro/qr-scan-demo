//
//  UICameraViewDelegate.swift
//  qr-scan-demo
//
//  Created by 平石　太郎 on 2022/12/26.
//

import AVFoundation

protocol UICameraViewDelegate: AnyObject {
    func didOutput(_ output: AVCaptureMetadataOutput, metadataObjects: [AVMetadataObject])
}
