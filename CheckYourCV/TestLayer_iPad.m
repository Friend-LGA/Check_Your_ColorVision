//
//  Created by Grigory Lutkov on 01.10.12.
//  Copyright (c) 2012 Grigory Lutkov. All rights reserved.
//

#import "TestLayer_iPad.h"
#import "MainMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "LGLocalization.h"
#import "LGGameCenter.h"
#import "LGKit.h"
#import "LGReachability.h"
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import "DEFacebookComposeViewController.h"

#pragma mark - TestLayer_iPad

@implementation TestLayer_iPad

+ (CCScene *) scene
{
	CCScene *scene = [CCScene node];
	TestLayer_iPad *layer = [TestLayer_iPad node];
	[scene addChild:layer];
	return scene;
}

- (id) init
{
	if ((self=[super init]))
    {
		[kLGKit performSelector:@selector(touchEnableWithTarget:) withObject:self afterDelay:0.5];
        winSize = [[CCDirector sharedDirector] winSize];
        [kStandartUserDefaults setInteger:0 forKey:@"goToMenuFromTest"];
        [kStandartUserDefaults setInteger:0 forKey:@"goToMenuFromResults"];
        
        squaresMoved = 0;
        take = 0;
        gameFinish = 0;
        mistakesOnScreen = 0;
        tryAgain = 0;
        
        textFontSize = 24;
        titleFontSize = 52;
        buttonsFontSize = 80;
        buttonsBgFontSize = 110;
        socialButtonsFontSize = 68;
        
        [self checkAds];
        [self sceneItems];
	}
	return self;
}

#pragma mark - Check Ads Availability

- (void) checkAds
{
    if (!kIsGameFull)
    {
        adsBanner = [CCSprite spriteWithFile:@"adsBanner.png"];
        adsBanner.position = ccp(winSize.width/2, winSize.height-adsBanner.contentSize.height/2);
        [self addChild:adsBanner z:100];
        
        winSize.height = winSize.height - adsBanner.contentSize.height;
    }
}

#pragma mark - TestLayer stuff

- (void) sceneItems
{
    UINavigationController *navigationController = [(AppController *)[[UIApplication sharedApplication] delegate] navigationController];
    
    NSString *buttonsBg = kSquareBgString;
    NSString *buttonsStroke = kSquareStrokeString;
    
    CCTexture2D *gamecenterButtonT2D = [[CCTextureCache sharedTextureCache] addImage:@"gamecenterSquareButton.png"];
    
    squareT = [[CCTextureCache sharedTextureCache] addImage:@"square.png"];
    stripeT = [[CCTextureCache sharedTextureCache] addImage:@"stripe.png"];
    
    bg = [CCSprite spriteWithFile:@"bg.png"];
	bg.position = ccp(navigationController.view.bounds.size.width/2, navigationController.view.bounds.size.height/2);
	[self addChild:bg z:-1];
    
    bgSecond = [CCSprite spriteWithFile:@"bgSecond.png"];
    bgSecond.position = ccp(winSize.width/2, winSize.height+bgSecond.contentSize.height/2+2);
    bgSecond.color = kColorLight;
    bgSecond.opacity = 225;
    [self addChild:bgSecond z:5];
    
    stripeL = [CCSprite spriteWithFile:@"stripeL.png"];
    stripeL.position = ccp(winSize.width/2, bgSecond.position.y-bgSecond.contentSize.height/2);
    stripeL.color = kColorDark;
    [self addChild:stripeL z:6];
    
    CCLabelTTF *temp = [CCLabelTTF labelWithString:@"TEMP" fontName:kFontComicSans fontSize:textFontSize];
    
    help = [CCLabelTTF labelWithString:LGLocalizedString(@"squareHelp", nil)
                              fontName:kFontComicSans
                              fontSize:textFontSize
                            dimensions:CGSizeMake(winSize.width-40, (temp.contentSize.height*2)*1.1)
                            hAlignment:kCCTextAlignmentCenter
                            vAlignment:kCCVerticalTextAlignmentCenter];
    help.position = ccp(winSize.width/2, bgSecond.position.y-bgSecond.contentSize.height/2+help.contentSize.height/2);
    help.color = kColorDark;
    [self addChild:help z:6];
    
    squareBig = [CCSprite spriteWithFile:@"squareBig.png"];
    squareBig.visible = 0;
    [self addChild:squareBig z:3];
    
    previousButtonText = [CCLabelTTF labelWithString:@"<" fontName:kFontComicSans fontSize:buttonsFontSize];
    [self addChild:previousButtonText z:2];
    previousButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:previousButtonBg z:1];
    previousButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:previousButtonStroke z:2];
    previousText = [CCLabelTTF labelWithString:LGLocalizedString(@"menu", nil) fontName:kFontComicSans fontSize:textFontSize];
    [self addChild:previousText z:1];
    
    [self setPropertiesForButton:previousButtonText
                        buttonBg:previousButtonBg
                    buttonStroke:previousButtonStroke
                      buttonText:previousText
                        position:ccp(previousButtonBg.contentSize.width/2-previousButtonBg.contentSize.width*0.16, previousButtonBg.contentSize.height/2-previousButtonBg.contentSize.height*0.20)
                           color:kColorDark];
    
    nextButtonText = [CCLabelTTF labelWithString:@">" fontName:kFontComicSans fontSize:buttonsFontSize];
    [self addChild:nextButtonText z:2];
    nextButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:nextButtonBg z:1];
    nextButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:nextButtonStroke z:2];
    nextText = [CCLabelTTF labelWithString:LGLocalizedString(@"finish", nil) fontName:kFontComicSans fontSize:textFontSize];
    [self addChild:nextText z:1];
    
    [self setPropertiesForButton:nextButtonText
                        buttonBg:nextButtonBg
                    buttonStroke:nextButtonStroke
                      buttonText:nextText
                        position:ccp(winSize.width-nextButtonBg.contentSize.width/2+nextButtonBg.contentSize.width*0.16, nextButtonBg.contentSize.height/2-nextButtonBg.contentSize.height*0.20)
                           color:kColorDark];
    
    menuButton = [CCLabelTTF labelWithString:@"<" fontName:kFontComicSans fontSize:buttonsFontSize];
    [self addChild:menuButton z:2];
    menuButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:menuButtonBg z:1];
    menuButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:menuButtonStroke z:2];
    menuButtonText = [CCLabelTTF labelWithString:LGLocalizedString(@"menu", nil) fontName:kFontComicSans fontSize:textFontSize];
    [self addChild:menuButtonText z:1];
    
    [self setPropertiesForButton:menuButton
                        buttonBg:menuButtonBg
                    buttonStroke:menuButtonStroke
                      buttonText:menuButtonText
                        position:ccp(menuButtonBg.contentSize.width/2-menuButtonBg.contentSize.width*0.16, previousButtonBg.position.y+menuButtonBg.contentSize.height)
                           color:kColorDark];
    
    gamecenterButton = [CCSprite spriteWithTexture:gamecenterButtonT2D];
    [self addChild:gamecenterButton z:2];
    gamecenterButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:gamecenterButtonBg z:1];
    gamecenterButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:gamecenterButtonStroke z:2];
    
    [self setPropertiesForButton:gamecenterButton
                        buttonBg:gamecenterButtonBg
                    buttonStroke:gamecenterButtonStroke
                      buttonText:nil
                        position:ccp(winSize.width-gamecenterButtonBg.contentSize.width/2+gamecenterButtonBg.contentSize.width*0.16, nextButtonBg.position.y+gamecenterButtonBg.contentSize.height)
                           color:kColorDark];
    
    facebookButton = [CCLabelTTF labelWithString:@"f" fontName:kFontArialBlack fontSize:socialButtonsFontSize]; ///// soundOnButton
    [self addChild:facebookButton z:5];
    facebookButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:facebookButtonBg z:4];
    facebookButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:facebookButtonStroke z:5];
    
    twitterButton = [CCLabelTTF labelWithString:@"t" fontName:kFontArialBlack fontSize:socialButtonsFontSize]; ///// soundOffButton
    [self addChild:twitterButton z:5];
    twitterButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:twitterButtonBg z:4];
    twitterButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:twitterButtonStroke z:5];
    
    vkontakteButton = [CCLabelTTF labelWithString:@"В" fontName:kFontArialBlack fontSize:socialButtonsFontSize-8]; ///// soundOffButton
    [self addChild:vkontakteButton z:5];
    vkontakteButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:vkontakteButtonBg z:4];
    vkontakteButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:vkontakteButtonStroke z:5];
    
    [self setPropertiesForButton:facebookButton
                        buttonBg:facebookButtonBg
                    buttonStroke:facebookButtonStroke
                      buttonText:nil
                        position:ccp(winSize.width-gamecenterButtonBg.contentSize.width/2+gamecenterButtonBg.contentSize.width*0.16, gamecenterButtonBg.position.y+facebookButtonBg.contentSize.height)
                           color:kColorDark];
    
    [self setPropertiesForButton:twitterButton
                        buttonBg:twitterButtonBg
                    buttonStroke:twitterButtonStroke
                      buttonText:nil
                        position:ccp(winSize.width-gamecenterButtonBg.contentSize.width/2+gamecenterButtonBg.contentSize.width*0.16, facebookButtonBg.position.y+twitterButtonBg.contentSize.height)
                           color:kColorDark];
    
    [self setPropertiesForButton:vkontakteButton
                        buttonBg:vkontakteButtonBg
                    buttonStroke:vkontakteButtonStroke
                      buttonText:nil
                        position:ccp(winSize.width-gamecenterButtonBg.contentSize.width/2+gamecenterButtonBg.contentSize.width*0.16, twitterButtonBg.position.y+vkontakteButtonBg.contentSize.height)
                           color:kColorDark];
    
    results = [CCLabelTTF labelWithString:LGLocalizedString(@"results", nil) fontName:kFontComicSans fontSize:titleFontSize];
    results.position = ccp(winSize.width/2, winSize.height-results.contentSize.height);
    results.color = ccc3(50, 50, 50);
    results.opacity = 0;
	[self addChild:results z:1];
    
    mistakesText = [CCLabelTTF labelWithString:LGLocalizedString(@"mistakes", nil) fontName:kFontComicSans fontSize:textFontSize];
    mistakesText.position = ccp(winSize.width*0.48, results.position.y-results.contentSize.height-mistakesText.contentSize.height/4);
    mistakesText.color = ccc3(50, 50, 50);
    mistakesText.opacity = 0;
    mistakesText.anchorPoint = ccp(1, 0.5);
	[self addChild:mistakesText z:1];
    
    mistakesResult = [CCLabelTTF labelWithString:@"0" fontName:kFontComicSans fontSize:textFontSize];
    mistakesResult.position = ccp(winSize.width*0.52, mistakesText.position.y);
    mistakesResult.color = ccc3(50, 50, 50);
    mistakesResult.opacity = 0;
    mistakesResult.anchorPoint = ccp(0, 0.5);
	[self addChild:mistakesResult z:1];
    
    timeText = [CCLabelTTF labelWithString:LGLocalizedString(@"time", nil) fontName:kFontComicSans fontSize:textFontSize];
    timeText.position = ccp(winSize.width*0.48, mistakesText.position.y-timeText.contentSize.height);
    timeText.color = ccc3(50, 50, 50);
    timeText.opacity = 0;
    timeText.anchorPoint = ccp(1, 0.5);
	[self addChild:timeText z:1];
    
    timer = [CCLabelTTF labelWithString:@"00:00" fontName:kFontComicSans fontSize:textFontSize];
    timer.position = ccp(winSize.width*0.5, previousText.position.y);
    timer.color = ccc3(50, 50, 50);
    timer.opacity = 0;
	[self addChild:timer z:1];
    
    squaresMovedText = [CCLabelTTF labelWithString:LGLocalizedString(@"squaresMoved", nil) fontName:kFontComicSans fontSize:textFontSize];
    squaresMovedText.position = ccp(winSize.width*0.48, timeText.position.y-squaresMovedText.contentSize.height);
    squaresMovedText.color = ccc3(50, 50, 50);
    squaresMovedText.opacity = 0;
    squaresMovedText.anchorPoint = ccp(1, 0.5);
	[self addChild:squaresMovedText z:1];
    
    squaresMovedResult = [CCLabelTTF labelWithString:@"0" fontName:kFontComicSans fontSize:textFontSize];
    squaresMovedResult.position = ccp(winSize.width*0.52, squaresMovedText.position.y);
    squaresMovedResult.color = ccc3(50, 50, 50);
    squaresMovedResult.opacity = 0;
    squaresMovedResult.anchorPoint = ccp(0, 0.5);
	[self addChild:squaresMovedResult z:1];
    
    scoreText = [CCLabelTTF labelWithString:LGLocalizedString(@"score", nil) fontName:kFontComicSans fontSize:textFontSize];
    scoreText.position = ccp(winSize.width*0.48, squaresMovedText.position.y-scoreText.contentSize.height);
    scoreText.color = ccc3(50, 50, 50);
    scoreText.opacity = 0;
    scoreText.anchorPoint = ccp(1, 0.5);
	[self addChild:scoreText z:1];
    
    scoreResult = [CCLabelTTF labelWithString:@"0" fontName:kFontComicSans fontSize:textFontSize];
    scoreResult.position = ccp(winSize.width*0.52, scoreText.position.y);
    scoreResult.color = ccc3(50, 50, 50);
    scoreResult.opacity = 0;
    scoreResult.anchorPoint = ccp(0, 0.5);
	[self addChild:scoreResult z:1];
    
    tryAgainButtonImg = [CCSprite spriteWithFile:@"retryImg.png"];
    tryAgainButtonImg.position = ccp(tryAgainButtonImg.contentSize.width*0.49, tryAgainButtonImg.contentSize.height*0.47);
    tryAgainButtonImg.color = ccc3(50, 50, 50);
    tryAgainButtonImg.opacity = 0;
	[self addChild:tryAgainButtonImg z:3];
    
    showMistakesButtonText = [CCLabelTTF labelWithString:@"✗" fontName:@"Arial" fontSize:buttonsFontSize-5];
    showMistakesButtonText.position = ccp(nextButtonBg.position.x, nextButtonBg.position.y-nextButtonBg.contentSize.height*0.02);
    showMistakesButtonText.color = ccc3(50, 50, 50);
    showMistakesButtonText.opacity = 0;
	[self addChild:showMistakesButtonText z:1];
    
    int k = 1;
    
    for (int i=0; i<=15; i++)
    {
        square[i] = [CCSprite spriteWithTexture:squareT];
        square[i].color = ccc3(255, 15.937*i, 0);
        [self addChild:square[i] z:2];
        
        //NSLog(@"255, %3.0f, 000", 15.937*i);
    }
    for (int i=16; i<=24; i++)
    {
        square[i] = [CCSprite spriteWithTexture:squareT];
        square[i].color = ccc3(255-15.937*(i-16), 255, 0);
        [self addChild:square[i] z:2];
        
        //NSLog(@"%3.0f, 255, 000     i = %d", 255-15.937*(i-16), i);
    }
    for (int i=25; i<=35; i++)
    {
        if (i <= 28)
        {
            square[i] = [CCSprite spriteWithTexture:squareT];
            square[i].color = ccc3(255-15.937*(i-16+k), 255, 0);
            [self addChild:square[i] z:2];
            
            //NSLog(@"%3.0f, 255, 000     i = %d", 255-15.937*(i-16+k), i);
        }
        if (i == 29)
        {
            square[i] = [CCSprite spriteWithTexture:squareT];
            square[i].color = ccc3(0, 255, 15.937*(i-32+k));
            [self addChild:square[i] z:2];
            
            //NSLog(@"000, 255, %3.0f     i = %d", 15.937*(i-32+k), i);
        }
        k = k + 1;
    }
    for (int i=30; i<=41; i++)
    {
        square[i] = [CCSprite spriteWithTexture:squareT];
        square[i].color = ccc3(0, 255, 15.937*(i-26));
        [self addChild:square[i] z:2];
        
        //NSLog(@"000, 255, %3.0f     i = %d", 15.937*(i-32), i);
    }
    for (int i=42; i<=54; i++)
    {
        square[i] = [CCSprite spriteWithTexture:squareT];
        square[i].color = ccc3(0, 255-15.937*(i-42), 255);
        [self addChild:square[i] z:2];
        
        //NSLog(@"000, %3.0f, 255     i = %d", 255-15.937*(i-48), i);
    }
    
    k = 1;
    
    for (int i=55; i<=65; i++)
    {
        if (i <= 56)
        {
            square[i] = [CCSprite spriteWithTexture:squareT];
            square[i].color = ccc3(0, 255-15.937*(i-42+k), 255);
            [self addChild:square[i] z:2];
            
            //NSLog(@"000, %3.0f, 255     i = %d", 255-15.937*(i-48+k), i);
        }
        if (i >= 57 && i <= 59)
        {
            square[i] = [CCSprite spriteWithTexture:squareT];
            square[i].color = ccc3(15.937*(i-58+k), 0, 255);
            [self addChild:square[i] z:2];
            
            //NSLog(@"%3.0f, 000, 255     i = %d", 15.937*(i-64+k), i);
        }
        k = k + 1;
    }
    for (int i=60; i<=67; i++)
    {
        square[i] = [CCSprite spriteWithTexture:squareT];
        square[i].color = ccc3(15.937*(i-52), 0, 255);
        [self addChild:square[i] z:2];
        
        //NSLog(@"%3.0f, 000, 255     i = %d", 15.937*(i-64), i);
    }
    for (int i=68; i<=83; i++)
    {
        square[i] = [CCSprite spriteWithTexture:squareT];
        square[i].color = ccc3(255, 0, 255-15.937*(i-68));
        [self addChild:square[i] z:2];
        
        //NSLog(@"255, 000, %3.0f", 255-15.937*(i-80));
    }
    
    winSize.height = winSize.height + adsBanner.contentSize.height;
    
    int step = winSize.height*(0.85 - 0.20)/6;
    
    stripe[1] = [CCSprite spriteWithTexture:stripeT];
	stripe[1].position = ccp(winSize.width/2+winSize.width, winSize.height*0.85);
	[self addChild:stripe[1] z:1];
    
    stripe[2] = [CCSprite spriteWithTexture:stripeT];
	stripe[2].position = ccp(winSize.width/2-winSize.width, stripe[1].position.y-step);
	[self addChild:stripe[2] z:1];
    
    stripe[3] = [CCSprite spriteWithTexture:stripeT];
	stripe[3].position = ccp(winSize.width/2+winSize.width, stripe[2].position.y-step);
	[self addChild:stripe[3] z:1];
    
    stripe[4] = [CCSprite spriteWithTexture:stripeT];
	stripe[4].position = ccp(winSize.width/2-winSize.width, stripe[3].position.y-step);
	[self addChild:stripe[4] z:1];
    
    stripe[5] = [CCSprite spriteWithTexture:stripeT];
	stripe[5].position = ccp(winSize.width/2+winSize.width, stripe[4].position.y-step);
	[self addChild:stripe[5] z:1];
    
    stripe[6] = [CCSprite spriteWithTexture:stripeT];
	stripe[6].position = ccp(winSize.width/2-winSize.width, stripe[5].position.y-step);
	[self addChild:stripe[6] z:1];
    
    stripe[7] = [CCSprite spriteWithTexture:stripeT];
	stripe[7].position = ccp(winSize.width/2+winSize.width, stripe[6].position.y-step);
	[self addChild:stripe[7] z:1];
    
    winSize.height = winSize.height - adsBanner.contentSize.height;
    
    for (int i=0; i<=11; i++)
    {
        place[i] = ccp(stripe[1].position.x-stripe[1].contentSize.width/2+11+square[i].contentSize.width/2+square[i].contentSize.width*i+2*i, stripe[1].position.y);
    }
    for (int i=12; i<=23; i++)
    {
        place[i] = ccp(stripe[2].position.x-stripe[2].contentSize.width/2+11+square[i].contentSize.width/2+square[i].contentSize.width*(i-12)+2*(i-12), stripe[2].position.y);
    }
    for (int i=24; i<=35; i++)
    {
        place[i] = ccp(stripe[3].position.x-stripe[3].contentSize.width/2+11+square[i].contentSize.width/2+square[i].contentSize.width*(i-24)+2*(i-24), stripe[3].position.y);
    }
    for (int i=36; i<=47; i++)
    {
        place[i] = ccp(stripe[4].position.x-stripe[4].contentSize.width/2+11+square[i].contentSize.width/2+square[i].contentSize.width*(i-36)+2*(i-36), stripe[4].position.y);
    }
    for (int i=48; i<=59; i++)
    {
        place[i] = ccp(stripe[5].position.x-stripe[5].contentSize.width/2+11+square[i].contentSize.width/2+square[i].contentSize.width*(i-48)+2*(i-48), stripe[5].position.y);
    }
    for (int i=60; i<=71; i++)
    {
        place[i] = ccp(stripe[6].position.x-stripe[6].contentSize.width/2+11+square[i].contentSize.width/2+square[i].contentSize.width*(i-60)+2*(i-60), stripe[6].position.y);
    }
    for (int i=72; i<=83; i++)
    {
        place[i] = ccp(stripe[7].position.x-stripe[7].contentSize.width/2+11+square[i].contentSize.width/2+square[i].contentSize.width*(i-72)+2*(i-72), stripe[7].position.y);
    }
    
    for (int i=0; i<=6; i++)
    {
        for (int k=1+(12*i); k<=10+(12*i); k++)
        {
            squareMistakeText[k] = [CCLabelTTF labelWithString:@"" fontName:kFontComicSans fontSize:textFontSize];
            squareMistakeText[k].position = place[k];
            squareMistakeText[k].color = ccc3(50, 50, 50);
            [self addChild:squareMistakeText[k] z:3];
        }
    }
    
    [self randomPlaces];
    [self buttonsAppear];
    [self testSpritesAppear];
    [self schedule:@selector(timer) interval:1];
}

#pragma mark - Buttons Creating Method

- (void) setPropertiesForButton:(CCSprite *)button
                       buttonBg:(CCSprite *)buttonBg
                   buttonStroke:(CCSprite *)buttonStroke
                     buttonText:(CCSprite *)buttonText
                       position:(CGPoint)position
                          color:(ccColor3B)color
{
    buttonBg.position = position;
    buttonBg.color = color;
    buttonBg.opacity = 0;
    
    if (button == gamecenterButton)
        button.position = ccp(position.x, position.y+buttonBg.contentSize.height*0.02);
    else if (button == facebookButton || button == twitterButton || button == vkontakteButton)
        button.position = ccp(position.x, position.y+buttonBg.contentSize.height*0.04);
    else button.position = ccp(position.x, position.y+buttonBg.contentSize.height*0.075);
    button.color = color;
	button.opacity = 0;
    
    buttonStroke.position = position;
    buttonStroke.color = color;
    buttonStroke.opacity = 0;
    
    if (buttonText == previousText || buttonText == menuButtonText)
    {
        buttonText.position = ccp(position.x+buttonBg.contentSize.width*0.55, position.y);
        buttonText.anchorPoint = ccp(0, 0.5);
    }
    else if (buttonText == nextText)
    {
        buttonText.position = ccp(position.x-buttonBg.contentSize.width*0.55, position.y);
        buttonText.anchorPoint = ccp(1, 0.5);
    }
    buttonText.color = color;
    buttonText.opacity = 0;
}

#pragma mark - Actions

- (void) helpAction
{
    helpOnScreen = 1;
    
    id a11 = [CCMoveBy actionWithDuration:0.1 position:ccp(0, -help.contentSize.height)];
    id a12 = [CCDelayTime actionWithDuration:2];
    id a13 = [a11 reverse];
    id a14 = [CCCallFunc actionWithTarget:self selector:@selector(resetHelpOnScreen)];
    [bgSecond runAction:[CCSequence actions:a11, a12, a13, a14, nil]];
    
    id a21 = [CCMoveBy actionWithDuration:0.1 position:ccp(0, -help.contentSize.height)];
    id a22 = [CCDelayTime actionWithDuration:2];
    id a23 = [a21 reverse];
    [help runAction:[CCSequence actions:a21, a22, a23, nil]];
    
    id a31 = [CCMoveBy actionWithDuration:0.1 position:ccp(0, -help.contentSize.height)];
    id a32 = [CCDelayTime actionWithDuration:2];
    id a33 = [a31 reverse];
    [stripeL runAction:[CCSequence actions:a31, a32, a33, nil]];
}

- (void) resetHelpOnScreen
{
    helpOnScreen = 0;
}

#pragma mark - Рандом Квадратов

- (void) randomPlaces
{
    for (int i=0; i<=83; i=i+12) ////////// несдвигаемые заданные квадратики
    {
        square[i].position = ccp(place[i].x, place[i].y);
    }
    for (int i=11; i<=83; i=i+12)
    {
        square[i].position = ccp(place[i].x, place[i].y);
    }
    for (int i=0; i<=6; i++) ////////// сдвигаемые рандомные квадратики
    {
        array[i] = [NSMutableArray arrayWithCapacity:10];
        arraySupport[i] = [NSMutableArray arrayWithCapacity:10];
        
        for (int k=1+(12*i); k<=10+(12*i); k++)
        {
            NSNumber *numberOfSquare = [NSNumber numberWithInt:k];
            [array[i] addObject:square[k]];
            [arraySupport[i] addObject:numberOfSquare];
        }
        for (int k=1+(12*i); k<=10+(12*i); k++)
        {
            int random = arc4random() % array[i].count;
            
            CCSprite *squareFromArray = [array[i] objectAtIndex:random];
            int numberOfSquare = [[arraySupport[i] objectAtIndex:random] intValue];
            
            if (numberOfSquare != k || k-(12*i) == 10)
            {
                [array[i] removeObjectAtIndex:random];
                [arraySupport[i] removeObjectAtIndex:random];
                
                squareFromArray.position = place[k];
                
                newPlace[numberOfSquare] = k;
                lol[newPlace[numberOfSquare]] = numberOfSquare;
                
                if (k-(12*i) == 10 && numberOfSquare == k)
                {
                    CGPoint temp = square[k].position;
                    int temp2 = newPlace[k];
                    int temp3 = lol[newPlace[k]];
                    
                    square[k].position = square[k-1].position;
                    lol[newPlace[k]] = lol[newPlace[k-1]];
                    newPlace[k] = newPlace[k-1];
                    
                    square[k-1].position = temp;
                    lol[newPlace[k-1]] = temp3;
                    newPlace[k-1] = temp2;
                }
            }
            else k = k - 1;
        }
    }
    
    startTime = [NSDate date];
    [kStandartUserDefaults setValue:startTime forKey:@"timer"];
}

#pragma mark - Таймер

- (void) timer
{
    startTime = [kStandartUserDefaults objectForKey:@"timer"];
    endTime = [NSDate date];
    playTime = [endTime timeIntervalSinceDate:startTime];
    int playTimeSec = 0;
    int playTimeMin = 0;
    
    for (playTimeSec = playTime; playTimeSec >= 60; playTimeSec = playTimeSec - 60)
    {
        playTimeMin = playTimeMin + 1;
    }
    
    [timer setString:[NSString stringWithFormat:@"%.2d:%.2d", playTimeMin, playTimeSec]];
}

#pragma mark - Appear

- (void) buttonsAppear
{
    float duration = .3;
    int opacity = 255;
    
    if (gameFinish == 0 && mistakesOnScreen == 0)
    {
        previousButtonStroke.opacity = 255;
        previousButtonBg.opacity = 30;
        nextButtonStroke.opacity = 255;
        nextButtonBg.opacity = 30;
        
        [kLGKit spriteFade:previousButtonText duration:duration opacity:opacity];
        [kLGKit spriteFade:nextButtonText duration:duration opacity:opacity];
        [kLGKit spriteFade:timer duration:duration opacity:opacity];
    }
    else if (gameFinish == 1 && mistakesOnScreen == 1) [kLGKit spriteFade:nextButtonText duration:duration opacity:opacity];
}

- (void) testSpritesAppear ////////// появление теста
{
    for (int i=1; i<=7; i=i+2)
    {
        id a1 = [CCMoveBy actionWithDuration:0.16 position:ccp(-winSize.width*1.05, 0)];
        id a2 = [CCMoveBy actionWithDuration:0.08 position:ccp(winSize.width*0.1, 0)];
        id a3 = [CCMoveBy actionWithDuration:0.04 position:ccp(-winSize.width*0.05, 0)];
        [stripe[i] runAction:[CCSequence actions:a1, a2, a3, nil]];
    }
    for (int i=2; i<=6; i=i+2)
    {
        id a1 = [CCMoveBy actionWithDuration:0.16 position:ccp(winSize.width*1.05, 0)];
        id a2 = [CCMoveBy actionWithDuration:0.08 position:ccp(-winSize.width*0.1, 0)];
        id a3 = [CCMoveBy actionWithDuration:0.04 position:ccp(winSize.width*0.05, 0)];
        [stripe[i] runAction:[CCSequence actions:a1, a2, a3, nil]];
    }
    for (int i=0; i<=83; i++)
    {
        if ((i >= 0 && i <= 11) || (i >= 24 && i <= 35) || (i >= 48 && i <= 59) || (i >= 72 && i <= 83))
        {
            id a1 = [CCMoveBy actionWithDuration:0.16 position:ccp(-winSize.width*1.05, 0)];
            id a2 = [CCMoveBy actionWithDuration:0.08 position:ccp(winSize.width*0.1, 0)];
            id a3 = [CCMoveBy actionWithDuration:0.04 position:ccp(-winSize.width*0.05, 0)];
            [square[i] runAction:[CCSequence actions:a1, a2, a3, nil]];
            
            id a4 = [CCMoveBy actionWithDuration:0.16 position:ccp(-winSize.width*1.05, 0)];
            id a5 = [CCMoveBy actionWithDuration:0.08 position:ccp(winSize.width*0.1, 0)];
            id a6 = [CCMoveBy actionWithDuration:0.04 position:ccp(-winSize.width*0.05, 0)];
            [squareMistakeText[i] runAction:[CCSequence actions:a4, a5, a6, nil]];
            
            place[i].x = place[i].x - winSize.width;
        }
        else if ((i >= 12 && i <= 23) || (i >= 36 && i <= 47) || (i >= 60 && i <= 71))
        {
            id a1 = [CCMoveBy actionWithDuration:0.16 position:ccp(winSize.width*1.05, 0)];
            id a2 = [CCMoveBy actionWithDuration:0.08 position:ccp(-winSize.width*0.1, 0)];
            id a3 = [CCMoveBy actionWithDuration:0.04 position:ccp(winSize.width*0.05, 0)];
            [square[i] runAction:[CCSequence actions:a1, a2, a3, nil]];
            
            id a4 = [CCMoveBy actionWithDuration:0.16 position:ccp(winSize.width*1.05, 0)];
            id a5 = [CCMoveBy actionWithDuration:0.08 position:ccp(-winSize.width*0.1, 0)];
            id a6 = [CCMoveBy actionWithDuration:0.04 position:ccp(winSize.width*0.05, 0)];
            [squareMistakeText[i] runAction:[CCSequence actions:a4, a5, a6, nil]];
            
            place[i].x = place[i].x + winSize.width;
        }
    }
    
    float duration = .28;
    int opacity = 255;
    
    if (gameFinish == 0 && mistakesOnScreen == 0) [nextText setString:LGLocalizedString(@"finish", nil)];
    else if (gameFinish == 1 && mistakesOnScreen == 1) [nextText setString:LGLocalizedString(@"results", nil)];
    
    if (gameFinish == 0 && mistakesOnScreen == 0) [kLGKit spriteFade:previousText duration:duration opacity:opacity];
    [kLGKit spriteFade:nextText duration:duration opacity:opacity];
    
    [kLGKit buttonUnselect:previousButtonBg color:kColorDark];
    [kLGKit buttonUnselect:nextButtonBg color:kColorDark];
}

- (void) finishSpritesAppear ////////// появление результатов
{
    float duration = .3;
    int opacity = 255;
    
    [previousText setString:LGLocalizedString(@"tryAgain", nil)];
    [nextText setString:LGLocalizedString(@"showMistakes", nil)];
    
    [kLGKit spriteFade:results duration:duration opacity:opacity];
    [kLGKit spriteFade:mistakesText duration:duration opacity:opacity];
    [kLGKit spriteFade:mistakesResult duration:duration opacity:opacity];
    [kLGKit spriteFade:timeText duration:duration opacity:opacity];
    [kLGKit spriteFade:timer duration:duration opacity:opacity];
    [kLGKit spriteFade:squaresMovedText duration:duration opacity:opacity];
    [kLGKit spriteFade:squaresMovedResult duration:duration opacity:opacity];
    [kLGKit spriteFade:scoreText duration:duration opacity:opacity];
    [kLGKit spriteFade:scoreResult duration:duration opacity:opacity];
    if (gameFinish == 1 && mistakesOnScreen == 0) [kLGKit spriteFade:tryAgainButtonImg duration:duration opacity:opacity];
    if (gameFinish == 1 && mistakesOnScreen == 0) [kLGKit spriteFade:previousText duration:duration opacity:opacity];
    [kLGKit spriteFade:showMistakesButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:nextText duration:duration opacity:opacity];
    [kLGKit spriteFade:menuButton duration:duration opacity:opacity];
    [kLGKit spriteFade:menuButtonBg duration:duration opacity:30];
    [kLGKit spriteFade:menuButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:menuButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:gamecenterButton duration:duration opacity:opacity];
    [kLGKit spriteFade:gamecenterButtonBg duration:duration opacity:30];
    [kLGKit spriteFade:gamecenterButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:facebookButton duration:duration opacity:opacity];
    [kLGKit spriteFade:facebookButtonBg duration:duration opacity:30];
    [kLGKit spriteFade:facebookButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:twitterButton duration:duration opacity:opacity];
    [kLGKit spriteFade:twitterButtonBg duration:duration opacity:30];
    [kLGKit spriteFade:twitterButtonStroke duration:duration opacity:opacity];
    if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"])
    {
        [kLGKit spriteFade:vkontakteButton duration:duration opacity:opacity];
        [kLGKit spriteFade:vkontakteButtonBg duration:duration opacity:30];
        [kLGKit spriteFade:vkontakteButtonStroke duration:duration opacity:opacity];
    }
    
    [kLGKit buttonUnselect:previousButtonBg color:kColorDark];
    [kLGKit buttonUnselect:nextButtonBg color:kColorDark];
}

#pragma mark - Disappear

- (void) buttonsDisappear
{
    float duration = .28;
    int opacity = 0;
    
    if ((gameFinish == 0 && mistakesOnScreen == 0) || tryAgain) [kLGKit spriteFade:previousButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:nextButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:timer duration:duration opacity:opacity];
    if (tryAgain) [kLGKit spriteFade:tryAgainButtonImg duration:duration opacity:opacity];
}

- (void) testSpritesDisappear ////////// исчезновение теста
{
    for (int i=1; i<=7; i=i+2)
    {
        id a1 = [CCMoveBy actionWithDuration:0.04 position:ccp(-winSize.width*0.05, 0)];
        id a2 = [CCMoveBy actionWithDuration:0.16 position:ccp(winSize.width*1.05, 0)];
        [stripe[i] runAction:[CCSequence actions:a1, a2, nil]];
    }
    for (int i=2; i<=6; i=i+2)
    {
        id a1 = [CCMoveBy actionWithDuration:0.04 position:ccp(winSize.width*0.05, 0)];
        id a2 = [CCMoveBy actionWithDuration:0.16 position:ccp(-winSize.width*1.05, 0)];
        [stripe[i] runAction:[CCSequence actions:a1, a2, nil]];
    }
    for (int i=0; i<=83; i++)
    {
        if ((i >= 0 && i <= 11) || (i >= 24 && i <= 35) || (i >= 48 && i <= 59) || (i >= 72 && i <= 83))
        {
            id a1 = [CCMoveBy actionWithDuration:0.04 position:ccp(-winSize.width*0.05, 0)];
            id a2 = [CCMoveBy actionWithDuration:0.16 position:ccp(winSize.width*1.05, 0)];
            [square[i] runAction:[CCSequence actions:a1, a2, nil]];
            
            id a3 = [CCMoveBy actionWithDuration:0.04 position:ccp(-winSize.width*0.05, 0)];
            id a4 = [CCMoveBy actionWithDuration:0.16 position:ccp(winSize.width*1.05, 0)];
            [squareMistakeText[i] runAction:[CCSequence actions:a3, a4, nil]];
            
            place[i].x = place[i].x + winSize.width;
        }
        else if ((i >= 12 && i <= 23) || (i >= 36 && i <= 47) || (i >= 60 && i <= 71))
        {
            id a1 = [CCMoveBy actionWithDuration:0.04 position:ccp(winSize.width*0.05, 0)];
            id a2 = [CCMoveBy actionWithDuration:0.16 position:ccp(-winSize.width*1.05, 0)];
            [square[i] runAction:[CCSequence actions:a1, a2, nil]];
            
            id a3 = [CCMoveBy actionWithDuration:0.04 position:ccp(winSize.width*0.05, 0)];
            id a4 = [CCMoveBy actionWithDuration:0.16 position:ccp(-winSize.width*1.05, 0)];
            [squareMistakeText[i] runAction:[CCSequence actions:a3, a4, nil]];
            
            place[i].x = place[i].x - winSize.width;
        }
    }
    
    float duration = .2;
    int opacity = 0;
    
	if ((gameFinish == 0 && mistakesOnScreen == 0) || tryAgain) [kLGKit spriteFade:previousText duration:duration opacity:opacity];
    [kLGKit spriteFade:nextText duration:duration opacity:opacity];
}

- (void) finishSpritesDisappear ////////// исчезновение результатов
{
    float duration = .3;
    int opacity = 0;
    
	[kLGKit spriteFade:results duration:duration opacity:opacity];
    [kLGKit spriteFade:mistakesText duration:duration opacity:opacity];
    [kLGKit spriteFade:mistakesResult duration:duration opacity:opacity];
    [kLGKit spriteFade:timeText duration:duration opacity:opacity];
    [kLGKit spriteFade:timer duration:duration opacity:opacity];
    [kLGKit spriteFade:squaresMovedText duration:duration opacity:opacity];
    [kLGKit spriteFade:squaresMovedResult duration:duration opacity:opacity];
    [kLGKit spriteFade:scoreText duration:duration opacity:opacity];
    [kLGKit spriteFade:scoreResult duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 1 || tryAgain == 1) [kLGKit spriteFade:tryAgainButtonImg duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 1 || tryAgain == 1) [kLGKit spriteFade:previousText duration:duration opacity:opacity];
    [kLGKit spriteFade:showMistakesButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:nextText duration:duration opacity:opacity];
    [kLGKit spriteFade:menuButton duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 0) [kLGKit spriteFade:menuButtonBg duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 0) [kLGKit spriteFade:menuButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:menuButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:gamecenterButton duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 0) [kLGKit spriteFade:gamecenterButtonBg duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 0) [kLGKit spriteFade:gamecenterButtonStroke duration:duration opacity:opacity];
    
    [kLGKit spriteFade:facebookButton duration:duration opacity:opacity];
    [kLGKit spriteFade:facebookButtonBg duration:duration opacity:opacity];
    [kLGKit spriteFade:facebookButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:twitterButton duration:duration opacity:opacity];
    [kLGKit spriteFade:twitterButtonBg duration:duration opacity:opacity];
    [kLGKit spriteFade:twitterButtonStroke duration:duration opacity:opacity];
    if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"])
    {
        [kLGKit spriteFade:vkontakteButton duration:duration opacity:opacity];
        [kLGKit spriteFade:vkontakteButtonBg duration:duration opacity:opacity];
        [kLGKit spriteFade:vkontakteButtonStroke duration:duration opacity:opacity];
    }
}

#pragma mark - Переходы

- (void) goToMenu
{
    [[CCDirector sharedDirector] replaceScene:[MainMenuLayer scene]];
}

- (void) goToTryAgain
{
    [[CCDirector sharedDirector] replaceScene:[TestLayer_iPad scene]];
}

#pragma mark - Результаты

- (void) finish ////////// результаты
{
	[self unschedule:@selector(timer)];
    int numberOfMistakes = 0;
    
    for (int i=0; i<=6; i++)
    {
        for (int k=1+(12*i); k<=10+(12*i); k++)
        {
            if (k != newPlace[k])
            {
                numberOfMistakes = numberOfMistakes + 1;
                
                if (k-newPlace[k] > 0) [squareMistakeText[newPlace[k]] setString:[NSString stringWithFormat:@"%d>", k-newPlace[k]]];
                else [squareMistakeText[newPlace[k]] setString:[NSString stringWithFormat:@"<%d", newPlace[k]-k]];
            }
        }
    }
    
    [mistakesResult setString:[NSString stringWithFormat:@"%d", numberOfMistakes]];
    timer.position = ccp(winSize.width*0.52, timeText.position.y);
    timer.anchorPoint = ccp(0, 0.5);
    [squaresMovedResult setString:[NSString stringWithFormat:@"%d", squaresMoved]];
    
    float scoreMistake = (70-(float)numberOfMistakes)*100;
    float scoreTime = (250-(float)playTime)*35;
    float scoreMoves = (100-(float)squaresMoved)*35;
    
    if (scoreTime < 0 || playTime <= 5) scoreTime = 0;
    if (scoreMoves < 0 || squaresMoved == 0) scoreMoves = 0;
    
    int score = (scoreMistake+scoreTime+scoreMoves)/((float)numberOfMistakes/2+1);
    [scoreResult setString:[NSString stringWithFormat:@"%d", score]];
    
    [kLGGameCenter submitScore:score forCategory:@"com.ApogeeStudio.CheckYourCV.Score" withAlert:NO];
    
    NSMutableArray *highscoreArray = [NSMutableArray array];
    [highscoreArray addObject:[NSNumber numberWithInteger:numberOfMistakes]];
    [highscoreArray addObject:[NSNumber numberWithInteger:playTime]];
    [highscoreArray addObject:[NSNumber numberWithInteger:squaresMoved]];
    [highscoreArray addObject:[NSNumber numberWithInteger:score]];
    
    NSMutableArray *highscoresArray = [NSMutableArray arrayWithArray:[kStandartUserDefaults arrayForKey:@"highscoresArray"]];
    
    if (highscoresArray.count == 0) [highscoresArray addObject:highscoreArray];
    else if (highscoresArray.count < 6)
    {
        BOOL insertIsDone = NO;
        for (int i=0; i<highscoresArray.count; i++)
        {
            NSArray *tempArray = [highscoresArray objectAtIndex:i];
            int tempScore = [[tempArray objectAtIndex:3] intValue];
            if (score == tempScore)
            {
                insertIsDone = YES;
                break;
            }
            else if (score > tempScore)
            {
                [highscoresArray insertObject:highscoreArray atIndex:i];
                insertIsDone = YES;
                break;
            }
        }
        if (insertIsDone == NO) [highscoresArray addObject:highscoreArray];
    }
    else if (highscoresArray.count == 6)
        for (int i=0; i<6; i++)
        {
            NSArray *tempArray = [highscoresArray objectAtIndex:i];
            int tempScore = [[tempArray objectAtIndex:3] intValue];
            if (score > tempScore)
            {
                [highscoresArray removeLastObject];
                [highscoresArray insertObject:highscoreArray atIndex:i];
                break;
            }
        }
    
    [kStandartUserDefaults setObject:highscoresArray forKey:@"highscoresArray"];
    
    [kLGGameCenter submitAchievement:@"com.ApogeeStudio.CheckYourCV.Dilettante" percentComplete:100]; // дилетант / dilettante
    if (numberOfMistakes <= 35) [kLGGameCenter submitAchievement:@"com.ApogeeStudio.CheckYourCV.Beginner" percentComplete:100]; // начинающий / beginner
    if (numberOfMistakes <= 5) [kLGGameCenter submitAchievement:@"com.ApogeeStudio.CheckYourCV.Amateur" percentComplete:100]; // любитель / amateur
    if (numberOfMistakes == 0) [kLGGameCenter submitAchievement:@"com.ApogeeStudio.CheckYourCV.Specialist" percentComplete:100]; // специалист / specialist
    if (numberOfMistakes == 0 && playTime <= 180) [kLGGameCenter submitAchievement:@"com.ApogeeStudio.CheckYourCV.Professional" percentComplete:100]; // профессионал / professional
    if (numberOfMistakes == 0 && playTime <= 150) [kLGGameCenter submitAchievement:@"com.ApogeeStudio.CheckYourCV.Master" percentComplete:100]; // мастер / master
    if (numberOfMistakes == 0 && playTime <= 120) [kLGGameCenter submitAchievement:@"com.ApogeeStudio.CheckYourCV.Guru" percentComplete:100]; // гуру / guru
    if (numberOfMistakes == 0 && playTime <= 90) [kLGGameCenter submitAchievement:@"com.ApogeeStudio.CheckYourCV.HawkEyed" percentComplete:100]; // зоркий глаз / hawkEyed
    if (numberOfMistakes == 0 && playTime <= 60) [kLGGameCenter submitAchievement:@"com.ApogeeStudio.CheckYourCV.Legend" percentComplete:100]; // легенда / legend
    if (numberOfMistakes == 0 && squaresMoved <= 35) [kLGGameCenter submitAchievement:@"com.ApogeeStudio.CheckYourCV.Strategist" percentComplete:100]; // стратег / strategist
    
    [self finishSpritesAppear];
    [kLGKit buttonUnselect:nextButtonBg color:kColorDark];
}

#pragma mark - Sounds

- (void) soundButton
{
    [kSimpleAudioEngine playEffect:@"soundButton.wav" pitch:1 pan:0 gain:0.8];
}

- (void) soundChoose
{
    [kSimpleAudioEngine playEffect:@"soundButton.wav" pitch:1.3 pan:0 gain:0.8];
}

#pragma mark - Alert Delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == alertGC)
    {
        if (buttonIndex == 1) [kLGGameCenter showLeaderboard:@"score"];
        else if (buttonIndex == 2) [kLGGameCenter showAchievements];
        
        [kLGKit buttonUnselect:gamecenterButtonBg color:kColorDark];
    }
    else if (alertView == alertVK)
    {
        Vkontakte *vk = kVkontakte;
        vk.delegate = self;
        
        if (buttonIndex == 1)
        {
            int bestScore;
            if ([kStandartUserDefaults arrayForKey:@"highscoresArray"])
            {
                NSMutableArray *highscoresArray = [NSMutableArray arrayWithArray:[kStandartUserDefaults arrayForKey:@"highscoresArray"]];
                NSArray *highscoreArray = [highscoresArray objectAtIndex:0];
                bestScore = [[highscoreArray objectAtIndex:3] intValue];
            }
            else bestScore = 0;
            
            CCScene *scene = [[CCDirector sharedDirector] runningScene];
            
            [vk postImageToWall:[self screenshotWithScene:scene]
                           text:[NSString stringWithFormat:@"%@ %i очков!\n%@", LGLocalizedString(@"postTextFb", nil), bestScore, LGLocalizedString(@"postEnd", nil)]
                           link:[NSURL URLWithString:@"http://j.mp/XhUr1z"]];
        }
        else if (buttonIndex == 2) [vk logout];
    }
}

#pragma mark

- (UIImage *) screenshotWithScene:(CCScene *)scene
{
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    
    CCNode *node = [scene.children objectAtIndex:0];
    CCRenderTexture *rtx = [CCRenderTexture renderTextureWithWidth:winSize.width height:winSize.height];
    
    [rtx begin];
    [node visit];
    [rtx end];
    
    return [rtx getUIImage];
}

#pragma mark - Touches Controller

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	touch = [touches anyObject];
	touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    if (CGRectContainsPoint(nextButtonBg.boundingBox, touchPoint)) ////////// next
    {
        [kLGKit buttonSelect:nextButtonBg color:kColorLight];
        [self soundButton];
        z = 1;
    }
    else if (CGRectContainsPoint(previousButtonBg.boundingBox, touchPoint)) ////////// previous
    {
        [kLGKit buttonSelect:previousButtonBg color:kColorLight];
        [self soundButton];
        z = 2;
    }
    else if (CGRectContainsPoint(menuButtonBg.boundingBox, touchPoint) && gameFinish == 1 && mistakesOnScreen == 0) ////////// menu
    {
        [kLGKit buttonSelect:menuButtonBg color:kColorLight];
        [self soundButton];
        z = 3;
    }
    else if (CGRectContainsPoint(gamecenterButtonBg.boundingBox, touchPoint) && gameFinish == 1 && mistakesOnScreen == 0) ////////// gamecenter
    {
        [kLGKit buttonSelect:gamecenterButtonBg color:kColorLight];
        [self soundButton];
        z = 4;
    }
    else if (CGRectContainsPoint(facebookButtonBg.boundingBox, touchPoint) && gameFinish == 1 && mistakesOnScreen == 0) ////////// Facebook
	{
        [self soundButton];
        
        if (kInternetStatus)
        {
            int bestScore;
            if ([kStandartUserDefaults arrayForKey:@"highscoresArray"])
            {
                NSMutableArray *highscoresArray = [NSMutableArray arrayWithArray:[kStandartUserDefaults arrayForKey:@"highscoresArray"]];
                NSArray *highscoreArray = [highscoresArray objectAtIndex:0];
                bestScore = [[highscoreArray objectAtIndex:3] intValue];
            }
            else bestScore = 0;
            
            //if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            
            UINavigationController *navigationController = [(AppController *)[[UIApplication sharedApplication] delegate] navigationController];
            
            NSString *secondText = [NSString new];
            if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"]) secondText = @"очков";
            else secondText = @"points";
            
            if (kOSVersion >= 6)
            {
                SLComposeViewController *facebookVC = [SLComposeViewController new];
                
                facebookVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                [facebookVC setCompletionHandler:^(SLComposeViewControllerResult result)
                 {
                     switch (result)
                     {
                         case SLComposeViewControllerResultCancelled:
                             NSLog(@"Facebook Post Cancelled");
                             break;
                         case SLComposeViewControllerResultDone:
                             NSLog(@"Facebook Post Sucessful");
                             break;
                         default:
                             break;
                     }
                     
                     [navigationController dismissModalViewControllerAnimated:YES];
                 }];
                
                [facebookVC setInitialText:[NSString stringWithFormat:@"%@ %i %@!\n%@", LGLocalizedString(@"postTextFb", nil), bestScore, secondText, LGLocalizedString(@"postEnd", nil)]];
                if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"]) [facebookVC addURL:[NSURL URLWithString:@"http://bit.ly/XhUr1z"]];
                else [facebookVC addURL:[NSURL URLWithString:@"http://bit.ly/14CHNNe"]];
                //[facebookVC addURL:[NSURL URLWithString:LGLocalizedString(@"postURL", nil)]];
                [facebookVC addImage:nil];
                
                [navigationController presentViewController:facebookVC animated:YES completion:nil];
            }
            else
            {
                DEFacebookComposeViewController *facebookVC = [DEFacebookComposeViewController new];
                
                [facebookVC setCompletionHandler:^(DEFacebookComposeViewControllerResult result)
                 {
                     switch (result)
                     {
                         case DEFacebookComposeViewControllerResultCancelled:
                             NSLog(@"Facebook Post Cancelled");
                             break;
                         case DEFacebookComposeViewControllerResultDone:
                             NSLog(@"Facebook Post Sucessful");
                             break;
                         default:
                             break;
                     }
                     
                     [navigationController dismissModalViewControllerAnimated:YES];
                 }];
                
                [facebookVC setInitialText:[NSString stringWithFormat:@"%@ %i %@!\n%@", LGLocalizedString(@"postTextFb", nil), bestScore, secondText, LGLocalizedString(@"postEnd", nil)]];
                if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"]) [facebookVC addURL:[NSURL URLWithString:@"http://bit.ly/XhUr1z"]];
                else [facebookVC addURL:[NSURL URLWithString:@"http://bit.ly/14CHNNe"]];
                //[facebookVC addURL:[NSURL URLWithString:LGLocalizedString(@"postURL", nil)]];
                [facebookVC addImage:nil];
                
                navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
                [navigationController presentViewController:facebookVC animated:YES completion:nil];
            }
        }
        else [kLGKit createAlertNoInternet];
	}
    else if (CGRectContainsPoint(twitterButtonBg.boundingBox, touchPoint) && gameFinish == 1 && mistakesOnScreen == 0) ////////// Twitter
	{
        [self soundButton];
        
        if (kInternetStatus)
        {
            int bestScore;
            if ([kStandartUserDefaults arrayForKey:@"highscoresArray"])
            {
                NSMutableArray *highscoresArray = [NSMutableArray arrayWithArray:[kStandartUserDefaults arrayForKey:@"highscoresArray"]];
                NSArray *highscoreArray = [highscoresArray objectAtIndex:0];
                bestScore = [[highscoreArray objectAtIndex:3] intValue];
            }
            else bestScore = 0;
            
            //if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            
            UINavigationController *navigationController = [(AppController *)[[UIApplication sharedApplication] delegate] navigationController];
            
            NSString *secondText = [NSString new];
            if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"]) secondText = @"очков";
            else secondText = @"points";
            
            if (kOSVersion >= 6)
            {
                SLComposeViewController *twitterVC = [SLComposeViewController new];
                
                twitterVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                [twitterVC setCompletionHandler:^(SLComposeViewControllerResult result)
                 {
                     switch (result)
                     {
                         case SLComposeViewControllerResultCancelled:
                             NSLog(@"Twitter Post Cancelled");
                             break;
                         case SLComposeViewControllerResultDone:
                             NSLog(@"Twitter Post Sucessful");
                             break;
                         default:
                             break;
                     }
                     
                     [navigationController dismissModalViewControllerAnimated:YES];
                 }];
                
                [twitterVC setInitialText:[NSString stringWithFormat:@"#CheckYourColorVision\n%@ %i %@!\n%@\n", LGLocalizedString(@"postTextTw", nil), bestScore, secondText, LGLocalizedString(@"postEnd", nil)]];
                
                CCScene *scene = [[CCDirector sharedDirector] runningScene];
                [twitterVC addImage:[self screenshotWithScene:scene]];
                
                if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"]) [twitterVC addURL:[NSURL URLWithString:@"j.mp/XhUr1z"]];
                else [twitterVC addURL:[NSURL URLWithString:@"j.mp/14CHNNe"]];
                
                [navigationController presentViewController:twitterVC animated:YES completion:nil];
            }
            else
            {
                TWTweetComposeViewController *twitterVC = [TWTweetComposeViewController new];
                
                [twitterVC setCompletionHandler:^(TWTweetComposeViewControllerResult result)
                 {
                     switch (result)
                     {
                         case TWTweetComposeViewControllerResultCancelled:
                             NSLog(@"Twitter Post Cancelled");
                             break;
                         case TWTweetComposeViewControllerResultDone:
                             NSLog(@"Twitter Post Sucessful");
                             break;
                         default:
                             break;
                     }
                     
                     [navigationController dismissModalViewControllerAnimated:YES];
                 }];
                
                [twitterVC setInitialText:[NSString stringWithFormat:@"#CheckYourColorVision\n%@ %i %@!\n%@\n", LGLocalizedString(@"postTextTw", nil), bestScore, secondText, LGLocalizedString(@"postEnd", nil)]];
                
                CCScene *scene = [[CCDirector sharedDirector] runningScene];
                [twitterVC addImage:[self screenshotWithScene:scene]];
                
                if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"]) [twitterVC addURL:[NSURL URLWithString:@"j.mp/XhUr1z"]];
                else [twitterVC addURL:[NSURL URLWithString:@"j.mp/14CHNNe"]];
                
                [navigationController presentViewController:twitterVC animated:YES completion:nil];
            }
        }
        else [kLGKit createAlertNoInternet];
	}
    else if (CGRectContainsPoint(vkontakteButtonBg.boundingBox, touchPoint) && [LGLocalizationGetPreferredLanguage isEqualToString:@"ru"] && gameFinish == 1 && mistakesOnScreen == 0) ////////// ВКонтакте
	{
        [self soundButton];
        
        if (kInternetStatus)
        {
            Vkontakte *vk = kVkontakte;
            vk.delegate = self;
            
            if (![vk isAuthorized]) [vk authenticate];
            else
            {
                alertVK = [[UIAlertView alloc] initWithTitle:nil
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"Закрыть"
                                           otherButtonTitles:@"Запостить результат", @"Выйти из аккаунта", nil];
                [alertVK show];
            }
        }
        else [kLGKit createAlertNoInternet];
	}
    else if (mistakesOnScreen == 0)
    {
        for (int i=0; i<=6; i++) ////////// сдвигаемые рандомные квадратики
        {
            for (int k=1+(12*i); k<=10+(12*i); k++)
            {
                if (CGRectContainsPoint(square[k].boundingBox, touchPoint))
                {
                    take = 1;
                    number = k;
                    
                    [self reorderChild:square[number] z:4];
                    
                    squareBig.position = square[number].position;
                    squareBig.visible = 1;
                    
                    //NSLog(@"Real Number (number) = %d", number);
                    //NSLog(@"New Number (newPlace[number]) = %d", newPlace[number]);
                    //NSLog(@"lol[newPlace[number]] = %d", lol[newPlace[number]]);
                }
            }
            for (int k=(12*i); k == (12*i) || k == (12*i) + 11; k+=11)
            {
                if (CGRectContainsPoint(square[k].boundingBox, touchPoint) && helpOnScreen == 0)
                {
                    [self soundChoose];
                    [self helpAction];
                }
            }
        }
    }
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    touch = [touches anyObject];
	touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    if (take == 1)
    {
        square[number].position = ccp(touchPoint.x, square[number].position.y);
        
        if (square[number].position.x <= place[1].x)
        {
            square[number].position = ccp(place[1].x, square[number].position.y);
        }
        else if (square[number].position.x >= place[10].x)
        {
            square[number].position = ccp(place[10].x, square[number].position.y);
        }
        
        if (ccpDistance(square[number].position, square[lol[newPlace[number]+1]].position) < square[number].contentSize.width/2 && square[number].position.y == square[lol[newPlace[number]+1]].position.y)
        {
            int q1 = lol[newPlace[number]+1];
            int q2 = newPlace[number];
            
            square[q1].position = place[q2];
            
            int k1 = newPlace[number];
            int k2 = lol[newPlace[number]];
            
            newPlace[number] = newPlace[number]+1;
            lol[k1] = lol[k1+1];
            
            newPlace[lol[k1+1]] = k1;
            lol[k1+1] = k2;
        }
        else if (ccpDistance(square[number].position, square[lol[newPlace[number]-1]].position) < square[number].contentSize.width/2 && square[number].position.y == square[lol[newPlace[number]-1]].position.y)
        {
            int q1 = lol[newPlace[number]-1];
            int q2 = newPlace[number];
            
            square[q1].position = place[q2];
            
            int k1 = newPlace[number];
            int k2 = lol[newPlace[number]];
            
            newPlace[number] = newPlace[number]-1;
            lol[k1] = lol[k1-1];
            
            newPlace[lol[k1-1]] = k1;
            lol[k1-1] = k2;
        }
        
        squareBig.position = square[number].position;
    }
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    touch = [touches anyObject];
	touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    if (CGRectContainsPoint(nextButtonBg.boundingBox, touchPoint) && z == 1) ////////// next
    {
        self.isTouchEnabled = NO;
        
        if (gameFinish == 0 && mistakesOnScreen == 0) //  finish
        {
            [self buttonsDisappear];
            [self testSpritesDisappear];
            
            [self performSelector:@selector(finish) withObject:nil afterDelay:0.3];
            
            [kLGKit performSelector:@selector(touchEnableWithTarget:) withObject:self afterDelay:0.6];
            
            gameFinish = 1;
        }
        else if (gameFinish == 1 && mistakesOnScreen == 0) // show mistakes
        {
            [self finishSpritesDisappear];
            
            [self performSelector:@selector(buttonsAppear) withObject:nil afterDelay:0.3];
            [self performSelector:@selector(testSpritesAppear) withObject:nil afterDelay:0.3];
            
            [kLGKit performSelector:@selector(touchEnableWithTarget:) withObject:self afterDelay:0.6];
            
            mistakesOnScreen = 1;
        }
        else if (gameFinish == 1 && mistakesOnScreen == 1) // results
        {
            [self buttonsDisappear];
            [self testSpritesDisappear];
            
            [self performSelector:@selector(finishSpritesAppear) withObject:nil afterDelay:0.3];
            
            [kLGKit performSelector:@selector(touchEnableWithTarget:) withObject:self afterDelay:0.6];
            
            mistakesOnScreen = 0;
        }
    }
    else if (z == 1) [kLGKit buttonUnselect:nextButtonBg color:kColorDark];
    
    if (CGRectContainsPoint(previousButtonBg.boundingBox, touchPoint) && z == 2) ////////// previous
    {
        self.isTouchEnabled = NO;
        
        if (gameFinish == 0 && mistakesOnScreen == 0) // menu
        {
            self.isTouchEnabled = NO;
            
            [kStandartUserDefaults setInteger:1 forKey:@"goToMenuFromTest"];
            
            [self testSpritesDisappear];
            [self buttonsDisappear];
            [self performSelector:@selector(goToMenu) withObject:nil afterDelay:0.3];
        }
        else if (gameFinish == 1 && mistakesOnScreen == 1) // restart
        {
            tryAgain = 1;
            
            [self buttonsDisappear];
            [self testSpritesDisappear];
            
            [self performSelector:@selector(goToTryAgain) withObject:nil afterDelay:0.3];
        }
        else if (gameFinish == 1 && mistakesOnScreen == 0) // restart
        {
            tryAgain = 1;
            
            [self finishSpritesDisappear];
            
            [self performSelector:@selector(goToTryAgain) withObject:nil afterDelay:0.3];
        }
    }
    else if (z == 2) [kLGKit buttonUnselect:previousButtonBg color:kColorDark];
    
    if (CGRectContainsPoint(menuButtonBg.boundingBox, touchPoint) && z == 3) ////////// menu
    {
        self.isTouchEnabled = NO;
        
        [kStandartUserDefaults setInteger:1 forKey:@"goToMenuFromResults"];
        
        [self finishSpritesDisappear];
        
        [self performSelector:@selector(goToMenu) withObject:nil afterDelay:0.3];
    }
    else if (z == 3) [kLGKit buttonUnselect:menuButtonBg color:kColorDark];
    
    if (CGRectContainsPoint(gamecenterButtonBg.boundingBox, touchPoint) && z == 4) ////////// gamecenter
    {
        alertGC = [[UIAlertView alloc] initWithTitle:nil
                                             message:nil
                                            delegate:self
                                   cancelButtonTitle:LGLocalizedString(@"cancel", nil)
                                   otherButtonTitles:LGLocalizedString(@"leaderboards", nil), LGLocalizedString(@"achievements", nil), nil];
        [alertGC show];
    }
    else if (z == 4) [kLGKit buttonUnselect:gamecenterButtonBg color:kColorDark];
    
    if (take == 1) ////////// сдвигаемые рандомные квадратики
    {
        take = 0;
        z = 0;
        
        square[number].position = place[newPlace[number]];
        
        squareBig.visible = 0;
        
        [self reorderChild:square[number] z:2];
        
        squaresMoved = squaresMoved + 1;
        
        [self soundChoose];
    }
    
    z = 0;
}

#pragma mark - VkontakteDelegate

- (void)vkontakteDidFailedWithError:(NSError *)error
{
    [kNavController dismissModalViewControllerAnimated:YES];
    
    [[[UIAlertView alloc] initWithTitle:@"Ошибка"
                                message:@"Произошла ошибка. Повторите попытку позже."
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)showVkontakteAuthController:(UIViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [kNavController presentModalViewController:controller animated:YES];
}

- (void)vkontakteAuthControllerDidCancelled
{
    [kNavController dismissModalViewControllerAnimated:YES];
}

- (void)vkontakteDidFinishLogin:(Vkontakte *)vkontakte
{
    [kNavController dismissModalViewControllerAnimated:YES];
    
    alertVK = [[UIAlertView alloc] initWithTitle:nil
                                         message:nil
                                        delegate:self
                               cancelButtonTitle:@"Закрыть"
                               otherButtonTitles:@"Запостить результат", @"Выйти из аккаунта", nil];
    [alertVK show];
}

- (void)vkontakteDidFinishGettinUserInfo:(NSDictionary *)info
{
    NSLog(@"VK Info: %@", info);
}

- (void)vkontakteDidFinishPostingToWall:(NSDictionary *)responce
{
    [[[UIAlertView alloc] initWithTitle:@"Готово"
                                message:@"Вы успешно отправили результат на стену."
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    
    NSLog(@"VK finish posting to wall: %@", responce);
}

@end
