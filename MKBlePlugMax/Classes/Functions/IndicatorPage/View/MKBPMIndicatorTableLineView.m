//
//  MKBPMIndicatorTableLineView.m
//  MKBlePlugMax_Example
//
//  Created by aa on 2022/3/31.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBPMIndicatorTableLineView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

@implementation MKBPMIndicatorTableLineViewModel
@end

@interface MKBPMIndicatorTableLineView ()

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKBPMIndicatorTableLineView

+ (MKBPMIndicatorTableLineView *)initHeaderViewWithTableView:(UITableView *)tableView {
    MKBPMIndicatorTableLineView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MKBPMIndicatorTableLineViewIdenty"];
    if (!headerView) {
        headerView = [[MKBPMIndicatorTableLineView alloc] initWithReuseIdentifier:@"MKBPMIndicatorTableLineViewIdenty"];
    }
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBCOLOR(242, 242, 242);
        [self.contentView addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize msgSize = [NSString sizeWithText:SafeStr(self.msgLabel.text)
                                    andFont:self.msgLabel.font
                                 andMaxSize:CGSizeMake(self.contentView.frame.size.width - 30.f, MAXFLOAT)];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(msgSize.height);
    }];
}

#pragma mark - setter
- (void)setHeaderModel:(MKBPMIndicatorTableLineViewModel *)headerModel {
    _headerModel = nil;
    _headerModel = headerModel;
    if (!_headerModel || ![_headerModel isKindOfClass:MKBPMIndicatorTableLineViewModel.class]) {
        return;
    }
    self.msgLabel.attributedText = _headerModel.text;
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _msgLabel;
}

@end
