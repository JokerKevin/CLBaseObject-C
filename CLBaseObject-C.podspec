
Pod::Spec.new do |s|
s.name         = "CLBaseObject-C"
s.version      = "1.0.0"
s.summary      = "自用封装"
s.platform      = :ios, "9.0"
s.ios.deployment_target = "9.0"
s.description  = <<-DESC
封装内容主要为：Netwrok,TableView,WebView,ViewController
DESC
s.homepage     = "https://github.com/JokerKevin/CLBaseObject-C"
s.author             = { "jokerzcl" => "493008927@qq.com" }
s.source       = { :git => "https://github.com/JokerKevin/CLBaseObject-C", :tag => "#{s.version}" }

s.source_files  = "CLBaseObject-C/Classes/*/*"
s.dependency 'MJRefresh'
s.dependency 'Masonry'
s.dependency 'SVProgressHUD'
s.dependency 'AFNetworking'
s.dependency 'YYCache'
s.dependency 'JSONModel'
s.dependency 'MJExtension'
s.dependency 'FDFullscreenPopGesture'
end
