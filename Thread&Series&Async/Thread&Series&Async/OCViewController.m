//
//  OCViewController.m
//  Thread&Series
//
//  Created by Fjzlsc1200 on 2020/4/1.
//  Copyright © 2020 Fjzlsc1200. All rights reserved.
//

#import "OCViewController.h"

@interface OCViewController ()

@end

@implementation OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//主线程下，是否开启新线程
-(void)testInMainThread{
    //主队列
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"主队列异步%@",[NSThread currentThread]);
    });
//    //主队列同步会导致死锁
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"%@",[NSThread currentThread]);
//    });
    
    //串行队列
    dispatch_queue_t ser_queue = dispatch_queue_create("串行", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(ser_queue, ^{
        sleep(1);
        NSLog(@"串行队列主线程同步0-%@",[NSThread currentThread]);
    });
    
    dispatch_async(ser_queue, ^{
        sleep(1);
        NSLog(@"串行队列主线程异步1-%@",[NSThread currentThread]);
    });
    
    dispatch_async(ser_queue, ^{
        sleep(1);
        NSLog(@"串行队列主线程异步2-%@",[NSThread currentThread]);
    });
    
    dispatch_sync(ser_queue, ^{
        sleep(1);
        NSLog(@"串行队列主线程同步3-%@",[NSThread currentThread]);
    });
    
    //并行队列
    dispatch_queue_t con_queue = dispatch_queue_create("并行", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(con_queue, ^{
        sleep(1);
        NSLog(@"并行队列主线程同步0-%@",[NSThread currentThread]);
    });
    
    dispatch_async(con_queue, ^{
        sleep(1);
        NSLog(@"并行队列主线程异步1-%@",[NSThread currentThread]);
    });
    
    dispatch_async(con_queue, ^{
        sleep(1);
        NSLog(@"并行队列主线程异步2-%@",[NSThread currentThread]);
    });
    
    dispatch_sync(con_queue, ^{
        sleep(1);
        NSLog(@"并行队列主线程同步3-%@",[NSThread currentThread]);
    });
}

// 非主线程下，异步是否新开线程
-(void)testInNotMainThread{
    [self performSelectorInBackground:@selector(testAsync) withObject:nil];
//    sleep(1);
//    NSLog(@"========================以下都是同步任务===============================");
//    [self performSelectorInBackground:@selector(testSync) withObject:nil];
}
-(void)testAsync{
    
    dispatch_queue_t ser_queue = dispatch_queue_create("串行", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t con_queue = dispatch_queue_create("并行", DISPATCH_QUEUE_CONCURRENT);

    

    NSLog(@"当前线程-%@",[NSThread currentThread]);
    dispatch_async(ser_queue, ^{
        NSLog(@"非主线程串行队列异步1-%@",[NSThread currentThread]);
        dispatch_async(ser_queue, ^{
            NSLog(@"非主线程串行队列异步4-%@",[NSThread currentThread]);
        });
        dispatch_async(ser_queue, ^{
            NSLog(@"非主线程串行队列异步5-%@",[NSThread currentThread]);
        });
        dispatch_async(ser_queue, ^{
            NSLog(@"非主线程串行队列异步6-%@",[NSThread currentThread]);
        });
    });
    dispatch_async(ser_queue, ^{
        NSLog(@"非主线程串行队列异步2-%@",[NSThread currentThread]);
    });
    dispatch_async(ser_queue, ^{
        NSLog(@"非主线程串行队列异步3-%@",[NSThread currentThread]);
    });


    sleep(1);
    NSLog(@"当前线程-%@",[NSThread currentThread]);
    dispatch_async(con_queue, ^{
        NSLog(@"非主线程并行队列异步1-%@",[NSThread currentThread]);
    });
    dispatch_async(con_queue, ^{
        NSLog(@"非主线程并行队列异步2-%@",[NSThread currentThread]);
    });
    dispatch_async(con_queue, ^{
        NSLog(@"非主线程并行队列异步3-%@",[NSThread currentThread]);
    });

    sleep(1);

    NSLog(@"当前线程-%@",[NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"非主线程但是主队列异步1.1-%@",[NSThread currentThread]);
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"非主线程但是主队列异步2.1-%@",[NSThread currentThread]);
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"非主线程但是主队列异步3.1-%@",[NSThread currentThread]);
    });


    sleep(1);
    NSLog(@"当前线程-%@",[NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"非主线程但是主队列异步1.2-%@",[NSThread currentThread]);
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"非主线程但是主队列异步2.2-%@",[NSThread currentThread]);
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"非主线程但是主队列异步3.2-%@",[NSThread currentThread]);
    });

}

//非主线程下，同步是否新开线程
-(void)testSync{
    
    dispatch_queue_t ser_queue = dispatch_queue_create("串行", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t con_queue = dispatch_queue_create("并行", DISPATCH_QUEUE_CONCURRENT);
    
//    dispatch_async(ser_queue, ^{
//        NSLog(@"当前线程-%@",[NSThread currentThread]);
//        //队列两个任务互相等待A等B执行完，B等A释放资源才去执行
//        //所以死锁是跟队列有关，跟线程无关
//        dispatch_sync(ser_queue, ^{
//            NSLog(@"非主线程串行队列同步1-%@",[NSThread currentThread]);
//        });
//        dispatch_sync(ser_queue, ^{
//            NSLog(@"非主线程串行队列同步2-%@",[NSThread currentThread]);
//        });
//        dispatch_sync(ser_queue, ^{
//            NSLog(@"非主线程串行队列同步3-%@",[NSThread currentThread]);
//        });
//    });
    
    dispatch_async(ser_queue, ^{
        NSLog(@"当前线程-%@",[NSThread currentThread]);
        //注意：此处并发队列，并没有创建新线程
        dispatch_sync(con_queue, ^{
            NSLog(@"非主线程并发队列同步1-%@",[NSThread currentThread]);
        });
        dispatch_sync(con_queue, ^{
            NSLog(@"非主线程并发队列同步2-%@",[NSThread currentThread]);
        });
        dispatch_sync(con_queue, ^{
            NSLog(@"非主线程并发队列同步3-%@",[NSThread currentThread]);
        });
    });
    
    sleep(1);

    dispatch_async(con_queue, ^{
        NSLog(@"当前线层-%@",[NSThread currentThread]);
        //注意线程依旧是同一个线程，但是因为所处队列不同，所以永远不同不会队列资源竞争与死锁现象
        dispatch_sync(con_queue, ^{
            NSLog(@"非主线程并发队列同步1-%@",[NSThread currentThread]);
        });
        dispatch_sync(con_queue, ^{
            NSLog(@"非主线程并发队列同步2-%@",[NSThread currentThread]);
        });
        dispatch_sync(con_queue, ^{
            NSLog(@"非主线程并发队列同步3-%@",[NSThread currentThread]);
        });
    });

    sleep(1);
    dispatch_async(con_queue, ^{
        NSLog(@"当前线程-%@",[NSThread currentThread]);
        dispatch_sync(ser_queue, ^{
            NSLog(@"非主线程串行队列同步1-%@",[NSThread currentThread]);
        });
        dispatch_sync(ser_queue, ^{
            NSLog(@"非主线程串行队列同步2-%@",[NSThread currentThread]);
        });
        dispatch_sync(ser_queue, ^{
            NSLog(@"非主线程串行队列同步3-%@",[NSThread currentThread]);
        });
    });
    
    sleep(1);

    dispatch_async(ser_queue, ^{
        NSLog(@"当前线程-%@",[NSThread currentThread]);
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"非主线程但是主队列同步1.1-%@",[NSThread currentThread]);
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"非主线程但是主队列同步2.1-%@",[NSThread currentThread]);
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"非主线程但是主队列同步3.1-%@",[NSThread currentThread]);
        });
    });

    dispatch_async(con_queue, ^{
        NSLog(@"当前线程-%@",[NSThread currentThread]);
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"非主线程但是主队列同步1.2-%@",[NSThread currentThread]);
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"非主线程但是主队列同步2.2-%@",[NSThread currentThread]);
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"非主线程但是主队列同步3.2-%@",[NSThread currentThread]);
        });
    });
}

@end
