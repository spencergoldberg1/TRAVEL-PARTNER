//import UIKit.UIColor
//
//extension UIColor {
//    convenience init?(hex: HexadecimalString, alpha: CGFloat = 1.0) {
//        guard hex.hasPrefix("#") else { return nil }
//        
//        let start = hex.index(hex.startIndex, offsetBy: 1)
//        let hexColor = HexadecimalString(hex[start...])
//        
//        guard hexColor.count == 6 else { return nil }
//        
//        let scanner = Scanner(string: hexColor)
//        var hexNumber: UInt64 = 0
//        
//        guard scanner.scanHexInt64(&hexNumber) else { return nil }
//        
//        let r = CGFloat((hexNumber & 0xff0000) >> 16) / 255.0
//        let g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255.0
//        let b = CGFloat(hexNumber & 0x0000ff) / 255.0
//        
//        self.init(red: r, green: g, blue: b, alpha: alpha)
//    }
//}
