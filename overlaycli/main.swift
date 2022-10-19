import AppKit
import Cocoa

class SWindow: NSWindow {
    override var canBecomeKey:Bool {
        return true
    }
    
    override var canBecomeMain:Bool {
        return true
    }
}

class Overlay: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var window: NSWindow!
    
    func main() {
        NSApp.activate(ignoringOtherApps: true)
        
        let winRect:NSRect = NSMakeRect(0, 0, 100, 100)
        self.setupWindow(winRect: winRect)
        self.window.center()
        self.window.makeKeyAndOrderFront(nil)
        self.window.orderFrontRegardless()
    }
    
    func setupWindow(winRect: NSRect) {
        let styleMask = NSWindow.StyleMask.borderless
        self.window = SWindow(contentRect: winRect, styleMask: styleMask, backing: NSWindow.BackingStoreType.buffered, defer: false)
        self.window.isOpaque = false
        self.window.alphaValue = 1
        self.window.backgroundColor = NSColor.clear
        self.window.delegate = self
        
        let height = 500.0
        let width = 500.0
        
        let winRect: NSRect = NSMakeRect(0, 0, width, height)
        self.window.setFrame(winRect, display: true)
        
        let message = NSView(frame: winRect)
        message.wantsLayer = true
        message.layer?.cornerRadius = 10
        
        let messageText = NSText(frame: winRect)
        messageText.string = "HERE SOME TEXT"
        messageText.backgroundColor = NSColor.init(red: 0.5, green: 0.2, blue: 0.9, alpha: 0.8)
        
        message.addSubview(messageText)
        
        self.window.contentView?.addSubview(message)
        
        let v: NSView = NSView(frame: winRect)
        v.wantsLayer = true
        v.layer?.backgroundColor = NSColor.green.cgColor
//        self.window?.contentView?.addSubview(v)
    }
}

func main() -> Int {
    autoreleasepool {
        let delegate = Overlay()
        let app = NSApplication.shared
        
        app.delegate = delegate
        delegate.main()
        
        _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    }
    return 0
}
_ = main()
