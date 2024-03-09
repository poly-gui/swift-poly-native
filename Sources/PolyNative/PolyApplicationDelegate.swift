//
//  PolyApplicationDelegate.swift
//  poly_native
//
//  Created by Kenneth Ng on 31/12/2023.
//

import Cocoa
import Foundation
import NanoPack

open class PolyApplicationDelegate: NSObject, NSApplicationDelegate {
    private var windowManager = WindowManager()
    
    private var applicationContext: ApplicationContext?
    
    open func applicationDidFinishLaunching(_ notification: Notification) {
        let portableLayer = PortableLayerInChildProcess(messageHandler: handleMessage(_:))
        
        applicationContext = ApplicationContext(
            portableLayer: portableLayer
        )
        
        do {
            try portableLayer.start()
        } catch let err {
            print("Unable to start portable layer process: \(String(describing: err))")
        }
    }
    
    private func handleMessage(_ message: NanoPackMessage) async {
        switch message.typeID {
        case CreateWindow_typeID:
            await MainActor.run { self.createWindow(message: message as! CreateWindow) }
            
        case CreateWidget_typeID:
            await MainActor.run { self.createView(message: message as! CreateWidget) }
            
        case UpdateWidget_typeID:
            await MainActor.run { self.updateView(message: message as! UpdateWidget) }
            
        case UpdateWidgets_typeID:
            let msg = message as! UpdateWidgets
            await MainActor.run {
                for update in msg.updates {
                    self.updateView(message: update)
                }
            }

        default:
            NSLog("tf is message \(message.typeID)")
        }
    }
    
    @MainActor
    private func createWindow(message: CreateWindow) {
        let window = NSWindow(
            contentRect: NSMakeRect(0, 0, CGFloat(integerLiteral: Int(message.width)), CGFloat(integerLiteral: Int(message.height))),
            styleMask: [.titled, .resizable, .miniaturizable, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = message.title
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        windowManager.add(window: window, withTag: message.tag)
    }
    
    @MainActor
    private func createView(message: CreateWidget) {
        guard let rootView = windowManager.findWindow(withTag: message.windowTag)?.contentView,
              let context = applicationContext
        else {
            return
        }
        _ = makeWidget(with: message.widget, parent: rootView, context: context)
    }
    
    @MainActor
    private func updateView(message: UpdateWidget) {
        guard let context = applicationContext,
              let view = context.viewRegistry.viewWithTag(message.tag)
        else {
            return
        }
        updateWidget(old: view, new: message.widget, context: context, args: message.args)
    }
}
