//
//  TestCell.swift
//  UITableViewGreatPartner
//
//  Created by ApesTalk on 2020/12/16.
//  Copyright © 2020 https://github.com/ApesTalk All rights reserved.
//

import UIKit
class TestCell: UITableViewCell {
    let iv: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .darkGray
        return iv
    }()
    
    let lbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        lbl.textColor = .black
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(iv)
        self.contentView.addSubview(lbl)
        iv.frame = CGRect(x: 15, y: 15, width: 30, height: 30)
        lbl.frame = CGRect(x: 60, y: 20, width: 190, height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func height() -> CGFloat {
        return 60
    }
    
}
