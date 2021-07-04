# TelegramStickersImport — Telegram stickers importing SDK for iOS
 
TelegramStickersImport helps your users import third-party programaticaly created sticker sets into Telegram Messenger for iOS.

Please read the full documentation here: https://core.telegram.org/import-stickers

>**WARNING:** Each time a user imports stickers, a **new sticker pack** is created on Telegram. **Do not use** the importing feature to share stickers *you* made with *other* users. If you want to share your stickers, simply upload them using [@stickers](https://t.me/stickers), then share the **link** of your pack. For example, here's a link to install some [Duck Stickers](https://t.me/addstickers/UtyaDuck).
 
### Installation
 
#### Installing using Cocoapods
To install TelegramStickersImport via Cocoapods add the following to your Podfile:
```ruby
target 'MyApp' do
pod 'TelegramStickersImport' 
end
```
then run `pod install` in your project root directory.
 
#### Installing using Carthage
Add the following line to your Cartfile:
```ruby
github "telegrammessenger/TelegramStickersImport"
```
then run `carthage update`, and you will get the latest version of TelegramStickersImport in your Carthage folder.
 
#### Installing using Swift Package Manager
Go to **File > Swift Packages > Add Package Dependency...** in Xcode and search for `TelegramStickersImport`.
 
### Project Setup
#### Configure Your Info.plist
Configure your `Info.plist` by right-clicking it in Project Navigator, choosing **Open As > Source Code** and adding this snippet:  
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
<string>tg</string>
</array>
```
 
### Usage
To import a sticker set of a single sticker to Telegram, add the following code to your app:  
```swift
import TelegramStickersImport
 
let stickerSet = StickerSet(software: "Example Software", isAnimated: false)
let yourStickerImage = UIImage()
if let stickerData = Sticker.StickerData(image: yourStickerImage) {
    try? staticStickerSet.addSticker(data: .image(stickerData), emojis: ["😎"])
}
stickerSet.import()
```
 
## License
 
TelegramStickersImport is available under the MIT license. [See the LICENSE file](LICENSE) for more info.
