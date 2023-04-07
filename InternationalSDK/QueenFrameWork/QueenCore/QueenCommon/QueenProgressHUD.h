#import <UIKit/UIKit.h>
typedef enum {
    QueenProgressHUDModeIndeterminate,
	QueenProgressHUDModeDeterminate,
	QueenProgressHUDModeCustomView
} QueenProgressHUDMode;
typedef enum {
    QueenProgressHUDAnimationFade,
    QueenProgressHUDAnimationZoom
} QueenProgressHUDAnimation;
@class QueenProgressHUD;
@protocol QueenProgressHUDDelegate <NSObject>
@required
- (void)hudWasHidden:(QueenProgressHUD *)hud;
@end
@interface MBRoundProgressView : UIProgressView {}
- (id)initWithDefaultSize;
@end
@interface QueenProgressHUD : UIView {
	QueenProgressHUDMode mode;
    QueenProgressHUDAnimation animationType;
	SEL methodForExecution;
	id targetForExecution;
	id objectForExecution;
	BOOL useAnimation;
    float yOffset;
    float xOffset;
	float width;
	float height;
	BOOL taskInProgress;
	float graceTime;
	float minShowTime;
	NSTimer *graceTimer;
	NSTimer *minShowTimer;
	NSDate *showStarted;
	UIView *indicator;
	UILabel *label;
	UILabel *detailsLabel;
	float progress;
	NSString *labelText;
	NSString *detailsLabelText;
	float opacity;
	UIFont *labelFont;
	UIFont *detailsLabelFont;
    BOOL isFinished;
	BOOL removeFromSuperViewOnHide;
	UIView *customView;
	CGAffineTransform rotationTransform;
}
+ (QueenProgressHUD *)QueenShowHUDAddedTo:(UIView *)view animated:(BOOL)animated;
+ (BOOL)JPBaoFu_HideHUDForView:(UIView *)view animated:(BOOL)animated;
- (id)initWithWindow:(UIWindow *)window;
- (id)initWithView:(UIView *)view;
@property (retain) UIView *customView;
@property (assign) QueenProgressHUDMode mode;
@property (assign) QueenProgressHUDAnimation animationType;
@property (assign) id<QueenProgressHUDDelegate> delegate;
@property (copy) NSString *labelText;
@property (copy) NSString *detailsLabelText;
@property (assign) float opacity;
@property (assign) float xOffset;
@property (assign) float yOffset;
@property (assign) float graceTime;
@property (assign) float minShowTime;
@property (assign) BOOL taskInProgress;
@property (assign) BOOL removeFromSuperViewOnHide;
@property (retain) UIFont* labelFont;
@property (retain) UIFont* detailsLabelFont;
@property (assign) float progress;
- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated;
@end
