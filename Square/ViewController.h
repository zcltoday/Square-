//
//  ViewController.h
//  Square
//
//  Created by qianfeng on 13-11-12.
//  Copyright (c) 2013年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSquare.h"


@interface ViewController : UIViewController <SquareMoveToBottom>
{
    BaseSquare *_square;
    BaseSquare *_squareBak;
    NSInteger _time;
    
    CGPoint curPoint;
    CGPoint prePoint;
}
@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) UILabel *labei;
@property (nonatomic, assign) NSInteger num;
@end
