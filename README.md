# UITableViewGreatPartner

A great partner of UITableView which can make create list view easy and fast.

对UITableView的一个简单灵活的封装，无hook零侵入，减少UIViewController中一堆代理方法的臃肿代码，有效避免在代理方法里面重复的if-else判断逻辑。sectionHeader、sectionFooter、cell灵活配置一下即可，支持批量操作。



## 常见的列表展示

UITableViewDataSource和UITableViewDelegate的常用代理方法完全交给ATTableViewPartner处理即可。

```
let tablePartner = ATTableViewPartner()
tablePartner.bind(tableView)
```

## 需要自定义一些复杂操作逻辑的列表

不调用bind方法，UITableViewDataSource和UITableViewDelegate的代理还是交给控制器，再按需添加自己要新实现的代理方法及新增打处理逻辑即可。



## 批量添加cellParter示例

对于同样的cell样式，支持批量添加配置信息（cellPartner）：

```
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
```


更多请参照demo。
