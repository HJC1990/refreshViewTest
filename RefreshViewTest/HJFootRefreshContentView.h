//
//  HJFootRefreshContentView.h
//  testhahah
//
//  Created by sam on 2019/6/24.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HJFootRefreshState) {
    HJFootRefreshNormal,
    HJFootRefreshPullUp,
    HJFootRefreshRelease,
    HJFootRefreshLoading
};

@interface HJFootRefreshContentView : UIView

@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic,strong) UIImageView *arrowImageV;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

- (void)changeState:(HJFootRefreshState)state;

@end

NS_ASSUME_NONNULL_END
