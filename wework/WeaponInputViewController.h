//
//  WeaponInputViewController.h
//  MathMonsters
//
//  Created by Ray Wenderlich on 5/3/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//



typedef enum {
    Blowgun = 0,
    NinjaStar,
    Fire,
    Sword,
    Smoke,
} Weapon;

@protocol WeaponInputControllerDelegate
- (void)weaponTapped:(Weapon)weapon;
- (void)doneTapped;
@end

@interface WeaponInputViewController : UIViewController {
   
}

@property (nonatomic, weak) id<WeaponInputControllerDelegate> delegate;

- (IBAction)blowgunTapped:(id)sender;
- (IBAction)fireTapped:(id)sender;
- (IBAction)ninjastarTapped:(id)sender;
- (IBAction)smokeTapped:(id)sender;
- (IBAction)swordTapped:(id)sender;
- (IBAction)doneTapped:(id)sender;

@end
