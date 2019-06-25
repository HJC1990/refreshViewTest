//
//  HJRefreshContentView.m
//  testhahah
//
//  Created by sam on 2019/6/22.
//  Copyright © 2019 sam. All rights reserved.
//

#import "HJRefreshContentView.h"

@implementation HJRefreshContentView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, self.bounds.size.width, 20)];
        _statusLabel.font = [UIFont boldSystemFontOfSize:12];
        _statusLabel.textColor = [UIColor blackColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel];
        
        _arrowImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _arrowImageV.image = [UIImage imageNamed:@"arrow"];
        [self addSubview:_arrowImageV];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.frame = CGRectMake(30, 25, 20, 20);
        [self addSubview:_activityIndicatorView];
    }
    return self;
}

- (void)layoutSubviews {
    CGSize size = self.bounds.size;
    self.statusLabel.frame = CGRectMake(20.0, round((size.height - 30.0) / 2.0), size.width - 40.0, 30.0);
    self.arrowImageV.frame = CGRectMake(0, round((size.height - 30.0) / 2.0), 12, 30);
    self.activityIndicatorView.frame = CGRectMake(round((size.width - 20.0) / 2.0), round((size.height - 20.0) / 2.0), 20.0, 20.0);
}

- (void)changeState:(HJRefreshState)state {
    switch (state) {
        case HJRefreshStateNormal: {
            self.statusLabel.alpha = 0.0;
            self.arrowImageV.alpha = 0.0;
            self.activityIndicatorView.alpha = 0.0;
            break;
        }
        case HJRefreshStatePull: {
            self.statusLabel.text = @"下拉刷新";
            self.statusLabel.alpha = 1.0;
            self.arrowImageV.alpha = 1.0;
            [self.activityIndicatorView stopAnimating];
            self.activityIndicatorView.alpha = 0.0;
            break;
        }
        case HJRefreshStateRelease: {
            NSLog(@"222222-----");
            self.statusLabel.text = @"松开刷新";
            self.statusLabel.alpha = 1.0;
            self.arrowImageV.alpha = 1.0;
            [self.activityIndicatorView startAnimating];
            self.activityIndicatorView.alpha = 0.0;
            break;
        }
        case HJRefreshStateLoading: {
            NSLog(@"11111-----");
            self.statusLabel.alpha = 0.0;
            self.arrowImageV.alpha = 0.0;
            [self.activityIndicatorView startAnimating];
            self.activityIndicatorView.alpha = 1.0;
            break;
        }
        default:
            break;
    }
}

@end
