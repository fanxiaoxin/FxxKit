//
//  UIColorExtension.swift
//  FXKit
//
//  Created by Fanxx on 2018/4/3.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit
import YYCategories

extension UIColor {
    public static func fx(_ rgb:UInt32) -> UIColor {
        return UIColor(rgb: rgb)
    }
}
extension FX.NamespaceImplement where Base: UIColor {
    ///生成虚线图
    public static func dottedLine(color:UIColor,size:CGSize,spacing:CGFloat) -> UIColor? {
        if let image = UIImage.fx.dottedLine(color: color, size: size, spacing: spacing) {
            return UIColor(patternImage: image)
        }
        return nil
    }
    public static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
