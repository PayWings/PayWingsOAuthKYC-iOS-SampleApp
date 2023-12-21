//
//  ConfirmEmailViewController.swift
//  PayWingsOAuthSDK-SampleApp
//
//  Created by Tjasa Jan on 01/10/2022.
//

import UIKit
import PayWingsOAuthSDK


class ConfirmEmailViewController : UIViewController, CheckEmailVerifiedCallbackDelegate, SendNewVerificationEmailCallbackDelegate {
    
    
    @IBOutlet weak var CheckEmailText: UILabel!
    @IBOutlet weak var ErrorMessage: UILabel!
    @IBOutlet weak var ChangeEmailButton: UIButton!
    
    var checkEmailCallback = CheckEmailVerifiedCallback()
    var resendEmailCallback = SendNewVerificationEmailCallback()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ErrorMessage.isHidden = true
        
        checkEmailCallback.delegate = self
        resendEmailCallback.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CheckEmailText.text = "Email verification required: " + AppData.shared().userEmail
    }
    
    
    @IBAction func onCheckEmailVerified(_ sender: Any) {
        showLoading()
        ErrorMessage.isHidden = true
        
        PayWingsOAuthClient.instance()?.checkEmailVerified(callback: checkEmailCallback)
    }
    
    
    @IBAction func onResendEmail(_ sender: Any) {
        showLoading()
        ErrorMessage.isHidden = true
        
        PayWingsOAuthClient.instance()?.sendNewVerificationEmail(callback: resendEmailCallback)
    }
    
    @IBAction func onChangeEmail(_ sender: Any) {
        ErrorMessage.isHidden = true
        performSegue(withIdentifier: "changeEmail", sender: nil)
    }
    
    
    // CheckEmailVerifiedCallbackDelegate
    func onEmailNotVerified() {
        ErrorMessage.text = "Email not verified"
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
    
    // SendNewVerificationEmailCallbackDelegate
    func onShowEmailConfirmationScreen(email: String, autoEmailSent: Bool) {
        AppData.shared().userEmail = email
        hideLoading()
    }
    
}


