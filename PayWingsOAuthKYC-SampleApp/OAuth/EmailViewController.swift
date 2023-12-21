//
//  EmailViewController.swift
//  PayWingsOAuthSDK-SampleApp
//
//  Created by Tjasa Jan on 01/10/2022.
//

import UIKit
import PayWingsOAuthSDK


class EmailViewController : UIViewController, RegisterUserCallbackDelegate {
    
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    
    @IBOutlet weak var ErrorMessage: UILabel!
    
    let callback = RegisterUserCallback()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        callback.delegate = self
        ErrorMessage.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FirstName.becomeFirstResponder()
    }
    
    
    @IBAction func onRegisterUser(_ sender: Any) {
        showLoading()
        ErrorMessage.isHidden = true
        self.view.endEditing(false)
        
        PayWingsOAuthClient.instance()?.registerUser(firstName: FirstName.text ?? "", lastName: LastName.text ?? "", email: Email.text ?? "", callback: callback)
    }
    
    
    // RegisterUserCallbackDelegate
    func onShowEmailConfirmationScreen(email: String, autoEmailSent: Bool) {
        AppData.shared().userEmail = email
        
        hideLoading()
        performSegue(withIdentifier: "checkEmailVerified", sender: nil)
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
