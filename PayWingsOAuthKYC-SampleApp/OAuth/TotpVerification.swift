//
//  TotpVerification.swift
//  PayWingsKYC-SampleApp
//
//  Created by Tjasa Jan on 22/11/2023.
//

import UIKit
import PayWingsOAuthSDK


class TotpVerificationViewController : UIViewController, SignInWithPhoneTimeBasedOTPVerificationCallbackDelegate {
    
    
    var accountName: String! = ""
    
    @IBOutlet weak var AccountName: UILabel!
    @IBOutlet weak var TOTPcode: UITextField!
    @IBOutlet weak var ErrorMessage: UILabel!
    
    let callback = SignInWithPhoneTimeBasedOTPVerificationCallback()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        callback.delegate = self
        AccountName.text = accountName
        ErrorMessage.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        TOTPcode.becomeFirstResponder()
    }
    
    
    @IBAction func onContinue(_ sender: Any) {
        showLoading()
        ErrorMessage.isHidden = true
        self.view.endEditing(false)
        
        PayWingsOAuthClient.instance()?.signInWithPhoneTimeBasedOTPVerification(timeBasedOtp: TOTPcode.text ?? "", callback: callback)
    }
    
    
    // SignInWithPhoneTimeBasedOTPVerificationCallbackDelegate
    func onShowEmailConfirmationScreen(email: String, autoEmailSent: Bool) {
        AppData.shared().userEmail = email
        hideLoading()
        performSegue(withIdentifier: "checkEmailVerified", sender: nil)
    }
    
    func onShowRegistrationScreen() {
        hideLoading()
        performSegue(withIdentifier: "userRegistration", sender: nil)
    }
    
    func onVerificationFailed() {
        ErrorMessage.text = "TOTP verification failed"
        ErrorMessage.isHidden = false
        hideLoading()
    }
    
    func onSignInSuccessful() {
        let passcode = KeychainService.getGenericPasswordFor(account: .encryption, service: .oauth, biometryProtected: true)
        PayWingsOAuthClient.setupSecurity(passcode: passcode ?? "", completionHandler: { success, error in
            
            success == true ? self.performSegue(withIdentifier: "authData", sender: nil) : debugPrint("Error \(error ?? "")")
        })
    }
    
    func onUserSignInRequired() {
        ErrorMessage.text = "Sign in is required - please enter your phone number"
        ErrorMessage.isHidden = false
        hideLoading()
    }
    
    func onError(error: PayWingsOAuthSDK.OAuthErrorCode, errorMessage: String?) {
        ErrorMessage.text = errorMessage ?? error.description
        ErrorMessage.isHidden = false
        hideLoading()
    }
}
