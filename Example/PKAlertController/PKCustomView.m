//
//  PKCustomView.m
//  PKAlertController
//
//  Created by Satoshi Ohki on 2015/02/25.
//  Copyright (c) 2015年 Satoshi Ohki. All rights reserved.
//

#import "PKCustomView.h"

@interface PKCustomView ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTitleHeightConstraint;

@property (nonatomic) CALayer *subTitleBottomBorderLayer;

@end

@implementation PKCustomView

- (void)updateSubTitleBorderLayer:(CALayer *)layer {
    layer.borderColor = self.subTitleLabel.textColor.CGColor;
    layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    layer.frame = CGRectMake(0, CGRectGetHeight(self.subTitleLabel.bounds), CGRectGetWidth(self.subTitleLabel.bounds), layer.borderWidth);
}

#pragma mark - (UIViewRendering)

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (!self.subTitleBottomBorderLayer) {
        CALayer *bottomBorderLayer = [CALayer layer];
        self.subTitleBottomBorderLayer = bottomBorderLayer;
        [self.subTitleLabel.layer addSublayer:bottomBorderLayer];
    }
    [self updateSubTitleBorderLayer:self.subTitleBottomBorderLayer];
}

#pragma mark - (UIConstraintBasedLayoutLayering)

- (CGSize)intrinsicContentSize {
    CGFloat subviewWidth = self.bounds.size.width - self.titleLabelLeadingConstraint.constant * 2;
    CGFloat subviewHeight = [self.titleLabel sizeThatFits:CGSizeMake(subviewWidth, CGFLOAT_MAX)].height;
    subviewHeight += self.subTitleHeightConstraint.constant;
    subviewHeight += [self.descriptionLabel sizeThatFits:CGSizeMake(subviewWidth, CGFLOAT_MAX)].height;

    CGSize totalSize = CGSizeMake(self.bounds.size.width, subviewHeight + self.titleLabelTopConstraint.constant);
    return totalSize;
}

#pragma mark - <PKAlertViewLayoutAdapter>

- (void)applyLayoutWithAlertComponentViews:(NSDictionary *)views {
    UIView *contentView = PKAlertGetViewInViews(PKAlertContentViewKey, views);

    NSMutableArray *contentConstraints = @[
        [NSLayoutConstraint constraintWithItem:self.headerImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationLessThanOrEqual toItem:
         contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0],
    ].mutableCopy;
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.headerImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    constraint.priority = UILayoutPriorityDefaultHigh;
    [contentConstraints addObject:constraint];
    [contentView addConstraints:contentConstraints];
}

@end
