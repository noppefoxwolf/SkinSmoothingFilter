//
//  HighpassFilter.swift
//  SkinSmoothingFilter
//
//  Created by beta on 2019/08/19.
//

import CoreImage

public let kCIInputBlurImageKey = "blurInputImage"

private final class BundleToken {}

public class HighpassFilter: CIFilter {
  @objc var inputImage: CIImage?
  @objc var blurInputImage: CIImage?
  @objc var inputAmount: Double = 5.0
  
  override public var outputImage: CIImage? {
    guard let inputImage = self.inputImage else { return nil }
    let blurInputImage = self.blurInputImage ?? makeBluredImage(from: inputImage)
    guard let highpassKernel = HighpassFilter.highpassKernel else { return nil }
    return highpassKernel.apply(extent: inputImage.extent, arguments: [inputImage, blurInputImage])
  }
  
  private func makeBluredImage(from inputImage: CIImage) -> CIImage {
    return inputImage.clampedToExtent().applyingGaussianBlur(sigma: inputAmount).cropped(to: inputImage.extent)
  }
  
  private static var highpassKernel: CIColorKernel? {
    guard let url = Bundle(for: BundleToken.self).url(forResource: "default", withExtension: "metallib") else { return nil }
    guard let data = try? Data(contentsOf: url) else { return nil }
    return try? CIColorKernel(functionName: "highpass", fromMetalLibraryData: data)
  }
}
