//
//  LoginViewController.swift
//  CheckLoginModule_Example
//
//  Created by 印聪 on 2023/2/7.
//  Copyright © 2023 印聪. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import KRProgressHUD

class LoginViewController: UIViewController {
    
    var succeedIn: (() -> ())?
    
    let disposeBag = DisposeBag()
    
    
    lazy var submitButton: UIButton = {
        let view = UIButton(type: .custom)
        view.backgroundColor = .red
        view.setTitle("登录", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "登录"
        view.backgroundColor = .white
        
        view.addSubview(submitButton)
        
        submitButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(300)
            make.height.equalTo(46)
        }
        
        
        submitButton.rx.tap.asObservable().subscribe(onNext: { [unowned self] _ in
            KRProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                User.shared.isLogin = true
                KRProgressHUD.dismiss()
                self.navigationController?.popViewController(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.succeedIn?()
                }
            }
        }).disposed(by: disposeBag)
    }
    
    @objc static func jumpToLoginViewController(handler: @escaping () -> ()) {
        guard let window = UIApplication.shared.delegate?.window else { return }
        guard let keyWindow = window else { return }
        guard let nav = keyWindow.rootViewController as? UINavigationController else { return }
        let viewController = LoginViewController()
        viewController.succeedIn = handler
        nav.pushViewController(viewController, animated: true)
    }
    
}
