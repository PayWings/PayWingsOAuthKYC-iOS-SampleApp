//
//  GetUserData.swift
//  PayWingsOAuthKYC-SampleApp
//
//  Created by Tjasa Jan on 25/11/2023.
//

import UIKit
import PayWingsOAuthSDK


class GetUserDataViewController : UIViewController, GetUserDataCallbackDelegate, GetNewAuthorizationDataCallbackDelegate {
    
    
    @IBOutlet weak var ErrorMessage: UILabel!
    @IBOutlet weak var UserID: UILabel!
    @IBOutlet weak var FirstName: UILabel!
    @IBOutlet weak var LastName: UILabel!
    @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var EmailConfirmed: UILabel!
    @IBOutlet weak var PhoneNumber: UILabel!
    
    
    var callbackUserData = GetUserDataCallback()
    var callbackAuthData = GetNewAuthorizationDataCallback()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ErrorMessage.isHidden = true
        
        callbackUserData.delegate = self
        callbackAuthData.delegate = self
    }
    
    
    @IBAction func onGetData(_ sender: Any) {
        showLoading()
        ErrorMessage.isHidden = true
        
        PayWingsOAuthClient.instance()?.getUserData(callback: callbackUserData)
    }
    
    
    
    @IBAction func onGetNewAuthorizationData(_ sender: Any) {
        showLoading()
        ErrorMessage.isHidden = true
        
        PayWingsOAuthClient.instance()?.getNewAuthorizationData(methodUrl: "/test", httpRequestMethod: .POST, callback: callbackAuthData)
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        
        PayWingsOAuthClient.instance()?.signOutUser()
        _ = KeychainService.deleteGenericPasswordFor(account: .encryption, service: .oauth, biometryProtected: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    @IBAction func onClose(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    // GetUserDataCallbackDelegate
    func onUserData(userId: String, firstName: String?, lastName: String?, email: String?, emailConfirmed: Bool, phoneNumber: String?) {
        UserID.text = "UserID: " + userId
        FirstName.text = "FirstName: " + (firstName ?? "")
        LastName.text = "LastName: " + (lastName ?? "")
        Email.text = "Email: " + (email ?? "")
        EmailConfirmed.text = "EmailConfirmed: " + emailConfirmed.description
        PhoneNumber.text = "PhoneNumber: " + (phoneNumber ?? "")
        hideLoading()
     }
    
    // GetNewAuthorizationDataCallbackDelegate
    func onNewAuthorizationData(dpop: String, accessToken: String, accessTokenExpirationTime: Int64) {
        ErrorMessage.text = "NEW AUTH DATA SUCCESS"
        ErrorMessage.isHidden = false
        hideLoading()
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

