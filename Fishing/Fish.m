//
//  Fish.m
//  Fishing
//
//  Created by Neima Mogadas on 7/28/15.
//  Copyright (c) 2015 Neima Mogadas. All rights reserved.
//

#import "Fish.h"

static int const STEP_SIZE_R = 8;
static int const STEP_SIZE_G = 4;
static int const STEP_SIZE_O = 12;


@implementation Fish
+(id)initWithImageNamed:(NSString *)name andType:(int)type {
 
    Fish *fish = [Fish spriteNodeWithImageNamed:name];
    fish._isFacingRight = TRUE;
    fish._timeAlive = 0;
    fish._typeOfFish = type;
    fish._framesToLive = 60;
    fish._canFishDie = YES;
    return fish;
    
}

-(void)moveFishRight {
    
    switch (self._typeOfFish) {
        case 1:
            self.position = CGPointMake(self.position.x + STEP_SIZE_G, self.position.y);
            break;
        case 2:
            self.position = CGPointMake(self.position.x + STEP_SIZE_R, self.position.y);
            break;
        case 3:
            self.position = CGPointMake(self.position.x + STEP_SIZE_O, self.position.y);
            break;
            
        default:
            break;
    }
    
    
}

-(void)moveFishLeft {
    
    switch (self._typeOfFish) {
        case 1:
            self.position = CGPointMake(self.position.x - STEP_SIZE_G, self.position.y);
            break;
        case 2:
            self.position = CGPointMake(self.position.x - STEP_SIZE_R, self.position.y);
            break;
        case 3:
            self.position = CGPointMake(self.position.x - STEP_SIZE_O, self.position.y);
            break;
            
        default:
            break;
    }
    
    
}

-(void)growFish {
    
    switch (self._typeOfFish) {
        case 1:
            if (self.xScale < 1 && self.yScale < 1) {
                self.xScale = self.xScale + 0.005 * self.xScale;
                self.yScale = self.yScale + 0.005 * self.yScale;}
            break;
        case 2:
            if (self.xScale < 1 && self.yScale < 1) {
                self.xScale = self.xScale + 0.01 * self.xScale;
                self.yScale = self.yScale + 0.01 * self.yScale;}
        case 3:
            if (self.xScale < 1 && self.yScale < 1) {
                self.xScale = self.xScale + 0.015 * self.xScale;
                self.yScale = self.yScale + 0.015 * self.yScale;}
            
        default:
            break;
    }
    
}

-(void)shakeFish {
    SKAction *rotateToStartPosition = [SKAction rotateByAngle: -M_PI/4 duration: 0.01];
    SKAction *rotate = [SKAction rotateByAngle:M_PI/2 duration: 0.16];
    SKAction *rotateBack = [SKAction rotateByAngle: -M_PI/2  duration: 0.16];
    SKAction *shakeSequence = [SKAction sequence:@[rotate, rotateBack]];
    
    
    [self runAction:rotateToStartPosition];
    
    [self runAction:[SKAction repeatActionForever:shakeSequence]];
    
   // SKAction *fadeOut = [SKAction fadeOutWithDuration:1];
   // SKAction *remove = [SKAction removeFromParent];
    
}

-(void)flashRed {
    
    self.color = [SKColor redColor];
    self.colorBlendFactor = 1;
    
    SKAction *pulseRed = [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:0 duration:.2];
    [self runAction: pulseRed];
}

@end




































