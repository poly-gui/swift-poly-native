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
            item.itemView = makeWidget(with: widget, parent: item.view, context: context)
        }

        return item
    }
}

class PolyListViewItem: NSCollectionViewItem {
    static let identifier = NSUserInterfaceItemIdentifier("ListViewItem")

    private(set) var isReused = false
    
    var itemView: NSView? = nil
    
    override func loadView() {
        view = NSView()
    }

    override func prepareForReuse() {
        isReused = true
    }
}

class PolyListViewDelegate: NSObject, NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {}
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: 40)
    }
}

class PolyListView: NSScrollView {
    private var dataSource: ListViewDataSource? = nil
    private var collectionViewDelegate: PolyListViewDelegate? = nil
    
    convenience init(_ context: ApplicationContext, _ message: ListView) {
        self.init()
        
        let collectionView = NSCollectionView()
        
        let layout = NSCollectionViewFlowLayout()
        
        let dataSource = ListViewDataSource(context, renderItem: message.renderItem, sections: message.sectionCounts)
        let delegate = PolyListViewDelegate()
        
        self.dataSource = dataSource
        self.collectionViewDelegate = delegate

        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.collectionViewLayout = layout
        collectionView.register(PolyListViewItem.self, forItemWithIdentifier: PolyListViewItem.identifier)
        
        documentView = collectionView
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        if oldSize.width != bounds.width, let collectionView = documentView as? NSCollectionView {
            collectionView.collectionViewLayout?.invalidateLayout()
        }
    }
}

@MainActor
func makeListView(with message: ListView, context: ApplicationContext) -> PolyListView {
    return PolyListView(context, message)
}

@MainActor
func makeListView<Parent: NSView>(with message: ListView, parent: Parent, context: ApplicationContext, commit: ViewCommiter<Parent>) -> NSView {
    let listView = PolyListView(context, message)

    commit(listView, parent)
    
    if message.width != minContent {
        if message.width == fillParent {
            listView.widthAnchor.constraint(equalTo: parent.widthAnchor).isActive = true
        } else {
            listView.widthAnchor.constraint(equalToConstant: message.width).isActive = true
            listView.widthAnchor.constraint(equalToConstant: message.width).isActive = true
        }
    }
    if message.height != minContent {
        if message.height == fillParent {
            listView.heightAnchor.constraint(equalTo: parent.heightAnchor).isActive = true
        } else {
            listView.widthAnchor.constraint(equalToConstant: message.height).isActive = true
            listView.heightAnchor.constraint(equalToConstant: message.height).isActive = true
        }
    }
    
    return listView
}
