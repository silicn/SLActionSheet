//
//  ViewController.m
//  SLActionSheet
//
//  Created by jiahao on 15/11/2.
//  Copyright © 2015年 silicn. All rights reserved.
//

#import "ViewController.h"

#import "SLActionSheet.h"

#import "UIControl+ClickButton.h"

#import <objc/runtime.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"iphone.jpg"];
    [self.view insertSubview:imageView atIndex:0];
    
    
    
//    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [tempBtn addTarget:self action:@selector(clickWithInterval:) forControlEvents:UIControlEventTouchUpInside];
//    tempBtn.uxy_acceptEventInterval = 2;
//    tempBtn.frame  = CGRectMake(100, 200, 100, 50);
//    tempBtn.backgroundColor = [UIColor redColor];
//  //  tempBtn.uxy_ignoreEvent = YES;
//    [self.view addSubview:tempBtn];
//    
//    NSLog(@"%@",[self getAllProperties:tempBtn]);
//    
//    
//    UIButton *temp2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [temp2Btn addTarget:self action:@selector(clickWithInterval2:) forControlEvents:UIControlEventTouchUpInside];
// //   temp2Btn.uxy_acceptEventInterval = 2;
//    temp2Btn.frame  = CGRectMake(100, 300, 100, 50);
//    temp2Btn.backgroundColor = [UIColor redColor];
//    //  tempBtn.uxy_ignoreEvent = YES;
//    [self.view addSubview:temp2Btn];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSArray *)getAllProperties:(UIButton *)btn
{
    u_int count;   
    objc_property_t *properties  =class_copyPropertyList([btn.superclass class], &count);  
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];   
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];   
    }   
    free(properties);   
    return propertiesArray;  
}  

- (void)clickWithInterval:(UIButton *)btn
{
    NSLog(@"clickWithInterval");
}

- (void)clickWithInterval2:(UIButton *)btn
{
    NSLog(@"clickWithInterval2");
}

- (IBAction)click:(UIButton *)sender {
    SLActionSheet *sheet = [[SLActionSheet alloc]initWithTitle:@"提示" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册",@"其他",nil];
       [sheet showInView:self.view];
//    sheet.destructiveButtonIndex = 1;
//    sheet.cancelColor = [UIColor blueColor];


}


- (IBAction)sheetClick:(UIButton *)sender {
    
//    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"提示" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
//    
//    [sheet showInView:self.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
