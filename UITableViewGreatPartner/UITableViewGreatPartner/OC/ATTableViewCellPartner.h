//
//  ATTableViewCellPartner.h
//  
//
//  Created by ApesTalk on 2020/12/16.
//  Copyright © 2020 https://github.com/ApesTalk All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CellConfigBlock)(id cell, NSIndexPath *indexPath);
typedef CGFloat(^CellHeightBlock)(id cell, NSIndexPath *indexPath);
typedef void(^CellSelectBlock)(NSIndexPath *indexPath);

@interface ATTableViewCellPartner : NSObject
@property (nonatomic, assign, readonly) NSInteger tag;///< 唯一标志
@property (nonatomic, copy, readonly) NSString *className;///< cell标志，用于注册和获取cell
@property (nonatomic, copy, readonly) CellConfigBlock configBlock;///< 配置内容
@property (nonatomic, copy, readonly) CellHeightBlock heightBlock;///< 高度
@property (nonatomic, copy, readonly) CellSelectBlock selectBlock;///< 点击回调

+ (instancetype)model:(NSInteger)tag className:(NSString *)className config:(CellConfigBlock)config height:(CellHeightBlock)height select:(CellSelectBlock)select;

@end


