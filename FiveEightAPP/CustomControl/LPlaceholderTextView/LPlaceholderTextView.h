//
//  LPlaceholderTextView.h
//  TuYouAPP
//
//  Created by caochun on 14/12/22.
//
//
#import <UIKit/UIKit.h>

@interface LPlaceholderTextView : UITextView
{
    UILabel *_placeholderLabel;
}


@property (strong, nonatomic) NSString *placeholderText;
@property (strong, nonatomic) UIColor *placeholderColor;


@end