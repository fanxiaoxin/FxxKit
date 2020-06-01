//
//  CollectionViewApiLoader.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/27.
//

import UIKit

extension UICollectionView: FXApiListTableType { }

open class FXCollectionCell<ModelType>: UICollectionViewCell, FXApiListCellType {
    public typealias TableType = UICollectionView
    
    public static func instance(for table: UICollectionView, indexPath: IndexPath) -> Self {
        return table.dequeueReusableCell(withReuseIdentifier: "Default", for: indexPath) as! Self
    }
    
    open var index:Int = 0
    open var model:ModelType? {
        didSet{
            if let m = self.model {
                self.load(model:m)
            }else{
                self.unloadModel()
            }
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.load()
    }
    open func load() {
        
    }
    open func load(model:ModelType) {
        
    }
    open func unloadModel() {
        
    }
}
