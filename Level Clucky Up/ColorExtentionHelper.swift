import Foundation
import SwiftUI

extension Color {
    init?(hex: String) {
        
        let trimmedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let cleanedHex = trimmedHex.hasPrefix("#") ? String(trimmedHex.dropFirst()) : trimmedHex
        
        // Ensure the hex string is either 3 or 6 characters long
        guard cleanedHex.count == 3 || cleanedHex.count == 6 else {
            return nil
        }
        
        let finalHex: String
        if cleanedHex.count == 3 {
            // Expand 3-character hex (e.g., "FFF" to "FFFFFF")
            finalHex = cleanedHex.map { String($0) + String($0) }.joined()
        } else {
            // Use the 6-character hex as is
            finalHex = cleanedHex
        }
        
        // Scan the hex string into a UInt32 value
        let scanner = Scanner(string: finalHex)
        var value: UInt32 = 0
        guard scanner.scanHexInt32(&value) else {
            return nil
        }
        
        // Extract red, green, and blue components and normalize to [0, 1]
        let red = Double((value >> 16) & 0xFF) / 255.0
        let green = Double((value >> 8) & 0xFF) / 255.0
        let blue = Double(value & 0xFF) / 255.0
        
        // Initialize the Color with RGB values
        self.init(red: red, green: green, blue: blue)
    }
}
