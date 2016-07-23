//
//  MenuScene.m
//  Fishing
//
//  Created by Neima Mogadas on 7/31/15.
//  Copyright (c) 2015 Neima Mogadas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuScene.h"
#import "GameScene.h"

//****************************************** THIS METHOD IS THE SAME AS THE ONE IN GAMEVIEWCONTROLLER.M
@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation MenuScene
{
    SKSpriteNode *rateButton;
    SKSpriteNode *settingsButton;
    SKSpriteNode *unlockablesButton;
    SKSpriteNode *leaderboardsButton;
    SKNode *touchedNode;
    SKSpriteNode *tapToBegin;
    int frameCount;
    
    SKSpriteNode *settings;
    
}

#pragma mark Default Methods
-(void)didMoveToView:(SKView *)view {

    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"MenuBackground"];

    // background.anchorPoint = CGPointMake(0,0);
    
    //background.position = CGPointMake(0, 0);
    [background setScale: 1.05];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.zPosition = -10;
    
    [self addChild: background];
    
    tapToBegin = [SKSpriteNode spriteNodeWithImageNamed:@"TapToBeginBig"];
    tapToBegin.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    tapToBegin.zPosition = 10;
    [tapToBegin setScale: 0.9];
    
    [self addChild: tapToBegin];
    
    SKAction *nodeVisible = [SKAction hide];
    SKAction *nodeInvisible = [SKAction unhide];
    SKAction *wait = [SKAction waitForDuration:0.5];
    SKAction *tapToBeginFlash = [SKAction sequence:@[nodeInvisible,wait,nodeVisible,wait]];
    SKAction *repeat = [SKAction repeatActionForever:tapToBeginFlash];
    
    [tapToBegin runAction:repeat];
    
    
    rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"RateButton"];    
    settingsButton = [SKSpriteNode spriteNodeWithImageNamed:@"SettingsButton"];
    unlockablesButton = [SKSpriteNode spriteNodeWithImageNamed:@"UnlockablesButton"];
    leaderboardsButton = [SKSpriteNode spriteNodeWithImageNamed:@"HighscoresButton"];
    
    rateButton.xScale = .5;
    rateButton.yScale = .5;
    settingsButton.xScale = .5;
    settingsButton.yScale = .5;
    unlockablesButton.xScale = .5;
    unlockablesButton.yScale = .5;
    leaderboardsButton.xScale = .5;
    leaderboardsButton.yScale = .5;
    
    [self addChild: rateButton];
    [self addChild: settingsButton];
    [self addChild: unlockablesButton];
    [self addChild: leaderboardsButton];
    
    float screenCenter = CGRectGetMidX(self.frame);

    unlockablesButton.position = CGPointMake(screenCenter - 150, 100);
    rateButton.position = CGPointMake(screenCenter - 50, 100);
    leaderboardsButton.position = CGPointMake(screenCenter + 50, 100);
    settingsButton.position = CGPointMake(screenCenter + 150, 100);
    
    unlockablesButton.zPosition = 10;
    settingsButton.zPosition = 10;
    rateButton.zPosition = 10;
    leaderboardsButton.zPosition = 10;
    
    rateButton.name = @"rate";
    settingsButton.name = @"settings";
    unlockablesButton.name = @"unlock";
    leaderboardsButton.name = @"lead";
    
    rateButton.userInteractionEnabled = TRUE;
    settingsButton.userInteractionEnabled = TRUE;
    unlockablesButton.userInteractionEnabled = TRUE;
    leaderboardsButton.userInteractionEnabled = TRUE;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {  //method is complete
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    touchedNode = [self nodeAtPoint:touchLocation];
    
    if (touchedNode != self) {
        touchedNode.alpha = 0.5;
    }

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    touchedNode.alpha = 1;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    touchedNode = [self nodeAtPoint:touchLocation];
    
    if ([touchedNode.name isEqualToString: rateButton.name])
        {
            printf("ratebutton\n");
            [self openRateLink];
        }
    else if ([touchedNode.name isEqualToString: settingsButton.name])
        {
            printf("settings\n");
            [self openSettings];
        }
    else if ([touchedNode.name isEqualToString: unlockablesButton.name])
        {
            printf("unlockables\n");
            [self openUnlockables];
        }
    else if ([touchedNode.name isEqualToString: leaderboardsButton.name])
        {
            printf("leaderboards\n");
            [self openLeaderboards];
        }
    else
        {
            GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            SKTransition *openGameScene = [SKTransition crossFadeWithDuration: 0.5]; //*** ask ryan about different transitions
            
            [self.view presentScene:scene transition:openGameScene];

        }
}
-(void)update:(NSTimeInterval)currentTime {
    if (frameCount == 60) {
        [self spawnDarkFishAndMoveRight];
    }
    if (frameCount == 120) {
        [self spawnDarkFishAndMoveLeft];
    }
    if (frameCount == 180) {
        [self spawnDarkFishAndMoveLeftLow];
        frameCount = 0;
    }
    frameCount ++;
    
}

#pragma mark Button Methods

-(void)openRateLink {
}

-(void)openSettings {
}

-(void)openUnlockables {
}

-(void)openLeaderboards {
}

// ************************ BACKGROUND FISH METHODS *******************************//

-(void)spawnDarkFishAndMoveRight {
    SKSpriteNode *darkFish = [SKSpriteNode spriteNodeWithImageNamed:@"DarkFish"];
    darkFish.xScale = darkFish.xScale/2;
    darkFish.yScale = darkFish.yScale/2;
    SKAction *moveFish = [SKAction moveByX:520 y:0 duration:4];
    SKAction *removeFish = [SKAction removeFromParent];
    SKAction *rtSeq = [SKAction sequence:@[moveFish, removeFish]];
    [self addChild:darkFish];
    darkFish.position = CGPointMake(260, 350);
    darkFish.zPosition = 20;
    [darkFish runAction: rtSeq];
    
}
-(void)spawnDarkFishAndMoveLeft {
    SKSpriteNode *darkFish = [SKSpriteNode spriteNodeWithImageNamed:@"DarkFish"];
    darkFish.xScale = -darkFish.xScale/2;
    darkFish.yScale = darkFish.yScale/2;
    SKAction *moveFish = [SKAction moveByX:-520 y:0 duration:4];
    SKAction *removeFish = [SKAction removeFromParent];
    SKAction *leftSeq = [SKAction sequence:@[moveFish, removeFish]];
    [self addChild:darkFish];
    darkFish.position = CGPointMake(770, 550);
    darkFish.zPosition = 20;
    [darkFish runAction: leftSeq];
    
}
-(void)spawnDarkFishAndMoveLeftLow {
    SKSpriteNode *darkFish = [SKSpriteNode spriteNodeWithImageNamed:@"DarkFish"];
    darkFish.xScale = -darkFish.xScale/2;
    darkFish.yScale = darkFish.yScale/2;
    SKAction *moveFish = [SKAction moveByX:-520 y:0 duration:4];
    SKAction *removeFish = [SKAction removeFromParent];
    SKAction *leftSeq = [SKAction sequence:@[moveFish, removeFish]];
    [self addChild:darkFish];
    darkFish.position = CGPointMake(770, 150);
    darkFish.zPosition = 20;
    [darkFish runAction: leftSeq];
    
}

































@end
