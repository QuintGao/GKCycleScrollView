Pod::Spec.new do |s|

  s.name                = 'GKCycleScrollView'

  s.version             = '0.0.5'

  s.summary             = '一个轻量级的自定义轮播图组件'

  s.homepage            = 'https://github.com/QuintGao/GKCycleScrollView'

  s.license             = { :type => "MIT", :file => "LICENSE" }

  s.author              = { '高坤' => '1094887059@qq.com' }

  s.social_media_url    = 'https://github.com/QuintGao'

  s.platform            = :ios, "8.0"

  s.source              = { :git => "https://github.com/QuintGao/GKCycleScrollView.git", :tag => s.version }

  s.source_files        = 'GKCycleScrollView/*.{h,m}'

  s.frameworks          = "Foundation", "UIKit"

  s.requires_arc 	    = true

end
