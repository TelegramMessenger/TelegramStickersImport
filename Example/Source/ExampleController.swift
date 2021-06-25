import UIKit
import TelegramStickersImport

class ExampleController: UIViewController {
    private var staticStickerSet: StickerSet?
    private var animatedStickerSet: StickerSet?
    private var selectedStickerSet: StickerSet?
    
    @IBOutlet weak var preview1: UIImageView!
    @IBOutlet weak var preview2: UIImageView!
    @IBOutlet weak var preview3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let staticStickerSet = StickerSet(software: "TelegramStickersImport-Example", isAnimated: false)
        if let path = Bundle.main.path(forResource: "s-1", ofType: "png", inDirectory: nil), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            try? staticStickerSet.addSticker(data: .image(data), emojis: ["👍", "😺"])
        }
        if let path = Bundle.main.path(forResource: "s-2", ofType: "png", inDirectory: nil), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            try? staticStickerSet.addSticker(data: .image(data), emojis: ["☠️", "💀"])
        }
        if let path = Bundle.main.path(forResource: "s-3", ofType: "png", inDirectory: nil), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            try? staticStickerSet.addSticker(data: .image(data), emojis: ["😎", "😼"])
        }
        self.staticStickerSet = staticStickerSet
        
        let animatedStickerSet = StickerSet(software: "TGStickersImport-Example", isAnimated: true)
        if let path = Bundle.main.path(forResource: "a-1", ofType: "tgs", inDirectory: nil), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            try? animatedStickerSet.addSticker(data: .animation(data), emojis: ["😭"])
        }
        if let path = Bundle.main.path(forResource: "a-2", ofType: "tgs", inDirectory: nil), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            try? animatedStickerSet.addSticker(data: .animation(data), emojis: ["🤷‍♂️"])
        }
        if let path = Bundle.main.path(forResource: "a-3", ofType: "tgs", inDirectory: nil), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            try? animatedStickerSet.addSticker(data: .animation(data), emojis: ["🤔"])
        }
        self.animatedStickerSet = animatedStickerSet
        
        self.selectedStickerSet = self.staticStickerSet
    }
    
    @IBAction func toggle(_ sender: Any) {
        if let sender = sender as? UISegmentedControl {
            switch sender.selectedSegmentIndex {
                case 0:
                    self.selectedStickerSet = self.staticStickerSet
                    self.preview1.image = UIImage(named: "s-1.png")
                    self.preview2.image = UIImage(named: "s-2.png")
                    self.preview3.image = UIImage(named: "s-3.png")
                case 1:
                    self.selectedStickerSet = self.animatedStickerSet
                    self.preview1.image = UIImage(named: "a-1-thumb.png")
                    self.preview2.image = UIImage(named: "a-2-thumb.png")
                    self.preview3.image = UIImage(named: "a-3-thumb.png")
                default:
                    break
            }
        }
    }
    
    @IBAction func send(_ sender: Any) {
        try? self.selectedStickerSet?.import()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}
