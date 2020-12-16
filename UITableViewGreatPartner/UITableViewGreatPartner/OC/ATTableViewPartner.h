//
//  ATTableViewPartner.h
//
//
//  Created by ApesTalk on 2020/12/16.
//  Copyright © 2020 https://github.com/ApesTalk All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ATTableViewSectionPartner.h"

typedef ATTableViewSectionPartner* (^GenerateSectionParterBack)(id obj);

@interface ATTableViewPartner : NSObject
@property (nonatomic, strong, readonly) NSMutableArray<ATTableViewSectionPartner *> *sectionSource;

//批量导入section
- (void)batchAddSections:(NSArray *)datas generator:(GenerateSectionParterBack)generator;

//常规的列表，调用bind交权即可
- (void)bind:(UITableView *)table;///< 把代理全权交给ATTableViewPartner

//复杂的列表，不调用bind，自己在VC中实现代理方法，新增代理方法或新增其他逻辑代码，可以部分使用下面的代码
- (NSInteger)numberOfSections:(UITableView *)table;
- (NSInteger)numberOfRows:(UITableView *)table section:(NSInteger)section;
- (UITableViewCell *)cellForRow:(UITableView *)table indexPath:(NSIndexPath *)indexPath;
- (UITableViewHeaderFooterView *)sectionHeader:(UITableView *)table section:(NSInteger)section;
- (UITableViewHeaderFooterView *)sectionFooter:(UITableView *)table section:(NSInteger)section;
- (CGFloat)heightForRow:(UITableView *)table indexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForSectionHeader:(UITableView *)table section:(NSInteger)section;
- (CGFloat)heightForSectionFooter:(UITableView *)table section:(NSInteger)section;
- (void)didSelectRow:(UITableView *)table indexPath:(NSIndexPath *)indexPath;

@end

