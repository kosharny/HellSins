import SwiftUI

enum AppThemeHS: String, CaseIterable, Codable, Identifiable {
    case ember = "ember"
    case frozenHell = "frozenHell"
    case voidAbyss = "voidAbyss"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .ember: return "Default Ember"
        case .frozenHell: return "Frozen Hell"
        case .voidAbyss: return "Void Abyss"
        }
    }

    var isPremium: Bool {
        switch self {
        case .ember: return false
        case .frozenHell: return true
        case .voidAbyss: return true
        }
    }

    var price: String { "$1.99" }

    var productID: String {
        switch self {
        case .ember: return ""
        case .frozenHell: return "premium_theme_frozenhell"
        case .voidAbyss: return "premium_theme_voidabyss"
        }
    }

    var gradient: [Color] {
        switch self {
        case .ember:
            return [Color(hex: "#0F0F12"), Color(hex: "#3D0000"), Color(hex: "#FF6A00")]
        case .frozenHell:
            return [Color(hex: "#0A0A1A"), Color(hex: "#001F5B"), Color(hex: "#00B4D8")]
        case .voidAbyss:
            return [Color(hex: "#0A000F"), Color(hex: "#2D0050"), Color(hex: "#9B00FF")]
        }
    }

    var primaryColor: Color {
        switch self {
        case .ember: return Color(hex: "#FF3B30")
        case .frozenHell: return Color(hex: "#00B4D8")
        case .voidAbyss: return Color(hex: "#9B00FF")
        }
    }

    var accentColor: Color {
        switch self {
        case .ember: return Color(hex: "#FF6A00")
        case .frozenHell: return Color(hex: "#0077B6")
        case .voidAbyss: return Color(hex: "#6A00CC")
        }
    }

    var previewIcon: String {
        switch self {
        case .ember: return "flame.fill"
        case .frozenHell: return "snowflake"
        case .voidAbyss: return "sparkles"
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
