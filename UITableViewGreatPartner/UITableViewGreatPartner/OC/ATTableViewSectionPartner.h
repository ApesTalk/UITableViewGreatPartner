//
//  ATTableViewSectionPartner.h
//  
//
//  Created by ApesTalk on 2020/12/16.
//  Copyright © 2020 https://github.com/ApesTalk All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ATTableViewCellPartner.h"

typedef void (^HFConfigBlock)(id view, NSInteger section);
typedef CGFloat (^HFHeightBlock)(id view, NSInteger section);
typedef ATTableViewCellPartner* (^GenerateCellParterBack)(id obj);

@interface ATTableViewSectionPartner : NSObject
@property (nonatomic, assign, readonly) NSInteger tag;
@property (nonatomic, copy, readonly) NSString *headerClassName;
@property (nonatomic, copy, readonly) NSString *footerClassName;
@property (nonatomic, copy, readonly) HFConfigBlock headerConfigBlock;
@property (nonatomic, copy, readonly) HFConfigBlock footerConfigBlock;
@property (nonatomic, copy, readonly) HFHeightBlock headerHeightBlock;
@property (nonatomic, copy, readonly) HFHeightBlock footerHeightBlock;

@property (nonatomic, strong, readonly) NSMutableArray<ATTableViewCellPartner *> *rowSource;

+ (instancetype)model:(NSInteger)tag
      headerClassName:(NSString *)headerClassName
      footerClassName:(NSString *)footerClassName
         headerConfig:(HFConfigBlock)headerConfig
         footerConfig:(HFConfigBlock)footerConfig
               headerHeight:(HFHeightBlock)headerHeight
               footerHeight:(HFHeightBlock)footerHeight;
//批量导入cell
- (void)batchAddRows:(NSArray *)datas generator:(GenerateCellParterBack)generator;
@end

