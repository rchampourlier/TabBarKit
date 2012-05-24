
/*!
@project    TabBarKit
@header     TBKTabBarItem.h
@copyright  (c) 2010 - 2011, David Morford
*/

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef NSUInteger TBKTabBarItemStyle;
enum {
	TBKTabBarItemDefaultStyle = 1,
	TBKTabBarItemArrowIndicatorStyle = 2,
  TBKTabBarItemTwiceHeightStyle = 3
};

/*!
@class TBKTabBarItem
@superclass UIButton
@abstract
*/
@interface TBKTabBarItem : UIButton

@property (nonatomic, copy) NSNumber *badgeValue;

#pragma mark Initializers

-(id) initWithImageName:(NSString *)anImageName style:(TBKTabBarItemStyle)aStyle;
-(id) initWithImageName:(NSString *)anImageName style:(TBKTabBarItemStyle)aStyle tag:(NSInteger)aTag;
-(id) initWithImageName:(NSString *)anImageName style:(TBKTabBarItemStyle)aStyle tag:(NSInteger)aTag title:(NSString *)aTitle;

@end

#pragma mark -

/*!
@protocol TBKTabBarItemDataSource <NSObject>
@abstract 
*/
@protocol TBKTabBarItemDataSource <NSObject>

@property (nonatomic, readonly) NSString *tabImageName;
@property (nonatomic, readonly) NSString *tabTitle;

@end
