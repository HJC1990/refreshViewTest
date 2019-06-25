//
//  HJRefreshContentView.h
//  testhahah
//
//  Created by sam on 2019/6/22.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HJRefreshState) {
    HJRefreshStateNormal,
    HJRefreshStatePull,
    HJRefreshStateRelease,
    HJRefreshStateLoading
};

@interface HJRefreshContentView : UIView

@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UIImageView *arrowImageV;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

- (void)changeState:(HJRefreshState)state;

@end

NS_ASSUME_NONNULL_END
