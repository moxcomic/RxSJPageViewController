#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SJPageMenuBar.h"
#import "SJPageMenuBarScrollIndicator.h"
#import "SJPageMenuItemView.h"
#import "SJPageMenuItemViewDefines.h"
#import "SJPageViewController.h"
#import "SJPageCollectionView.h"
#import "SJPageViewControllerItemCell.h"
#import "UIScrollView+SJPageViewControllerExtended.h"
#import "UIViewController+SJPageViewControllerExtended.h"

FOUNDATION_EXPORT double SJPageViewControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char SJPageViewControllerVersionString[];

