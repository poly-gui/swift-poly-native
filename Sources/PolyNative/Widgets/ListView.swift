//
//  ListView.swift
//
//
//  Created by Kenneth Ng on 24/02/2024.
//

import AppKit
import Foundation

class ListViewDataSource: NSObject, NSCollectionViewDataSource {
    private let sections: [Int32]
    private let renderItem: CallbackHandle
    private let context: ApplicationContext
    
    init(_ context: ApplicationContext, renderItem: CallbackHandle, sections: [Int32]) {
        self.context = context
        self.sections = sections
        self.renderItem = renderItem
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(sections[section])
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let item = collectionView.makeItem(withIdentifier: PolyListViewItem.identifier, for: indexPath) as? PolyListViewItem else {
            return NSCollectionViewItem()
        }
        
        let group = DispatchGroup()
        
        group.enter()
        var widgetData: Data?
        let renderItemConfig = RenderItemConfig(sectionIndex: Int32(indexPath.section), itemIndex: Int32(indexPath.item))
        context.rpc.invoke(renderItem, args: renderItemConfig) { resultData in
            widgetData = resultData
            group.leave()
        }
        _ = group.wait(timeout: DispatchTime.now() + DispatchTimeInterval.milliseconds(200))
        
        guard let data = widgetData,
              let widget = Widget.from(data: data)
        else {
            return NSCollectionViewItem()
        }

        if item.isReused, let itemView = item.itemView {
            updateWidget(old: itemView, new: widget, context: context)
        } else {
            guard let widget = makeWidget(with: widget, context: context) else {
                return NSCollectionViewItem()
            }
            item.itemView = widget
        }
        
        return item
    }
}

class PolyListViewItem: NSCollectionViewItem {
    static let identifier = NSUserInterfaceItemIdentifier("ListViewItem")
    
    var itemView: NSView? {
        didSet {
            if let itemView {
                self.view.addSubview(itemView)
            } else {
                oldValue?.removeFromSuperview()
            }
        }
    }
    
    private(set) var isReused = false
    
    override func loadView() {
        self.view = NSView()
    }

    override func prepareForReuse() {
        isReused = true
    }
}

class PolyListView: NSCollectionView, NSCollectionViewDelegate {
    private var _dataSource: ListViewDataSource? = nil
    
    convenience init(message: ListView, context: ApplicationContext) {
        self.init()
        
        let layout = NSCollectionViewGridLayout()
        layout.maximumNumberOfColumns = 1
        layout.minimumLineSpacing = 10.0
        layout.maximumItemSize = NSSize(width: bounds.size.width, height: 0.0)
        layout.minimumItemSize = NSSize(width: bounds.size.width, height: 0.0)
        
        let dataSource = ListViewDataSource(context, renderItem: message.renderItem, sections: message.sectionCounts)
        let delegate = PolyListViewDelegate()
        
        _dataSource = dataSource
        self.dataSource = dataSource
        self.delegate = delegate
        collectionViewLayout = layout
        register(PolyListViewItem.self, forItemWithIdentifier: PolyListViewItem.identifier)
    }
}

class PolyListViewDelegate: NSObject, NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
    }
}

@MainActor
func makeListView(with message: ListView, context: ApplicationContext) -> PolyListView {
    return PolyListView(message: message, context: context)
}

@MainActor
func makeListView<Parent: NSView>(with message: ListView, parent: Parent, context: ApplicationContext, commit: ViewCommiter<Parent>) -> PolyListView {
    let listView = PolyListView(message: message, context: context)
    
    commit(listView, parent)
    
    if message.width != minContent {
        if message.width == fillParent {
            listView.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        } else {
            listView.widthAnchor.constraint(equalToConstant: message.width).isActive = true
        }
    }
    if message.height != minContent {
        if message.height == fillParent {
            listView.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
        } else {
            listView.heightAnchor.constraint(equalToConstant: message.height).isActive = true
        }
    }
    
    return listView
}
