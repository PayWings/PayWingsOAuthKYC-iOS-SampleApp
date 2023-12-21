//
//  KycDataViewController.swift
//  PayWingsOnboardingKYC-SampleApp
//
//  Created by tjasa on 20/07/2020.
//  Copyright © 2020 Intech. All rights reserved.
//

import UIKit
import PayWingsKycSDK


class KycDataViewController : UIViewController {
    
    
    var result: PayWingsKycSDK.SuccessEvent!
    
    @IBOutlet weak var KycTitle: UILabel!
    
    @IBOutlet weak var KycID: UILabel!
    @IBOutlet weak var PersonID: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sample App"
        navigationItem.setHidesBackButton(true, animated: false)
        
        KycTitle.text = "KYC Successful"
        KycTitle.textColor = .systemGreen
        
        setKycValues()

    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    func setKycValues() {
        
        KycID.text = "KycID: " + (result.KycID ?? "")
        PersonID.text = "PersonID: " + (result.PersonID ?? "")
    }
    
    
    @IBAction func onClose(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
