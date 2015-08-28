//
//  XXBMemoTabViewController.h
//  XXBNews
//
//  Created by xuxubin on 15/8/6.
//  Copyright (c) 2015年 xuxubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBBaseTabViewController.h"
#import "MemoEditDelegate.h"

@interface XXBMemoTabController : XXBBaseTabViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, MemoEditDelegate, NSFetchedResultsControllerDelegate>

@end
