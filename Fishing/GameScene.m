//




 //realone
//  GameScene.m
//  Fishing
//
//  Copyright (c) 2015 Neima Mogadas. All rights reserved.


#import "GameScene.h"
#import "Fish.h"

static int const MAX_RIGHT_POSITION = 745; //max position of fish nodes
static int const MAX_LEFT_POSITION = 290;
//static int const MIN_DEPTH = 520;
//static int const MAX_DEPTH = 10;


@implementation GameScene
{
    
    NSMutableArray *fishArray;
    NSMutableArray *rowArray;
    
    int frameCount;
    int score;
    int bestScore;
    int spawnOnFrame;
    
    SKNode *leftEye;
    SKNode *rightEye;
    SKLabelNode *scoreNode;
    SKLabelNode *endScoreNode;
    SKLabelNode *bestScoreNode;
    

    CGPoint touchLocation;
    Fish *sprite;
    
    BOOL isGamePaused;
    BOOL isGameOver;
    
    
    SKSpriteNode *pauseButton;
    SKSpriteNode *pausedScreen;
    SKSpriteNode *GameOverScreen;
    SKSpriteNode *HomeButton;
    SKSpriteNode *ReplayButton;
    
}

#pragma mark Default Methods

-(void)didMoveToView:(SKView *)view {
    
    bestScore = 0;
    
    [self initialMethod];
    
}

-(void)initialMethod {
    
    /* Setup your scene here */
    
    [self unpauseGame];
    frameCount = 0;
    
    fishArray = [[NSMutableArray alloc] init];
    rowArray = [[NSMutableArray alloc] init];
    
    for (int rowNum = 0; rowNum < 9; rowNum++) {
        [rowArray addObject:[NSNumber numberWithBool:false]];
    }
    
    [self makeBackground];
    
    SKSpriteNode *fisherman = [SKSpriteNode spriteNodeWithImageNamed:@"Fisherman"];
    [fisherman setScale: 0.60];
    fisherman.position = CGPointMake(CGRectGetMidX(self.frame), 565);
    fisherman.zPosition = -.95;
    
    leftEye = [[SKNode alloc] init];
    leftEye.position = CGPointMake(510, 595);
    
    rightEye = [[SKNode alloc] init];
    rightEye.position = CGPointMake(520, 595);
    
    
    SKAction *bobFisherman = [SKAction moveByX:0 y:10 duration:2];
    SKAction *bobFishermanBack = [SKAction moveByX:0 y:-10 duration:2];
    
    SKNode *container= [[SKNode alloc] init];
    [container addChild:leftEye];
    [container addChild:rightEye];
    [container addChild:fisherman];
    
    [self addChild:container];
    
    SKAction *bobSequence = [SKAction sequence:@[bobFisherman, bobFishermanBack]];
    
    
    [container runAction:[SKAction repeatActionForever:bobSequence]];
    
    scoreNode = [[SKLabelNode alloc] initWithFontNamed:@"BigJohn"];
    scoreNode.text = @"0";
    scoreNode.fontSize = 32;
    scoreNode.position = CGPointMake(310, 735);
    [self addChild:scoreNode];
    
    pauseButton = [SKSpriteNode spriteNodeWithImageNamed:@"PauseButton"];
    [pauseButton setScale:0.4];
    pauseButton.position = CGPointMake(683, 735);
    [self addChild:pauseButton];
    
    SKAction *makeCloudLeft = [SKAction performSelector: @selector(spawnCloudLeft) onTarget:self];
    SKAction *waitForCloud = [SKAction waitForDuration:40];
    SKAction *makeCloudRight = [SKAction performSelector: @selector(spawnCloudRight) onTarget:self];
    SKAction *cloudMovement = [SKAction sequence:@[makeCloudLeft, waitForCloud, makeCloudRight, waitForCloud]];
    [self runAction:[SKAction repeatActionForever:cloudMovement]];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
        
        touchLocation = [touch locationInNode:self];

        for (int index = 0; index < fishArray.count; index++) {
            Fish *temp = fishArray[index];

            if([temp containsPoint:touchLocation])
            {
                if(temp.isShaking && temp._canFishDie)
                {
                    score++;
                    [self killFish:temp];
                }
               else if (!isGameOver && temp._canFishDie)
                    [self gameover];
                
            }
        }
    
    if (isGamePaused && [self containsPoint:touchLocation]) {
        
        [self unpauseGame];
        SKAction *hidePause = [SKAction hide];
        [pausedScreen runAction:hidePause];
        
    }

    
    if ([pauseButton containsPoint:touchLocation]) {
        
        [self pauseGame];
        pausedScreen = [SKSpriteNode spriteNodeWithImageNamed:@"PausedScreen"];
        pausedScreen.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:pausedScreen];
        
    }
    
    if ([ReplayButton containsPoint:touchLocation] && isGameOver == YES)  {
        
        [self replay];
        
    }
    
    if ([HomeButton containsPoint:touchLocation] && isGameOver == YES) {
        

        
    }
    
 
        double xLoc = touchLocation.x;
        printf("%f \n",xLoc);
        
        double yLoc = touchLocation.y;
        printf("%f \n",yLoc);
        
       
    
}

-(void)pauseGame{
    
    isGamePaused = YES;
}

-(void)unpauseGame {
    
    isGamePaused = NO;
    
}

-(void)update:(CFTimeInterval)currentTime {
   
    if (!isGamePaused) {

        static int const MIN_FRAME_COUNT = 15;
        
        scoreNode.text = [NSString stringWithFormat:@"%d", score];
        if (score == 10 && scoreNode.position.x == 310) {
            scoreNode.position = CGPointMake(325, 735);
        }
        if (score == 100 && scoreNode.position.x == 325) {
            scoreNode.position = CGPointMake(340, 735);
        }

        [self moveFish];
        
        spawnOnFrame = 30;
        
        if (score > 15) {
            spawnOnFrame = 25;
        }
        else if (score > 30) {
            spawnOnFrame = 20;
        }
        else if (score > 50) {
            spawnOnFrame = 15;
        }
        else if (score > 75) {
            spawnOnFrame = 13;
        }
        else if (score > 100) {
            spawnOnFrame = 10;
        }
        else if (score > 200) {
            spawnOnFrame = 8;
        }
        
        frameCount++;
        if (frameCount == spawnOnFrame && isGameOver == NO) {
            [self spawnFish];
            frameCount = 0;
            if (frameCount > MIN_FRAME_COUNT)
                {
                    frameCount--;
                }
        }
        
        for (int index = 0; index < fishArray.count; index++) {
            Fish *temp = fishArray[index];
            
            if ((temp.xScale >= .99 || temp.yScale >=.99)) {
                
                if(!temp.isShaking) {
                    [temp shakeFish];
                    temp.isShaking = TRUE;
                }
                    temp._framesToLive--;
            }
         
           
            if (temp._framesToLive <=0 && temp._canFishDie == YES && !isGameOver) {
                [temp removeFromParent];
                [self gameover];

            }
        }
        
       // if(self.xScale >= 1 && self.yScale >= 1){
            
        
    
    
    
    }
}
-(void)gameover {
    
    [self removeChildrenInArray:fishArray];
    [self pauseGame];
    isGameOver = YES;
    
    GameOverScreen = [SKSpriteNode spriteNodeWithImageNamed:@"GameOverScreen"];
    GameOverScreen.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    GameOverScreen.zPosition = 100;
    [self addChild:GameOverScreen];
    
    endScoreNode = [[SKLabelNode alloc] initWithFontNamed:@"BigJohn"];
    endScoreNode.text = @"0";
    endScoreNode.fontSize = 32;
    endScoreNode.position = CGPointMake(558, 390);
    endScoreNode.text = [NSString stringWithFormat:@"%d", score];
    [self addChild:endScoreNode];
    
    bestScoreNode = [[SKLabelNode alloc] initWithFontNamed:@"BigJohn"];
    bestScoreNode.text = @"0";
    bestScoreNode.fontSize = 32;
    bestScoreNode.position = CGPointMake(558, 340);
    if (score > bestScore) {bestScore = score;}
    bestScoreNode.text = [NSString stringWithFormat:@"%d", bestScore];
    [self addChild:bestScoreNode];
    
    HomeButton = [SKSpriteNode spriteNodeWithImageNamed:@"HomeButton"];
    HomeButton.position = CGPointMake(CGRectGetMidX(self.frame) - 100, 120);
    HomeButton.zPosition = 100;
    [self addChild:HomeButton];
    
    ReplayButton = [SKSpriteNode spriteNodeWithImageNamed:@"ReplayButton"];
    ReplayButton.position = CGPointMake(CGRectGetMidX(self.frame) + 100, 120);
    ReplayButton.zPosition = 100;
    [self addChild:ReplayButton];
    
}

-(void)replay {
    
    isGameOver = NO;
    score = 0;
    spawnOnFrame = 0;
    [self unpauseGame];
    [self removeAllChildren];
    [self removeAllActions];
    [self initialMethod];
    
    
}
    
#pragma mark Fish Methods
-(void)killFish: (Fish *)tempFish{
    
    tempFish._canFishDie = NO;
    [tempFish flashRed];
    
    SKShapeNode *yourline = [SKShapeNode node];
    yourline.glowWidth = 4;
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, leftEye.position.x, leftEye.position.y);
    CGPathAddLineToPoint(pathToDraw, NULL, tempFish.position.x, tempFish.position.y);
    yourline.path = pathToDraw;
    [yourline setStrokeColor:[UIColor redColor]];
    yourline.zPosition = 1;
    SKNode *lineNode = [[SKNode alloc]init];
    [lineNode addChild:yourline];
    
    SKShapeNode *yourline2 = [SKShapeNode node];
    yourline2.glowWidth = 2;
    CGMutablePathRef pathToDraw2 = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw2, NULL, leftEye.position.x, leftEye.position.y);
    CGPathAddLineToPoint(pathToDraw2, NULL, tempFish.position.x, tempFish.position.y);
    yourline2.path = pathToDraw2;
    [yourline2 setStrokeColor:[UIColor whiteColor]];
    yourline2.zPosition = 1;
    
    [lineNode addChild:yourline2];
    [self addChild: lineNode];
    
    SKShapeNode *yourline3 = [SKShapeNode node];
    yourline3.glowWidth = 4;
    CGMutablePathRef pathToDraw3 = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw3, NULL, rightEye.position.x, rightEye.position.y);
    CGPathAddLineToPoint(pathToDraw3, NULL, tempFish.position.x, tempFish.position.y);
    yourline3.path = pathToDraw3;
    [yourline3 setStrokeColor:[UIColor redColor]];
    yourline3.zPosition = 1;
    SKNode *lineNode2 = [[SKNode alloc]init];
    [lineNode2 addChild:yourline3];
    
    SKShapeNode *yourline4 = [SKShapeNode node];
    yourline4.glowWidth = 2;
    CGMutablePathRef pathToDraw4 = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw4, NULL, rightEye.position.x, rightEye.position.y);
    CGPathAddLineToPoint(pathToDraw4, NULL, tempFish.position.x, tempFish.position.y);
    yourline4.path = pathToDraw4;
    [yourline4 setStrokeColor:[UIColor whiteColor]];
    yourline4.zPosition = 1;
    
    [lineNode2 addChild:yourline4];
    [self addChild: lineNode2];
    
    SKAction *delayAction = [SKAction waitForDuration:.15];
    SKAction *removeFish = [SKAction removeFromParent];
    
    SKAction *removeSequence = [SKAction sequence:@[delayAction, removeFish]];
    
    
    void (^laserRemovalBlock)(void) = ^{
        yourline.path = NULL;
        yourline2.path = NULL;
        yourline3.path = NULL;
        yourline4.path = NULL;
        
    };
    SKAction *removeLasers = [SKAction runBlock:laserRemovalBlock];
    SKAction *removeLaserSequence = [SKAction sequence:@[delayAction, removeFish, removeLasers]];
    
    
    [tempFish runAction:removeSequence completion:laserRemovalBlock];
    [lineNode runAction:removeLaserSequence];
    [lineNode2 runAction:removeLaserSequence];
}


-(void)spawnFish {
    
    int fishType = arc4random_uniform(3) +1; // creates rand # from 1-3
    Fish *newFish;
    
    
    switch (fishType) {
        case 1:
            newFish = [Fish initWithImageNamed: @"Green Fish" andType: 1];
            break;
        case 2:
            newFish = [Fish initWithImageNamed: @"Red Fish" andType: 2];
            break;
        case 3:
            newFish = [Fish initWithImageNamed: @"Orange Fish" andType: 3];
            break;
        default:
            break;
    }
    
    [fishArray addObject: newFish];
    

    
    newFish.xScale = 0.5;
    newFish.yScale = 0.5;
    
    rowArray = [NSMutableArray array];
    int fishRow = arc4random_uniform(9) + 1; //9 rows
    [rowArray addObject:[NSNumber numberWithInt:fishRow]];
    
    /*
    for (int i = 0; i < sizeof(rowArray) ; i++) {
        if ((fishRow = (int)rowArray[i])) {
            fishRow = arc4random_uniform(9) + 1; //9 rows
            break;
        }
    }
     */

  
    
    if (fishArray.count %2 == 0)
        {
            newFish.position = CGPointMake(291, fishRow * 51 + 10);
        }
    else
            newFish.position = CGPointMake(744, fishRow * 51 + 10);
    
  
    [self addChild: newFish];

    
    
    
}
-(void)moveFish {
    
    for (int indexOfFish = 0; indexOfFish < fishArray.count; indexOfFish ++ ) {
        
        Fish *tempFish = [fishArray objectAtIndex: indexOfFish];
        CGFloat fXLoc = tempFish.position.x;
        if (fXLoc < MAX_RIGHT_POSITION && tempFish._isFacingRight)
            {
                [tempFish moveFishRight];
            }
        if (fXLoc >= MAX_RIGHT_POSITION)
            {
                tempFish._isFacingRight = FALSE;        //doesn't actually change the direction the fish is facing
                tempFish.xScale = tempFish.xScale * -1; //changes actual direction the fish is facing
                do
                    {
                        [tempFish moveFishLeft];
                        fXLoc = tempFish.position.x;//resets x position variable(or else infinte loop will result)

                    }
                while (fXLoc >= MAX_RIGHT_POSITION);
            }
        else if (!tempFish._isFacingRight && fXLoc >= MAX_LEFT_POSITION)
            {
                [tempFish moveFishLeft];
            }
        else if (fXLoc < MAX_LEFT_POSITION)
            {
                [tempFish moveFishRight];
                tempFish._isFacingRight = TRUE;
                tempFish.xScale = tempFish.xScale * -1; //fish faces right again
            }
        [tempFish growFish];
        
        
    }
} //move fish method is complete!!! YAY!!!!!

#pragma mark Background Methods

-(void)spawnCloudLeft{
    SKSpriteNode *cloud = [SKSpriteNode spriteNodeWithImageNamed:@"Cloud"];
    cloud.xScale = cloud.xScale/1.5;
    cloud.yScale = cloud.yScale/1.5;
    cloud.colorBlendFactor = .2;
    SKAction *moveCloud = [SKAction moveByX:-520 y:0 duration:70];
    SKAction *removeCloud = [SKAction removeFromParent];
    SKAction *leftSeq = [SKAction sequence:@[moveCloud, removeCloud]];
    [self addChild:cloud];
    cloud.position = CGPointMake(770, 700);
    [cloud runAction: leftSeq];
    
}

-(void)spawnCloudRight{
    SKSpriteNode *cloud = [SKSpriteNode spriteNodeWithImageNamed:@"Cloud"];
    cloud.xScale = cloud.xScale/1.5;
    cloud.yScale = cloud.yScale/1.5;
    cloud.colorBlendFactor = .2;
    SKAction *moveCloud = [SKAction moveByX:520 y:0 duration:70];
    SKAction *removeCloud = [SKAction removeFromParent];
    SKAction *leftSeq = [SKAction sequence:@[moveCloud, removeCloud]];
    [self addChild:cloud];
    cloud.position = CGPointMake(260, 750);
    [cloud runAction: leftSeq];
    
}

-(void)makeBackground {
    // SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"Fish Game Background"];
    SKSpriteNode *backgroundTop = [SKSpriteNode spriteNodeWithImageNamed:@"BackgroundTop"];
    SKSpriteNode *backgroundBot = [SKSpriteNode spriteNodeWithImageNamed:@"BackgroundBot"];
    
    
    // background.anchorPoint = CGPointMake(0,0);
    //background.position = CGPointMake(0, 0);
    
    
    [backgroundBot setScale: 1.05];
    [backgroundTop setScale: 1.05];
    backgroundBot.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    backgroundTop.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    backgroundBot.zPosition = -.9;
    backgroundTop.zPosition = -1;
    [self addChild: backgroundTop];
    [self addChild:backgroundBot];

}
@end
