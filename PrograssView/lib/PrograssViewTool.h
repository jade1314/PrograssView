//
//  PrograssView.h
//  PanGu
//
//  Created by 王玉 on 2017/4/10.
//  Copyright © 2017年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarModel.h"
#import "UIView+frame.h"
#import "UIView+Shadow.h"
#import "DateHelper.h"


@interface PrograssViewTool : UIView
@property (nonatomic,strong) CalendarModel * currentModelTop;

@property (nonatomic,strong) UIProgressView * progress;
- (void)reloadDateWithModel:(CalendarModel *)model;

@end
