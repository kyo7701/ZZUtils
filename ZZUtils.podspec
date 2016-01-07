Pod::Spec.new do |s|
  s.name         = "ZZUtils"
  s.version      = "0.0.1"
  s.summary      = "A Demo used to reusing some code."
  s.requires_arc = true
  s.description  = <<-DESC
		   it's a Demo version for some useful tips in iOS
                   DESC
  s.homepage     = "https://github.com/kyo7701/ZZUtils"
  s.license      = 'MIT'
  s.author             = { "mr_cris" => "mr_cris@outlook.com" }
   s.platform     = :ios
   s.platform     = :ios, "7.0"


  s.source       = { :git => "https://github.com/kyo7701/ZZUtils.git", :tag => "0.0.1" }



  s.source_files  = "LPGridView/*.{h,m}"

  s.frameworks = "UIKit", "Foundation","Masonry"


end
