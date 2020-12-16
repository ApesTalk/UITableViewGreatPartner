//
//  ConfigurableCellModel.swift
//  HumanAssistant
//
//  Created by ApesTalk on 2020/11/10.
//  Copyright © 2020 https://github.com/ApesTalk All rights reserved.
//

import Foundation
import UIKit

typealias cellActionCallBack = (_ cell: UITableViewCell?, _ indexPath: IndexPath)->Void
typealias cellHeightCallBack = (_ cell: UITableViewCell?, _ indexPath: IndexPath)->CGFloat

class ATTableViewCellPartner: NSObject {
    var tag: Int = 0
    //MARK:注意className将被用于cellIdentifier
    var className: String = "UITableViewCell"
    var configuration: cellActionCallBack? = nil
    var selectAction: cellActionCallBack? = nil
    var heightCal: cellHeightCallBack? = nil

    //逃逸闭包
    init(_ tag: Int, _ className: String, _ config: cellActionCallBack?, _ didSelect: cellActionCallBack?, _ heightCal:  cellHeightCallBack?) {
        super.init()
        self.tag = tag
        self.className = className
        self.configuration = config
        self.selectAction = didSelect
        self.heightCal = heightCal
    }
    
    //Swift 类名字符串转类 Swift中类的完整名称是 ProjectName.ClassName
    func cellClass() -> UITableViewCell.Type {
        if self.className == "UITableViewCell" {
            return UITableViewCell.self
        }
        
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"]
        let cellClass: AnyClass? = NSClassFromString((nameSpace as! String) + "." + self.className)
        guard let cellType = cellClass as? UITableViewCell.Type else {
            return UITableViewCell.self
        }
        return cellType
    }
    
}
