//
//  FqyMessageBox+Toast.swift
//  ManageFinances
//
//  Created by Fanxx on 16/7/8.
//  Copyright © 2016年 YinChengPai. All rights reserved.
//

import UIKit

extension FXMessageBox {
    ///自动消失的提示框
    public class func toast(_ message:String,completion:(()->Void)?=nil) {
        /*
        let label = UILabel()
        label.text = message
        label.font = Style[Theme.FontSize.normal]
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.textAlignment = .left
        let view = self.wrapView(label, leftRight: 15,topBottom: 5)
        view.addSubview(label)
        self.curtain(view, completion: completion)
        */
        self.toastInFront(message, completion: completion)
    }
    ///自定义视图弹出框
    public class func toastInFront(_ message:String,completion:(()->Void)?=nil) {
        let window = UIApplication.shared.keyWindow!
        let showview = UIView()
        showview.backgroundColor = .lightGray
        showview.frame = CGRect(x: 1, y: 1, width: 1, height: 1)
        showview.alpha = 1.0;
        showview.layer.cornerRadius = 16.0;
        showview.layer.masksToBounds = true
        showview.isUserInteractionEnabled = false
        window.addSubview(showview)
        
        let label = UILabel()
        label.text = message
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.textAlignment = .left
        showview.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(showview).inset(UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15))
        }
        showview.snp.makeConstraints { (make) in
            make.centerX.equalTo(window)
            make.top.equalTo(window).offset(75)
            make.height.greaterThanOrEqualTo(32)
            make.left.greaterThanOrEqualTo(window).offset(15)
        }
        UIView.animate(withDuration: 3, animations: {
            showview.alpha = 0
        }) { (ok) in
            showview.removeFromSuperview()
        }
        completion?()
    }
}
