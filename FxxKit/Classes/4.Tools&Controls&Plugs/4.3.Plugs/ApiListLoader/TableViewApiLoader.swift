//
//  TableViewApiLoader.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/27.
//

import UIKit

extension UITableView: FXApiListTableType { }

open class FXTableCell<ModelType>: UITableViewCell, FXApiListCellType {
    public typealias TableType = UITableView
    
    public static func instance(for table: UITableView, indexPath: IndexPath) -> Self {
        if let c = table.dequeueReusableCell(withIdentifier: "Default") as? Self {
            return c
        }else{
            table.register(Self.self, forCellReuseIdentifier: "Default")
            return table.dequeueReusableCell(withIdentifier: "Default") as! Self
        }
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
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
