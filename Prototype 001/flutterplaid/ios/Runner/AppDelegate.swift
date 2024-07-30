import UIKit
import Flutter
import PlaidLinkKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private let channel = "plaidChannel"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: channel, binaryMessenger: controller.binaryMessenger)
        
        methodChannel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "openPlaidLink" {
                if let args = call.arguments as? [String: Any],
                   let linkToken = args["linkToken"] as? String {
                    self?.openPlaidLink(linkToken: linkToken, result: result)
                } else {
                    result(FlutterError(code: "NO_TOKEN", message: "No Link token provided", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func openPlaidLink(linkToken: String, result: @escaping FlutterResult) {
        let linkTokenConfiguration = PLKLinkTokenConfiguration(token: linkToken) { (success: PLKLinkSuccess?) in
            guard let success = success else { return }
            let message = "Public Token: \(success.publicToken)"
            self.showToast(message: message)
            result(nil)
        } onExit: { (exit: PLKLinkExit?) in
            if let error = exit?.error {
                let message = "Exit: \(error.localizedDescription)"
                self.showToast(message: message)
            } else {
                let message = "Exit: User cancelled"
                self.showToast(message: message)
            }
        }
        
        let linkViewController = PLKPlaidLinkViewController(configuration: linkTokenConfiguration)
        linkViewController?.modalPresentationStyle = .overFullScreen
        self.window?.rootViewController?.present(linkViewController!, animated: true, completion: nil)
    }
    
    private func showToast(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
