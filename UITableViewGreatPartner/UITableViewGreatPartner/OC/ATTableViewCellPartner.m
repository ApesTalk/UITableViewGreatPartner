//
//  ATTableViewCellPartner.m
//  
//
//  Created by ApesTalk on 2020/12/16.
//  Copyright © 2020 https://github.com/ApesTalk All rights reserved.
//

#import "ATTableViewCellPartner.h"

@interface ATTableViewCellPartner ()
@property (nonatomic, assign, readwrite) NSInteger tag;///< 唯一标志
@property (nonatomic, copy, readwrite) NSString *className;///< cell标志，用于注册和获取cell
@property (nonatomic, copy, readwrite) CellConfigBlock configBlock;///< 配置内容
@property (nonatomic, copy, readwrite) CellHeightBlock heightBlock;///< 高度
@property (nonatomic, copy, readwrite) CellSelectBlock selectBlock;///< 点击回调
@end

@implementation ATTableViewCellPartner
+ (instancetype)model:(NSInteger)tag className:(NSString *)className config:(CellConfigBlock)config height:(CellHeightBlock)height select:(CellSelectBlock)select;
{
    ATTableViewCellPartner *partner = [[ATTableViewCellPartner alloc] init];
    partner.tag = tag;
    partner.className = className;
    partner.configBlock = config;
    partner.heightBlock = height;
    partner.selectBlock = select;
    return partner;
}

@end
