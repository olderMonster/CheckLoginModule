//
//  User.swift
//  CheckLoginModule_Example
//
//  Created by 印聪 on 2023/2/7.
//  Copyright © 2023 印聪. All rights reserved.
//

import Foundation
import CheckLoginModule

@objc public class User: NSObject {
    @objc static let shared = User()
    
    @objc var isLogin = false
    
    @objc static public func createOrderAlert(viewController: UIViewController) {
        
        let alertViewController = UIAlertController(title: "购买", message: "即将购买价值188元的大礼包一份", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        let payAction = UIAlertAction(title: "下单", style: .default)
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(payAction)
        
        viewController.present(alertViewController, animated: true)
    }
}


extension User: AnnotationDelegate {
    
    public func authorizeAccess() -> Bool {
        return isLogin
    }
    
    public func requestAuthorizeAccess(_ authoried: @escaping () -> Void) {
        LoginViewController.jumpToLoginViewController {
            authoried()
        }
    }
    
}
