//
//  HJRefreshView.h
//  testhahah
//
//  Created by sam on 2019/6/22.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJRefreshContentView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HJRefreshViewDelegate;

@interface HJRefreshView : UIView

@property (nonatomic,weak) id<HJRefreshViewDelegate> delegate;
@property (nonatomic,assign) HJRefreshState state;

- (id)initWithTargeView:(UIScrollView *)targetView;

- (void)startRefresh;
- (void)stopRefresh;

@end

@protocol HJRefreshViewDelegate <NSObject>

- (void)pullToRefreshViewDidStartLoading;

@end

NS_ASSUME_NONNULL_END
