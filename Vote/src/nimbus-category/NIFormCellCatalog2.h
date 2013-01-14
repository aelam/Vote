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

#import "NITableViewModel.h"
#import "NIFormCellCatalog.h"

#pragma mark Form Elements

/**
 * A single element of a form with an ID property.
 *
 * Each form element has, at the very least, an element ID property which can be used to
 * differentiate the form elements when change notifications are received. Each element cell
 * will assign the element ID to the tag property of its views.
 *
 *      @ingroup TableCellCatalog
 */

/**
 * Created by Gregory Hill on 03/15/2012
 *
 * A text input form element with a label on the left.
 *
 * This element is similar to HTML's <input type="text">. It presents a simple text field
 * control with optional placeholder text. You can assign a delegate to this object that will
 * be assigned to the text field, allowing you to receive text field delegate notifications.
 *
 * The next step is to create text fields that can accept specific input (text, numeric)
 *
 * Bound to NITextInputFormElementCell2 when using the @link TableCellFactory Nimbus cell factory@endlink.
 *
 *      @ingroup TableCellCatalog
 */
@interface NITextInputFormElement2 : NITextInputFormElement

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


@property (nonatomic,retain) UIImage *image;

/**
 * @property required used to identify any field that is required.  Processing
 *	the data after submission to verify that data has been entered is left
 *	as an exercise for the user.
 */
@property (nonatomic, readwrite, assign) BOOL required;

@end

#pragma mark -
#pragma mark Form Element Cells


/**
 * The cell sibling to NITextInputFormElement2.
 *
 * Displays two fields: a readonly title, and a text field for editing.
 *
 * @image html NITextInputCellExample1.png "Example of a NITextInputFormElementCell."
 *
 *      @ingroup TableCellCatalog
 */
@interface NITextInputFormElementCell2 : NITextInputFormElementCell <UITextFieldDelegate> {
@private
	CGFloat			_maxLabelLength;
}

@property (nonatomic,retain) UIImageView *leftImageView;

+ (UITableViewCellStyle) cellStyle;
@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * A date picker form element.
 *
 * This element shows a date that can be modified.
 *
 * You can initialize it with a labelText showing on the left in the table cell, a date that will
 * be used to initialize the date picker and a delegate target and method that gets called when a
 * different date is selected.
 *
 * To change the date picker format you can access the datePicker property of the
 * NIDatePickerFormElementCell sibling object.
 *
 *      @ingroup TableCellCatalog
 */
@interface NINumberPickerFormElement : NIFormElement

+ (id)numberPickerElementWithID:(NSInteger)elementID labelText:(NSString *)labelText min:(NSInteger)min max:(NSInteger)max defaultValue:(NSInteger)default0 didChangeTarget:(id)target didChangeSelector:(SEL)selector;

@property (nonatomic, copy) NSString *labelText;
@property (nonatomic,assign) NSInteger minValue;
@property (nonatomic,assign) NSInteger maxValue;
@property (nonatomic,assign) NSInteger defaultValue;
@property (nonatomic,retain) UIImage *image;

@property (nonatomic,assign) NSInteger value;

@property (nonatomic, NI_WEAK) id didChangeTarget;
@property (nonatomic, assign) SEL didChangeSelector;

@end


/**
 * The cell sibling to NIDatePickerFormElement
 *
 * Displays a left-aligned label and a right-aligned date.
 *
 *      @ingroup TableCellCatalog
 */
@interface NINumberPickerFormElementCell : NIFormElementCell <UITextFieldDelegate>
@property (nonatomic, readonly, NI_STRONG) UITextField *numberField;
@property (nonatomic, readonly, NI_STRONG) UIPickerView *numberPicker;
@end


