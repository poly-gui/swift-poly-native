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
        guard let portableBinaryPath = Bundle.main.path(forResource: "bundle", ofType: nil) else {
            return
        }
        
        let portableLayerProcess = Process()
        portableLayerProcess.executableURL = NSURL.fileURL(withPath: portableBinaryPath)
        
        let messageChannel = StandardIOMessageChannel(process: portableLayerProcess)
        listenToIncomingMessages(from: messageChannel)
        
        applicationContext = ApplicationContext(
            messageChannel: messageChannel
        )
        
        do {
            try portableLayerProcess.run()
        } catch let err {
            print("Unable to start portable layer process: \(String(describing: err))")
        }
    }
    
    private func listenToIncomingMessages(from channel: MessageChannel) {
        Task {
            for await messageData in channel.messages {
                guard let message = makeNanoPackMessage(from: messageData) else {
                    #if DEBUG
                    if let log = String(data: messageData, encoding: .utf8) {
                        NSLog("VERBOSE: \(log)")
                    } else {
                        NSLog("WARNING: failed to decode message received from portable layer")
                    }
                    #endif
                    continue
                }
                
                Task {
                    await self.handleMessage(message)
                }
            }
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

        case ReplyFromCallback_typeID:
            let msg = message as! ReplyFromCallback
            applicationContext?.rpc.reply(to: msg.to, data: msg.args)

        default:
            NSLog("tf is message \(message.typeID)")
            break
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
