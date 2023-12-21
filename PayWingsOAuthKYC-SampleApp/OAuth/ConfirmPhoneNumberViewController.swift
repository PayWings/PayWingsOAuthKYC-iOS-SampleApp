//
//  ConfirmPhoneNumberViewController.swift
//  PayWingsOAuthSDK-SampleApp
//
//  Created by Tjasa Jan on 01/10/2022.
//

import UIKit
import PayWingsOAuthSDK


class ConfirmPhoneNumberViewController : UIViewController, SignInWithPhoneNumberVerifyOtpCallbackDelegate {
    
    
    var mobileNumber: String!
    var otpLength: Int!
    
    @IBOutlet weak var VerificationCodeText: UILabel!
    @IBOutlet weak var VerificationCode: UITextField!
    
    @IBOutlet weak var ErrorMessage: UILabel!
    
    var callback = SignInWithPhoneNumberVerifyOtpCallback()
    
    var account: String = ""
    var secKey: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        callback.delegate = self
        
        ErrorMessage.isHidden = true
        VerificationCodeText.text = "Enter " + otpLength.description + "-digit verification code"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        VerificationCode.becomeFirstResponder()
    }
    
    
    @IBAction func onSubmitVerificationCode(_ sender: Any) {
        showLoading()
        ErrorMessage.isHidden = true
        VerificationCode.resignFirstResponder()
        
        PayWingsOAuthClient.instance()?.signInWithPhoneNumberVerifyOtp(otp: VerificationCode.text ?? "", callback: callback)
    }
    
    
    
    // SignInWithPhoneNumberVerifyOtpCallbackDelegate
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
        ErrorMessage.text = "OTP verification failed"
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
    
    func onShowTimeBasedOtpVerificationInputScreen(accountName: String) {
        account = accountName
        performSegue(withIdentifier: "totpVerification", sender: nil)
    }
    
    func onShowTimeBasedOtpSetupScreen(accountName: String, secretKey: String) {
        account = accountName
        secKey = secretKey
        performSegue(withIdentifier: "totpSetup", sender: nil)
    }
    
    func onError(error: PayWingsOAuthSDK.OAuthErrorCode, errorMessage: String?) {
        ErrorMessage.text = errorMessage ?? error.description
        ErrorMessage.isHidden = false
        hideLoading()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "totpVerification" {
            guard let vc = segue.destination as? TotpVerificationViewController else { return }
            vc.accountName = account
        }
        else if segue.identifier == "totpSetup" {
            guard let vc = segue.destination as? TotpSetupViewController else { return }
            vc.accountName = account
            vc.secKey = secKey
        }
    }
    
}
