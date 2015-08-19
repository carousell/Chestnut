Pod::Spec.new do |s|
  s.name         = "Chestnut"
  s.version      = "0.0.1"
  s.summary      = "UITextField for currency input."
  s.homepage     = "https://github.com/tflhyl/Chestnut"
  s.license      = { :type => "MIT" }
  s.author       = { "tflhyl" => "tflhyl@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/tflhyl/Chestnut.git", :tag => "0.0.1" }
  s.source_files  = "Chestnut"
  s.requires_arc = true
end
