#import "TBKTabBarItem.h"
#import "UIImage+TBKMasking.h"
#import "SRDevice.h"

@interface TBKTabBarItemSelectionLayer : CAShapeLayer
-(id) initWithItemFrame:(CGRect)itemFrame style:(TBKTabBarItemStyle)aStyle;
@end

@implementation TBKTabBarItemSelectionLayer

-(id) initWithItemFrame:(CGRect)itemFrame style:(TBKTabBarItemStyle)aStyle {
	self = [super init];
	if (!self) {
		return nil;
	}
	self.needsDisplayOnBoundsChange = YES;
	
	CGRect insetFrame = CGRectZero;
	if (aStyle == TBKTabBarItemArrowIndicatorStyle) {
		insetFrame = CGRectMake(0, 3, itemFrame.size.width, itemFrame.size.height - 3);
	}
	else if (aStyle == TBKTabBarItemDefaultStyle || aStyle == TBKTabBarItemTwiceHeightStyle) {
		insetFrame = CGRectMake(0, 2, itemFrame.size.width, itemFrame.size.height - 6);
	}
	
	self.position = CGPointMake(0,0);
	self.anchorPoint = CGPointMake(0.0, 0.0);
	self.frame = insetFrame;
	
	UIBezierPath *roundedRectPath = nil;
	
	if (aStyle == TBKTabBarItemArrowIndicatorStyle) {
		roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:insetFrame 
												byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) 
													  cornerRadii:CGSizeMake(5.0, 5.0)];
	}
	else if (aStyle == TBKTabBarItemDefaultStyle || aStyle == TBKTabBarItemTwiceHeightStyle) {
		roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:insetFrame 
												byRoundingCorners:(UIRectCornerAllCorners) 
													  cornerRadii:CGSizeMake(5.0, 5.0)];	
	}
	self.path = roundedRectPath.CGPath;
	self.fillColor = [UIColor colorWithWhite:(50.0/100.0) alpha:0.25].CGColor;
	return self;
}

@end

#pragma mark -

@interface TBKBadgeLayer : CAShapeLayer
@property (nonatomic, assign) CATextLayer *countTextLayer;
-(void) setCountString:(NSString *)aString;
@end

@implementation TBKBadgeLayer

@synthesize countTextLayer;

-(id) initWithFrame:(CGRect)rect count:(NSString *)countString {
	self = [super init];
	if (!self) {
		return nil;
	}
	//self.needsDisplayOnBoundsChange = YES;
	self.anchorPoint = CGPointMake(0.0, 0.0);
	self.bounds = CGRectMake(0, 0, 14, 14);
	
	NSLog(@"%@", NSStringFromCGRect(rect));
	
	self.position = CGPointMake(CGRectGetWidth(rect) - 3.0, 3.0);
	NSLog(@"%@", NSStringFromCGPoint(self.position));
	NSLog(@"%@", NSStringFromCGPoint(CGPointMake(20.0 - 3.0, 3.0)));
	
	UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
	self.path = circlePath.CGPath;
	self.fillColor = [UIColor redColor].CGColor;
	//self.borderColor  = [UIColor whiteColor].CGColor;
	//self.borderWidth = 1.0;
	
	self.countTextLayer = [CATextLayer layer];
	self.countTextLayer.position = CGPointMake(0.0, 3.0);
	self.countTextLayer.anchorPoint = CGPointMake(0.0, 0.0);
	self.countTextLayer.bounds = self.bounds;
	
	self.countTextLayer.string = countString;
	self.countTextLayer.fontSize = 12.0;
	self.countTextLayer.alignmentMode = @"center";
	
	[self addSublayer:self.countTextLayer];
	
	return self;
}

-(void) setCountString:(NSString *)aString {
	self.countTextLayer.string = aString;
	[self setNeedsDisplay];
}


-(void) dealloc {
	[super dealloc];
}

@end

#pragma mark -

@interface TBKTabBarItem ()
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) UIImage *tabImage;
@property (nonatomic, retain) UIImage *selectedTabImage;
@property (nonatomic, assign) TBKTabBarItemStyle selectionStyle;

@property (nonatomic, retain) NSString *controllerTitle;
@property (nonatomic, retain) NSString *tabTitle;
@property (nonatomic, assign) BOOL displayTitle;

@property (nonatomic, assign) TBKTabBarItemSelectionLayer *selectionLayer;
@property (nonatomic, assign) TBKBadgeLayer *badgeLayer;
@end

#pragma mark -

@implementation TBKTabBarItem

@synthesize badgeValue;
@synthesize imageName;
@synthesize tabImage;
@synthesize selectedTabImage;
@synthesize selectionStyle;
@synthesize controllerTitle;
@synthesize tabTitle;
@synthesize displayTitle;
@synthesize selectionLayer;
@synthesize badgeLayer;


#pragma mark Initializers

-(id) initWithImageName:(NSString *)anImageName style:(TBKTabBarItemStyle)aStyle {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	self.selectionStyle = aStyle;
	self.backgroundColor = [UIColor clearColor];
	
	// Image
	self.imageName = anImageName;
	self.tabImage = [[UIImage imageNamed:self.imageName] tabBarImage];
	self.selectedTabImage = [[UIImage imageNamed:self.imageName] selectedTabBarImage];
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	[self setImage:self.tabImage forState:UIControlStateNormal];
	[self setImage:self.selectedTabImage forState:UIControlStateSelected];
	
	return self;
}

-(id) initWithImageName:(NSString *)anImageName style:(TBKTabBarItemStyle)aStyle tag:(NSInteger)aTag {
	self = [self initWithImageName:anImageName style:aStyle];
	if (!self) {
		return nil;
	}
	self.tag = aTag;
	return self;
}

-(id) initWithImageName:(NSString *)anImageName style:(TBKTabBarItemStyle)aStyle tag:(NSInteger)aTag title:(NSString *)aTitle {
	self = [self initWithImageName:anImageName style: aStyle tag:aTag];
	if (!self) {
		return nil;
	}
    
	self.controllerTitle = aTitle;
	self.tabTitle = aTitle;
	
	if (self.controllerTitle && self.selectionStyle != TBKTabBarItemArrowIndicatorStyle) {
		self.displayTitle = YES;
		self.titleLabel.textAlignment = UITextAlignmentCenter;
    self.titleLabel.contentMode = UIViewContentModeLeft;
       
    if (self.selectionStyle == TBKTabBarItemDefaultStyle) {
      self.titleLabel.font = [UIFont boldSystemFontOfSize:10.0];
      self.imageEdgeInsets = UIEdgeInsetsMake(0, 14, 10, 14);
      self.titleEdgeInsets = UIEdgeInsetsMake(30, -30, 0, 0);
    }
    else if (self.selectionStyle == TBKTabBarItemTwiceHeightStyle) {
      self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
      self.imageEdgeInsets = UIEdgeInsetsMake(0, 44, 22, 0);
      self.titleEdgeInsets = UIEdgeInsetsMake(60, -64, 0, 0);
    }
    
		[self setTitle:self.controllerTitle forState:UIControlStateNormal];
	}
	return self;
}


#pragma mark UIControl

-(void) setSelected:(BOOL)flag {
	[super setSelected:flag];
	[self.selectionLayer removeFromSuperlayer];
	self.selectionLayer = nil;
	selectionLayer = [[TBKTabBarItemSelectionLayer alloc] initWithItemFrame:self.bounds style:self.selectionStyle];
	if (flag) {
		if (![self.layer.sublayers containsObject:self.selectionLayer]) {
			//[self.layer addSublayer:self.selectionLayer];
      [self.layer insertSublayer:self.selectionLayer atIndex:0];
		}
	}
	else {
		if ([self.layer.sublayers containsObject:self.selectionLayer]) {
			[self.selectionLayer removeFromSuperlayer];
		}
    self.titleLabel.textColor = [UIColor grayColor];
	}
	[self setNeedsDisplay];
}


-(void) setHighlighted:(BOOL)flag {

}

-(void) setBadgeValue:(NSNumber *)aValue {
	if ([badgeValue compare:aValue] != NSOrderedSame) {
		[badgeValue release];
		badgeValue = [aValue copy];
	}
	if (!self.badgeLayer) {
		badgeLayer = [[TBKBadgeLayer alloc] initWithFrame:self.bounds count:[aValue stringValue]];
		[self.layer addSublayer:self.badgeLayer];
	}
	if (self.badgeLayer && [aValue unsignedIntegerValue] == 0) {
		[self.badgeLayer removeFromSuperlayer];
		return;
	}
	else {
		[self.badgeLayer setCountString:[aValue stringValue]];
	}
}



#pragma mark -

-(void) dealloc {
	self.tabTitle = nil;
	self.controllerTitle = nil;
	self.badgeValue = nil;
	self.imageName = nil;
	self.tabImage = nil;
	self.selectedTabImage = nil;
	[super dealloc];
}

@end
