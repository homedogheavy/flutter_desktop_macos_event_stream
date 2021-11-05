import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    private var eventSink: FlutterEventSink?

    private func nsButtonTmpl(label: String, cgRect: CGRect, color: CGColor ) -> NSButton {
        let bt = NSButton(title: label, target: self, action: #selector(tapped(_:)))
        bt.frame = cgRect;
        bt.bezelStyle = .texturedSquare
        bt.isBordered = false
        bt.wantsLayer = true
        bt.layer?.backgroundColor = color
        return bt
    }

    override func applicationDidFinishLaunching(_ aNotification: Notification) {
        let controller : FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
        let chargingChannel = FlutterEventChannel(name: "samples.flutter.io/button",
                                                  binaryMessenger: controller.engine.binaryMessenger)
        chargingChannel.setStreamHandler(self)
        let btA = nsButtonTmpl(label: "buttonA", cgRect: CGRect(x:150, y:150, width: 100, height: 50), color: NSColor.red.cgColor)
        mainFlutterWindow?.contentView?.subviews[0].addSubview(btA)

        let btB = nsButtonTmpl(label: "buttonB", cgRect: CGRect(x:300, y:150, width: 100, height: 50), color: NSColor.green.cgColor)
        mainFlutterWindow?.contentView?.subviews[0].addSubview(btB)

        let btC = nsButtonTmpl(label: "buttonC", cgRect: CGRect(x:450, y:150, width: 100, height: 50), color: NSColor.blue.cgColor)
        mainFlutterWindow?.contentView?.subviews[0].addSubview(btC)
    }

    @objc func tapped(_ sender: NSButton) {
        sendBatteryStateEvent(label: sender.title)
    }

    public func onListen(withArguments arguments: Any?,
                         eventSink: @escaping FlutterEventSink) -> FlutterError? {
         self.eventSink = eventSink
        return nil
    }
    
    private func sendBatteryStateEvent(label: String) {
        guard let eventSink = eventSink else {
            return
        }
        eventSink(label)
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
    }
}

