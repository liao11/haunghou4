//
//  QueenCHIDeleteView.h
//  QueenFrameWork
//
//  Created by Admin on 2022/11/29.
//  Copyright © 2022 muu. All rights reserved.
//

#import <UIKit/UIKit.h>





@protocol Queen_HIDeleteViewDelegate <NSObject>
- (void)JPBaoFu_DeteleVeiwClickReturnEvent;
- (void)JPBaoFu_DeteleViewClickRegisterEvent:(NSString *)account password:(NSString *)password;
- (void)JPBaoFu_signUpViewClickDetailProtocolInfo;
@end
@interface QueenCHIDeleteView : UIView
@property (nonatomic, weak) id<Queen_HIDeleteViewDelegate> delegate;
+ (instancetype)QueenShowDeteleViewInContext:(UIView *)context;
- (void)Queen_refreshMainView;
@end
