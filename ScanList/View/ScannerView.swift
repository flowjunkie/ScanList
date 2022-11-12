//
//  ScannerView.swift
//  ScanList
//
//  Created by Melody Prince on 7/17/22.
//

import SwiftUI
import AVFoundation
import UIKit

struct ScannerView: UIViewControllerRepresentable {

  typealias UIViewControllerType = ScanVC

  func makeUIViewController(context: Context) -> UIViewControllerType {
      ScanVC()
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

  }

  func makeCoordinator() -> ScannerView.Coordinator {
    ScannerView.Coordinator(self)
  }
}

extension ScannerView {
  class Coordinator : NSObject, AVCaptureMetadataOutputObjectsDelegate {

    var parent: ScannerView

    init(_ parent: ScannerView) {
      self.parent = parent
    }
  }
}

struct ScannerView_Previews: PreviewProvider {
  static var previews: some View {
    ScannerView()
  }
}
