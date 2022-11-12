//
//  ScanVC.swift
//  Scan List
//
//  Created by Melody Prince on 3/31/16.
//  Copyright © 2016 Melody Prince. All rights reserved.
//

// AVCapture code taken from https://www.hackingwithswift.com/example-code/media/how-to-scan-a-barcode

import AVFoundation
import UIKit

class ScanVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

  var captureSession: AVCaptureSession!
  var previewLayer: AVCaptureVideoPreviewLayer!

//    @IBOutlet var cancelButton: UIBarButtonItem!
//    @IBOutlet var skipButton: UIBarButtonItem!

//    @IBAction func cancel(_ sender: AnyObject) {
//        navigationController?.popViewController(animated: true)
//    }
//
//    @IBAction func skipScan(_ sender: UIBarButtonItem) {
//
//        let storyboard = UIStoryboard.init(name: "ItemDetailTVC", bundle: Bundle.main)
//        let itemDetailTVC = storyboard.instantiateViewController(withIdentifier: "ItemDetailTVC") as! ItemDetailTVC
//
//        let id = Date.timeIntervalSinceReferenceDate
//        itemDetailTVC.item = NewItem(id: "\(id)")
//
//        itemDetailTVC.vcThatPresentedMe = "ScanVC"
//
//        navigationController?.pushViewController(itemDetailTVC, animated: true)
//    }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.black

    print("ScanVC:viewDidLoad")

//        if runningInSimulator {
//            showSimulatorActions()
//
//        } else {
//            loadAVCaptureView()
//        }

    loadAVCaptureView()

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if (captureSession?.isRunning == false) {
      captureSession.startRunning();
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    if (captureSession?.isRunning == true) {
      captureSession.stopRunning();
    }
  }

  func failed() {
    let ac = UIAlertController(title: "Scanning not supported",
      message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
      preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(ac, animated: true, completion: nil)
    captureSession = nil
  }

  func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject],
    from connection: AVCaptureConnection) {
    captureSession.stopRunning()

    if let metadataObject = metadataObjects.first {
      let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;

      AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

      let barcode: String? = readableObject.stringValue

      print(barcode as Any)

      // TODO: save descriptor for use with Core Image
      //readableObject.descriptor
      // From CIBarcodeDescriptor documentation
//            - (CIImage*) imageFromBarcodeDescriptor:(CIBarcodeDescriptor*)descriptor
//            {
//                NSDictionary* inputParams = @{
//                @"inputBarcodeDescriptor" : descriptor
//            };
//                CIFilter* barcodeCreationFilter = [CIFilter filterWithName:@"CIBarcodeGenerator" withInputParameters:inputParams];
//                CIImage* outputImage = barcodeCreationFilter.outputImage;
//                return outputImage;
//            }
//
//      if let item = NewCatalog.sharedInstance.itemWithBarcode(barcode!) {
//        showCatalogItemActions(item.id)
//      } else {
//                editNewItem(barcode!)
//      }
    }
  }

  func loadAVCaptureView() {
    captureSession = AVCaptureSession()

    let videoCaptureDevice: AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.video)
    let videoInput: AVCaptureDeviceInput

    do {
      if let device = videoCaptureDevice {
        videoInput = try AVCaptureDeviceInput(device: device)
      } else {
//                 Do more here?
        failed()
        return
      }
    } catch {
//             Do more here?
      return
    }

    if (captureSession.canAddInput(videoInput)) {
      captureSession.addInput(videoInput)
    } else {
      failed();
      return;
    }

    let metadataOutput = AVCaptureMetadataOutput()

    if (captureSession.canAddOutput(metadataOutput)) {
      captureSession.addOutput(metadataOutput)

      metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean8,
                                            AVMetadataObject.ObjectType.ean13,
                                            AVMetadataObject.ObjectType.pdf417,
                                            AVMetadataObject.ObjectType.qr]
    } else {
      failed()
      return
    }

    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
    previewLayer.frame = view.layer.bounds;
    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
    view.layer.addSublayer(previewLayer);

    captureSession.startRunning();
  }

  func showCatalogItemActions(_ id: String) {
    let actionSheet = UIAlertController.init(title: nil, message: nil,
                                             preferredStyle: UIAlertController.Style.actionSheet)

    // Cancel
    let cancelActionHandler = { (action: UIAlertAction!) -> Void in
      self.dismiss(animated: false, completion: nil)
    }
    let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel,
                                          handler: cancelActionHandler)
    actionSheet.addAction(cancelAction)

//    // Add item to list
//    if let item = NewCatalog.sharedInstance.itemWithId(id) {
//      if !item.onList {
//        let addItemActionHandler = { (action: UIAlertAction!) -> Void in
//          // TODO
//          // self.addItemToList(id)
//        }
//        let addItemAction = UIAlertAction.init(title: "Add to List", style: UIAlertAction.Style.default,
//          handler: addItemActionHandler)
//        actionSheet.addAction(addItemAction)
//      }
//    }
//
//    // Edit item
//    let catalogItemActionHandler = { (action: UIAlertAction!) -> Void in
//      // TODO
//      //self.editCatalogItem(id)
//    }
//    let catalogItemAction = UIAlertAction.init(title: "Edit Item", style: UIAlertAction.Style.default,
//      handler: catalogItemActionHandler)
//    actionSheet.addAction(catalogItemAction)
//
//    present(actionSheet, animated: true, completion: nil)
  }
}
