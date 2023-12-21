//
//  ChangeEmailViewController.swift
//  PayWingsOAuthSDK-TestApp
//
//  Created by Tjasa Jan on 10/10/2022.
//

import UIKit
import PayWingsOAuthSDK


class ChangeEmailViewController : UIViewController, ChangeUnverifiedEmailCallbackDelegate {
    
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var ErrorMessage: UILabel!
    
    var callback = ChangeUnverifiedEmailCallback()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        ErrorMessage.isHidden = true
        callback.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Email.becomeFirstResponder()
    }
    
    
    @IBAction func onChangeEmail(_ sender: Any) {
        showLoading()
        ErrorMessage.isHidden = true
        self.view.endEditing(false)
        
        PayWingsOAuthClient.instance()?.changeUnverifiedEmail(email: Email.text ?? "", callback: callback)
    }
    
    
    
    // ChangeUnverifiedEmailCallbackDelegate
    func onShowEmailConfirmationScreen(email: String, autoEmailSent: Bool) {
        AppData.shared().userEmail = email
        hideLoading()
        self.navigationController?.transitionFromRightToLeft()
        self.navigationController?.popViewController(animated: true)
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




extension UINavigationController {
    
    public func transitionFromRightToLeft() {

        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.layer.add(transition, forKey: nil)
    }
}
