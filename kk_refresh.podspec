
Pod::Spec.new do |s|

s.name         = 'kk_refresh'
s.version      = '1.0.4'
s.summary      = 'a component of refresh on iOS'
s.homepage     = 'https://github.com/CoderJFCK/kk_refresh'
s.description  = <<-DESC
It is a component for ios refresh, written by Swift.
DESC
s.license      = 'MIT'
s.authors      = {'Kirk' => 'kk.07.self@gmail.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/CoderJFCK/kk_refresh.git', :tag => s.version}
s.source_files = 'kk_refresh/Refresh/*'
s.requires_arc = true

end

