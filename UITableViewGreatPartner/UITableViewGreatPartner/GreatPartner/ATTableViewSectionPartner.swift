//
//  ATTableViewSectionPartner.swift
//  HumanAssistant
//
//  Created by ApesTalk on 2020/12/15.
//  Copyright © 2020 https://github.com/ApesTalk All rights reserved.
//

import Foundation
import UIKit

typealias sectionActionCallBack = (_ view: UITableViewHeaderFooterView?, _ section: Int) -> Void
typealias sectionHeightCallBack = (_ view: UITableViewHeaderFooterView?, _ section: Int) -> CGFloat
typealias generateCellParterCallBack = (_ obj: Any) -> ATTableViewCellPartner


class ATTableViewSectionPartner: NSObject {
    var tag: Int = 0
    //MARK:注意className将被用于Identifier
    var headerClassName: String? = nil
    var footerClassName: String? = nil
    var headerConfiguration: sectionActionCallBack? = nil
    var footerConfiguration: sectionActionCallBack? = nil
    var headerHeightCal: sectionHeightCallBack? = nil
    var footerHeightCal: sectionHeightCallBack? = nil
    
    var rowSource: [ATTableViewCellPartner] = [ATTableViewCellPartner]()
    
    //批量添加cellParter
    func batchAddRows(_ array: [Any], _ generater: generateCellParterCallBack) {
        for item in array {
            self.rowSource.append(generater(item))
        }
    }
    
    //逃逸闭包
    init(_ tag: Int, _ headerClassName: String?, _ footerClassName: String?,
         _ headerConfig: sectionActionCallBack?, _ footerConfig: sectionActionCallBack?,
         _ headerHeightCal: sectionHeightCallBack?, _ footerHeightCal: sectionHeightCallBack?) {
        super.init()
        self.tag = tag
        self.headerClassName = headerClassName
        self.footerClassName = footerClassName
        self.headerConfiguration = headerConfig
        self.footerConfiguration = footerConfig
        self.headerHeightCal = headerHeightCal
        self.footerHeightCal = footerHeightCal
    }
    
    func headerClass() -> UITableViewHeaderFooterView.Type? {
        if self.headerClassName == nil || self.headerClassName!.count == 0 {
            return nil
        }
        
        if self.headerClassName == "UITableViewHeaderFooterView" {
            return UITableViewHeaderFooterView.self
        }
        
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"]
        let viewClass: AnyClass? = NSClassFromString((nameSpace as! String) + "." + self.headerClassName!)
        guard let viewType = viewClass as? UITableViewHeaderFooterView.Type else {
            return nil
        }
        return viewType
    }
    func footerClass() -> UITableViewHeaderFooterView.Type? {
        if self.footerClassName == nil || self.footerClassName!.count == 0 {
            return nil
        }
        
        if self.headerClassName == "UITableViewHeaderFooterView" {
            return UITableViewHeaderFooterView.self
        }
        
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"]
        let viewClass: AnyClass? = NSClassFromString((nameSpace as! String) + "." + self.footerClassName!)
        guard let viewType = viewClass as? UITableViewHeaderFooterView.Type else {
            return nil
        }
        return viewType
    }
}
