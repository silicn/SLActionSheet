//
//  SLActionSheet.h
//  SLActionSheet
//
//  Created by jiahao on 15/11/2.
//  Copyright © 2015年 silicn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLActionSheet;

@protocol sheetDelegate <NSObject>

- (void)actionSheet:(nonnull SLActionSheet *)sheet clickedAtIndex:(NSInteger)index;

- (void)actionSheetCancel:(nonnull SLActionSheet *)sheet;


@end

@interface SLActionSheet : UIView

@property(nonatomic,weak,nullable) id <sheetDelegate>   delegate;

// sets destructive (red) button. -1 means none set. default is -1. ignored if only one button

@property(nonatomic)NSInteger destructiveButtonIndex;     
@property(nonatomic, strong) UIColor * _Nullable cancelColor;

- (nullable id)initWithTitle:(nullable NSString *)title delegate:(nullable id<UIActionSheetDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION; 
 
- (void)showInView:(nonnull UIView *)superView;


@end
