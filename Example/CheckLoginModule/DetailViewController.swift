//
//  DetailViewController.swift
//  CheckLoginModule_Example
//
//  Created by 印聪 on 2023/2/7.
//  Copyright © 2023 印聪. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

@objc class DetailViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    lazy var buyButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("购买", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.addTarget(self, action: #selector(buyAction), for: .touchUpInside)
        return view
    }()
    
    lazy var msgButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("查看消息", for: .normal)
        view.setTitleColor(.black, for: .normal)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "详情"
        view.backgroundColor = .white
        view.addSubview(buyButton)
        view.addSubview(msgButton)
        
        msgButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.jumpToMessagePage()
        }).disposed(by: disposeBag)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        buyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(160)
        }
        
        msgButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(buyButton.snp.bottom).offset(40)
        }
        
    }
    
    //被注解的方法需要使用 dynamic 修饰
    @objc dynamic func buyAction() {
        User.createOrderAlert(viewController: self)
    }
    
    //被注解的方法需要使用 dynamic 修饰
    @objc dynamic func jumpToMessagePage() {
        self.navigationController?.pushViewController(MessageViewController(), animated: true)
    }
}
