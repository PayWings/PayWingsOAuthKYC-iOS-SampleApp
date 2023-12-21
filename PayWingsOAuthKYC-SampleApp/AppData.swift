//
//  AppData.swift
//  PayWingsKYC-SampleApp
//
//  Created by Tjasa Jan on 29/08/2023.
//

import UIKit
import PayWingsOAuthSDK


class AppData {
    
    private static var privateShared : AppData?
    
    final class func shared() -> AppData
    {
        guard let iShared = privateShared else {
            privateShared = AppData()
            return privateShared!
        }
        return iShared
    }
    
    private init() {}
    deinit {}
    
    class func destroy() {
        privateShared = nil
    }
    
    var dpop: String?
    var accessToken: String?
    
    var userEmail = ""
}


extension UIViewController {
    
    func showLoading() {
        
        let activityView = UIActivityIndicatorView()
        activityView.style = .medium
        activityView.color = UIColor.label
        activityView.center = self.view.center
        activityView.tag = 0123
        self.view.addSubview(activityView)
        activityView.startAnimating()
        
        self.view.isUserInteractionEnabled = false
    }
    
    func hideLoading() {
        if let activityView = self.view.viewWithTag(0123) {
            activityView.removeFromSuperview()
        }
        self.view.isUserInteractionEnabled = true
    }
}
