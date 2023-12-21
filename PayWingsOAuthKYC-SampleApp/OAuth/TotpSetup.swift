//
//  TotpSetup.swift
//  PayWingsKYC-SampleApp
//
//  Created by Tjasa Jan on 22/11/2023.
//

import UIKit


class TotpSetupViewController : UIViewController {
    
    var accountName: String! = ""
    var secKey: String! = ""
    
    @IBOutlet weak var AccountName: UILabel!
    @IBOutlet weak var Key: UITextView!
    @IBOutlet weak var ErrorMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AccountName.text = accountName
        Key.text = secKey
        
        ErrorMessage.isHidden = true
    }
    
    
    
    @IBAction func onContinue(_ sender: Any) {
        
        performSegue(withIdentifier: "totpVerification", sender: nil)
    }
    
    
}
