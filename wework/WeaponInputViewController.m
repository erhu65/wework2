    //
//  WeaponInputViewController.m
//  MathMonsters
//
//  Created by Ray Wenderlich on 5/3/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "WeaponInputViewController.h"

@implementation WeaponInputViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)blowgunTapped:(id)sender {
    if (_delegate != nil) {
        [_delegate weaponTapped:Blowgun];
    }
}

- (IBAction)fireTapped:(id)sender {
    if (_delegate != nil) {
        [_delegate weaponTapped:Fire];
    }
}

- (IBAction)ninjastarTapped:(id)sender {
    if (_delegate != nil) {
        [_delegate weaponTapped:NinjaStar];
    }
}

- (IBAction)smokeTapped:(id)sender {
    if (_delegate != nil) {
        [_delegate weaponTapped:Smoke];
    }
}

- (IBAction)swordTapped:(id)sender {
    if (_delegate != nil) {
        [_delegate weaponTapped:Sword];
    }
}

- (IBAction)doneTapped:(id)sender {
    if (_delegate != nil) {
        [_delegate doneTapped];
    }
}

@end
