//
//  ViewControllerAccessable.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/23.
//

import UIKit

public protocol FXViewControllerAccessable {
    func load(_ destination: FXViewControllerType, segue: FXPresentSegue?, otherwise: (()->Void)?)
}

extension UIViewController: FXViewControllerAccessable {
    private func check(preconditions destination: FXViewControllerType, pass: @escaping ()->Void) {
        self.check(preconditions: destination, pass: pass, otherwise: nil)
    }
    private func check(preconditions destination: FXViewControllerType, pass: @escaping ()->Void, otherwise: (()->Void)?) {
        if let cs = destination.preconditions {
            self.check(conditions: cs, pass: pass, otherwise: otherwise)
        }else{
            pass()
        }
    }
    ///私有方法，用于前置权限的检查
    private func check(conditions:[FXViewControllerPrecondition], pass: @escaping ()->Void, otherwise: (()->Void)?) {
        if conditions.count > 0 {
            var newCs = conditions
            let cdt = newCs.removeFirst()
            cdt.failureHandler = otherwise
            FXViewControllerAccessCenter.shared.check(condition: cdt, input: self) { [weak self] (_) in
                self?.check(conditions: newCs, pass: pass, otherwise: otherwise)
            }
        }else{
            pass()
        }
    }
    ///不判断前提要求，直接加载
    public func directLoad(_ destination: FXViewControllerType, segue: FXPresentSegue? = nil) {
        self.fx.present(destination, segue: segue ?? destination.segue)
    }
    ///判断权限通过后加载
    public func load(_ destination: FXViewControllerType, segue: FXPresentSegue?, otherwise: (()->Void)?) {
        self.check(preconditions: destination, pass: { [weak self] in
            self?.directLoad(destination, segue: segue)
        }, otherwise: otherwise)
    }
}
extension FXViewControllerType {
    ///关闭页面
    public func unload() {
        self.fx.dismiss()
    }
}

extension FXViewControllerAccessable {
    public func load(_ destination: FXViewControllerType, segue: FXPresentSegue?, otherwise: (()->Void)?) {
        UIViewController.fx.current?.load(destination, segue: segue, otherwise: otherwise)
    }
}
extension FXViewControllerAccessable {
    public func load(_ destination: FXViewControllerType, segue: FXPresentSegue? = nil) {
        self.load(destination, segue: segue, otherwise: nil)
    }
    public func load(_ destination: FXViewControllerType, otherwise: (()->Void)?) {
        self.load(destination, segue: nil, otherwise: otherwise)
    }
}
extension FXPrecondition: FXViewControllerAccessable where InputType: UIViewController {
    public func load(_ destination: FXViewControllerType, segue: FXPresentSegue?, otherwise: (() -> Void)?) {
        (self.input ?? UIViewController.fx.current)?.load(destination, segue: segue, otherwise: otherwise)
    }
}
