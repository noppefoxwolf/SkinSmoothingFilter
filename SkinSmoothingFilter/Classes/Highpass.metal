#include <metal_stdlib>
using namespace metal;
#include <CoreImage/CoreImage.h>

extern "C" { namespace coreimage {
  float4 highpass(sample_t image, sample_t blurredImage) {
    return float4(float3(image.rgb - blurredImage.rgb) + 0.5, image.a);
  }
}}
