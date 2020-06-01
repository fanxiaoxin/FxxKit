//
//  ViewLayout.swift
//  FXKit
//
//  Created by Fanxx on 2019/5/30.
//  Copyright © 2019 Fanxx. All rights reserved.
//

import UIKit
import SnapKit

///约束值比较
public enum FXViewLayoutCompare {
    ///等于
    case equal
    ///小于等于
    case lessThanOrEqual
    ///大于等于
    case greatherThanOrEqual
}
extension ConstraintMakerExtendable {
    func compare(_ c: FXViewLayoutCompare, _ other: ConstraintRelatableTarget) -> ConstraintMakerEditable {
        switch c {
        case .equal:
            return self.equalTo(other)
        case .lessThanOrEqual:
            return self.lessThanOrEqualTo(other)
        case .greatherThanOrEqual:
            return self.greaterThanOrEqualTo(other)
        }
    }
}

///视图约束
public enum FXViewLayout {
    ///高度(差额，比例)
    case height(CGFloat, CGFloat)
    ///宽度(差额，比例)
    case width(CGFloat, CGFloat)
    
    ///左-左
    case left(CGFloat)
    ///右-右
    case right(CGFloat)
    ///上-上
    case top(CGFloat)
    ///下-下
    case bottom(CGFloat)
    
    ///基线
    case baseline(CGFloat)
    ///上基线
    case firstBaseline(CGFloat)
    ///线基线
    case lastBaseline(CGFloat)
    
    ///左-右
    case leftRight(CGFloat)
    ///右-左
    case rightLeft(CGFloat)
    ///上-下
    case topBottom(CGFloat)
    ///下-上
    case bottomTop(CGFloat)
    
    ///水平居中
    case centerX(CGFloat)
    ///竖直居中
    case centerY(CGFloat)
    ///居中
    case center(CGFloat, CGFloat)
    
    ///左-左，右-右
    case marginX(CGFloat,CGFloat)
    ///上-上，下-下
    case marginY(CGFloat,CGFloat)
    ///上-上，左-左，下-下，右-右
    case margin(CGFloat,CGFloat,CGFloat,CGFloat)
    
    ///针对父视图做约束
    indirect case parent(FXViewLayout)
    ///小于等于
    indirect case less(FXViewLayout)
    ///大于等于
    indirect case greather(FXViewLayout)
    ///组合约束，用于自定义
    case set([FXViewLayout])
    ///自定义
    case custom(apply:(UIView, UIView)->Void)
    
    ///优先级
    indirect case priority(FXViewLayout, ConstraintPriority)
    ///优先级
    func priority(_ value: ConstraintPriority) -> FXViewLayout {
        return .priority(self, value)
    }
}

extension ConstraintMakerEditable {
    @discardableResult
    func fx_priority(_ value: ConstraintPriority?) -> ConstraintMakerFinalizable? {
        if let v = value {
            return self.priority(v)
        } else {
            return nil
        }
    }
}
extension FXViewLayout {
    ///应用约束
    public func apply(to v1: UIView, with v2: UIView, compare: FXViewLayoutCompare = .equal, priority: ConstraintPriority? = nil) {
        switch self {
        case let .parent(layout):
            if let sp = v1.superview {
                layout.apply(to: sp, with: v2, compare: compare, priority: priority)
            }
            return
        case let .less(layout):
            layout.apply(to: v1, with: v2, compare: .lessThanOrEqual, priority: priority)
        case let .greather(layout):
            layout.apply(to: v1, with: v2, compare: .greatherThanOrEqual, priority: priority)
        case let .priority(layout, value):
            layout.apply(to: v1, with: v2, compare: compare, priority: value)
        default: break
        }
        v2.snp.makeConstraints { (make) in
            switch self {
            ///高度
            case let .height(os, m): make.height.compare(compare, v1).offset(os).multipliedBy(m).fx_priority(priority)
            ///宽度
            case let .width(os, m): make.width.compare(compare, v1).offset(os).multipliedBy(m).fx_priority(priority)
            ///左-左
            case let .left(v): make.left.compare(compare, v1).offset(v).fx_priority(priority)
            ///右-右
            case let .right(v): make.right.compare(compare, v1).offset(-v).fx_priority(priority)
            ///上-上
            case let .top(v): make.top.compare(compare, v1).offset(v).fx_priority(priority)
            ///下-下
            case let .bottom(v): make.bottom.compare(compare, v1).offset(-v).fx_priority(priority)
                
            ///基线
            case let .baseline(v): make.baseline.compare(compare, v1).offset(-v).fx_priority(priority)
            ///上基线
            case let .firstBaseline(v): make.firstBaseline.compare(compare, v1).offset(-v).fx_priority(priority)
            ///下基线
            case let .lastBaseline(v): make.lastBaseline.compare(compare, v1).offset(-v).fx_priority(priority)
                
            ///左-右
            case let .leftRight(v): make.right.compare(compare, v1.snp.left).offset(-v).fx_priority(priority)
            ///右-左
            case let .rightLeft(v): make.left.compare(compare, v1.snp.right).offset(v).fx_priority(priority)
            ///上-下
            case let .topBottom(v): make.bottom.compare(compare, v1.snp.top).offset(-v).fx_priority(priority)
            ///下-上
            case let .bottomTop(v): make.top.compare(compare, v1.snp.bottom).offset(v).fx_priority(priority)
                
            ///水平居中
            case let .centerX(v): make.centerX.compare(compare, v1).offset(v).fx_priority(priority)
            ///竖直居中
            case let .centerY(v): make.centerY.compare(compare, v1).offset(v).fx_priority(priority)
            //居中
            case let .center(x, y):
                make.centerX.compare(compare, v1).offset(x).fx_priority(priority)
                make.centerY.compare(compare, v1).offset(y).fx_priority(priority)
                
            ///左-左，右-右
            case let .marginX(left,right):
                make.left.compare(compare, v1).offset(left).fx_priority(priority)
                make.right.compare(compare, v1).offset(-right).fx_priority(priority)
            ///上-上，下-下
            case let .marginY(top,bottom):
                make.top.compare(compare, v1).offset(top).fx_priority(priority)
                make.bottom.compare(compare, v1).offset(-bottom).fx_priority(priority)
            ///上-上，左-左，下-下，右-右
            case let .margin(top,left,bottom,right):
                make.edges.compare(compare, v1).inset(UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)).fx_priority(priority)
            case let .set(layout): layout.forEach({ $0.apply(to: v1, with: v2, compare: compare, priority: priority) })
            case let .custom(apply: apply): apply(v1, v2)
            default: break
            }
        }
    }
    ///应用约束
    public func apply(to views: [UIView]) {
        if views.count < 1 {
            return
        }
        switch self {
        case let .parent(layout):
            layout.apply(to: views.map({ $0.superview ?? $0 }))
            return
        default: break
        }
        for i in 0..<views.count - 1 {
            self.apply(to: views[i], with: views[i + 1])
        }
    }
}
extension Array where Element == FXViewLayout {
    ///应用约束
    public func apply(to v1: UIView, with v2: UIView) {
        self.forEach { $0.apply(to: v1, with: v2) }
    }
    ///应用约束
    public func apply(to views: [UIView]) {
        self.forEach { $0.apply(to: views) }
    }
}

extension FX.NamespaceImplement where Base: UIView {
    public func layout(_ view: UIView, _ layout:FXViewLayout...) {
        layout.apply(to: self.base, with: view)
    }
}

extension FX.NamespaceImplement where Base == [UIView] {
    public func layout(_ layout:FXViewLayout...) {
        layout.apply(to: self.base)
    }
}

///快捷方式
extension FXViewLayout {
    ///高度
    public static var height: FXViewLayout { return .height(0, 1) }
    ///宽度
    public static var width: FXViewLayout { return .width(0, 1) }
    
    ///高度(比例)
    public static func height(_ v:CGFloat) -> FXViewLayout { return .height(0, v) }
    ///宽度(比例)
    public static func width(_ v:CGFloat) -> FXViewLayout { return .width(0, v) }
    
    ///左左
    public static var left: FXViewLayout { return .left(0) }
    ///右右
    public static var right: FXViewLayout { return .right(0) }
    ///上上
    public static var top: FXViewLayout { return .top(0) }
    ///下下
    public static var bottom: FXViewLayout { return .bottom(0) }
    
    ///基线对齐
    public static var baseline: FXViewLayout { return .baseline(0) }
    ///上基线对齐
    public static var firstBaseline: FXViewLayout { return .firstBaseline(0) }
    ///下基线对齐
    public static var lastBaseline: FXViewLayout { return .lastBaseline(0) }
    
    ///左右
    public static var leftRight: FXViewLayout { return .leftRight(0) }
    ///右左
    public static var rightLeft: FXViewLayout { return .rightLeft(0) }
    ///上下
    public static var topBottom: FXViewLayout { return .topBottom(0) }
    ///下上
    public static var bottomTop: FXViewLayout { return .bottomTop(0) }
    
    ///水平居中
    public static var centerX: FXViewLayout { return .centerX(0) }
    ///竖直居中
    public static var centerY: FXViewLayout { return .centerY(0) }
    ///居中
    public static var center: FXViewLayout { return .center(0,0) }
    
    ///水平边距
    public static func marginX(_ v:CGFloat) -> FXViewLayout { return .marginX(v, v) }
    ///竖直边距
    public static func marginY(_ v:CGFloat) -> FXViewLayout { return .marginY(v, v) }
    ///水平边距
    public static var marginX: FXViewLayout { return .marginX(0,0) }
    ///竖直边距
    public static var marginY: FXViewLayout { return .marginY(0,0) }
    
    ///边距(水平，竖直)
    public static func margin(_ vx:CGFloat, _ vy:CGFloat) -> FXViewLayout { return .margin(vy, vx, vy, vx) }
    ///边距
    public static func margin(_ v:CGFloat) -> FXViewLayout { return .margin(v, v, v, v) }
    ///四周贴边
    public static var margin: FXViewLayout { return .margin(0,0,0,0) }
}
//父视图扩展
extension FXViewLayout {
    ///父视图水平边距
    public static func paddingX(_ left:CGFloat, _ right: CGFloat) -> FXViewLayout { return .parent(.marginX(left, right)) }
    ///父视图竖直边距
    public static func paddingY(_ top:CGFloat, _ bottom: CGFloat) -> FXViewLayout { return .parent(.marginY(top, bottom)) }
    ///父视图水平边距
    public static func paddingX(_ v:CGFloat) -> FXViewLayout { return .parent(.marginX(v, v)) }
    ///父视图竖直边距
    public static func paddingY(_ v:CGFloat) -> FXViewLayout { return .parent(.marginY(v, v)) }
    ///父视图水平边距
    public static var paddingX: FXViewLayout { return .parent(.marginX(0,0)) }
    ///父视图竖直边距
    public static var paddingY: FXViewLayout { return .parent(.marginY(0,0)) }
    
}
