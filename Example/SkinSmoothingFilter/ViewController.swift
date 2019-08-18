//
//  ViewController.swift
//  SkinSmoothingFilter
//
//  Created by noppefoxwolf on 08/17/2019.
//  Copyright (c) 2019 noppefoxwolf. All rights reserved.
//

import UIKit
import ARKit
import SkinSmoothingFilter

class ViewController: UIViewController {
  
  private let session: ARSession = .init()
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet weak var toggle: UISwitch!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    session.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let configuration = ARFaceTrackingConfiguration()
    if #available(iOS 13.0, *) {
      configuration.frameSemantics = .personSegmentation
    }
    session.run(configuration)
  }
  
}

extension ViewController: ARSessionDelegate {
  
  func session(_ session: ARSession, didUpdate frame: ARFrame) {
    if let segmentationBuffer = frame.segmentationBuffer, toggle.isOn {
      let inputImage = CIImage(cvImageBuffer: frame.capturedImage)
      let maskImage = CIImage(cvPixelBuffer: segmentationBuffer)
      let scale: CGFloat = inputImage.extent.width / maskImage.extent.width
      DispatchQueue.main.async {
        let filter = SkinSmoothingFilter()
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(maskImage.transformed(by: .init(scaleX: scale, y: scale)), forKey: kCIInputMaskImageKey)
        filter.setValue(10.0, forKey: kCIInputAmountKey)
        self.imageView.image = UIImage(ciImage: filter.outputImage!.oriented(.right))
      }
    } else {
      DispatchQueue.main.async {
        self.imageView.image = UIImage(ciImage: CIImage(cvPixelBuffer: frame.capturedImage).oriented(.right))
      }
    }
  }
}

