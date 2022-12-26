//
//  ScannerViewModel.swift
//  qr-scan-demo
//
//  Created by 平石　太郎 on 2022/12/26.
//

import AVFoundation
import Foundation
import Combine

class ScannerViewModel: ObservableObject {
    @Published private(set) var qrcode: String = "QR"

    private(set) var didOutputSubject: PassthroughSubject<DidOutputObjects, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        subscribeDidOutput()
    }
    
    deinit { cancellables.forEach { $0.cancel() } }
}

extension ScannerViewModel {
    private func subscribeDidOutput() {
        didOutputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] objects in
                guard let self = self else { return }
                guard let metadataObject = objects.metadataObjects.first else { return }
                guard let readable = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readable.stringValue else { return }
                self.qrcode = stringValue
            }
            .store(in: &cancellables)
    }
}
