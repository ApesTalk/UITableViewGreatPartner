//
//  FlexiableTableViewModel.swift
//  HumanAssistant
//
//  Created by ApesTalk on 2020/12/15.
//  Copyright © 2020 https://github.com/ApesTalk All rights reserved.
//

import Foundation
import UIKit

//如果常用代理方法如果能满足，直接调用bind即可
//不能满足时，不需调用bind，额外的代理方法实现还是交给Controller处理

typealias generateSectionParterCallBack = (_ obj: Any) -> ATTableViewSectionPartner

private var myContext = 0

class ATTableViewPartner: NSObject {
    weak private var table: UITableView?
    var sectionSource: [ATTableViewSectionPartner] = [ATTableViewSectionPartner]()
    
    override init() {
        super.init()
        self.addObserver(self, forKeyPath: "sectionSource", options: .new, context: &myContext)
    }
    
    //批量添加sectionParter
    func batchAddSections(_ array: [Any], _ generater: generateSectionParterCallBack) {
        for item in array {
            self.sectionSource.append(generater(item))
        }
    }
    
    
    func bind(_ tableView: UITableView) {
        self.table = tableView
        self.table?.dataSource = self
        self.table?.delegate = self
    }
    
    func getCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell? {
        let sp = self.sectionSource[indexPath.section]
        let rp = sp.rowSource[indexPath.row]
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: rp.className)
        if cell == nil {
            cell = rp.cellClass().init(style: .default, reuseIdentifier: rp.className)
        }
        return cell
    }
    func getSectionHeader(_ tableView: UITableView, _ section: Int) -> UITableViewHeaderFooterView? {
        let sp = self.sectionSource[section]
        if let cls: UITableViewHeaderFooterView.Type = sp.headerClass(), let identifier = sp.headerClassName {
            var header: UITableViewHeaderFooterView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
            if header == nil {
                header = cls.init(reuseIdentifier: identifier)
            }
            return header
        }
        return nil
    }
    func getSectionFooter(_ tableView: UITableView, _ section: Int) -> UITableViewHeaderFooterView? {
        let sp = self.sectionSource[section]
        if let cls: UITableViewHeaderFooterView.Type = sp.footerClass(), let identifier = sp.footerClassName {
            var footer: UITableViewHeaderFooterView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
            if footer == nil {
                footer = cls.init(reuseIdentifier: identifier)
            }
            return footer
        }
        return nil
    }
    
    //如果不调用上面的方法绑定UITableView及其代理，也可以外部直接调如下方法获取
    func numberOfSections(_ tableView: UITableView) -> Int {
        return self.sectionSource.count
    }
    func numberOfRows(_ tableView: UITableView, _ section: Int) -> Int {
        return self.sectionSource[section].rowSource.count
    }
    func cellForRow(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let sp = self.sectionSource[indexPath.section]
        let rp = sp.rowSource[indexPath.row]
        let cell: UITableViewCell? = self.getCell(tableView, indexPath)
        guard cell == nil || rp.configuration == nil else {
            rp.configuration!(cell, indexPath)
            return cell!
        }
        return UITableViewCell()
    }
    func sectionHeader(_ tableView: UITableView, _ section: Int) -> UIView? {
        let sp = self.sectionSource[section]
        let header: UITableViewHeaderFooterView? = self.getSectionHeader(tableView, section)
        guard header == nil || sp.headerConfiguration == nil else {
            sp.headerConfiguration!(header, section)
            return header
        }
        return header
    }
    func sectionFooter(_ tableView: UITableView, _ section: Int) -> UIView? {
        let sp = self.sectionSource[section]
        let footer: UITableViewHeaderFooterView? = self.getSectionFooter(tableView, section)
        guard footer == nil || sp.footerConfiguration == nil else {
            sp.footerConfiguration!(footer, section)
            return footer
        }
        return footer
    }
    
    func heightForRow(_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat {
        let sp = self.sectionSource[indexPath.section]
        let rp = sp.rowSource[indexPath.row]
        let cell: UITableViewCell? = self.getCell(tableView, indexPath)
        guard cell == nil || rp.heightCal == nil else {
            return rp.heightCal!(cell, indexPath)
        }
        return CGFloat.leastNormalMagnitude
    }
    func heightForSectionHeader(_ tableView: UITableView, _ section: Int) -> CGFloat {
        let sp = self.sectionSource[section]
        let header: UITableViewHeaderFooterView? = self.getSectionHeader(tableView, section)
        guard header == nil || sp.headerHeightCal == nil else {
            return sp.headerHeightCal!(header, section)
        }
        return CGFloat.leastNormalMagnitude
    }
    func heightForSectionFooter(_ tableView: UITableView, _ section: Int) -> CGFloat {
        let sp = self.sectionSource[section]
        let footer: UITableViewHeaderFooterView? = self.getSectionFooter(tableView, section)
        guard footer == nil || sp.footerHeightCal == nil else {
            return sp.footerHeightCal!(footer, section)
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func didSelectRow(_ tableView: UITableView, _ indexPath: IndexPath) {
        let sp = self.sectionSource[indexPath.section]
        let rp = sp.rowSource[indexPath.row]
        if rp.selectAction != nil {
            rp.selectAction!(nil, indexPath)
        }
    }
}

extension ATTableViewPartner: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections(tableView)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRows(tableView, section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.cellForRow(tableView, indexPath)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionHeader(tableView, section)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.sectionFooter(tableView, section)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow(tableView, indexPath)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.heightForSectionHeader(tableView, section)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.heightForSectionFooter(tableView, section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectRow(tableView, indexPath)
    }
}

