//
//  RWNITextInputFormElement.h
//  Vote
//
//  Created by Ryan Wang on 12-12-29.
//  Copyright (c) 2012年 Ryan Wang. All rights reserved.
//

#import <NimbusModels/NimbusModels.h>
#import "RWNITextInputFormElementCell.h"

@interface RWNITextInputFormElement : NITextInputFormElement

// Designated initializer
+ (id)textInputElementWithID:(NSInteger)elementID title:(NSString *)title placeholderText:(NSString *)placeholderText value:(NSString *)value delegate:(id<UITextFieldDelegate>)delegate required:(BOOL)required;
+ (id)textInputElementWithID:(NSInteger)elementID title:(NSString *)title placeholderText:(NSString *)placeholderText value:(NSString *)value  delegate:(id<UITextFieldDelegate>)delegate;
+ (id)textInputElementWithID:(NSInteger)elementID title:(NSString *)title placeholderText:(NSString *)placeholderText value:(NSString *)value;

+ (id)passwordInputElementWithID:(NSInteger)elementID title:(NSString *)title placeholderText:(NSString *)placeholderText value:(NSString *)value delegate:(id<UITextFieldDelegate>)delegate required:(BOOL)required;
+ (id)passwordInputElementWithID:(NSInteger)elementID title:(NSString *)title placeholderText:(NSString *)placeholderText value:(NSString *)value delegate:(id<UITextFieldDelegate>)delegate;
+ (id)passwordInputElementWithID:(NSInteger)elementID title:(NSString *)title placeholderText:(NSString *)placeholderText value:(NSString *)value;

- (UITableViewCellStyle) cellStyle;

/**
 * @property title is used to place a label on the left side of the textfield
 */
@property (nonatomic, readwrite, copy) NSString *title;

/**
 * @property required used to identify any field that is required.  Processing
 *	the data after submission to verify that data has been entered is left
 *	as an exercise for the user.
 */
@property (nonatomic, readwrite, assign) BOOL required;



@end
