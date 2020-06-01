//
//  WindowManager.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/27.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

///用于管理自定义的窗口
open class FXWindowManager {
    ///单例
    public static let shared = FXWindowManager()
    ///将构造函数私有化，仅限单例使用
    private init() { }
    ///存储所有的窗口
    fileprivate var windows:[UIWindow] = []
    
    ///当前程序的主窗口
    public var mainWindow: UIWindow? {
        if let window = FXApplication.application.delegate?.window {
            return window ?? FXApplication.application.keyWindow
        }
        return nil
    }
    ///一般和mainWindow是同一个
    public var keyWindow: UIWindow? {

        return FXApplication.application.keyWindow
    }
    ///当前最顶层的window
    public var topWindow: UIWindow? {
        var top : UIWindow? = nil
        for w in FXApplication.application.windows {
            if w.windowLevel.rawValue >= (top?.windowLevel.rawValue ?? 0) {
                top = w
            }
        }
        return top
    }
    //显示窗口
    open func show(_ window:UIWindow){
        self.windows.append(window)
        window.isHidden = false
    }
    //关闭窗口
    open func close(_ window:UIWindow){
        window.isHidden = true
        if let index = self.windows.firstIndex(of: window) {
            self.windows.remove(at: index)
        }
    }
    //关闭所有窗口
    open func closeAll(){
        for window in self.windows {
            window.isHidden = true
        }
        self.windows.removeAll()
    }
}
extension FXWindowManager {
    ///显示View
    open func show(view: UIView, level:UIWindow.Level = UIWindow.Level.alert) -> UIWindow {
        let controller = UIViewController()
        controller.view = view
        return self.show(controller: controller,level:level)
    }
    ///关闭View
    open func close(view: UIView){
        if let w = view.window {
            self.close(w)
        }
    }
    ///显示viewController
    open func show(controller: UIViewController, level:UIWindow.Level = UIWindow.Level.alert) -> UIWindow{
        let window = UIWindow(frame:UIScreen.main.bounds)
        window.windowLevel = level
        window.rootViewController = controller
        self.show(window)
        return window
    }
    ///关闭viewController
    open func close(controller: UIViewController){
        if let w = controller.view.window {
            self.close(w)
        }
    }
}
extension FX.NamespaceImplement where Base: UIWindow {
    //显示
    public func show() {
        FXWindowManager.shared.show(self.base)
    }
    //关闭
    public func close() {
        FXWindowManager.shared.close(self.base)
    }
}
extension FX.NamespaceImplement where Base: UIViewController {
    ///在新窗口中打开
    @discardableResult
    public func showInNewWindow(level:UIWindow.Level = UIWindow.Level.alert) -> UIWindow {
        return FXWindowManager.shared.show(controller: self.base, level: level)
    }
    ///如果之前在新窗口中打开了，则关闭
    public func closeWindow() {
        FXWindowManager.shared.close(controller: self.base)
    }
}
