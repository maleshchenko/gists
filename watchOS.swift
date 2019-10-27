// InterfaceController is a default viewController-like class in a watchOS app

import WatchKit
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    override func willActivate() {
        super.willActivate()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            session.sendMessage(["messageKey": "messageValue"], replyHandler: nil)
        }
    }
}

extension InterfaceController: WCSessionDelegate {    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        guard let text = message["receivedMessageKey"] as? String else { return }
        // print(text)
    }
}


// -----------------------------


// iOS AppDelegate

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        return true
    }
}

extension AppDelegate: WCSessionDelegate {
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {        
        guard let value = message["messageKey"] as? String else { return }
        if value == "messageValue" {
            session.sendMessage(["receivedMessageKey": "Hello, world!"], replyHandler: nil)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
}
