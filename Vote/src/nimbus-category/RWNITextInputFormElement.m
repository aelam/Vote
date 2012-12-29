//
//  RWNITextInputFormElement.m
//  Vote
//
//  Created by Ryan Wang on 12-12-29.
//  Copyright (c) 2012年 Ryan Wang. All rights reserved.
//

#import "RWNITextInputFormElement.h"

@implementation RWNITextInputFormElement


@synthesize title			= _title;
@synthesize required		= _required;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCellStyle) cellStyle {
	return UITableViewCellStyleValue2;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)textInputElementWithID:(NSInteger)elementID
					   title:(NSString *)title
			 placeholderText:(NSString *)placeholderText
					   value:(NSString *)value
					delegate:(id<UITextFieldDelegate>)delegate
					required:(BOOL)required {
	//
	RWNITextInputFormElement* element = [super textInputElementWithID:elementID placeholderText:placeholderText value:value delegate:delegate];
	element.title = title;
	element.required = required;
	
	return element;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)textInputElementWithID:(NSInteger)elementID
					   title:(NSString *)title
			 placeholderText:(NSString *)placeholderText
					   value:(NSString *)value
					delegate:(id<UITextFieldDelegate>)delegate {
	//
	return [self textInputElementWithID:elementID
								  title:title
						placeholderText:placeholderText
								  value:value
							   delegate:delegate
							   required:NO];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)textInputElementWithID:(NSInteger)elementID
					   title:(NSString *)title
			 placeholderText:(NSString *)placeholderText
					   value:(NSString *)value {
	//
	return [self textInputElementWithID:elementID
								  title:title
						placeholderText:placeholderText
								  value:value
							   delegate:nil
							   required:NO];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)passwordInputElementWithID:(NSInteger)elementID
						   title:(NSString *)title
				 placeholderText:(NSString *)placeholderText
						   value:(NSString *)value
						delegate:(id<UITextFieldDelegate>)delegate
						required:(BOOL)required {
	//
	RWNITextInputFormElement* element = [self textInputElementWithID:elementID
                                                               title:title
                                                     placeholderText:placeholderText
                                                               value:value
                                                            delegate:delegate
                                                            required:required];
	element.isPassword = YES;
	
	return element;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)passwordInputElementWithID:(NSInteger)elementID
						   title:(NSString *)title
				 placeholderText:(NSString *)placeholderText
						   value:(NSString *)value
						delegate:(id<UITextFieldDelegate>)delegate {
	//
	return [self passwordInputElementWithID:elementID
									  title:title
							placeholderText:placeholderText
									  value:value
								   delegate:delegate
								   required:NO];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)passwordInputElementWithID:(NSInteger)elementID
						   title:(NSString *)title
				 placeholderText:(NSString *)placeholderText
						   value:(NSString *)value {
	//
	return [self passwordInputElementWithID:elementID
									  title:title
							placeholderText:placeholderText
									  value:value
								   delegate:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass {
    return [RWNITextInputFormElementCell class];
}



@end
