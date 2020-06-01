//
//  MFCurtainController.swift
//  ManageFinances
//
//  Created by Fanxx on 16/7/7.
//  Copyright © 2016年 YinChengPai. All rights reserved.
//

import UIKit

open class FXCurtainController: UIViewController {
   open var contentView : UIView?{
        willSet {
            if let c = self.contentView {
                c.removeFromSuperview()
            }
            if let c = newValue {
                container.addSubview(c)
                c.snp.makeConstraints({ (make) in
                    make.edges.equalTo(container)
                })
            }
        }
    }
    open var completion : (()->Void)?
    public let container = UIView()
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = false
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        self.view.clipsToBounds = true
        
        self.container.backgroundColor = UIColor.clear
        self.container.clipsToBounds = true
        self.view.addSubview(self.container)
        container.snp.makeConstraints { (make) -> Void in
            make.left.greaterThanOrEqualTo(self.view.snp.left)
            make.right.lessThanOrEqualTo(self.view.snp.right)
            make.center.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
    open func show(_ to:UIViewController){
        let offset = to.topLayoutGuide.length
//        for controller in to.childViewControllers {
//            if let c = controller as? MFCurtainController {
//                c.view.alpha = 0
//            }
//        }
        to.view.addSubview(self.view)
        to.addChild(self)
        self.view.snp.makeConstraints { (make) in
            make.top.equalTo(to.view).offset(offset)
            make.left.equalTo(to.view)
            make.right.equalTo(to.view)
        }
        to.view.layoutIfNeeded()
        self.container.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view).offset(self.container.height)
        }
        to.view.layoutIfNeeded()
        self.container.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view).offset(0)
        }
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            to.view.layoutIfNeeded()
            }, completion: { (finish) -> Void in
                self.completion?()
                self.perform(#selector(self.hide), afterDelay: 1.5)
        })
    }
    @objc open func hide(){
        self.container.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view).offset(self.container.height)
        }
        if let controller = self.parent {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                controller.view.layoutIfNeeded()
                }, completion:{ (finish) -> Void in
                    self.view.removeFromSuperview()
                    self.removeFromParent()
            })
        }
    }
}
