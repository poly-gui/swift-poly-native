//
//  Styling.swift
//
//
//  Created by Kenneth Ng on 14/03/2024.
//

import Foundation

import AppKit

extension NSFont.Weight {
    /// Maps font weight numbers, e.g. 100, 400, 500, to NSFont.Weight
    /// - parameter fontWeight: The font weight number between 100 and 900
    /// - returns the corresponding NSFont.Weight, or NSFont.regular if the weight is not recognized.
    static func fromNumber(_ fontWeight: UInt32) -> NSFont.Weight {
        switch fontWeight {
        case 100:
            return .ultraLight
        case 200:
            return .thin
        case 300:
            return .light
        case 400:
            return .regular
        case 500:
            return .medium
        case 600:
            return .semibold
        case 700:
            return .bold
        case 800:
            return .heavy
        case 900:
            return .black
        default:
            return .regular
        }
    }
}
