//
//  WeaponSelector.h
//  MathMonsters
//
//  Created by Ray Wenderlich on 5/3/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeaponInputViewController.h"


@protocol WeaponSelectorDelegate
- (void)weaponChanged:(Weapon)weapon;
@end

@interface WeaponSelector : UIImageView <WeaponInputControllerDelegate> {


}

@property (nonatomic, strong) WeaponInputViewController *weaponInputView;
@property (nonatomic, assign) Weapon weapon;
@property (nonatomic, weak) IBOutlet id<WeaponSelectorDelegate> delegate;

- (UIView *)inputView;

@end
