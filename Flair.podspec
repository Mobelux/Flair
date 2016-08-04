Pod::Spec.new do |s|

  s.name         = "Flair"
  s.version      = "1.0.0"
  s.summary      = "A way to provide style (color & text) in JSON, and have that converted to Swift"
  s.homepage     = "https://github.com/Mobelux/Flair"
  s.license      = "MIT"

  s.author             = { "Andrew Mayers" => "andrew@mobelux.com" }
  s.social_media_url   = "http://twitter.com/jamayers"

  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.11"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "10.0"

  s.source       = { :git => "https://github.com/Mobelux/Flair.git", :tag => "#{s.version}" }
  s.source_files  = "Flair/Flair/**/*.{h,m,swift}", "Flair/Shared/**/*.{h,m,swift}"
  s.exclude_files = "Flair/Shared/Tests"

  s.framework  = "Foundation"
end
