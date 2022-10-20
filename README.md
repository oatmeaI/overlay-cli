# overlay-cli
A small CLI tool to display an overlay on macOS. A replacement for Hammerspoon's `hs.alert`

### Setup
1. Open `overlaycli.xcodeproj` in Xcode
2. Click "Run"

All the code is in `main.swift`

### Todo
 - [ ] Figure out the comments where I said I dunno what it means
 - [x] Figure out how to pass in arguments from the commandline (start with simple stuff - probably x, y, height, width)
 - [ ] Figure out how to pass in more complex data - the eventual text I want to be able to render has newlines, special characters, etc - it'll need to be escaped on the commandline - it's gonna be a while thing
 - [ ] Figure out how signal the program to exit, or at least hide the overlay
 - [ ] On that note - should it be more of a daemon that runs in the background and displays and hides overlays as you call it? Or a single program that shows one overlay and quits when it's hidden? Hmm...
 - [ ] Be able to pass in font, color, size, background color, etc
