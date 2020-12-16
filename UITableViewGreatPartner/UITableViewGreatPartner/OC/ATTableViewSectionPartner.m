//
//  ATTableViewSectionPartner.m
//  
//
//  Created by ApesTalk on 2020/12/16.
//  Copyright © 2020 https://github.com/ApesTalk All rights reserved.
//

#import "ATTableViewSectionPartner.h"

@interface ATTableViewSectionPartner ()
@property (nonatomic, assign, readwrite) NSInteger tag;
@property (nonatomic, copy, readwrite) NSString *headerClassName;
@property (nonatomic, copy, readwrite) NSString *footerClassName;
@property (nonatomic, copy, readwrite) HFConfigBlock headerConfigBlock;
@property (nonatomic, copy, readwrite) HFConfigBlock footerConfigBlock;
@property (nonatomic, copy, readwrite) HFHeightBlock headerHeightBlock;
@property (nonatomic, copy, readwrite) HFHeightBlock footerHeightBlock;

@property (nonatomic, strong, readwrite) NSMutableArray<ATTableViewCellPartner *> *rowSource;
@end

@implementation ATTableViewSectionPartner
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rowSource = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)model:(NSInteger)tag
headerClassName:(NSString *)headerClassName
footerClassName:(NSString *)footerClassName
   headerConfig:(HFConfigBlock)headerConfig
   footerConfig:(HFConfigBlock)footerConfig
         headerHeight:(HFHeightBlock)headerHeight
         footerHeight:(HFHeightBlock)footerHeight
{
    ATTableViewSectionPartner *partner = [[ATTableViewSectionPartner alloc]init];
    partner.tag = tag;
    partner.headerClassName = headerClassName;
    partner.footerClassName = footerClassName;
    partner.headerConfigBlock = headerConfig;
    partner.footerConfigBlock = footerConfig;
    partner.headerHeightBlock = headerHeight;
    partner.footerHeightBlock = footerHeight;
    return partner;
}

- (void)batchAddRows:(NSArray *)datas generator:(GenerateCellParterBack)generator
{
    for(id d in datas) {
        if(generator){
            [self.rowSource addObject:generator(d)];
        }
    }
}
@end
