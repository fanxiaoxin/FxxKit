//
//  ViewBuilder.swift
//  FXKit
//
//  Created by Fanxx on 2019/5/30.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit
import SnapKit

extension FX.NamespaceImplement where Base: UIView {
    ///添加子视图并返回子视图
    @discardableResult
    public func add<ViewType: UIView>(_ view:ViewType, layout: [FXViewLayout], ext: FXViewLayout...) -> NamespaceWrapper<ViewType> {
        self.base.addSubview(view)
        layout.apply(to: self.base, with: view)
        ext.apply(to: self.base, with: view)
        return view.fx
    }
    ///添加子视图并返回子视图
    @discardableResult
    public func add<ViewType: UIView>(_ view:ViewType, layout: FXViewLayout...) -> NamespaceWrapper<ViewType> {
        return self.add(view, layout: layout)
    }
    ///添加子视图并返回原视图
    @discardableResult
    public func append(_ view:UIView, layout: [FXViewLayout], ext: FXViewLayout...) -> Self {
        self.base.addSubview(view)
        layout.apply(to: self.base, with: view)
        ext.apply(to: self.base, with: view)
        return self
    }
    ///添加子视图并返回原视图
    @discardableResult
    public func append(_ view:UIView, layout: FXViewLayout...) -> Self {
        return self.append(view, layout: layout)
    }
    ///添加子视图到父视图并返回添加视图
    @discardableResult
    public func next<ViewType: UIView>(_ view:ViewType, layout: [FXViewLayout], ext: FXViewLayout...) -> NamespaceWrapper<ViewType>  {
        if let sp = self.base.superview {
            sp.addSubview(view)
            layout.apply(to: self.base, with: view)
            ext.apply(to: self.base, with: view)
        }
        return view.fx
    }
    ///添加子视图到父视图并返回添加视图
    @discardableResult
    public func next<ViewType: UIView>(_ view:ViewType, layout: FXViewLayout...) -> NamespaceWrapper<ViewType>  {
        return self.next(view, layout: layout)
    }
    ///添加子视图到父视图并返回当前视图
    @discardableResult
    public func follow<ViewType: UIView>(_ view:ViewType, layout: [FXViewLayout], ext: FXViewLayout...) -> Self  {
        self.next(view, layout: layout)
        if let sp = self.base.superview {
            sp.addSubview(view)
            layout.apply(to: self.base, with: view)
            ext.apply(to: self.base, with: view)
        }
        return self
    }
    ///添加子视图到父视图并返回当前视图
    @discardableResult
    public func follow<ViewType: UIView>(_ view:ViewType, layout: FXViewLayout...) -> Self  {
        return self.follow(view, layout: layout)
    }
    ///添加父视图约束并返回父视图
    @discardableResult
    public func parent(_ layout: FXViewLayout...) -> NamespaceWrapper<UIView> {
        if let sp = self.base.superview {
            layout.apply(to: sp, with: self.base)
            return sp.fx
        }
        return self as! NamespaceWrapper<UIView>
    }
    ///批量添加子视图到父视图并返回父视图
    @discardableResult
    public func sub(_ views:[UIView], first firstLayout: [FXViewLayout],
                                    last lastLayout: [FXViewLayout],
                                    between betweenLayout:[FXViewLayout],
                                    all layout:[FXViewLayout]) ->Self  {
        if views.count > 0 {
            for view in views {
                self.add(view, layout: layout)
            }
            firstLayout.apply(to: self.base, with: views.first!)
            lastLayout.apply(to: self.base, with: views.last!)
            betweenLayout.apply(to: views)
        }
        return self
    }
    ///批量添加子视图到父视图并返回父视图
    @discardableResult
    public func sub(_ viewBuilders:[(NamespaceWrapper<UIView>) -> Void], first firstLayout: [FXViewLayout],
                    last lastLayout: [FXViewLayout],
                    between betweenLayout:[FXViewLayout],
                    all layout:[FXViewLayout]) ->Self  {
        return self.sub(viewBuilders.map({ (vb) -> UIView in
            let view = UIView()
            vb(view.fx)
            return view
        }), first: firstLayout, last: lastLayout, between: betweenLayout, all: layout)
    }
    ///批量添加子视图到父视图并返回父视图
    @discardableResult
    public func sub(_ views:[UIView], orientation: FXOrientation = .landscape, margin:UIEdgeInsets = .zero, spacing: CGFloat = 0, equalsSize: Bool = false) ->Self  {
        switch orientation {
        case .landscape:
            return self.sub(views, first: [.left(margin.left)], last: [.right(margin.right)], between: equalsSize ? [.rightLeft(spacing), .width] : [.rightLeft(spacing)], all: [.marginY(margin.top, margin.bottom)])
        case .portrait:
            return self.sub(views, first: [.top(margin.top)], last: [.bottom(margin.bottom)], between: equalsSize ? [.bottomTop(spacing), .height] : [.bottomTop(spacing)], all: [.marginX(margin.left, margin.right)])
        }
    }
    ///批量添加子视图到父视图并返回父视图
    @discardableResult
    public func sub(_ viewBuilders:[(NamespaceWrapper<UIView>) -> Void], orientation: FXOrientation = .landscape, margin:UIEdgeInsets = .zero, spacing: CGFloat = 0, equalsSize: Bool = false) ->Self  {
        return self.sub(viewBuilders.map({ (vb) -> UIView in
            let view = UIView()
            vb(view.fx)
            return view
        }), orientation: orientation, margin: margin, spacing: spacing, equalsSize: equalsSize)
    }
    ///设置视图的高宽
    @discardableResult
    public func size(_ width: CGFloat,_ height: CGFloat) -> NamespaceWrapper<Base>  {
        self.base.snp.makeConstraints { (make) in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        return self as! NamespaceWrapper<Self.Base>
    }
    ///设置视图的高宽
    @discardableResult
    public func size(_ widthHeight: CGFloat) -> NamespaceWrapper<Base>  {
        return self.size(widthHeight, widthHeight)
    }
    ///设置视图的高度
    @discardableResult
    public func height(_ height: CGFloat) -> NamespaceWrapper<Base>  {
        self.base.snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
        return self as! NamespaceWrapper<Self.Base>
    }
    ///设置视图的宽度
    @discardableResult
    public func width(_ width: CGFloat) -> NamespaceWrapper<Base>  {
        self.base.snp.makeConstraints { (make) in
            make.width.equalTo(width)
        }
        return self as! NamespaceWrapper<Self.Base>
    }
    ///设置视图的宽高比
    @discardableResult
    public func aspect(ratio: CGFloat) -> NamespaceWrapper<Base>  {
        self.base.snp.makeConstraints { (make) in
            make.width.equalTo(self.base.snp.height).multipliedBy(ratio)
        }
        return self as! NamespaceWrapper<Self.Base>
    }
    ///获取父视图
    public var parent: NamespaceWrapper<UIView> {
        return self.base.superview!.fx
    }
}
///更细微的扩展
extension FX.NamespaceImplement where Base: UIView {
    ///重复生成类似视图
    public static func `repeat`<ParamsType>(_ parameters: [ParamsType], builder: (NamespaceWrapper<Base>,ParamsType) -> Void) -> [Base] {
        var views:[Base] = []
        for p in parameters {
            let view = Base()
            builder(view.fx, p)
            views.append(view)
        }
        return views
    }
    ///获取上一个视图
    @discardableResult
    public func previous() ->NamespaceWrapper<UIView>  {
        if let sp = self.base.superview {
            if let idx = sp.subviews.firstIndex(of: self.base), idx > 0 {
                return sp.subviews[idx - 1].fx
            }
        }
        return self as! NamespaceWrapper<UIView>
    }
}
/* 示例
class myview:UIView {
    func load() {
        let top = UIView()
        let center = UIView()
        let c1 = UIView()
        let c2 = UIView()
        let c3 = UIView()
        let bottom = UIView()
        
        center.fx.add(c1, layout: .left, .marginY)
        .next(c2, layout: .leftRight, .paddingY, .width)
        .next(c3, layout: .leftRight, .paddingY, .width, .parent(.right))
        
        self.fx.add(top, layout: .top, .marginX)
            .next(center, layout: .topBottom, .paddingX)
            .next(bottom, layout: .topBottom, .parent(.bottom))
    }
}
*/
