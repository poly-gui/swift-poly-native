//
//  Text.swift
//
//
//  Created by Kenneth Ng on 05/01/2024.
//

import AppKit
import Foundation
import twx

class PolyStaticText: NSTextField, Paddable {
    var padding: Double = 0
    var paddingTop: Double = 0
    var paddingLeft: Double = 0
    var paddingBottom: Double = 0
    var paddingRight: Double = 0
    var paddingX: Double = 0
    var paddingY: Double = 0

    private var styleDict: TailwindStyleSheet? = nil
    private var windowResizeListenerHandle: WindowResizeListenerHandle? = nil

    convenience init(_ message: Text) {
        self.init(labelWithString: message.content)

//        wantsLayer = true
//        styleDict = parseToStyleDict(string: message.tw)
//        if let styleDict = styleDict {
//            apply(styleDict, to: self)
//        }

        let font: NSFont? = if message.style.fontFamily == "" {
            .systemFont(
                ofSize: CGFloat(message.style.fontSize),
                weight: .fromNumber(message.style.fontWeight))
        } else {
            NSFont(name: message.style.fontFamily, size: CGFloat(message.style.fontSize))
        }

        if font != nil {
            self.font = font
        }

        let cell = PolyTextFieldCell()
        cell.padding = padding
        cell.paddingTop = paddingTop
        cell.paddingLeft = paddingLeft
        cell.paddingBottom = paddingBottom
        cell.paddingRight = paddingRight
        cell.paddingX = paddingX
        cell.paddingY = paddingY
        cell.stringValue = message.content
        self.cell = cell
    }

    override func viewDidMoveToWindow() {
        guard let window = window,
              let delegate = window.delegate as? PolyWindowDelegate
        else {
            return
        }
        windowResizeListenerHandle = delegate.addResizeListener { _ in
            if let styleDict = self.styleDict {
                apply(styleDict, to: self)
            }
        }
    }

    override func updateLayer() {
        guard let styleDict = styleDict else {
            return
        }
        apply(styleDict, to: self)
    }

    func update(message: Text) {
//        styleDict = parseToStyleDict(string: message.tw)

        let font: NSFont?
        if message.style.fontFamily == "" {
            font = .systemFont(
                ofSize: CGFloat(message.style.fontSize),
                weight: .fromNumber(message.style.fontWeight))
        } else {
            font = NSFont(name: message.style.fontFamily, size: CGFloat(message.style.fontSize))
        }

        if font != nil {
            self.font = font
        }
    }
}

@MainActor
func makeText(with message: Text) -> NSTextField {
    return PolyStaticText(message)
}

@MainActor
func makeText<Parent: NSView>(with message: Text, parent: Parent, commit: ViewCommiter<Parent>) -> NSTextField {
    let text = makeText(with: message)
    commit(text, parent)
    return text
}

@MainActor
func updateText(current text: NSTextField, new config: Text) {
    text.stringValue = config.content
    text.sizeToFit()

    let font: NSFont?
    if config.style.fontFamily == "" {
        font = .systemFont(
            ofSize: CGFloat(config.style.fontSize),
            weight: .fromNumber(config.style.fontWeight))
    } else {
        font = NSFont(name: config.style.fontFamily, size: CGFloat(config.style.fontSize))
    }

    if font != nil {
        text.font = font
    }
}
