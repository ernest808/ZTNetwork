
Pod::Spec.new do |s|
    
    s.name         = "ZTNetwork"
    s.version      = "0.0.1"
    s.summary      = "A short description of ZTNetwork."
    s.source_files = "ZTNetwork/**/*.{h,m}"
    s.description  = <<-DESC
    独立网络库
    DESC
    
    s.homepage     = "https://gitee.com/zengwu/"
    
    s.license      = "MIT"
    # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
    
    s.author             = { "zengwu" => "63660451@qq.com" }
    # Or just: s.author    = "zengwu"
    # s.authors            = { "zengwu" => "63660451@qq.com" }
    # s.social_media_url   = "http://xinxuntech.com"
    
    # s.platform     = :ios
    s.platform     = :ios, "8.0"
    
    #  When using multiple platforms
    # s.ios.deployment_target = "5.0"
    # s.osx.deployment_target = "10.7"
    # s.watchos.deployment_target = "2.0"
    # s.tvos.deployment_target = "9.0"
    
    s.source       = { :git => "https://gitee.com/zengwu/", :tag => s.version.to_s }
    
    # s.default_subspec = "NetworkLib"

end
