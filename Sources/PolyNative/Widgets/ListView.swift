//
//  ListView.swift
//
//
//  Created by Kenneth Ng on 24/02/2024.
//

import AppKit
import Foundation

class ListViewDataSource: NSObject, NSCollectionViewDataSource {
    var sections: [UInt32]
    
    private let onCreate: CallbackHandle
    private let onBind: CallbackHandle
    private let context: ApplicationContext
    
    init(_ context: ApplicationContext, onCreate: CallbackHandle, onBind: CallbackHandle, sections: [UInt32]) {
        self.context = context
        self.sections = sections
        self.onCreate = onCreate
        self.onBind = onBind
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
        
        item.context = context
        item.onCreateCallbackHandle = onCreate
        item.onBindCallbackHandle = onBind
        
        let renderItemConfig = ListViewItemConfig(
            sectionIndex: UInt32(indexPath.section),
            itemIndex: UInt32(indexPath.item),
            itemTag: item.tag
        )
        
        if item.isReused {
            item.rebind(config: renderItemConfig)
        } else {
            item.create(config: renderItemConfig)
        }
        
        return item
    }
}

class PolyListViewItem: NSCollectionViewItem {
    static let identifier = NSUserInterfaceItemIdentifier("ListViewItem")

    private(set) var isReused = false
    
    var context: ApplicationContext? = nil
    var tag: UInt32? = nil
    var itemView: NSView? = nil
    var onCreateCallbackHandle: CallbackHandle? = nil
    var onBindCallbackHandle: CallbackHandle? = nil
    
    override func loadView() {
        view = NSView()
    }

    override func prepareForReuse() {
        isReused = true
    }
    
    func create(config: ListViewItemConfig) {
        context!.portableLayer.invokeCallback(onCreateCallbackHandle!, config) { result in
            guard case let .success(msg) = result else {
                return
            }
            DispatchQueue.main.sync {
                guard let itemMsg = msg as? ListViewItem else {
                    return
                }
                self.tag = itemMsg.itemTag
                self.itemView = makeWidget(with: itemMsg.widget, parent: self.view, context: self.context!)
            }
        }
    }
    
    func rebind(config: ListViewItemConfig) {
        context!.portableLayer.invokeVoidCallback(onBindCallbackHandle!, config) { _ in }
    }
}

class PolyListViewDelegate: NSObject, NSCollectionViewDelegateFlowLayout {
    var itemHeight: Float = 0.0
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {}
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: CGFloat(itemHeight))
    }
}

class PolyListView: NSScrollView {
    private(set) var dataSource: ListViewDataSource? = nil
    private(set) var collectionViewDelegate: PolyListViewDelegate? = nil
    
    private var collectionView: NSCollectionView? = nil
    
    convenience init(_ context: ApplicationContext, _ message: ListView) {
        self.init()
        
        let collectionView = NSCollectionView()
        
        let layout = NSCollectionViewFlowLayout()
        
        let dataSource = ListViewDataSource(context, onCreate: message.onCreate, onBind: message.onBind, sections: message.sections)
        let delegate = PolyListViewDelegate()
        delegate.itemHeight = Float(message.itemHeight)

        self.dataSource = dataSource
        self.collectionViewDelegate = delegate

        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.collectionViewLayout = layout
        collectionView.register(PolyListViewItem.self, forItemWithIdentifier: PolyListViewItem.identifier)
        
        self.collectionView = collectionView
        documentView = collectionView
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        if oldSize.width != bounds.width, let collectionView = documentView as? NSCollectionView {
            collectionView.collectionViewLayout?.invalidateLayout()
        }
    }
    
    func reloadData() {
        collectionView?.reloadData()
    }
    
    func performBatchUpdates(_ operations: ListViewBatchOperations) {
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.performBatchUpdates {
            for operation in operations.operations {
                switch operation {
                case let operation as ListViewDeleteOperation:
                    var paths: Set<IndexPath> = []
                    for i in operation.deleteAt {
                        paths.insert(IndexPath(item: Int(i), section: 0))
                    }
                    collectionView.deleteItems(at: paths)
                    
                case let operation as ListViewInsertOperation:
                    var paths: Set<IndexPath> = []
                    for i in operation.insertAt {
                        paths.insert(IndexPath(item: Int(i), section: 0))
                    }
                    collectionView.insertItems(at: paths)
                    
                default:
                    break
                }
            }
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
    
    listView.translatesAutoresizingMaskIntoConstraints = false
    
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

@MainActor
func updateListView(current listView: PolyListView, new config: ListView, operations: ListViewBatchOperations) {
    listView.dataSource?.sections = config.sections
    if operations.operations.isEmpty {
        listView.reloadData()
    } else {
        listView.performBatchUpdates(operations)
    }
}
