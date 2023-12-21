//
//  ViewController.swift
//  PayWingsKYC-SampleApp
//
//  Created by Tjasa Jan on 29/08/2023.
//

import UIKit
import PayWingsOAuthSDK
import InAppSettingsKit


class ViewController: UIViewController, IASKSettingsDelegate, OAuthInitializationCallbackDelegate {
    
    
    var kycSdkVersion = "KYC SDK v1.0.0"
    var oauthSdkVersion = "OAuth SDK v2.0.0"
    
    @IBOutlet weak var KycSdkVersion: UILabel!
    @IBOutlet weak var OauthSdkVersion: UILabel!
    
    @IBOutlet weak var OpenWalletButton: UIButton!
    
    var oauthInitCallback = OAuthInitializationCallback()
    var oauthInitialized: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sample App"
        OpenWalletButton.isHidden = true
        
        oauthInitCallback.delegate = self
        initializeOAuth()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        KycSdkVersion.text = kycSdkVersion
        OauthSdkVersion.text = oauthSdkVersion
    }
    
    
    func initializeOAuth() {
        
        let domain = UserDefaults.standard.string(forKey: "domain") ?? ""
        let apiKey = UserDefaults.standard.string(forKey: "api_key") ?? ""
        let appPlatformID = UserDefaults.standard.string(forKey: "app_platform_id") ?? ""
        let recaptchaKey = UserDefaults.standard.string(forKey: "recaptcha_key") ?? ""
        
        PayWingsOAuthClient.initialize(environmentType: .TEST, apiKey: apiKey, domain: domain, appPlatformID: appPlatformID, recaptchaKey: recaptchaKey, callback: oauthInitCallback)
    }
    
    
    @IBAction func onStartKyc(_ sender: Any) {
        performSegue(withIdentifier: "loading", sender: nil)
    }
    
    
    @IBAction func startOAuth(_ sender: Any) {
        
        // 2 options to check if OAuth was successfully initialized:
        // Check isReady property
        if PayWingsOAuthClient.isReady {
            //
        }
        // Using callback in the init function
        if oauthInitialized {
            guard PayWingsOAuthClient.instance()?.isUserSignIn() ?? false, let passcode = KeychainService.getGenericPasswordFor(account: .encryption, service: .oauth, biometryProtected: true) else {

                let passcode = UUID().uuidString.replacingOccurrences(of: "-", with: "")
                
                if KeychainService.storeGenericPasswordFor(account: .encryption, service: .oauth, password: passcode, biometryProtected: true) {
                    performSegue(withIdentifier: "enterMobileNumber", sender: nil)
                }
                return
            }
            PayWingsOAuthClient.unlock(passcode: passcode, completionHandler: { success, error in
                
                success == true ? performSegue(withIdentifier: "authData", sender: nil) : debugPrint("Error \(error ?? "")")
            })
        }
        else {
            initializeOAuth()
        }
    }
    
    
//    // Sample for opening another app
//    @IBAction func onOpenWallet(_ sender: Any) {
//        let scheme = "otherappscheme"
//        if let url = URL(string: scheme + "://parameters?name1=test1&name2=test2"), UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:]) { success in
//                print(success)
//            }
//        }
//    }
    
    
    // OAuthInitializationCallbackDelegate
    func onSuccess() {
        oauthInitialized = true
    }
    
    func onFailure(error: OAuthErrorCode, errorMessage: String?) {
        oauthInitialized = false
    }
    
    
    
    @IBAction func openSettings(_ sender: Any) {
        let appSettingsViewController = IASKAppSettingsViewController()
        appSettingsViewController.neverShowPrivacySettings = true
        appSettingsViewController.showCreditsFooter = false
        appSettingsViewController.delegate = self
        
        let navController = UINavigationController(rootViewController: appSettingsViewController)
        navController.modalPresentationStyle = .fullScreen
        self.show(navController, sender: self)
    }
    
    func settingsViewControllerDidEnd(_ settingsViewController: IASKAppSettingsViewController) {
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

