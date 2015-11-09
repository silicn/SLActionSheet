//
//  SLActionSheet.m
//  SLActionSheet
//
//  Created by jiahao on 15/11/2.
//  Copyright © 2015年 silicn. All rights reserved.
//

#import "SLActionSheet.h"



@interface SLActionSheet ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *_title;
    NSString *_cancelTitle;
    
    UIColor  *_cancelColor;
    
}

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, strong)UILabel *headView;


@end

static SLActionSheet *actionsheet = nil;

@implementation SLActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = [NSMutableArray arrayWithCapacity:1];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
#warning this will cause the effect to appear broken until opacity returns to 1.
            visualEffectView.alpha = 0.4;
            
            visualEffectView.frame = frame;
            [self addSubview:visualEffectView];
        }
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.dataSource = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}


- (id)initWithTitle:(nullable NSString *)title delegate:(nullable id<sheetDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ...
{
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.25];
        
        self.destructiveButtonIndex = -1;
        if (delegate) {
            self.delegate = delegate;
        }
        if (destructiveButtonTitle) {
            [self.dataSource addObject:destructiveButtonTitle];
        }
        va_list arguments;
        id eachObject;
        if (otherButtonTitles) {
            [self.dataSource addObject:otherButtonTitles];
            va_start(arguments, otherButtonTitles);
            while ((eachObject = va_arg(arguments, id))) {
                [self.dataSource addObject:eachObject];
            }
            va_end(arguments);
        }
        
        if (cancelButtonTitle) {
            _cancelTitle = cancelButtonTitle;
            [self.dataSource addObject:cancelButtonTitle];
        }
        
        
        [self addSubview:self.tableView];
        
        if (title) {
            _title = title;
            self.tableView.tableHeaderView = self.headView;
            self.headView.text = title;
        }

        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_cancelTitle) {
        return 2;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001f;
    }else{
        return 6.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_cancelTitle) {
            return self.dataSource.count - 1;
        }else{
            return self.dataSource.count;
        }
        
    }else{
        return 1;
    }
}


-(void)layoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"SLActionSheet";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:18.0];  
    }
    
    if (_destructiveButtonIndex == indexPath.row) {
        cell.textLabel.textColor  = [UIColor redColor];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    if (indexPath.section == 0) {
       cell.textLabel.text = self.dataSource[indexPath.row]; 
    }else{
        if (_cancelColor) {
            cell.textLabel.textColor = _cancelColor;
        }else{
            cell.textLabel.textColor = [UIColor redColor];
        }
        cell.textLabel.text = [self.dataSource lastObject];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1  && _cancelTitle) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheetCancel:)]) {
            [self.delegate actionSheetCancel:self];
        }
        [self removeSelfAnimate];
        return;
    }
   
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedAtIndex:)]) {
        [self.delegate actionSheet:self clickedAtIndex:indexPath.row];
    }
    [self removeSelfAnimate];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self removeSelfAnimate];
}

- (void)removeSelfAnimate
{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect frame = _tableView.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        _tableView.frame = frame;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showInView:(nonnull UIView *)superView
{
    [superView.window addSubview:self];
    if (_tableView) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.25];
            CGRect frame = _tableView.frame;
            NSLog(@"%f   %f ",_tableView.contentSize.height,frame.origin.y);
            frame.origin.y = frame.origin.y - _tableView.contentSize.height + (_title == nil ? 0:20);
            frame.size.height = _tableView.contentSize.height;
            _tableView.frame = frame;
        } completion:NULL];
    }
}


- (UILabel *)headView
{
    if (_headView == nil) {
        _headView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.font = [UIFont systemFontOfSize:13.0];
        _headView.textColor = [UIColor lightGrayColor];
        _headView.textAlignment = NSTextAlignmentCenter;
    }

    return _headView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 10) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
        _tableView.scrollsToTop = NO;
    }
    return _tableView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
