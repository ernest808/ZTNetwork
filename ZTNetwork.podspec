

Pod::Spec.new do |s|
    s.name         = "ZTNetwork"
    s.version      = "1.0.5"
    s.summary      = "使用AFNetwork进行网络访问."
    s.source_files = "ZTNetwork/*.{h,m}"
    s.description  = <<-DESC
    使用AFNetwork进行网络访问的独立网络库
    DESC
    
    s.homepage     = "https://gitee.com/zengwu/"
    
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "zengwu" => "63660451@qq.com" }
       
    # s.platform     = :ios
    s.platform     = :ios, "8.0"
    s.dependency   'AFNetworking', '~> 3.2.1'    
    #  When using multiple platforms
    s.ios.deployment_target = "7.0"
    # s.osx.deployment_target = "10.7"
    # s.watchos.deployment_target = "2.0"
    # s.tvos.deployment_target = "9.0"
    
    s.source     = { :git => "https://github.com/ernest808/ZTNetwork", :tag => s.version }
    s.requires_arc = true 
      #第三层文件夹
      s.subspec 'Animation' do |ani|
      ani.source_files = 'ZTNetwork/NetworkLib/Animation/*'
      end

      s.subspec 'common' do |com|
      com.source_files = 'ZTNetwork/NetworkLib/common/*'
      end

      #s.subspec 'DataSorce' do |datasource|
      #datasource.source_files = 'ZTNetwork/NetworkLib/DataSource/*'
      #end

      #s.subspec 'Model' do |model|
      #model.source_files = 'ZTNetwork/NetworkLib/Model/*'
      #end

      s.subspec 'PageModel' do |page|
      page.source_files = 'ZTNetwork/NetworkLib/PageModel/*'
      end
end
