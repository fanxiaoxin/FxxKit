//
//  FXGesturePasswordView.swift
//  Demo
//
//  Created by Fanxx on 16/5/4.
//  Copyright © 2016年 Fanxx. All rights reserved.
//

import UIKit

///手势解锁View
@IBDesignable open class FXGesturePasswordView: UIControl,CAAnimationDelegate {
    ///最终值
    open var value : [Int] = []
    ///检查密码序列是否正确
//    var validate : (([Int])->Bool?)?
    ///非选中的图片
    @IBInspectable open var unselectedImage : UIImage? {
        didSet {
            if let image = self.unselectedImage {
                self.forEachUnselectedItem({ (layer) in
                    layer.sublayers?.first?.contents = image.cgImage
                })
            }
        }
    }
    ///选中的图片
    @IBInspectable open var selectedImage : UIImage? {
        didSet {
            if let image = self.selectedImage {
                self.forEachSelectedItem({ (layer) in
                    layer.sublayers?.first?.contents = image.cgImage
                })
            }
        }
    }
    ///颜色
    @IBInspectable open var color = UIColor(red: 0.498, green: 0.978, blue: 0.529, alpha: 1) {
        didSet{
            self.forEachSelectedItem { $0.strokeColor = self.color.cgColor }
            self.line.strokeColor = self.color.cgColor
        }
    }
    ///未选择的颜色
    @IBInspectable open var unselectedColor = UIColor(red: 0.498, green: 0.978, blue: 0.529, alpha: 1) {
        didSet{
            self.forEachUnselectedItem { $0.strokeColor = self.unselectedColor.cgColor }
        }
    }
    ///错误颜色
    @IBInspectable open var errorColor = UIColor(red: 0.78, green: 0.219, blue: 0.212, alpha: 1)
    ///间距，大于0.5则为距离，小于0.5则为比例
    @IBInspectable open var itemSpace:CGFloat = 1.2/10.0
    ///边距，大于0.5则为距离，小于0.5则为比例
    @IBInspectable open var padding:CGFloat = 1.0/10.0
    ///中心点相对整个点的大小
    @IBInspectable open var pointScale:CGFloat = 2 / 7
    ///线是否在前面，默认为否
    @IBInspectable open var isFrontLine:Bool = false {
        didSet {
            self.line.removeFromSuperlayer()
            if self.isFrontLine {
                self.layer.addSublayer(self.line)
            }else{
                self.layer.insertSublayer(self.line, at: 0)
            }
        }
    }
    
    ///设置选中项的样式
    open func displaySelectedItem(_ layer:CAShapeLayer){
        layer.lineWidth = 2
        if layer.path != nil {
            let animation = CABasicAnimation(keyPath: "path")
            let s : CGFloat = 4.0
            var rect = layer.bounds
            rect.origin.x -= s
            rect.origin.y -= s
            rect.size.width += s * 2
            rect.size.height += s * 2
            let bigPath = CGPath(ellipseIn: rect, transform: nil)
            animation.toValue = bigPath
            animation.duration = 0.25
            animation.repeatCount = 1
            animation.autoreverses = true
            layer.add(animation, forKey: nil)
        }
    }
    fileprivate func __displaySelectedItem(_ layer:CAShapeLayer){
        layer.strokeColor = self.color.cgColor
        if let imageLayer = layer.sublayers?.first {
            if let selectedImage = self.selectedImage {
                imageLayer.contents = selectedImage.cgImage
            }else if imageLayer.contents == nil {
                imageLayer.backgroundColor = self.color.cgColor
            }
        }
        self.displaySelectedItem(layer)
    }
    ///设置非选中项的样式
    open func displayUnselectedItem(_ layer:CAShapeLayer){
        layer.fillColor = UIColor.white.cgColor
        layer.strokeColor = self.unselectedColor.cgColor
        layer.lineWidth = 1
    }
    fileprivate func __displayUnselectedItem(_ layer:CAShapeLayer){
        layer.strokeColor = self.unselectedColor.cgColor
        if let imageLayer = layer.sublayers?.first {
            imageLayer.contentsScale = UIScreen.main.scale
            imageLayer.contentsGravity = CALayerContentsGravity.center
            imageLayer.backgroundColor = UIColor.clear.cgColor
            if let unselectedImage = self.unselectedImage {
                imageLayer.contents = unselectedImage.cgImage
            }else{
                imageLayer.contents = nil
            }
        }

        self.displayUnselectedItem(layer)
    }
    ///设置线的样式
    open func displayLine(_ layer:CAShapeLayer){
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = self.color.cgColor
        layer.lineWidth = 8
    }
    fileprivate func __displayLine(_ layer:CAShapeLayer){
        layer.miterLimit = 0
        layer.lineCap = CAShapeLayerLineCap.round
        layer.lineJoin = CAShapeLayerLineJoin.round
        self.displayLine(layer)
    }
    ///设置错误的动画参数
    open func displayErrorAnimateParams(_ layer:CALayer,animation:CABasicAnimation){
        animation.toValue = self.errorColor.cgColor
        animation.duration = 0.25
//        animation.autoreverses = true
//        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.repeatCount = 1
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.load()
    }
    override open var canBecomeFirstResponder : Bool {
        return true
    }
    fileprivate var line : CAShapeLayer = CAShapeLayer()
    fileprivate var layers:[CAShapeLayer] = []
    open func load() {
        self.__displayLine(line)
        self.layer.addSublayer(line)
        for _ in 0...8 {
            let layer = CAShapeLayer()
            let imageLayer = CALayer()
            layer.addSublayer(imageLayer)
            self.__displayUnselectedItem(layer)
            self.layers.append(layer)
            self.layer.addSublayer(layer)
        }
    }
    override open func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of:layer)
        if layer == self.layer {
            let width = min(layer.bounds.size.width,layer.bounds.size.height)
            let space = self.itemSpace < 0.5 ? self.itemSpace * width : self.itemSpace
            let padding = self.padding < 0.5 ? self.padding * width : self.padding
            let size = (width - (space + padding) * 2) / 3
            let left = (layer.bounds.size.width - space * 2 - size * 3) / 2
            let top = (layer.bounds.size.height - space * 2 - size * 3) / 2
            for i in 0...self.layers.count - 1{
                let x = i % 3
                let y = i / 3
                self.layers[i].frame = CGRect(x: left + (size + space) * CGFloat(x), y: top + (size + space) * CGFloat(y),width: size,height: size)
                self.layers[i].path = CGPath(ellipseIn: CGRect(x: 0,y:0,width:size,height:size), transform: nil)
                if let imageLayer = self.layers[i].sublayers?.first {
                    imageLayer.frame = CGRect(x: (size - size * pointScale) / 2, y: (size - size * pointScale) / 2, width: size * pointScale, height: size * pointScale)
                    imageLayer.cornerRadius = size * pointScale / 2
                }
            }
        }
    }
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        let point = touch.location(in: self)
        if let index = self.hitTest(point) {
            self.__displaySelectedItem(self.layers[index])
            self.value.append(index + 1)
            return true
        }
        return false
    }
    //事件
    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        let point = touch.location(in: self)
        if let index = self.hitTest(point) {
            self.__displaySelectedItem(self.layers[index])
            self.value.append(index + 1)
            self.drawLineToPoint(nil)
        }else{
            self.drawLineToPoint(point)
        }
        return true
    }
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        self.tryValidate()
    }
    override open func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        self.tryValidate()
    }
    ///返回触碰并且未被选中的索引
    fileprivate func hitTest(_ point: CGPoint) -> Int? {
        for i in 0...self.layers.count - 1 {
            if !self.value.contains(i + 1) {
                if self.layers[i].frame.contains(point) {
                    return i
                }
            }
        }
        return nil
    }
    //事件 end
    fileprivate func forEachSelectedItem(_ block:((CAShapeLayer)->Void)){
        for i in 0...self.layers.count - 1 {
            if self.value.contains(i + 1) {
                block(self.layers[i])
            }
        }
    }
    fileprivate func forEachUnselectedItem(_ block:((CAShapeLayer)->Void)){
        for i in 0...self.layers.count - 1 {
            if !self.value.contains(i + 1) {
                block(self.layers[i])
            }
        }
    }
    ///画线
    fileprivate func drawLineToPoint(_ point:CGPoint?) {
        if self.value.count > 0 {
            let path = CGMutablePath()
            let layer = self.layers[self.value[0]-1]
            path.move(to: CGPoint(x: layer.frame.origin.x + layer.frame.size.width/2, y: layer.frame.origin.y + layer.frame.size.height/2))
            if self.value.count > 1 {
                for i in 1...self.value.count - 1 {
                    let layer = self.layers[self.value[i]-1]
                    path.addLine(to: CGPoint(x: layer.frame.origin.x + layer.frame.size.width/2, y: layer.frame.origin.y + layer.frame.size.height/2))
                }
            }
            if let p = point {
                path.addLine(to: p)
            }
            self.line.path = path
        }
    }
    fileprivate func tryValidate(){
        self.drawLineToPoint(nil)
        self.sendActions(for: .valueChanged)
    }
    ///密码错误
    open func displayError(){
        self.isUserInteractionEnabled = false

        let animate = CABasicAnimation(keyPath: "strokeColor")
        self.displayErrorAnimateParams(self.line,animation: animate)
        animate.delegate = self
        self.line.add(animate, forKey: nil)
        
        self.forEachSelectedItem { (layer) in
            if let imageLayer = layer.sublayers?.first {
                if imageLayer.contents == nil {
                    let animate = CABasicAnimation(keyPath: "backgroundColor")
                    self.displayErrorAnimateParams(imageLayer,animation: animate)
                    imageLayer.add(animate, forKey: nil)
                }
            }
            let animate = CABasicAnimation(keyPath: "strokeColor")
            self.displayErrorAnimateParams(layer,animation: animate)
            layer.add(animate, forKey: nil)
        }
    }
    open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.clear()
        self.isUserInteractionEnabled = true
    }
    ///清空页面
    open func clear(){
        self.value.removeAll()
        self.line.path = nil
        for layer in self.layers {
            self.__displayUnselectedItem(layer)
        }
    }
}

extension FXStyleSetting where TargetType: FXGesturePasswordView {
    public static func unselected(image:UIImage) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.unselectedImage = image
        })
    }
    public static func selected(image:UIImage) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.selectedImage = image
        })
    }
    public static func unselected(_ color:UIColor) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.unselectedColor = color
        })
    }
    public static func selected(_ color:UIColor) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.color = color
        })
    }
    public static func error(_ color:UIColor) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.errorColor = color
        })
    }
    public static func spacing(_ spacing:CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.itemSpace = spacing
        })
    }
    public static func padding(_ padding:CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.padding = padding
        })
    }
}
