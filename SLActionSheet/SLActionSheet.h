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

- (void)actionSheet:(nonnull SLActionSheet *)sheet clickedAtIndex:(NSInteger )index;

- (void)actionSheetCancel:(nonnull SLActionSheet *)sheet;


@end

@interface SLActionSheet : UIView

@property(nonatomic,weak)id <sheetDelegate> delegate;


- (nullable id)initWithTitle:(nullable NSString *)title delegate:(nullable id<UIActionSheetDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ...; 


- (void)showInView:(nonnull UIView *)view;


@end
