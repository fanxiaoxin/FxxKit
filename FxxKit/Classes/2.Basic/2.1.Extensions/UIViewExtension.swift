//
//  UIView+FXAdd.swift
//  FXKit
//
//  Created by Fanxx on 2018/3/23.
//  Copyright © 2018年 fanxx. All rights reserved.
//

import UIKit
import SnapKit

extension FX.NamespaceImplement where Base: UIView {
    public func layoutedSize() -> CGSize {
        if #available(iOS 9.0, *) {
            return self.base.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        } else {
            self.base.frame.size.height = 0
            self.base.layoutIfNeeded()
            return self.base.frame.size
        }
    }
    ///抖动动画
   public func shake() {
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: UIView.KeyframeAnimationOptions.calculationModeLinear, animations: {
            let left = self.base.left
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                self.base.left = left - 20
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.32, animations: {
                self.base.left = left + 20
            })
            UIView.addKeyframe(withRelativeStartTime: 0.52, relativeDuration: 0.28, animations: {
                self.base.left = left - 15
            })
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                self.base.left = left
            })
        }, completion: nil)
    }
}

//private var __visibleConstraintsKey:Void?
extension FX.NamespaceImplement where Base: UIView {
    func getVisibleConstraints() -> [NSLayoutConstraint]? {
        return self.getAssociated(object: "fxVisibleConstraints")
    }
    func setVisibleConstraints(_ value:[NSLayoutConstraint]?) {
        self.setAssociated(object: value, key: "fxVisibleConstraints")
    }
    public var isVisible: Bool {
        get {
            return !self.base.isHidden
        }
        set {
            self.set(visible: newValue)
        }
    }
    public func set(visible: Bool, direction: FXDirection = .none, hierarchy: Int = 1) {
        if self.base.isHidden == visible {
            self.base.isHidden = !visible
            self.unsafeSet(visible: visible, direction: direction, hierarchy: hierarchy)
        }
    }
    private func unsafeSet(visible:Bool, direction:FXDirection, hierarchy:Int) {
        if visible {
            if let constraints = self.getVisibleConstraints(), constraints.count > 0 {
                for constraint in constraints {
                    constraint.constant = constraint.fx.getVisibleConstant()
                }
            }
        }else{
            self.base.layoutIfNeeded()
            let frame = self.base.frame
            let dir = self.autoVisible(direction:direction,hierarchy:hierarchy)
            var constraints:[NSLayoutConstraint] = []
            var view = self.base.superview
            var h = hierarchy
            while let v = view,h > 0 {
                for constraint in v.constraints {
                    if self.setInvisible(constraint:constraint, frame:frame,direction:dir) {
                        constraints.append(constraint)
                    }
                }
                view = v.superview
                h -= 1
            }
            self.setVisibleConstraints(constraints)
        }
    }
    ///自动查找方向
    private func autoVisible(direction:FXDirection,hierarchy:Int) -> FXDirection {
        if direction == .none {
            var bottom = false
            var left = false
            var view = self.base.superview;
            var h = hierarchy
            while let v = view, h > 0 {
                for constraint in v.constraints {
                    let attribute:NSLayoutConstraint.Attribute?
                    if constraint.firstItem === self.base {
                        attribute = constraint.firstAttribute
                    }else if constraint.secondItem === self.base {
                        attribute = constraint.secondAttribute
                    }else{
                        attribute = nil
                    }
                    if let attr = attribute {
                        if !bottom && (
                            attr == .bottom ||
                                attr == .bottomMargin
                            ) {
                            bottom = true
                        }
                        if !left && (
                            attr == .left ||
                                attr == .leftMargin ||
                                attr == .leading ||
                                attr == .leadingMargin
                            ) {
                            left = true
                        }
                        if bottom && left {
                            return [.bottom, .left]
                        }
                    }
                }
                view = v.superview;
                h -= 1;
            }
            return [(bottom ? .bottom : .top), (left ? .left : .right)]
        }
        return direction;
    }
    private func setInvisible(constraint:NSLayoutConstraint, frame:CGRect,direction:FXDirection) -> Bool {
        let attribute:NSLayoutConstraint.Attribute
        let prefix: CGFloat
        if constraint.firstItem === self.base {
            attribute = constraint.firstAttribute
            prefix = 1
        }else if constraint.secondItem === self.base {
            attribute = constraint.secondAttribute
            prefix = -1
        }else{
            return false
        }
        let cst = constraint
        switch (attribute) {
        case .top, .topMargin:
            if direction.contains(.bottom) {
                cst.fx.setVisibleConstant(constraint.constant)
                constraint.constant = prefix * frame.size.height;
                return true
            }
        case .left, .leftMargin, .leading, .leadingMargin:
            if direction.contains(.right) {
                cst.fx.setVisibleConstant(constraint.constant)
                constraint.constant = prefix * frame.size.width;
                return true
            }
        case .bottom, .bottomMargin:
            if direction.contains(.top) {
                cst.fx.setVisibleConstant(constraint.constant)
                constraint.constant = prefix * frame.size.height;
                return true
            }
        case .right, .rightMargin, .trailing, .trailingMargin:
            if direction.contains(.left) {
                cst.fx.setVisibleConstant(constraint.constant)
                constraint.constant = prefix * frame.size.width;
                return true
            }
        default:
            break;
        }
        return false
    }
    
    ///设置是否可见
    public func set(visible:Bool, direction:FXDirection, animated: Bool, completion:(()->Void)? = nil) {
        let view = self.base
        if view.isHidden == visible {
            self.unsafeSet(visible: visible, direction: direction, hierarchy: 1)
            if animated {
                let alpha = view.alpha
                if visible {
                    view.alpha = 0
                    view.isHidden = false
                    UIView.animate(withDuration: 0.25, animations: {
                        view.superview?.layoutIfNeeded()
                        view.alpha = alpha
                    }) { (_) in
                        completion?()
                    }
                }else{
                    UIView.animate(withDuration: 0.25, animations: {
                        view.superview?.layoutIfNeeded()
                        view.alpha = 0
                    }) { (_) in
                        view.isHidden = true
                        view.alpha = alpha
                        completion?()
                    }
                }
            }else{
                view.isHidden = !visible
                completion?()
            }
        }
    }
    ///嵌套循环找到指定的View
    public func forEachSubviews<ViewType: UIView>(body: @escaping (ViewType) -> Void) {
        self.base.subviews.forEach { (view) in
            if let v = view as? ViewType {
                body(v)
            }else{
                view.fx.forEachSubviews(body: body)
            }
        }
    }
}
//private var __visibleConstantKey: Void?
extension FX.NamespaceImplement where Base: NSLayoutConstraint {
    func getVisibleConstant() -> CGFloat {
        return self.getAssociated(object: "fxVisibleConstant") ?? 0
    }
    func setVisibleConstant(_ value:CGFloat) {
        self.setAssociated(object: value, key: "fxVisibleConstant")
    }
    /*
    var visibleConstant: CGFloat {
        get {
            return (objc_getAssociatedObject(self.base, &__visibleConstantKey) as? CGFloat) ?? 0
        }
        set {
            objc_setAssociatedObject(self.base, &__visibleConstantKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }*/
}
