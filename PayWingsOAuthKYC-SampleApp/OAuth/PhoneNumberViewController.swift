//
//  PhoneNumberViewController.swift
//  PayWingsOAuthSDK-SampleApp
//
//  Created by Tjasa Jan on 01/10/2022.
//

import UIKit
import PayWingsOAuthSDK



class PhoneNumberViewController : UIViewController, SignInWithPhoneNumberRequestOtpCallbackDelegate {
    
    
    @IBOutlet weak var CountryCode: UITextField!
    @IBOutlet weak var MobileNumber: UITextField!
    @IBOutlet weak var ErrorMessage: UILabel!
    
    var callback = SignInWithPhoneNumberRequestOtpCallback()
    
    var otpL: Int = 0
    var account: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        callback.delegate = self
        ErrorMessage.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        CountryCode.becomeFirstResponder()
    }
    

    @IBAction func onSubmitPhoneNumebr(_ sender: Any) {
        showLoading()
        ErrorMessage.isHidden = true
        let countryCode = CountryCode.text ?? ""
        let phoneNUmber = MobileNumber.text ?? ""
        MobileNumber.resignFirstResponder()
        
        PayWingsOAuthClient.instance()?.signInWithPhoneNumberRequestOtp(phoneNumberCountryCode: countryCode, phoneNumber: phoneNUmber, smsContentTemplate: nil, callback: callback)
    }
    
    
    // SignInWithPhoneNumberRequestOtpCallbackDelegate
    func onShowOtpInputScreen(otpLength: Int) {
        otpL = otpLength
        hideLoading()
        performSegue(withIdentifier: "confirmMobileNumber", sender: nil)
    }
    
    func onShowTimeBasedOtpVerificationInputScreen(accountName: String) {
        account = accountName
        performSegue(withIdentifier: "totpVerification", sender: nil)
    }
    
    func onError(error: PayWingsOAuthSDK.OAuthErrorCode, errorMessage: String?) {
        ErrorMessage.text = errorMessage ?? error.description
        ErrorMessage.isHidden = false
        hideLoading()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmMobileNumber" {
            guard let vc = segue.destination as? ConfirmPhoneNumberViewController else { return }
            vc.mobileNumber = MobileNumber.text
            vc.otpLength = otpL
        }
        else if segue.identifier == "totpVerification" {
            guard let vc = segue.destination as? TotpVerificationViewController else { return }
            vc.accountName = account
        }
    }
    
}
