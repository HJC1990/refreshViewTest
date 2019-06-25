//
//  HJFootRefreshView.m
//  testhahah
//
//  Created by sam on 2019/6/24.
//  Copyright © 2019 sam. All rights reserved.
//

#import "HJFootRefreshView.h"

#define kPullUpRefreshHeight 40

@interface HJFootRefreshView ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) HJFootRefreshContentView *contentView;
@property (nonatomic)        BOOL          expanded;//scrollviews是否是展开的

@end

@implementation HJFootRefreshView

- (id)initWithTargeView:(UIScrollView *)targetView {
    if (self = [super init]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.scrollView = targetView;
        
        [self.scrollView addSubview:self];
        
        self.contentView = [[HJFootRefreshContentView alloc] init];
        [self addSubview:self.contentView];
        self.state = HJFootRefreshPullUp;
        [self.contentView changeState:HJFootRefreshPullUp];
        
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)layoutSubviews {
    NSLog(@"contentSize---%f",self.scrollView.contentSize.height);
    self.contentView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-120)*0.5, self.scrollView.contentSize.height, 120, 40);
}

- (void)setState:(HJFootRefreshState)state {
    BOOL isLoading = NO;
    if (_state == HJFootRefreshLoading) {
        isLoading = YES;
    }
    _state = state;
    
    if (!isLoading && _state == HJFootRefreshLoading) {
        if ([self.delegate respondsToSelector:@selector(pullUpToRefreshViewDidStartLoading)]) {
            [self.delegate pullUpToRefreshViewDidStartLoading];
        }
    }
    
}

- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    if (expanded) {
        [self changeContentInsetBottom:kPullUpRefreshHeight];
    } else {
        [self changeContentInsetBottom:0];
    }
}

- (void)changeContentInsetBottom:(CGFloat)topInset {
    UIEdgeInsets inset;
    inset.bottom += topInset;
    
    NSLog(@"offset----%f----%f",self.scrollView.contentInset.bottom,inset.bottom);
    self.scrollView.contentInset = inset;
    
    
}

- (void)startRefresh {
    NSLog(@"开始刷新");
    if (self.state == HJFootRefreshLoading) {
        return;
    }
    
    [self setState:HJFootRefreshLoading animated:NO expanded:NO completion:nil];
    
}

- (void)stopRefresh {
    NSLog(@"结束刷新");
    if (self.state != HJFootRefreshLoading) {
        return;
    }
    
    __weak HJFootRefreshView *weakSelf = self;
    [self setState:HJFootRefreshNormal animated:YES expanded:NO completion:^{
        weakSelf.state = HJFootRefreshPullUp;
        [weakSelf.contentView changeState:HJFootRefreshPullUp];
        weakSelf.contentView.arrowImageV.transform = CGAffineTransformRotate(weakSelf.contentView.arrowImageV.transform, M_PI);
        [weakSelf setNeedsLayout];
        NSLog(@"高--低----%f----%f",weakSelf.scrollView.contentInset.top,weakSelf.scrollView.contentInset.bottom);
    }];
}

- (void)setState:(HJFootRefreshState)state animated:(BOOL)animated expanded:(BOOL)expanded completion:(void(^)(void))completion{
    
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
        [self.contentView changeState:HJFootRefreshPullUp];
        self.state = HJFootRefreshPullUp;
        return;
    }
    
    CGFloat iphoneHeight = [UIScreen mainScreen].bounds.size.height-64;
    CGFloat contentSizeHeihgt = self.scrollView.contentSize.height;
    NSLog(@"比较一下·===%f====%f",iphoneHeight,contentSizeHeihgt);
    if (self.scrollView.dragging) {
        if (self.state == HJFootRefreshRelease) {
            if (y > 0 && y+iphoneHeight < contentSizeHeihgt+kPullUpRefreshHeight) {
                [self.contentView changeState:HJFootRefreshPullUp];
                self.state = HJFootRefreshPullUp;
                [UIView animateWithDuration:0.3 animations:^{
                    self.contentView.arrowImageV.transform = CGAffineTransformRotate(self.contentView.arrowImageV.transform, M_PI);
                }];
            }
        } else if (self.state == HJFootRefreshPullUp) {
            if (y+iphoneHeight > contentSizeHeihgt+kPullUpRefreshHeight) {
                [self.contentView changeState:HJFootRefreshRelease];
                self.state = HJFootRefreshRelease;
                [UIView animateWithDuration:0.3 animations:^{
                    self.contentView.arrowImageV.transform = CGAffineTransformRotate(self.contentView.arrowImageV.transform, M_PI);
                }];
            }
        }
        return;
    }
    
    NSLog(@"释放*****%f******%ld",y,(long)self.state);
    if (self.state != HJFootRefreshRelease) {
        return;
    }
    
    [self setState:HJFootRefreshLoading animated:YES expanded:YES completion:nil];
    
}

@end
