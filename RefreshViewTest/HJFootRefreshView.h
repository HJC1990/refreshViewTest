//
//  HJFootRefreshView.h
//  testhahah
//
//  Created by sam on 2019/6/24.
//  Copyright © 2019 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJFootRefreshContentView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HJFootRefreshViewDelegate;

@interface HJFootRefreshView : UIView

@property (nonatomic,weak) id<HJFootRefreshViewDelegate> delegate;
@property (nonatomic,assign) HJFootRefreshState state;

- (id)initWithTargeView:(UIScrollView *)targetView;

- (void)startRefresh;
- (void)stopRefresh;

@end

@protocol HJFootRefreshViewDelegate <NSObject>

- (void)pullUpToRefreshViewDidStartLoading;

@end

NS_ASSUME_NONNULL_END
