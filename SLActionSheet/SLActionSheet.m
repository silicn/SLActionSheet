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


@end

static SLActionSheet *actionsheet = nil;

@implementation SLActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = [NSMutableArray arrayWithCapacity:1];
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.alpha = 0.5;
        visualEffectView.frame = frame;
        [self addSubview:visualEffectView];
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
            [self.dataSource addObject:title];
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
        return 6.0f;
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
    view.backgroundColor = [UIColor clearColor];
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
        cell.separatorInset = UIEdgeInsetsMake(0, -50, 0, 0);
    }
    
    if (_title && indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    
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
    if (_title) {
        if (indexPath.row == 0 && indexPath.section == 0) {
            return;
        }
    }
    
    if (indexPath.section == 1  && _cancelTitle) {
        [self removeSelfAnimate];
        return;
    }
   
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedAtIndex:)]) {
       
        [self.delegate actionSheet:self clickedAtIndex:indexPath.row];
    }
     NSLog(@"%ld",(long)indexPath.row);
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
    [view addSubview:self];
    if (_tableView) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.25];
            CGRect frame = _tableView.frame;
            frame.origin.y = view.bounds.size.height - _tableView.contentSize.height;
            frame.size.height = _tableView.contentSize.height;
            _tableView.frame = frame;
        } completion:^(BOOL finished) {
        }];
    }
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 100, [UIScreen mainScreen].bounds.size.width, 100) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
        _tableView.scrollsToTop = NO;
        [self addSubview:_tableView];
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
