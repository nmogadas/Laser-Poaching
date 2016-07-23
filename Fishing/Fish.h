//
//  Fish.h
//  Fishing
//
//  Created by Neima Mogadas on 7/28/15.
//  Copyright (c) 2015 Neima Mogadas. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Fish:SKSpriteNode
@property BOOL _isFacingRight;
@property BOOL isShaking;
@property int _timeAlive;
@property int _typeOfFish;
@property int _row; // row that fish can swim in
@property int _framesToLive;
@property BOOL _canFishDie;


+(id)initWithImageNamed:(NSString *)name andType:(int) type;
// Creates a fish sprite, type is the color of the fish
// 1 is green, 2 is red, etc

-(void)moveFishRight;

-(void)moveFishLeft;

-(void)growFish;

-(void)shakeFish;

-(void)flashRed;

@end
