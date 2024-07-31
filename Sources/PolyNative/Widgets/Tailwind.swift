import AppKit
import Collections
import Foundation
import twx

typealias TailwindStyleDict = [String: Any]
typealias TailwindStyleSheet = OrderedDictionary<UInt32, TailwindStyleDict>

extension Int {
    func toCGColor() -> CGColor {
        return CGColor(
            red: CGFloat((self & 0xFF0000) >> 16) / 255,
            green: CGFloat((self & 0xFF00) >> 8) / 255,
            blue: CGFloat(self & 0xFF) / 255,
            alpha: CGFloat((self & 0xFF000000) >> 24) / 255
        )
    }
}

func parseToStyleDict(string: String) -> TailwindStyleSheet? {
    guard string != "" else {
        return nil
    }
    return string.utf8CString.withUnsafeBufferPointer { ptr -> TailwindStyleSheet? in
        guard let jsonCCstr = twx_parse_to_json(ptr.baseAddress) else {
            return nil
        }

        let jsonStr = String(cString: jsonCCstr)
        let styleDict = try? JSONSerialization.jsonObject(with: jsonStr.data(using: .utf8)!) as? [String: TailwindStyleDict]
        free(jsonCCstr)

        guard styleDict != nil else {
            return nil
        }

        var stylesheet = TailwindStyleSheet(minimumCapacity: styleDict!.count)
        styleDict!.forEach { key, val in
            stylesheet[UInt32(key, radix: 10)!] = val
        }

        stylesheet.sort(by: { a, b in
            let popcountA = a.key.nonzeroBitCount
            let popcountB = b.key.nonzeroBitCount
            if popcountA == popcountB {
                return a.key < b.key
            }
            return popcountA < popcountB
        })

        return stylesheet
    }
}

func apply(_ stylesheet: TailwindStyleSheet, to view: NSView) {
    var modifierCode: UInt32 = 0

    if NSAppearance.current.name == .darkAqua {
        modifierCode |= TWX_MODIFIER_DARK.rawValue
    }

    if let window = view.window {
        let windowWidth = window.frame.size.width
        if windowWidth >= 640 {
            modifierCode |= TWX_MODIFIER_SM.rawValue
        }
        if windowWidth >= 768 {
            modifierCode |= TWX_MODIFIER_MD.rawValue
        }
        if windowWidth >= 1024 {
            modifierCode |= TWX_MODIFIER_LG.rawValue
        }
        if windowWidth >= 1280 {
            modifierCode |= TWX_MODIFIER_XL.rawValue
        }
        if modifierCode >= 1536 {
            modifierCode |= TWX_MODIFIER_XXL.rawValue
        }
    }

    if let baseStyle = stylesheet[0] {
        apply(baseStyle, to: view)
    }

    stylesheet.forEach { modifier, styles in
        if modifierCode & modifier == modifier {
            apply(styles, to: view)
        }
    }
}

func remToPt(_ rem: Double) -> Double {
    return rem * NSFont.systemFontSize
}

func apply(_ styleDict: TailwindStyleDict, to view: NSView) {
    guard let layer = view.layer else {
        return
    }

    styleDict.forEach { key, value in
        switch key {
        case "backgroundColor":
            layer.backgroundColor = (value as! Int).toCGColor()

        default:
            break
        }
    }
}
