//
//  LoadingViewController.swift
//  PayWingsKYC-SampleApp
//
//  Created by Tjasa Jan on 29/08/2023.
//

import UIKit
import PayWingsKycSDK
import PayWingsOAuthSDK


class LoadingViewController : UIViewController, VerificationResultDelegate {
    
    var settings : KycSettings?
    var result = VerificationResult()
    
    var kycSuccess: PayWingsKycSDK.SuccessEvent?
    var kycError: PayWingsKycSDK.ErrorEvent?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        result.delegate = self
        
        initializeKyc()
    }
    
    
    func initializeKyc() {
        
        let sdkUsername = UserDefaults.standard.string(forKey: "sdk_api_username") ?? ""
        let sdkPassword = UserDefaults.standard.string(forKey: "sdk_api_password") ?? ""
        let sdkBaseUrl = UserDefaults.standard.string(forKey: "sdk_api_url") ?? ""
        let credentials = KycCredentials(username: sdkUsername, password: sdkPassword, endpointUrl: sdkBaseUrl)
        
        PayWingsKyc.initialize(vc: self, credentials: credentials, result: result)
        
        PayWingsKyc.tokenRefreshHandler { (methodUrl, onComplete) in
            PayWingsOAuthClient.instance()?.getNewAuthorizationData(methodUrl: methodUrl, httpRequestMethod: .POST, completion: { authData in
                
                onComplete(authData.accessTokenData?.accessToken, authData.dpop)
                
                if authData.userSignInRequired ?? false {
                    // Return to login screen
                }
            })
        }
        startKyc()
    }
    
    func startKyc() {
        
        getKycSettings()
        setStyle()
        PayWingsKyc.startKyc(settings: settings!)
    }
    
    
    func getKycSettings() {
        
        let referenceId = UUID().uuidString
        let referenceNumber = UserDefaults.standard.string(forKey: "reference_number") ?? ""
        settings = KycSettings(referenceID: referenceId, referenceNumber: referenceNumber, language: nil)
    }
    
    func setStyle() {
        let theme = PayWingsKycSDK.Style.VideoTheme
        theme.colors.primaryButtonBackground = .purple
        theme.colors.secondaryButtonContent = .purple
        PayWingsKycSDK.Style.VideoTheme = theme
    }
    
    
    // VerificationResultDelegate
    func onSuccess(result: PayWingsKycSDK.SuccessEvent) {
        kycSuccess = result
        performSegue(withIdentifier: "kycSuccess", sender: nil)
    }
    
    func onError(result: PayWingsKycSDK.ErrorEvent) {
        kycError = result
        performSegue(withIdentifier: "kycError", sender: nil)
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kycSuccess" {
            guard let vc = segue.destination as? KycDataViewController else { return }
            vc.result = kycSuccess
        }
        else if segue.identifier == "kycError" {
            guard let vc = segue.destination as? KycErrorViewController else { return }
            vc.result = kycError
        }
    }
    
    
    
}
