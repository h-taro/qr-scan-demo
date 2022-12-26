//
//  ScannerView.swift
//  qr-scan-demo
//
//  Created by 平石　太郎 on 2022/12/26.
//

import SwiftUI

struct ScannerView: View {
    @StateObject private var viewModel: ScannerViewModel = .init()

    var body: some View {
        contentView
    }
    
    private var contentView: some View {
        ZStack(alignment: .center) {
            CameraViewRepresentable(didOutputSubject: viewModel.didOutputSubject)
            Text(viewModel.qrcode)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue.opacity(0.8))
                .shadow(radius: 0.8)
        }
    }
}


