

#import "CHTRoleOfInforView.h"

@interface CHTRoleOfInforView ()

@property (weak, nonatomic) IBOutlet UITextField *roleName;
@property (weak, nonatomic) IBOutlet UITextField *roleId;
@property (weak, nonatomic) IBOutlet UITextField *roleLevel;
@property (weak, nonatomic) IBOutlet UIButton *confirm;
@end

@implementation CHTRoleOfInforView

- (void)setup {
    self.confirm.enabled = NO;
    self.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
    [self.confirm setBackgroundColor:[UIColor lightGrayColor]];
    [self.roleName addTarget:self action:@selector(textFieldChange:) forControlEvents:(UIControlEventEditingChanged)];
    [self.roleId addTarget:self action:@selector(textFieldChange:) forControlEvents:(UIControlEventEditingChanged)];
    [self.roleLevel addTarget:self action:@selector(textFieldChange:) forControlEvents:(UIControlEventEditingChanged)];
}
- (void)textFieldChange:(UITextField *)textField{
    
    if (self.roleName.text.length > 0 && self.roleId.text.length > 0 && self.roleLevel.text.length > 0) {
        [self.confirm setBackgroundColor:[UIColor orangeColor]];
        self.confirm.enabled = YES;
    }else{
        [self.confirm setBackgroundColor:[UIColor lightGrayColor]];
        self.confirm.enabled = NO;
    }
}

- (IBAction)comfirmOperation:(UIButton *)sender {
   
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.callInfo) {
            self.callInfo(@{
                            @"CP_RoleName" : self.roleName.text,
                            @"CP_RoleID" : self.roleId.text,
                            @"CP_RoleLevel":self.roleLevel.text
                            });
        }
    }];
}

@end
