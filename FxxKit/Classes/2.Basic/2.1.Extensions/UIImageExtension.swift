//
//  UIImage+FXAdd.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/23.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit

extension FX.NamespaceImplement where Base: UIImage {
    ///获取当前启动页
    public static func launch() -> UIImage? {
        if let n = self.launchImageName() {
            return UIImage(named:n)
        }else{
            return nil
        }
    }
    ///获取启动页名称
    private static func launchImageName() -> String? {
        var viewSize = UIScreen.main.bounds.size
        var viewOrientation = "Portrait"
        if UIDevice.current.orientation.isLandscape {
            viewSize = CGSize(width:viewSize.height, height:viewSize.width)
            viewOrientation = "Landscape"
        }
    
        if let imagesDict = Bundle.main.infoDictionary?["UILaunchImages"] as? [[String:Any]] {
            for dict in imagesDict {
                if let ss = dict["UILaunchImageSize"] as? String,let so = dict["UILaunchImageOrientation"] as? String {
                    let imageSize = NSCoder.cgSize(for: ss)
                    if imageSize.equalTo(viewSize) && viewOrientation == so {
                        return dict["UILaunchImageName"] as? String
                    }
                }
            }
        }
        return nil
    }
    ///生成虚线图
    public static func dottedLine(color:UIColor,size:CGSize,spacing:CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: size.width + spacing, height: size.height + spacing))
        if let context = UIGraphicsGetCurrentContext() {
            //第一行
            context.beginPath()
            context.setLineWidth(size.height)
            context.setStrokeColor(color.cgColor)
            context.setLineDash(phase: 0, lengths: [size.width,spacing])
            context.move(to: CGPoint(x: 0, y: size.height / 2))
            context.addLine(to: CGPoint(x: size.width + spacing, y: size.height / 2))
            context.strokePath()
            //第二行
            context.setLineWidth(spacing)
            context.setStrokeColor(color.cgColor)
            context.setLineDash(phase: 0, lengths: [spacing,size.width])
            context.move(to: CGPoint(x: -size.width, y: size.height + spacing / 2))
            context.addLine(to: CGPoint(x: size.width + spacing, y: size.height + spacing / 2))
            context.strokePath()
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    public static func textMask(_ text:NSAttributedString, size: CGSize = CGSize(width: 1000, height: 1000),color: UIColor = UIColor(white: 0, alpha: 0.5)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: size))
            
            let rect = text.boundingRect(with: size, options: [], context: nil)
            let point = CGPoint(x: (size.width - rect.size.width) / 2, y: (size.height - rect.size.height) / 2)
            text.draw(in: CGRect(origin: point, size: rect.size))
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    public func resize(insets:UIEdgeInsets) -> UIImage {
        return self.base.resizableImage(withCapInsets: insets)
    }
}
