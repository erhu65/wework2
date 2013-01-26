//
//  WeaponSelector.m
//  MathMonsters
//
//  Created by Ray Wenderlich on 5/3/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "WeaponSelector.h"

@implementation WeaponSelector

- (void)setWeapon:(Weapon)weapon {
    _weapon = _weapon;
    switch (weapon) {
        case Blowgun:
            self.image = [UIImage imageNamed:@"blowgun.png"];
            break;
        case Fire:
            self.image = [UIImage imageNamed:@"fire.png"];
            break;
        case NinjaStar:
            self.image = [UIImage imageNamed:@"ninjastar.png"];
            break;
        case Smoke:
            self.image = [UIImage imageNamed:@"smoke.png"];
            break;
        case Sword:
            self.image = [UIImage imageNamed:@"sword.png"];
            break;            
        default:
            break;
    }
}

- (UIView *)inputView {
    if (_weaponInputView == nil) {
        self.weaponInputView = [[WeaponInputViewController alloc] initWithNibName:@"WeaponInputViewController" bundle:[NSBundle mainBundle]];
        _weaponInputView.delegate = self;
    }
    return _weaponInputView.view;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self becomeFirstResponder];
}

- (void)weaponTapped:(Weapon)weapon {
    self.weapon = weapon;
    [self resignFirstResponder];
    [_delegate weaponChanged:weapon];
}

- (void)doneTapped {
    [self resignFirstResponder];
}


@end
