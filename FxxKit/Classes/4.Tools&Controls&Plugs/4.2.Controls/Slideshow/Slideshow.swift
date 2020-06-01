//
//  Slideshow.swift
//  FXKit
//
//  Created by Fanxx on 2019/6/11.
//

import UIKit
import Kingfisher

open class FXSlideshow: UIView,UIScrollViewDelegate, FXEventTriggerable {
    public typealias EventType = Event
    public enum Event: FXEventType {
        case click
    }
    public var dataSource: [CustomStringConvertible]? {
        didSet {
            self.reloadData()
        }
    }
    public var placeholder: UIImage?
    public var timeInterval : TimeInterval = 4
    public var autoTransform : Bool = false
    ///重新加载数据，不会默认加载，必须调用后才会加载
    public func reloadData(){
        self.containerView.removeAllSubviews()
        if let d = self.dataSource {
            let count = d.count
            if count > 0 {
                self.pageControl.numberOfPages = count
                //前后多加两张用来平滑第一张跟最后一张
                for i in 0...count+1 {
                    let imageView = UIImageView()
                    imageView.contentMode = .scaleToFill
                    if self.autoTransform {
                        imageView.layer.cornerRadius = 2.5
                        imageView.layer.masksToBounds = true
                    }
                    self.containerView.addSubview(imageView)
                    imageView.snp.makeConstraints({ (make) -> Void in
                        make.width.equalTo(self.scrollView)
                    })
                    let index:Int
                    if i == 0 {
                        index = count - 1
                    }else if i == count + 1{
                        index = 0
                    }else{
                        index = i-1
                    }
                    let placeHolder = self.placeholder
//                    if let imageUrl = d[index] {
                    let url = URL(string: d[index].description)
                    imageView.kf.setImage(with: url, placeholder:placeHolder)
//                    }else{
//                        imageView.image = placeHolder
//                    }
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFigure(_:)))
                    imageView.tag = index
                    imageView.addGestureRecognizer(tap)
                    imageView.isUserInteractionEnabled = true
                }
                if self.containerView.subviews.count > 0 {
                    self.containerView.subviews[0].fx.layout(self.containerView, .left, .top, .bottom)
                    if self.containerView.subviews.count > 1 {
                         for i in 1..<self.containerView.subviews.count {
                            self.containerView.subviews[i - 1]
                                .fx.layout(self.containerView.subviews[i],
                                           .rightLeft)
                             self.containerView.subviews[i].fx.layout(self.containerView, .top, .bottom)
                        }
                    }
                    self.containerView.subviews.last!.fx.layout(self.containerView, .right)
                }
//                self.scrollView.layoutIfNeeded()
                //                self.scrollView.setContentOffset(CGPoint(x: scrollView.bounds.size.width, y: 0),animated:true)
                if count > 1 {
                    self.scrollView.isScrollEnabled = true
                    self.beginTimer()
                }else{
                    self.scrollView.isScrollEnabled = false
                }
                self.scrollViewDidScroll(self.scrollView)
            }else{
                self.endTimer()
            }
        }
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.setContentOffset(CGPoint(x: scrollView.bounds.size.width * CGFloat(self.pageControl.currentPage + 1), y: 0),animated:false)
    }
    ///PageControl,外部可用于调整样式
    @IBInspectable public let pageControl : FXPageControl
    public let scrollView : UIScrollView
    public let containerView : UIView
    
    fileprivate var timer : Timer?
    override public init(frame: CGRect) {
        self.scrollView = UIScrollView()
        self.containerView = UIView()
        self.pageControl = FXPageControl()
        super.init(frame: frame)
        self.loadView()
    }
    required public init?(coder aDecoder: NSCoder) {
        self.scrollView = UIScrollView()
        self.containerView = UIView()
        self.pageControl = FXPageControl()
        super.init(coder: aDecoder)
        self.loadView()
    }
    public func loadView(){
        self.clipsToBounds = true
        self.scrollView.isPagingEnabled = true
        self.scrollView.bounces = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.delegate = self
        self.scrollView.clipsToBounds = false
        self.containerView.clipsToBounds = false
        self.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) -> Void in
            if self.autoTransform {
                make.edges.equalTo(self).inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            }else{
                make.edges.equalTo(self)
            }
        }
        self.scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.scrollView)
            make.height.equalTo(self.scrollView)
        }
        let pageView = UIView()
        self.addSubview(pageView)
        pageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            if self.autoTransform {
                make.bottom.equalTo(self).offset(20)
            }else{
                make.bottom.equalTo(self).offset(5)
            }
        }
        pageView.addSubview(self.pageControl)
        self.pageControl.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(pageView)
            make.height.equalTo(20)
        }
        self.pageControl.hidesForSinglePage = true
        self.pageControl.addTarget(self, action: #selector(self.pageControlChange(_:)), for: .valueChanged)
    }
    //取消计时
    func endTimer(){
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    //开始计时
    func beginTimer(){
        if self.pageControl.numberOfPages > 1 && self.timer == nil{
            self.timer = Timer(timeInterval: self.timeInterval, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer!, forMode: .common)
        }
    }
    //手动操作时停止自动滚动
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.endTimer()
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidEndDecelerating(scrollView)
        }
        self.beginTimer()
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(scrollView)
    }
    //滚动值改变时改变页码
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int((scrollView.contentOffset.x + 0.1) / scrollView.bounds.size.width);
        if index == 0 {
            //第一张则跳到最后一张
            self.pageControl.currentPage = self.pageControl.numberOfPages
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width * CGFloat(self.pageControl.numberOfPages), y: 0)
        }else if index == self.pageControl.numberOfPages + 1 {
            //最后一张则跳到第一张
            self.pageControl.currentPage = 0
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }else{
            //其他则从第二张算起
            self.pageControl.currentPage = index-1
        }
        self.scrollViewDidScroll(scrollView)
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.autoTransform {
            let offset = scrollView.contentOffset.x
            for i in 0..<self.containerView.subviews.count {
                let view = self.containerView.subviews[i]
                let rate = min(abs(view.left - offset) / scrollView.width, 1)
                let scale = 1 * (0.85 + 0.15 * (1 - rate))
                //            var transform = CGAffineTransform(translationX: (offset - view.left) * 0.3 , y: 0)
                //            transform = transform.scaledBy(x: scale, y: scale)
                var transform = CGAffineTransform(scaleX: scale, y: scale)
                let sb:CGFloat = offset > view.left ? 1 : -1
                let translate = min(abs(offset - view.left),scrollView.width) / scrollView.width
                transform = transform.translatedBy(x: translate * sb * 22 , y: 0)
                self.containerView.subviews[i].transform = transform
            }
        }
        
    }
    //页码改变时滚动过去
    @objc func pageControlChange(_ pageControl:UIPageControl){
        self.scrollView.setContentOffset(CGPoint(x: scrollView.bounds.size.width * CGFloat(self.pageControl.currentPage + 1), y: 0),animated:true)
    }
    //自动翻页
    @objc func autoScroll(){
        if self.pageControl.currentPage >= self.pageControl.numberOfPages - 1 {
            self.pageControl.currentPage = 0
            self.scrollView.setContentOffset(CGPoint(x: scrollView.bounds.size.width * CGFloat(self.pageControl.numberOfPages + 1), y: 0),animated:true)
        }else{
            self.pageControl.currentPage += 1
            self.pageControlChange(self.pageControl)
        }
    }
    //点击某一页
    @objc func tapFigure(_ tap:UITapGestureRecognizer){
        if let d = self.dataSource, let index = tap.view?.tag {
            self.events.send(event: .click, result: d[index])
        }
    }
    deinit{
        self.endTimer()
    }
}

extension FXBuildable where Self: UIView {
    public static func fxSlideshow(_ styles: FXStyleSetting<FXSlideshow>...) -> FXSlideshow {
        return FXSlideshow().fx(styles: styles)
    }
}
extension FXStyleSetting where TargetType: FXSlideshow {
    public static func page(color:UIColor?) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.pageControl.pageIndicatorTintColor = color
        })
    }
    public static func page(selected color:UIColor?) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.pageControl.currentPageIndicatorTintColor = color
        })
    }
    public static func page(size:CGSize) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.pageControl.pointSize = size
        })
    }
    public static func page(spacing:CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.pageControl.pointSpacing = spacing
        })
    }
    public static func page(offset:CGFloat) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.pageControl.superview!.snp.updateConstraints({ (make) in
                make.bottom.equalTo(target).offset(offset)
            })
        })
    }
    public static func page(size:CGSize, spacing: CGFloat, color normal: UIColor?, selected current: UIColor?) -> FXStyleSetting<TargetType> {
        return .init(action: { (target) in
            target.pageControl.pointSize = size
            target.pageControl.pointSpacing = spacing
            target.pageControl.pageIndicatorTintColor = normal
            target.pageControl.currentPageIndicatorTintColor = current
        })
    }
}
