//
//  TestSettingController.swift
//  FXKit
//
//  Created by Fanxx on 2019/7/31.
//

import UIKit

open class FXTestSettingController: UITableViewController {
    open var items: [FXTestSettingItem]!
    open var selectAction: ((FXTestSettingItem) -> Void)!
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Default")
        let item = self.items[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = (item.value as? CustomStringConvertible)?.description ?? item.value.debugDescription
        
        return cell
    }
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.items[indexPath.row]
        if let options = item.options {
            let alert = UIAlertController(title: item.name, message: "某些配置可能要重启后才生效", preferredStyle: .actionSheet)
            
            for option in options {
                let value = (option.value as? CustomStringConvertible)?.description ?? option.value.debugDescription
                alert.addAction(.init(title: "\(option.name)(\(value))", style: .default, handler: { _ in
                    self.items[indexPath.row].value = option.value
                    self.selectAction(self.items[indexPath.row])
                    self.tableView.reloadRow(at: indexPath, with: .automatic)
                }))
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
}
