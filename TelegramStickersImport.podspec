Pod::Spec.new do |s|
  s.name             = "TelegramStickersImport"
  s.version          = "1.1.0"
  s.summary          = "TelegramStickersImport helps your users import third-party programaticaly created sticker sets into Telegram Messenger for iOS."
  s.homepage         = "https://github.com/TelegramMessenger/TelegramStickersImport"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Telegram Messenger'
  s.platforms        = { :ios => "9.0" }
  s.source           = { :git => 'https://github.com/TelegramMessenger/TelegramStickersImport.git', :tag => s.version.to_s }
  s.source_files     = 'Source/*.swift'
  s.swift_version    = '4.2'
  s.requires_arc     = true

end
