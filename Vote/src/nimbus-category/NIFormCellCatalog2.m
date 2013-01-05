//
// Copyright 2011 Jeff Verkoeyen
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "NimbusCore.h"
#import "NIFormCellCatalog2.h"
#import <objc/message.h>

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NITextInputFormElement2

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
	NITextInputFormElement2* element = [super textInputElementWithID:elementID 
													 placeholderText:placeholderText 
															   value:value 
															delegate:delegate];
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
	NITextInputFormElement2* element = [self textInputElementWithID:elementID 
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
	return [NITextInputFormElementCell2 class];
}

@end



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NITextInputFormElementCell2

+ (UITableViewCellStyle) cellStyle {
	return UITableViewCellStyleValue2;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	if (self) {
		_maxLabelLength = (NIIsPad() ? 100.0f : 55.0f);
	}
	
	return self;
}

/**
 * Use the built-in structure of UITextField to place a label on the left side and the text content 
 *	on the right.
 */
///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object {
	BOOL shouldUpdate = [super shouldUpdateCellWithObject:object];
	
	if (shouldUpdate) {
		NITextInputFormElement2* textInputElement = (NITextInputFormElement2 *)self.element;
		
		UILabel *label = [[UILabel alloc] init];
		
		NSString *title = textInputElement.title;
		label.text = [title stringByAppendingFormat:@"%@", (textInputElement.required ? @" * " : @" ")];
		
		label.textAlignment = UITextAlignmentLeft;
		[label sizeToFit];
		
		self.textField.leftView = label;
		self.textField.leftViewMode = UITextFieldViewModeAlways;

		self.textField.placeholder = textInputElement.placeholderText;
		self.textField.text = textInputElement.value;
		self.textField.delegate = textInputElement.delegate;
		self.textField.secureTextEntry = textInputElement.isPassword;
		self.textField.textAlignment = NSTextAlignmentRight;
		self.textField.tag = self.tag;
		
		[self setNeedsLayout];
	}
	
	return shouldUpdate;
}


@end


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@implementation NINumberPickerFormElement

@synthesize labelText = _labelText;
@synthesize minValue = _minValue;
@synthesize maxValue = _maxValue;
@synthesize selectedValue = _selectedValue;
@synthesize defaultValue = _defaultValue;
@synthesize didChangeTarget = _didChangeTarget;
@synthesize didChangeSelector = _didChangeSelector;

+ (id)numberPickerElementWithID:(NSInteger)elementID labelText:(NSString *)labelText min:(NSInteger)min max:(NSInteger)max defaultValue:(NSInteger)default0 didChangeTarget:(id)target didChangeSelector:(SEL)selector {
    NINumberPickerFormElement *element = [super elementWithID:elementID];
    element.labelText = labelText;
    element.maxValue = max;
    element.minValue = min;
    element.defaultValue = default0;
    element.didChangeTarget = target;
    element.didChangeSelector = selector;
    
    return element;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)cellClass {
    return [NINumberPickerFormElementCell class];
}

@end
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////

@interface NINumberPickerFormElementCell() <UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, readwrite, NI_STRONG) UITextField* dumbDateField;
@end

@implementation NINumberPickerFormElementCell

@synthesize dumbDateField = _dumbDateField;
@synthesize numberField = _numberField;
@synthesize numberPicker = _numberPicker;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _numberPicker = [[UIPickerView alloc] init];
        _numberPicker.showsSelectionIndicator = YES;
        _numberPicker.delegate = self;
        _numberPicker.dataSource = self;
        _numberField = [[UITextField alloc] init];
        _numberField.backgroundColor = [UIColor redColor];
        _numberField.delegate = self;
        _numberField.font = [UIFont systemFontOfSize:16.0f];
        _numberField.minimumFontSize = 10.0f;
        _numberField.backgroundColor = [UIColor clearColor];
        _numberField.adjustsFontSizeToFitWidth = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < NIIOS_6_0
        _numberField.textAlignment = UITextAlignmentRight;
#else
        _numberField.textAlignment = NSTextAlignmentRight;
#endif
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolbar.tintColor = [UIColor blueColor];
//        UIBarButtonItem *canelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelChanges:)];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(submitChanges:)];
        toolbar.items = [NSArray arrayWithObjects:/*canelItem,*/spaceItem,doneItem, nil];
        _numberField.inputView = _numberPicker;
        _numberField.inputAccessoryView = toolbar;
        [self.contentView addSubview:_numberField];
        
        _dumbDateField = [[UITextField alloc] init];
        _dumbDateField.hidden = YES;
        _dumbDateField.enabled = NO;
        [self.contentView addSubview:_dumbDateField];
    }
    return self;
}

- (void)submitChanges:(id)sender {
    [_numberField endEditing:YES];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets contentPadding = NICellContentPadding();
    CGRect contentFrame = UIEdgeInsetsInsetRect(self.contentView.frame, contentPadding);
    
    [_numberField sizeToFit];
    CGRect frame = _numberField.frame;
    frame.origin.y = floorf((self.contentView.frame.size.height - frame.size.height) / 2);
    frame.origin.x = self.contentView.frame.size.width - frame.size.width - 10;
    _numberField.frame = frame;
    self.dumbDateField.frame = _numberField.frame;
    
    frame = self.textLabel.frame;
    CGFloat leftEdge = 0;
    // Take into account the size of the image view.
    if (nil != self.imageView.image) {
        leftEdge = self.imageView.frame.size.width + 10;
    }
    frame.size.width = (self.contentView.frame.size.width
                        - contentFrame.origin.x
                        - _numberField.frame.size.width
                        - _numberField.frame.origin.y
                        - leftEdge);
    self.textLabel.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.textLabel.text = nil;
    _numberField.text = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(NIDatePickerFormElement *)datePickerElement {
    if ([super shouldUpdateCellWithObject:datePickerElement]) {
        
        self.textLabel.text = datePickerElement.labelText;
        
        NINumberPickerFormElement *elemet = (NINumberPickerFormElement *)self.element;
        NSString *value = [NSString stringWithFormat:@"%d",elemet.defaultValue];
        self.numberField.text = value;
                
        self.dumbDateField.text = self.numberField.text;
        
        _numberField.tag = self.tag;
        _numberPicker.tag = self.tag;
        
        [self setNeedsLayout];
        return YES;
    }
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)selectedNumberDidChange {

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NINumberPickerFormElement *elemet = (NINumberPickerFormElement *)self.element;
    NSInteger count = elemet.maxValue - elemet.minValue;

    return count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NINumberPickerFormElement *elemet = (NINumberPickerFormElement *)self.element;
    return [NSString stringWithFormat:@"%d",elemet.minValue + row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    NINumberPickerFormElement *datePickerElement = (NINumberPickerFormElement *)self.element;

    NSInteger selectedValue = row + datePickerElement.minValue;
    
    self.numberField.text = [NSString stringWithFormat:@"%d",selectedValue];
    
    self.dumbDateField.text = self.numberField.text;
    
    datePickerElement.selectedValue = selectedValue;
    
    if (nil != datePickerElement.didChangeSelector && nil != datePickerElement.didChangeTarget
        && [datePickerElement.didChangeTarget respondsToSelector:datePickerElement.didChangeSelector]) {
        // [datePickerElement.didChangeTarget performSelector:datePickerElement.didChangeSelector withObject:self.datePicker];
        
        // The following is a workaround to supress the warning and requires <objc/message.h>
        objc_msgSend(datePickerElement.didChangeTarget, 
                     datePickerElement.didChangeSelector, _numberPicker);
        
    }

    
}


//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
//    backgroundView.backgroundColor = [UIColor blueColor];
//    
//    return backgroundView;
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.dumbDateField.delegate = self.numberField.delegate;
    self.dumbDateField.font = self.numberField.font;
    self.dumbDateField.minimumFontSize = self.numberField.minimumFontSize;
    self.dumbDateField.backgroundColor = self.numberField.backgroundColor;
    self.dumbDateField.adjustsFontSizeToFitWidth = self.numberField.adjustsFontSizeToFitWidth;
    self.dumbDateField.textAlignment = self.numberField.textAlignment;
    self.dumbDateField.textColor = self.numberField.textColor;
    
    textField.hidden = YES;
    self.dumbDateField.hidden = NO;
    return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.hidden = NO;
    self.dumbDateField.hidden = YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return NO;
}

@end



