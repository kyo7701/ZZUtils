Pod::Spec.new do |s|
  s.name         = "ZZUtils"
  s.version      = "0.0.1"
  s.summary      = "A Demo used to reusing some code."
  s.requires_arc = true
  s.description  = "it's a Demo version for some useful tips in iOS"
  s.homepage     = "https://github.com/kyo7701/ZZUtils"
  s.license      = { :type => 'MIT'}
  s.author             = { "mr_cris" => "mr_cris@outlook.com" }
  s.platform     = :ios

  s.source       = { :git => "https://github.com/kyo7701/ZZUtils.git", :tag => "s.version" }
 s.dependency "Masonry","0.6.1" 
 s.dependency "UITableView+FDTemplateLayoutCell", "1.4"

  s.source_files  = 'Universal List Logic/*.{h,m}'

  s.frameworks = "UIKit", "Foundation"


end
