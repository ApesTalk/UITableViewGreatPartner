//
//  ViewController.swift
//  UITableViewGreatPartner
//
//  Created by ApesTalk on 2020/12/16.
//  Copyright © 2020 https://github.com/ApesTalk All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let tablePartner = ATTableViewPartner()
    
    let tableView: UITableView = {
        let t = UITableView.init(frame: .zero, style: .grouped)
        t.tableFooterView = UIView()
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.frame = self.view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        //简单的列表，完全可以交给partner去处理，不需要vc再实现代理方法
        tablePartner.bind(tableView)
        //此行注释掉，代理还是交给VC处理，自己再加一些复杂的处理逻辑
        
        
        tablePartner.batchAddSections([1, 2]) { (item) -> ATTableViewSectionPartner in
            return ATTableViewSectionPartner.init(0, "UITableViewHeaderFooterView", "UITableViewHeaderFooterView", { (header, section) in
                header?.textLabel?.textColor = .red
                header?.textLabel?.text = "Section Header \(section)"
            }, { (footer, section) in
                footer?.textLabel?.textColor = .blue
                footer?.textLabel?.text = "Section Footer \(section)"
            }, { (header, section) -> CGFloat in
                return 50
            }) { (footer, section) -> CGFloat in
                return 40
            }
        }
        
        tablePartner.sectionSource[0].batchAddRows([0]) { (item) -> ATTableViewCellPartner in
            return ATTableViewCellPartner.init(0, "UITableViewCell", { (cell, indexPath) in
                cell?.textLabel?.textColor = .black
                cell?.textLabel?.text = "第一个分区的第一个Cell"
            }, { (cell, indexPath) in
                print("第一个分区的cell被点击")
            }) { (cell, indexPath) -> CGFloat in
                return 80
            }
        }
        
        let arr = self.networkRequest(0)
        tablePartner.sectionSource[1].batchAddRows(arr) { (item) -> ATTableViewCellPartner in
            return ATTableViewCellPartner.init(0, "TestCell", { (cell, indexPath) in
                guard let t = item as? String else {
                    return
                }
                let rCell = cell as! TestCell
                rCell.lbl.text = t
            }, { (cell, indexPath) in
                print("第二个分区的第\(indexPath.row)cell被点击")
            }) { (cell, indexPath) -> CGFloat in
                return TestCell.height()
            }
        }
        
        
    }

    //假装有网络请求
    func networkRequest(_ page: Int) -> [String] {
        var arr = [String]()
        for i in page * 20 ..< page * 20 + 20 {
            arr.append("Cell Item \(i)")
        }
        return arr
    }
    
}

//不使用bind，自定义补充实现一些协议方法
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tablePartner.numberOfSections(tableView)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tablePartner.numberOfRows(tableView, section)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.transform = CGAffineTransform(translationX: -50, y: 0);
        UIView.animate(withDuration: 0.1) {
            cell.contentView.transform = .identity;
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tablePartner.cellForRow(tableView, indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tablePartner.heightForRow(tableView, indexPath)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelect section=\(indexPath.section), row=\(indexPath.row)")
        //自定义一些操作
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.tablePartner.sectionHeader(tableView, section)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.tablePartner.sectionFooter(tableView, section)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.tablePartner.heightForSectionHeader(tableView, section)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.tablePartner.heightForSectionFooter(tableView, section)
    }
}

