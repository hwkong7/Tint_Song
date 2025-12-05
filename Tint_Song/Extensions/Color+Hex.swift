import SwiftUI

extension Color {
    func toHex() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)

        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    init(hex: String) {
        var cleaned = hex
        if cleaned.hasPrefix("#") {
            cleaned.removeFirst()
        }
        
        var rgb: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

//import SwiftUI
//
//extension Color {
//    init?(hex: String) {
//        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines)
//        hexFormatted = hexFormatted.replacingOccurrences(of: "#", with: "")
//
//        var rgb: UInt64 = 0
//        guard Scanner(string: hexFormatted).scanHexInt64(&rgb) else {
//            return nil
//        }
//
//        let r = Double((rgb >> 16) & 0xFF) / 255
//        let g = Double((rgb >> 8) & 0xFF) / 255
//        let b = Double(rgb & 0xFF) / 255
//
//        self.init(red: r, green: g, blue: b)
//    }
//}
