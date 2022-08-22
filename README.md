# M1Pasteboard

This is a simple solution to the clipping board problem of Apple silicon MAC IOS simulator.

## Working Principle
* Start an HTTP service locally. After receiving the request, the service will return the current clipboard content.
* Customize the shortcut key `Ctrl + V` on the app side, start this shortcut key in the input box(UITextField or UITextView), then send an HTTP request, and automatically fill the input box after getting the result. The code has been encapsulated and can be directly integrated.

## Inspire
[CocoaHTTPServer](https://github.com/robbiehanson/CocoaHTTPServer)
[findFirstResponder](https://stackoverflow.com/questions/1823317/get-the-current-first-responder-without-using-a-private-api)