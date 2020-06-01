//
//  ViewControllerType.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/23.
//

import UIKit

public protocol FXViewControllerType: UIViewController {
    ///进入场景，除非特殊情况由调用方设置，一般建议自己定义自己的场景或使用默认
    var segue: FXPresentSegue { get }
    ///设置进入该页面的权限
    var preconditions : [FXViewControllerPrecondition]? { get }
}
