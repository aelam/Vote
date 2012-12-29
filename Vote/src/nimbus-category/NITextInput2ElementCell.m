//
//  NITextInput2ElementCell.m
//  Vote
//
//  Created by Ryan Wang on 12-12-29.
//  Copyright (c) 2012年 Ryan Wang. All rights reserved.
//

#import "NITextInput2ElementCell.h"


static const CGFloat kTextFieldLeftMargin = 10;
static const CGFloat kImageViewRightMargin = 10;

@implementation NITextInput2ElementCell

@synthesize textField = _textField;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _textField = [[UITextField alloc] init];
        [_textField setTag:self.element.elementID];
        [_textField setAdjustsFontSizeToFitWidth:YES];
        [_textField setMinimumFontSize:10.0f];
        [_textField addTarget:self action:@selector(textFieldDidChangeValue) forControlEvents:UIControlEventAllEditingEvents];
        [self.contentView addSubview:_textField];
        
        [self.textLabel removeFromSuperview];
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
//    _textField.frame = UIEdgeInsetsInsetRect(self.contentView.bounds, NICellContentPadding());
    UIEdgeInsets contentPadding = NICellContentPadding();
    CGRect contentFrame = UIEdgeInsetsInsetRect(self.contentView.frame, contentPadding);
    
    [_textField sizeToFit];
    CGRect frame = _textField.frame;
    frame.origin.y = floorf((self.contentView.frame.size.height - frame.size.height) / 2);
    frame.origin.x = self.contentView.frame.size.width - frame.size.width - frame.origin.y;
    _textField.frame = frame;
    
    frame = self.textLabel.frame;
    CGFloat leftEdge = 0;
    // Take into account the size of the image view.
    if (nil != self.imageView.image) {
        leftEdge = self.imageView.frame.size.width + kImageViewRightMargin;
    }
    frame.size.width = (self.contentView.frame.size.width
                        - contentFrame.origin.x
                        - _textField.frame.size.width
                        - _textField.frame.origin.y
                        - kTextFieldLeftMargin
                        - leftEdge);
    self.textLabel.frame = frame;

}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
    [super prepareForReuse];
    
    _textField.placeholder = nil;
    _textField.text = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(NITextInputFormElement *)textInputElement {
    if ([super shouldUpdateCellWithObject:textInputElement]) {
        _textField.placeholder = textInputElement.placeholderText;
        _textField.text = textInputElement.value;
        _textField.delegate = textInputElement.delegate;
        _textField.secureTextEntry = textInputElement.isPassword;
        
        _textField.tag = self.tag;
        
        [self setNeedsLayout];
        return YES;
    }
    return NO;
}


@end
