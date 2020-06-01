//
//  CollectionViewFixedColumnsLayout.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/6.
//

import UIKit

///固定列数
open class FXCollectionViewFixedColumnsLayout: UICollectionViewLayout {
    ///边距
    public var padding: UIEdgeInsets = .zero
    ///间距
    public var spacing: CGPoint = .zero
    ///列数
    public var numberOfColumns: Int = 2
    ///高度，可根据宽度获取，每个cell必须同高宽
    public var height: ((_ width: CGFloat) -> CGFloat)?
    
    //CollectionView会在初次布局时首先调用该方法
    //CollectionView会在布局失效后、重新查询布局之前调用此方法
    //子类中必须重写该方法并调用超类的方法
    private var __attributes : [UICollectionViewLayoutAttributes]?
    private var __itemSize: CGSize = .zero
    open override func prepare() {
        super.prepare()
        
        if let width = self.collectionView?.bounds.size.width {
            let w = (width - self.padding.left - self.padding.right + self.spacing.x) / CGFloat(self.numberOfColumns) - self.spacing.x
            self.__itemSize = CGSize(width: w, height: self.height?(w) ?? w)
        }else{
            self.__itemSize = .zero
        }
        
        if let count = self.collectionView?.numberOfItems(inSection: 0) {
            var atts:[UICollectionViewLayoutAttributes] = []
            for i in 0..<count {
                if let att = self.layoutAttributesForItem(at: IndexPath(item: i, section: 0)) {
                    atts.append(att)
                }
            }
            __attributes = atts
        }else{
            __attributes = nil
        }
    }
    //子类必须重写此方法。
    //并使用它来返回CollectionView视图内容的宽高，
    //这个值代表的是所有的内容的宽高，并不是当前可见的部分。
    //CollectionView将会使用该值配置内容的大小来促进滚动。
    open override var collectionViewContentSize: CGSize {
        if let cv = self.collectionView{
            let count = cv.numberOfItems(inSection: 0)
            let width = cv.bounds.size.width
            let rows = (count - 1) / self.numberOfColumns + 1
            let height = self.padding.top + (self.__itemSize.height + self.spacing.y) * CGFloat(rows) - self.spacing.y + self.padding.bottom
            return CGSize(width: width, height: height)
        }
        return .zero
    }
    ///返回UICollectionViewLayoutAttributes 类型的数组，
    ///UICollectionViewLayoutAttributes 对象包含cell或view的布局信息。
    ///子类必须重载该方法，并返回该区域内所有元素的布局信息，包括cell,追加视图和装饰视图。
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.__attributes
    }
    ///返回指定indexPath的item的布局信息。子类必须重载该方法,该方法
    ///只能为cell提供布局信息，不能为补充视图和装饰视图提供。
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let col = indexPath.row % self.numberOfColumns
        let row = indexPath.row / self.numberOfColumns
        let x = self.padding.left + CGFloat(col) * (__itemSize.width + self.spacing.x)
        let y = self.padding.top + CGFloat(row) * (__itemSize.height + self.spacing.y)
        
        let frame = CGRect(x: x, y: y, width: __itemSize.width, height: __itemSize.height)
        attribute.frame = frame
        
        return attribute
    }
    /*
    ///如果你的布局支持追加视图的话，必须重载该方法，该方法返回的是
    追加视图的布局信息，kind这个参数区分段头还是段尾的，在collectionview注册的时候回用到该参数。
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
    }
    ///如果你的布局支持装饰视图的话，必须重载该方法，该方法返回的是装饰视图的布局信息，
     ecorationViewKind这个参数在collectionview注册的时候回用到
    open override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
    }*/

    //当Bounds改变时，返回YES使CollectionView重新查询几何信息的布局
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
