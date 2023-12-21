//
//  KycErrorViewController.swift
//  PayWingsOnboardingKYC-SampleApp
//
//  Created by tjasa on 20/07/2020.
//  Copyright © 2020 Intech. All rights reserved.
//

import UIKit
import PayWingsKycSDK


class KycErrorViewController : UIViewController {
    
    
    var result: PayWingsKycSDK.ErrorEvent!
    
    @IBOutlet weak var RestartKycButton: UIButton!
    
    @IBOutlet weak var KycReferenceID: UILabel!
    @IBOutlet weak var KycID: UILabel!
    @IBOutlet weak var PersonID: UILabel!
    @IBOutlet weak var ErrorDescription: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sample App"
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        setKycValues()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    func setKycValues() {
        
        KycReferenceID.text = "KycReferenceID: " + (result.KycReferenceID ?? "")
        KycID.text = "KycID: " + (result.KycID ?? "")
        PersonID.text = "PersonID: " + (result.PersonID ?? "")
        ErrorDescription.text = "ErrorDescription: " + result.ErrorData.code.description + " " + result.ErrorData.message
    }
    
    
    @IBAction func onRestartKyc(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
