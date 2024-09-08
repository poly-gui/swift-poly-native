import AppKit
import Foundation

class PolyRow: NSStackView, MultiChildrenWidget {
    private(set) var gravity: NSStackView.Gravity = .center

    static func committer(_ child: NSView, _ parent: PolyRow) {
        parent.addView(child)
    }

    convenience init(_ message: Row) {
        self.init()
        orientation = .horizontal

        gravity = switch message.horizontalAlignment {
        case .start: .leading
        case .end: .trailing
        case .center: .center
        default: .center
        }

        alignment = switch message.verticalAlignment {
        case .center: .centerY
        case .bottom: .bottom
        case .start: .top
        case .end: .bottom
        default: alignment
        }
    }

    func addView(_ view: NSView) {
        addView(view, in: gravity)
    }

    func insertView(_ view: NSView, at index: Int) {
        insertView(view, at: index, in: gravity)
    }

    func insertView(_ view: NSView, before anotherView: NSView) {
        for i in 0 ..< arrangedSubviews.count {
            if anotherView == arrangedSubviews[i] {
                insertView(view, at: i, in: gravity)
                return
            }
        }
    }
}

@MainActor
func makeRow(with message: Row, context: ApplicationContext) -> PolyRow? {
    let row = PolyRow(message)
    for child in message.children {
        guard makeWidget(with: child, parent: row, context: context, commit: PolyRow.committer(_:_:)) != nil else {
            return nil
        }
    }
    return row
}

@MainActor
func makeRow<Parent: NSView>(with message: Row, parent: Parent, context: ApplicationContext, commit: ViewCommiter<Parent>) -> NSStackView? {
    guard let row = makeRow(with: message, context: context) else {
        return nil
    }

    commit(row, parent)

    row.translatesAutoresizingMaskIntoConstraints = false

    if message.width != minContent {
        if message.width == fillParent {
            row.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        } else {
            row.widthAnchor.constraint(equalToConstant: message.width).isActive = true
        }
    }
    if message.height != minContent {
        if message.height == fillParent {
            row.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
        } else {
            row.heightAnchor.constraint(equalToConstant: message.height).isActive = true
        }
    }

    return row
}

@MainActor
func updateRow(current stackView: NSStackView, new config: Row) {
    switch config.verticalAlignment {
    case .center:
        stackView.alignment = .centerY
    case .bottom:
        stackView.alignment = .bottom
    case .start:
        stackView.alignment = .top
    case .end:
        stackView.alignment = .bottom
    default:
        break
    }
}
