Pod::Spec.new do |s|
  s.name             = 'SkinSmoothingFilter'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SkinSmoothingFilter.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/noppefoxwolf/SkinSmoothingFilter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'noppefoxwolf' => 'noppelabs@gmail.com' }
  s.source           = { :git => 'https://github.com/noppefoxwolf/SkinSmoothingFilter.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/noppefoxwolf'

  s.ios.deployment_target = '12.0'
  s.source_files = 'SkinSmoothingFilter/Classes/**/*.{h,swift,metal}'
  s.pod_target_xcconfig = {
    'MTLLINKER_FLAGS' => '-cikernel',
    'MTL_COMPILER_FLAGS' => '-fcikernel'
  }
end
