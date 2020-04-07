//
//  OCViewController.h
//  Thread&Series&Async
//
//  Created by Fjzlsc1200 on 2020/4/7.
//  Copyright © 2020 Fjzlsc1200. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCViewController : UIViewController

-(void)testInMainThread;

-(void)testInNotMainThread;
-(void)testAsync;
-(void)testSync;


@end

NS_ASSUME_NONNULL_END
