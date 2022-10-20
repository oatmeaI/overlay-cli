import AppKit
import Cocoa

// overlay-cli: A commandline tool that displays an overlay onscreen with the given text

// We're creating a headless app - there's no Dock icon or menubar or anything
// So we need to override some properties of NSWindow (the Cocoa base class for a window)
// in order to make it so that this weird non-app window is allowed to be focused
class SWindow: NSWindow {
    override var canBecomeKey:Bool {
        return true
    }
    
    override var canBecomeMain:Bool {
        return true
    }
}

// function to read local file, we pass in the name of the file
private func getData(name: String?) {
    guard let path = Bundle.main.path(forResource: "config", ofType: "plist", inDirectory: "Resources") else { return }
    let url = URL(fileURLWithPath: path)

    let data = try! Data(contentsOf: url)

    guard let plist = try! PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {return}

    print(plist)
}

// This class describes the actual app itself!
class Overlay: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var window: NSWindow!
    
    func main(height: Float, width: Float) {
        NSApp.activate(ignoringOtherApps: true) // Brings our app to the front
        
        // We define the height and width arguments as Floats, but the NSMakeRect method actually wants CGFloats. I dunno what that even is - I think some leftover from Cocoa, maybe? - but anyway, I think making the external interface ask for a normal Float, and dealing with the weirdness in secret here makes sense.
        let startingRect = NSMakeRect(0, 0, CGFloat(height), CGFloat(width)) // Create the rectangle that our window will use (we will want to pass the dimensions in as arguments in the future)
        self.setupWindow(winRect: startingRect) // winRect: startingRect - this is a labeled argument.
        
        self.window.center() // duh
        self.window.makeKeyAndOrderFront(nil) // Might not be necessary; more stuff to force our window on top of everything else.
        self.window.orderFrontRegardless() // Brings our WINDOW to the front (as opposed to line 24)
    }
    
    func setupWindow(winRect: NSRect) { // winRect: NSRect - this defines a labeled argument, and defines the type of the argument as NSRect
        let styleMask = NSWindow.StyleMask.borderless // Just a builtin constant that tells the window not to draw the usual window chrome
        self.window = SWindow(contentRect: winRect, styleMask: styleMask, backing: NSWindow.BackingStoreType.buffered, defer: false) // Create an instance of our custom window class. Pass in the rectangle, the styleMask we defined. unclear what backing and defer mean; this is copypasta code lol
        self.window.isOpaque = false // duh
        self.window.backgroundColor = NSColor.clear // The window itself shouldn't have a background...you'll see why
        self.window.delegate = self // dunno. possibly not needed.
        
        self.window.setFrame(winRect, display: true) // also unclear what this does lol
        
        let message = NSView(frame: winRect) // create a view that will hold our content
        message.wantsLayer = true // `layer` means a Core Animation layer - this is how we will give it rounded corners
        message.layer?.cornerRadius = 10 // voila
        
        let messageText = NSText(frame: winRect) // now create the object that holds the text we wanna render
        messageText.string = "HERE SOME TEXT" // we'll also want to pass this in somehow
        messageText.backgroundColor = NSColor.init(red: 0.5, green: 0.2, blue: 0.9, alpha: 0.8) // gonna want to pass this in as well
        
        message.addSubview(messageText) // add the text to the Core Animation layer we created above...
        
        self.window.contentView?.addSubview(message) // ...and then add the layer to window
    }
}

func main() -> Int {
    autoreleasepool { // dunno what this does, I assume turns on automatic memory management / garbage collection
        let delegate = Overlay() // Create our app object
        let app = NSApplication.shared // NSApplication.shared is like...a reference to the Application object provided by AppKit? Honestly I don't quite understand this stuff...
        getData(name: "config")
        let height = Float(CommandLine.arguments[1]) ?? 500.0 // Commandline args always come in as strings, so we gotta make them Floats
        let width = Float(CommandLine.arguments[2])  ?? 500.0 // Float() returns nil (or maybe 0, I can't remember) if it can't parse a number out of the value, so we gotta default this to something
        
        app.delegate = delegate // ...but attaching our Overlay instance to NSApplication.shared.delegate is kinda what...makes the app run.
        delegate.main(height: height, width: width) // This makes sense, we're calling the actual method we wrote above...
        
        _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv) // ...but the app also doesn't run if we don't also call this. Frankly, I think I'm doing something wrong here, but I don't quite understand what.
    }
    return 0
}
_ = main() // aaaand just run the actual program.
