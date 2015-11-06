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
            UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            visualEffectView.alpha = 0.5;
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
        
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0];
        if (delegate) {
            self.delegate = delegate;
        }
        if (title) {
            _title = title;
            self.tableView.tableHeaderView = self.headView;
            self.headView.text = title;
        }
        if (destructiveButtonTitle) {
            [self.dataSource addObject:destructiveButtonTitle];
        }
        va_list arguments;
        id eachObject;
        if (otherButtonTitles) {
            NSLog(@"otherButtonTitles = %@",otherButtonTitles);
            [self.dataSource addObject:otherButtonTitles];
            va_start(arguments, otherButtonTitles);
            
            while ((eachObject = va_arg(arguments, id))) {
                [self.dataSource addObject:eachObject];
                NSLog(@"eachObject = %@",eachObject);
            }
            va_end(arguments);
        }
        
        if (cancelButtonTitle) {
            _cancelTitle = cancelButtonTitle;
            [self.dataSource addObject:cancelButtonTitle];
        }
        [self addSubview:self.tableView];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView reloadData];
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
        return 0.001f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataSource.count - 1;
    }else{
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor redColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor redColor];
    return view;
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
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
    }
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:18.0];    
    if (indexPath.section == 0) {
       cell.textLabel.text = self.dataSource[indexPath.row]; 
    }else{
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

- (void)showInView:(nonnull UIView *)view
{
    [[UIApplication  sharedApplication].keyWindow addSubview:self];
    if (_tableView) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.25];
            CGRect frame = _tableView.frame;
            NSLog(@"%f   %f ",_tableView.contentSize.height,frame.origin.y);
            
            
            frame.origin.y = frame.origin.y - _tableView.contentSize.height;
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
        _headView.text = _title;
    }

    return _headView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 20) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor cyanColor];
        _tableView.scrollEnabled = NO;
        _tableView.scrollsToTop = NO;
        _tableView.rowHeight = 44.0f;
//        [self addSubview:_tableView];
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
