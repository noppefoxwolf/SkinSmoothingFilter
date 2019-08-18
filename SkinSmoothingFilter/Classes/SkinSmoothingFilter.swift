//
//  SkinSmoothingFilter.swift
//  SkinSmoothingFilter
//
//  Created by beta on 2019/08/19.
//

import CoreImage

@objc public class SkinSmoothingFilter: CIFilter {
  @objc var inputImage: CIImage?
  @objc var inputAmount: Double = 5.0
  @objc var inputMaskImage: CIImage?
  
  public override init() {
    super.init()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override public var outputImage: CIImage? {
    guard let inputImage = inputImage else { return nil }
    guard let inputMaskImage = inputMaskImage else { return nil }
    let highpassOutput: CIImage
    highpass: do {
      let filter = HighpassFilter()
      filter.setValue(inputImage, forKey: kCIInputImageKey)
      filter.setValue(inputAmount, forKey: kCIInputAmountKey)
      highpassOutput = filter.outputImage!
    }
    let invertedHighpassOutput: CIImage
    invert: do {
      let filter = CIFilter(name: "CIColorInvert")!
      filter.setValue(highpassOutput, forKey: kCIInputImageKey)
      invertedHighpassOutput = filter.outputImage!
    }
    let smoothingOutput: CIImage
    smooth: do {
      let filter = CIFilter(name: "CIOverlayBlendMode")!
      filter.setValue(invertedHighpassOutput, forKey: kCIInputImageKey)
      filter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
      smoothingOutput = filter.outputImage!
    }
    let maskedOutput: CIImage
    mask: do {
      let filter = CIFilter(name: "CIBlendWithMask")!
      filter.setValue(smoothingOutput, forKey: kCIInputImageKey)
      filter.setValue(inputImage, forKey: kCIInputBackgroundImageKey)
      filter.setValue(inputMaskImage, forKey: kCIInputMaskImageKey)
      maskedOutput = filter.outputImage!
    }
    return maskedOutput
  }
}


