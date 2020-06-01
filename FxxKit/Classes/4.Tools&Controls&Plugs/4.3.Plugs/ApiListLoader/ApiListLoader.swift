//
//  ApiListLoader.swift
//  FXKit
//
//  Created by Fanxx on 2019/11/27.
//

import UIKit
@_exported import MJRefresh

public protocol FXApiListTableType: UIScrollView {
    func reloadData()
}
public protocol FXApiListCellType: class {
    associatedtype TableType: FXApiListTableType
    associatedtype ModelType
    var index: Int { get set }
    var model: ModelType? { get set }
    static func instance(for table: TableType, indexPath: IndexPath) -> Self
}

open class FXApiListLoader<ApiType: FXResponseApiType, CellType: FXApiListCellType, MJHeader: MJRefreshHeader, MJFooter: MJRefreshFooter>: NSObject, FXEventTriggerable where ApiType.ResponseType: FXApiListResponseType, CellType.ModelType == ApiType.ResponseType.ModelType {
    public typealias EventType = Event
    ///事件
    public enum Event: FXEventType {
        ///数据准备加载
        case dataWillLoad
        ///数据加载完成,参数ListResult
        case dataDidLoaded
        ///数据准备加载,参数Cell
        case cellWillLoad
        ///数据加载完成,参数Cell
        case cellDidLoaded
    }
    ///API请求方案
    public var scheme: FXApiRequestSchemeType?
    ///列表控件
    public var listTable: CellType.TableType?
    ///接口
    public var api = ApiType()
    ///接口数据
    open var result: [ApiType.ResponseType.ModelType]?
    ///最后一次返回的接口数据
    open var lastResponse: ApiType.ResponseType?
    ///获取列表数据
    open var numberOfList: Int { return self.result?.count ?? 0}
    ///获取对应索引的Cell
    open func cell(for indexPath:IndexPath) -> CellType {
        let cell = CellType.instance(for: self.listTable!, indexPath: indexPath)
        cell.index = indexPath.row
        self.events.send(event: .cellWillLoad, result: cell)
        cell.model = self.result?[indexPath.row]
        self.events.send(event: .cellDidLoaded, result: cell)
        
        return cell
    }
    ///重载数据
    open func reloadData(){
        self.loadDatas()
    }
    //用于标记是否当前正在加载，若被刷掉则可以用来中断前一个加载
    fileprivate var _loadFlag = 0
    open func loadDatas(){
        self.events.send(event: .dataWillLoad, result: nil)
        if let listTable = self.listTable {
            if listTable.mj_header == nil {
                listTable.mj_header = MJHeader(refreshingBlock: { [weak self] in
                    self?.loadDatas()
                })
            }
            self._loadFlag += 1
            let loadFlag = self._loadFlag
            self.scheme?.request(api)
                .whatever { [weak self] in loadFlag == self?._loadFlag }
                .success { [weak self] (rs) in
                    if let s = self {
                        s.listTable?.mj_header?.endRefreshing()
                        s.lastResponse = rs
                        s.result = rs.list
                        s.listTable?.scrollToTop(animated: false)
                        s.listTable?.reloadData()
                        s.didLoadedDatas(rs)
                    }
                }
        }
    }
    
    open func didLoadedDatas(_ result:ApiType.ResponseType?) {
        self.events.send(event: .dataDidLoaded, result: result)
    }
}

///针对分页列表做处理
extension FXApiListLoader where ApiType: FXPagedResponseApiType {
    open func reloadData(){
        self.loadFirstPage()
    }
    open func loadFirstPage(){
        self.events.send(event: .dataWillLoad, result: nil)
        if let listTable = self.listTable {
            listTable.mj_footer?.endRefreshingWithNoMoreData()
            if listTable.mj_header == nil {
                listTable.mj_header = MJHeader(refreshingBlock: { [weak self] in
                    self?.loadFirstPage()
                })
            }
            self._loadFlag += 1
            let loadFlag = self._loadFlag
            ///保留页码，用于失败时还原
            let oldPageNumber = self.api.page.pageNumber
            //重置页码
            self.api.page.pageNumber = 1
            self.scheme?.request(api)
            .whatever { [weak self] in loadFlag == self?._loadFlag }
            .success { [weak self] (rs) in
                if let s = self {
                    s.listTable?.mj_header?.endRefreshing()
                    s.listTable?.mj_footer?.endRefreshing()
                    if s.listTable?.mj_footer == nil {
                        s.listTable?.mj_footer = MJFooter(refreshingBlock: { [weak self] in
                            self?.loadNextPage()
                        })
                    }
                    if rs.isEnd {
                        s.listTable?.mj_footer?.endRefreshingWithNoMoreData()
                    }else{
                        s.listTable?.mj_footer?.resetNoMoreData()
                    }
                    s.lastResponse = rs
                    s.result = rs.list
                    s.listTable?.scrollToTop(animated: false)
                    s.listTable?.reloadData()
                    
                    s.didLoadedDatas(rs)
                }
            }.failure {  [weak self] _ in
                self?.api.page.pageNumber = oldPageNumber
            }
        }
    }
    ///加载下一步数据
    open func loadNextPage(){
        self.api.page.pageNumber += 1
        self._loadFlag += 1
        let loadFlag = self._loadFlag
        self.scheme?.request(api)
        .whatever { [weak self] in loadFlag == self?._loadFlag }
        .success { [weak self] (rs) in
            if let s = self {
                s.listTable?.mj_footer?.endRefreshing()
                if rs.isEnd {
                    s.listTable?.mj_footer?.endRefreshingWithNoMoreData()
                }
                s.lastResponse = rs
                if s.result != nil, let list = rs.list {
                    s.result!.append(contentsOf: list)
                }else{
                    s.result = rs.list
                }
                s.listTable?.reloadData()
                
                s.didLoadedDatas(rs)
            }
        }.failure { [weak self] _ in
            self?.api.page.pageNumber -= 1
        }
    }
}
