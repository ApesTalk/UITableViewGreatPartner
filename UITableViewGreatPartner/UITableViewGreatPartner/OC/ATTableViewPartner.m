//
//  ATTableViewPartner.m
//
//
//  Created by ApesTalk on 2020/12/16.
//  Copyright © 2020 https://github.com/ApesTalk All rights reserved.
//

#import "ATTableViewPartner.h"

@interface ATTableViewPartner () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView *table;
@property (nonatomic, strong, readwrite) NSMutableArray<ATTableViewSectionPartner *> *sectionSource;
@end

@implementation ATTableViewPartner
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sectionSource = [NSMutableArray array];
    }
    return self;
}

- (void)batchAddSections:(NSArray *)datas generator:(GenerateSectionParterBack)generator
{
    for(id d in datas) {
        if(generator){
            [self.sectionSource addObject:generator(d)];
        }
    }
}

- (void)batchAddRows:(NSArray *)datas inSection:(NSInteger)section generator:(GenerateCellParterBack)generator
{
    if(section >= 0 && section < self.sectionSource.count){
        ATTableViewSectionPartner *sp = self.sectionSource[section];
        [sp batchAddRows:datas generator:generator];
    }
}

- (void)removeAllRowsInSection:(NSInteger)section
{
    if(section >= 0 && section < self.sectionSource.count){
        ATTableViewSectionPartner *sp = self.sectionSource[section];
        [sp.rowSource removeAllObjects];
    }
}

- (void)bind:(UITableView *)table
{
    self.table = table;
    self.table.dataSource = self;
    self.table.delegate = self;
}

- (UITableViewCell *)getCell:(UITableView *)table indexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if(self.sectionSource.count > section){
        NSInteger row = indexPath.row;
        NSArray *rowSource = self.sectionSource[section].rowSource;
        if(rowSource.count > row){
            ATTableViewCellPartner *rp = rowSource[row];
            UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:rp.className];
            if(!cell){
                Class cls = NSClassFromString(rp.className);
                if([cls isSubclassOfClass:[UITableViewCell class]]){
                    cell = [[cls alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rp.className];
                }
            }
            return cell;
        }
    }
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"partner-empty-cellIden"];
}

- (UITableViewHeaderFooterView *)getSectionHeader:(UITableView *)table section:(NSInteger)section
{
    if(section >= 0 && section < self.sectionSource.count){
        ATTableViewSectionPartner *sp = self.sectionSource[section];
        UITableViewHeaderFooterView *header = [table dequeueReusableHeaderFooterViewWithIdentifier:sp.headerClassName];
        if(!header){
            Class cls = NSClassFromString(sp.headerClassName);
            if([cls isSubclassOfClass:[UITableViewHeaderFooterView class]]){
                header = [[cls alloc]initWithReuseIdentifier:sp.headerClassName];
            }
        }
        return header;
    }
    return nil;
}

- (UITableViewHeaderFooterView *)getSectionFooter:(UITableView *)table section:(NSInteger)section
{
    if(section >= 0 && section < self.sectionSource.count){
        ATTableViewSectionPartner *sp = self.sectionSource[section];
        UITableViewHeaderFooterView *footer = [table dequeueReusableHeaderFooterViewWithIdentifier:sp.footerClassName];
        if(!footer){
            Class cls = NSClassFromString(sp.footerClassName);
            if([cls isSubclassOfClass:[UITableViewHeaderFooterView class]]){
                footer = [[cls alloc]initWithReuseIdentifier:sp.footerClassName];
            }
        }
        return footer;
    }
    return nil;
}

- (NSInteger)numberOfSections:(UITableView *)table
{
    return self.sectionSource.count;
}

- (NSInteger)numberOfRows:(UITableView *)table section:(NSInteger)section
{
    if(self.sectionSource.count > section){
        return self.sectionSource[section].rowSource.count;
    }
    return 0;
}

- (UITableViewCell *)cellForRow:(UITableView *)table indexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self getCell:table indexPath:indexPath];
    if(self.sectionSource.count > indexPath.section){
        NSArray *rowSource = self.sectionSource[indexPath.section].rowSource;
        if(indexPath.row < rowSource.count){
            ATTableViewCellPartner *cp = rowSource[indexPath.row];
            if(cp.configBlock){
                cp.configBlock(cell, indexPath);
            }
        }
    }
    return cell;
}

- (UITableViewHeaderFooterView *)sectionHeader:(UITableView *)table section:(NSInteger)section
{
    UITableViewHeaderFooterView *header = [self getSectionHeader:table section:section];
    if(self.sectionSource.count > section){
        ATTableViewSectionPartner *cp = self.sectionSource[section];
        if(cp.headerConfigBlock){
            cp.headerConfigBlock(header, section);
        }
    }
    return header;
}

- (UITableViewHeaderFooterView *)sectionFooter:(UITableView *)table section:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = [self getSectionFooter:table section:section];
    if(self.sectionSource.count > section){
        ATTableViewSectionPartner *cp = self.sectionSource[section];
        if(cp.footerConfigBlock){
            cp.footerConfigBlock(footer, section);
        }
    }
    return footer;
}

- (CGFloat)heightForRow:(UITableView *)table indexPath:(NSIndexPath *)indexPath
{
    if(self.sectionSource.count > indexPath.section){
        NSArray *rowSource = self.sectionSource[indexPath.section].rowSource;
        if(indexPath.row < rowSource.count){
            ATTableViewCellPartner *cp = rowSource[indexPath.row];
            if(cp.heightBlock){
                return cp.heightBlock([self getCell:table indexPath:indexPath], indexPath);
            }
        }
    }
    return CGFLOAT_MIN;
}


- (CGFloat)heightForSectionHeader:(UITableView *)table section:(NSInteger)section
{
    if(self.sectionSource.count > section){
        ATTableViewSectionPartner *cp = self.sectionSource[section];
        if(cp.headerHeightBlock){
            return cp.headerHeightBlock([self getSectionHeader:table section:section], section);
        }
    }
    return CGFLOAT_MIN;
}

- (CGFloat)heightForSectionFooter:(UITableView *)table section:(NSInteger)section
{
    if(self.sectionSource.count > section){
        ATTableViewSectionPartner *cp = self.sectionSource[section];
        if(cp.footerHeightBlock){
            return cp.footerHeightBlock([self getSectionFooter:table section:section], section);
        }
    }
    return CGFLOAT_MIN;
}

- (void)didSelectRow:(UITableView *)table indexPath:(NSIndexPath *)indexPath
{
    if(self.sectionSource.count > indexPath.section){
        NSArray *rowSource = self.sectionSource[indexPath.section].rowSource;
        if(indexPath.row < rowSource.count){
            ATTableViewCellPartner *cp = rowSource[indexPath.row];
            if(cp.selectBlock){
                cp.selectBlock(indexPath);
            }
        }
    }
}

#pragma mark---UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self numberOfSections:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfRows:tableView section:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellForRow:tableView indexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self sectionHeader:tableView section:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self sectionFooter:tableView section:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForRow:tableView indexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self heightForSectionHeader:tableView section:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self heightForSectionFooter:tableView section:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectRow:tableView indexPath:indexPath];
}
@end
