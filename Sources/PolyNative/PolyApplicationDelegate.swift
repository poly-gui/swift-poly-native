import Cocoa
import Foundation
import NanoPack
import twx

open class PolyApplicationDelegate: NSObject, NSApplicationDelegate, NativeLayerServiceDelegate {
    private var windowManager = WindowManager()
    private var applicationContext: ApplicationContext?
    
    #if DEBUG
    private var devServerSocket: URLSessionWebSocketTask?
    #endif
    
    private var portableLayerProcess: Process?
    private var rpcChannel: StandardIOChannel?
    private var rpcServer: NativeLayerServiceServer?
    
    open func applicationDidFinishLaunching(_ notification: Notification) {
        initializeApplicationContext()
    }
    
    public func stop() {
        rpcChannel?.close()
        portableLayerProcess?.terminate()
    }
    
    public func applicationWillTerminate(_ notification: Notification) {
        stop()
    }
    
    func createWidget(_ widget: Widget, _ windowTag: String) {
        DispatchQueue.main.async {
            guard let rootView = self.windowManager.findWindow(withTag: windowTag)?.contentView,
                  let context = self.applicationContext
            else {
                return
            }
            _ = makeWidget(with: widget, parent: rootView, context: context)
        }
    }
    
    func updateWidget(_ tag: UInt32, _ widget: Widget, _ args: NanoPackMessage?) {
        DispatchQueue.main.async {
            guard let context = self.applicationContext,
                  let view = context.viewRegistry.viewWithTag(tag)
            else {
                return
            }
            PolyNative.updateWidget(old: view, new: widget, context: context, args: args)
        }
    }
    
    func updateWidgets(_ tag: [UInt32], _ widgets: [Widget], _ args: (any NanoPack.NanoPackMessage)?) {
        DispatchQueue.main.async {
            guard let context = self.applicationContext else {
                return
            }
            for i in 0 ..< tag.count {
                guard let view = context.viewRegistry.viewWithTag(tag[i]) else {
                    continue
                }
                PolyNative.updateWidget(old: view, new: widgets[i], context: context, args: args)
            }
        }
    }

    func createWindow(_ title: String, _ description: String, _ width: Int32, _ height: Int32, _ tag: String) {
        DispatchQueue.main.async {
            let window = NSWindow(
                contentRect: NSMakeRect(0, 0, CGFloat(integerLiteral: Int(width)), CGFloat(integerLiteral: Int(height))),
                styleMask: [.titled, .resizable, .miniaturizable, .closable],
                backing: .buffered,
                defer: false
            )
            let delegate = PolyWindowDelegate()
            window.title = title
            window.delegate = delegate
            window.isReleasedWhenClosed = false
            window.center()
            window.makeKeyAndOrderFront(nil)
            self.windowManager.add(window: window, withTag: tag, delegate: delegate)
        }
    }
        
    private func initializeApplicationContext() {
        let portableLayerProcess = Process()
        portableLayerProcess.executableURL = NSURL.fileURL(withPath: Bundle.main.path(forResource: "bundle", ofType: nil)!)
        
        let stdin = Pipe()
        let stdout = Pipe()
        portableLayerProcess.standardInput = stdin
        portableLayerProcess.standardOutput = stdout
        
        let channel = NPStandardIOChannel(stdin: stdin, stdout: stdout)
        let portableLayer = PortableLayerServiceClient(channel: channel)
        rpcServer = NativeLayerServiceServer(channel: channel, delegate: self)
        applicationContext = ApplicationContext(
            portableLayer: portableLayer
        )
        
        do {
            try portableLayerProcess.run()
            channel.open()
            
            #if DEBUG
            if devServerSocket == nil {
                connectToDevServer()
            }
            #endif
        } catch let err {
            channel.close()
            print("Unable to start portable layer process: \(String(describing: err))")
        }
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
        rpcChannel?.close()
        portableLayerProcess?.terminate()
        applicationContext = nil
        initializeApplicationContext()
    }
    #endif
}
