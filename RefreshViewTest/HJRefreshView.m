//
//  HJRefreshView.m
//  testhahah
//
//  Created by sam on 2019/6/22.
//  Copyright © 2019 sam. All rights reserved.
//

#import "HJRefreshView.h"

#define kRefreshHeight 60

@interface HJRefreshView ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) HJRefreshContentView *contentView;
@property (nonatomic)        BOOL          expanded;//scrollviews是否是展开的

@end

@implementation HJRefreshView

- (id)initWithTargeView:(UIScrollView *)targetView {
    if (self = [super init]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.scrollView = targetView;
        
        [self.scrollView addSubview:self];
        
        self.contentView = [[HJRefreshContentView alloc] init];
        [self addSubview:self.contentView];
        self.state = HJRefreshStatePull;
        [self.contentView changeState:HJRefreshStatePull];
        
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)layoutSubviews {
    
    self.contentView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-120)*0.5, -40, 120, 40);
}

- (void)setState:(HJRefreshState)state {
    BOOL isLoading = NO;
    if (_state == HJRefreshStateLoading) {
        isLoading = YES;
    }
    _state = state;
    
    if (!isLoading && _state == HJRefreshStateLoading) {
        if ([self.delegate respondsToSelector:@selector(pullToRefreshViewDidStartLoading)]) {
            [self.delegate pullToRefreshViewDidStartLoading];
        }
    }
    
}

- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    if (expanded) {
        [self changeContentInsetTop:kRefreshHeight];
    } else {
        [self changeContentInsetTop:0];
    }
}

- (void)changeContentInsetTop:(CGFloat)topInset {
    UIEdgeInsets inset;
    inset.top += topInset;
    
    self.scrollView.contentInset = inset;
    
    
}

- (void)startRefresh {
    NSLog(@"开始刷新");
    if (self.state == HJRefreshStateLoading) {
        return;
    }
    
    [self setState:HJRefreshStateLoading animated:NO expanded:NO completion:nil];
    
}

- (void)stopRefresh {
    NSLog(@"结束刷新");
    if (self.state != HJRefreshStateLoading) {
        return;
    }
    
    __weak HJRefreshView *weakSelf = self;
    [self setState:HJRefreshStateNormal animated:YES expanded:NO completion:^{
        weakSelf.state = HJRefreshStatePull;
        [weakSelf.contentView changeState:HJRefreshStatePull];
        weakSelf.contentView.arrowImageV.transform = CGAffineTransformRotate(weakSelf.contentView.arrowImageV.transform, M_PI);
        
    }];
}

- (void)setState:(HJRefreshState)state animated:(BOOL)animated expanded:(BOOL)expanded completion:(void(^)(void))completion{
    
        self.state = state;
        self.expanded = expanded;
        [self.contentView changeState:state];
        if (completion) {
            completion();
        }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (![keyPath isEqualToString:@"contentOffset"] || object != self.scrollView) {
        return;
    }
    
    CGFloat y = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
    NSLog(@"*****%f******%ld",y,(long)self.state);
    
    if (y == 0) {
        [self.contentView changeState:HJRefreshStatePull];
        self.state = HJRefreshStatePull;
        return;
    }
    
    if (self.scrollView.dragging) {
        if (self.state == HJRefreshStateRelease) {
            if (y < 0 && y > - kRefreshHeight) {
                [self.contentView changeState:HJRefreshStatePull];
                self.state = HJRefreshStatePull;
                [UIView animateWithDuration:0.3 animations:^{
                    self.contentView.arrowImageV.transform = CGAffineTransformRotate(self.contentView.arrowImageV.transform, M_PI);
                }];
            }
        } else if (self.state == HJRefreshStatePull) {
            if (y < -kRefreshHeight) {
                [self.contentView changeState:HJRefreshStateRelease];
                self.state = HJRefreshStateRelease;
                [UIView animateWithDuration:0.3 animations:^{
                    self.contentView.arrowImageV.transform = CGAffineTransformRotate(self.contentView.arrowImageV.transform, M_PI);
                }];
            }
        }
        return;
    }
    
    NSLog(@"释放*****%f******%ld",y,(long)self.state);
    if (self.state != HJRefreshStateRelease) {
        return;
    }
    
    [self setState:HJRefreshStateLoading animated:YES expanded:YES completion:nil];

}

@end
