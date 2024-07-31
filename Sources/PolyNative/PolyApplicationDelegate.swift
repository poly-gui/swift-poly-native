//
//  PolyApplicationDelegate.swift
//  poly_native
//
//  Created by Kenneth Ng on 31/12/2023.
//

import Cocoa
import Foundation
import NanoPack
import twx

open class PolyApplicationDelegate: NSObject, NSApplicationDelegate {
    private var windowManager = WindowManager()
    private var applicationContext: ApplicationContext?
    
    #if DEBUG
    private var devServerSocket: URLSessionWebSocketTask?
    #endif
    
    open func applicationDidFinishLaunching(_ notification: Notification) {
        initializeApplicationContext()
    }
    
    public func stop() {
        do {
            try applicationContext?.portableLayer.kill()
        } catch {}
    }
    
    public func applicationWillTerminate(_ notification: Notification) {
        stop()
    }
    
    private func initializeApplicationContext() {
        let portableLayer = PortableLayerInChildProcess(messageHandler: handleMessage(_:))
        applicationContext = ApplicationContext(
            portableLayer: portableLayer
        )

        do {
            try portableLayer.start()
            #if DEBUG
            if devServerSocket == nil {
                connectToDevServer()
            }
            #endif
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
        let delegate = PolyWindowDelegate()
        window.title = message.title
        window.delegate = delegate
        window.isReleasedWhenClosed = false
        window.center()
        window.makeKeyAndOrderFront(nil)

        windowManager.add(window: window, withTag: message.tag, delegate: delegate)
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
    
    #if DEBUG
    private func connectToDevServer() {
        let task = URLSession.shared.webSocketTask(with: URL(string: "ws://localhost:8759/ws")!)
        task.resume()
        task.receive { result in
            guard case .success(let msg) = result else {
                return
            }
            self.onWebSocketMessage(msg)
        }
        
        devServerSocket = task
        
        print("connected to dev server at localhost:8759!")
    }
    
    private func onWebSocketMessage(_ message: URLSessionWebSocketTask.Message) {
        guard case .string(let string) = message else {
            return
        }
        
        switch string {
        case "hotRestart":
            hotRestart()
            
        default:
            break
        }
    }
    
    private func hotRestart() {
        print("binary updated. hot restarting...")
        Task {
            await MainActor.run { windowManager.closeAllWindows() }
        }
        do {
            try applicationContext?.portableLayer.kill()
            applicationContext = nil
        } catch let err {
            print("[WARNING] failed to gracefully terminate portable layer process. \(err)")
        }
        initializeApplicationContext()
    }
    #endif
}
