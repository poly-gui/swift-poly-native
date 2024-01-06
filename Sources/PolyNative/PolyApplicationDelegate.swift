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
    
    open func applicationDidFinishLaunching(_ notification: Notification) {
        guard let portableBinaryPath = Bundle.main.path(forResource: "bundle", ofType: nil) else {
            return
        }
        
        let portableLayerProcess = Process()
        let stdout = Pipe()
        let stdin = Pipe()
        
        if #available(macOS 13.0, *) {
            portableLayerProcess.executableURL = URL(filePath: portableBinaryPath)
        } else {
            portableLayerProcess.executableURL = NSURL.fileURL(withPath: portableBinaryPath)
        }
        portableLayerProcess.standardOutput = stdout
        portableLayerProcess.standardInput = stdin
        
        stdout.fileHandleForReading.readabilityHandler = { pipe in
            let data = pipe.availableData
            guard !data.isEmpty else {
                return
            }
            
            let typeID = data[4 ..< 8].withUnsafeBytes {
                $0.load(as: Int32.self).littleEndian
            }
            
            guard let message = makeNanoPackMessage(from: data[4...], typeID: Int(typeID)) else {
                return
            }
            
            self.handleMessage(message)
        }
        
        do {
            try portableLayerProcess.run()
        } catch let err {
            print("Unable to start portable layer process: \(String(describing: err))")
        }
    }
    
    private func handleMessage(_ message: NanoPackMessage) {
        switch message.typeID {
        case CreateWindow_typeID:
            Task {
                await MainActor.run { self.createWindow(message: message as! CreateWindow) }
            }
            
        case CreateWidget_typeID:
            Task {
                await MainActor.run { self.createView(message: message as! CreateWidget) }
            }
            
        default:
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
        guard let window = windowManager.findWindow(withTag: message.windowTag),
              let view = makeWidget(with: message.widget, parent: window.contentView)
        else {
            return
        }
        window.contentView?.addSubview(view)
    }
}
