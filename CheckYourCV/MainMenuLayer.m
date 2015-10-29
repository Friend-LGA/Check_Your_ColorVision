//
//  Created by Grigory Lutkov on 01.10.12.
//  Copyright (c) 2012 Grigory Lutkov. All rights reserved.
//

#import "MainMenuLayer.h"
#import "TestLayer_iPhone.h"
#import "TestLayer_iPad.h"
#import "SimpleAudioEngine.h"
#import "LGLocalization.h"
#import "LGGameCenter.h"
#import "LGInAppPurchases.h"
#import "LGReachability.h"
#import "LGKit.h"
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import "DEFacebookComposeViewController.h"

#pragma mark - MainMenuLayer

@implementation MainMenuLayer

+ (CCScene *) scene
{
	CCScene *scene = [CCScene node];
	MainMenuLayer *layer = [MainMenuLayer node];
	[scene addChild:layer];
	return scene;
}

//////////////////////////////////////////////////////////////////////////////////////////////////// init

- (id) init
{
	if ((self = [super init]))
    {
		self.isTouchEnabled = YES;
        winSize = [[CCDirector sharedDirector] winSize];
        [kStandartUserDefaults setInteger:0 forKey:@"goToTest"];
        
        [self checkAds];
        
        if (kDevicePad) [self settings_iPad];
		else if (kDevicePhone) [self settings_iPhone];
        
        [self menuInit];
	}
	return self;
}

#pragma mark - Check Settings

- (void) settings_iPhone
{
    if (kIsGameFull) titleFontSize = 26;
    else if (!kIsGameFull) titleFontSize = 22;
    if (kIsGameFull) aboutTextFontSize = 13;
    else if (!kIsGameFull) aboutTextFontSize = 12;
    buttonsBgFontSize = 55;
    closeButtonFontSize = 20;
    closeButtonBgFontSize = 25;
    buttonsTextFontSize = 9;
    playButtonTextFontSize = 22;
    aboutButtonFontSize = 37;
    textButtonsFontSize = 17;
    socialButtonsFontSize = 34;
}

- (void) settings_iPad
{
    titleFontSize = 52;
    aboutTextFontSize = 24;
    buttonsBgFontSize = 110;
    closeButtonFontSize = 40;
    closeButtonBgFontSize = 50;
    buttonsTextFontSize = 24;
    playButtonTextFontSize = 44;
    aboutButtonFontSize = 74;
    textButtonsFontSize = 32;
    socialButtonsFontSize = 68;
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

#pragma mark - Menu Layer Initiating

- (void) menuInit
{
    UINavigationController *navigationController = [(AppController *)[[UIApplication sharedApplication] delegate] navigationController];
    
    NSString *buttonsBg = kSquareBgString;
    NSString *buttonsStroke = kSquareStrokeString;
    
    playButtonT2D = [[CCTextureCache sharedTextureCache] addImage:@"playButton.png"];
    playButtonTappedT2D = [[CCTextureCache sharedTextureCache] addImage:@"playButtonTapped.png"];
    CCTexture2D *moreGamesButtonT2D = [[CCTextureCache sharedTextureCache] addImage:@"moreGamesButton.png"];
    CCTexture2D *highscoresButtonT2D = [[CCTextureCache sharedTextureCache] addImage:@"highscoresButton.png"];
    CCTexture2D *gamecenterButtonT2D = [[CCTextureCache sharedTextureCache] addImage:@"gamecenterSquareButton.png"];
    CCTexture2D *optionsButtonT2D = [[CCTextureCache sharedTextureCache] addImage:@"optionsButton.png"];
    
    bg = [CCSprite spriteWithFile:@"bg.png"];
    bg.position = ccp(navigationController.view.bounds.size.width/2, navigationController.view.bounds.size.height/2);
    [self addChild:bg z:-2];
    
    bgSecond = [CCSprite spriteWithFile:@"bgSecond.png"];
    bgSecond.position = ccp(winSize.width/2, winSize.height/2);
    bgSecond.opacity = 0;
    bgSecond.color = kColorDark;
    [self addChild:bgSecond z:3];
    
	logo = [CCSprite spriteWithFile:@"logo.png"];
    if (kDevicePhone) logo.position = ccp(winSize.width/2, winSize.height-logo.contentSize.height*0.55);
    else if (kDevicePad && kIsGameFull) logo.position = ccp(winSize.width/2, winSize.height-logo.contentSize.height*0.5);
    else if (kDevicePad && !kIsGameFull)
    {
        logo.scale = 0.9;
        logo.position = ccp(winSize.width/2, winSize.height-logo.contentSize.height*0.45);
    }
	logo.opacity = 0;
	[self addChild:logo z:0];
    
    closeButton = [CCLabelTTF labelWithString:@"✕" fontName:kFontArial fontSize:closeButtonFontSize]; ///// close
    [self addChild:closeButton z:4];
    closeButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:closeButtonBgFontSize];
    [self addChild:closeButtonStroke z:4];
    
    [self setPropertiesForButton:closeButton
                        buttonBg:nil
                    buttonStroke:closeButtonStroke
                      buttonText:nil
                        position:ccp(winSize.width-closeButton.contentSize.width*1.2, winSize.height-closeButton.contentSize.height*0.8)
                           color:kColorLight];
    
    playButton = [CCSprite spriteWithTexture:playButtonT2D]; ///// play
    if (kDevicePhone) playButton.position = ccp(winSize.width*0.43, winSize.height*0.33);
    else if (kDevicePad && kIsGameFull) playButton.position = ccp(winSize.width*0.4, winSize.height*0.45);
    else if (kDevicePad && !kIsGameFull) playButton.position = ccp(winSize.width*0.4, winSize.height*0.48);
    playButton.opacity = 0;
    [self addChild:playButton z:2];
    playButtonText = [CCLabelTTF labelWithString:LGLocalizedString(@"playButtonUnsel", nil) fontName:kFontComicSans fontSize:playButtonTextFontSize];
    [self addChild:playButtonText z:1];
    
    if (kDevicePhone)
        [self setPropertiesForButton:nil
                            buttonBg:nil
                        buttonStroke:nil
                          buttonText:playButtonText
                            position:playButton.position
                               color:kColorDark];
    else if (kDevicePad)
        [self setPropertiesForButton:nil
                            buttonBg:nil
                        buttonStroke:nil
                          buttonText:playButtonText
                            position:playButton.position
                               color:kColorDark];
    
    highscoresButton = [CCSprite spriteWithTexture:highscoresButtonT2D]; ///// highscores
    [self addChild:highscoresButton z:2];
    highscoresButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:highscoresButtonBg z:1];
    highscoresButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:highscoresButtonStroke z:2];
    highscoresButtonText = [CCLabelTTF labelWithString:LGLocalizedString(@"highscoresButtonUnsel", nil) fontName:kFontComicSans fontSize:buttonsTextFontSize];
    [self addChild:highscoresButtonText z:1];
    
    gamecenterButton = [CCSprite spriteWithTexture:gamecenterButtonT2D]; ///// gamecenter
    [self addChild:gamecenterButton z:2];
    gamecenterButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:gamecenterButtonBg z:1];
    gamecenterButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:gamecenterButtonStroke z:2];
    gamecenterButtonText = [CCLabelTTF labelWithString:LGLocalizedString(@"gamecenterButtonUnsel", nil) fontName:kFontComicSans fontSize:buttonsTextFontSize];
    [self addChild:gamecenterButtonText z:1];
    
    optionsButton = [CCSprite spriteWithTexture:optionsButtonT2D]; ///// options
    [self addChild:optionsButton z:2];
    optionsButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:optionsButtonBg z:1];
    optionsButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:optionsButtonStroke z:2];
    optionsButtonText = [CCLabelTTF labelWithString:LGLocalizedString(@"optionsButtonUnsel", nil) fontName:kFontComicSans fontSize:buttonsTextFontSize];
    [self addChild:optionsButtonText z:1];
    
    purchasesButton = [CCLabelTTF labelWithString:@"$" fontName:kFontPlaytime fontSize:aboutButtonFontSize]; ///// purchases
    [self addChild:purchasesButton z:2];
    purchasesButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:purchasesButtonBg z:1];
    purchasesButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:purchasesButtonStroke z:2];
    purchasesButtonText = [CCLabelTTF labelWithString:LGLocalizedString(@"purchasesButtonUnsel", nil) fontName:kFontComicSans fontSize:buttonsTextFontSize];
    [self addChild:purchasesButtonText z:1];
    
    moreGamesButton = [CCSprite spriteWithTexture:moreGamesButtonT2D]; ///// moreGames
    [self addChild:moreGamesButton z:2];
    moreGamesButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:moreGamesButtonBg z:1];
    moreGamesButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:moreGamesButtonStroke z:2];
    moreGamesButtonText = [CCLabelTTF labelWithString:LGLocalizedString(@"moreGamesButtonUnsel", nil) fontName:kFontComicSans fontSize:buttonsTextFontSize];
    [self addChild:moreGamesButtonText z:1];
    
    newsButton = [CCLabelTTF labelWithString:@"!" fontName:kFontPlaytime fontSize:aboutButtonFontSize]; ///// news
    [self addChild:newsButton z:2];
    newsButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:newsButtonBg z:1];
    newsButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:newsButtonStroke z:2];
    newsButtonText = [CCLabelTTF labelWithString:LGLocalizedString(@"newsButtonUnsel", nil) fontName:kFontComicSans fontSize:buttonsTextFontSize];
    [self addChild:newsButtonText z:1];
    
    aboutButton = [CCLabelTTF labelWithString:@"?" fontName:kFontPlaytime fontSize:aboutButtonFontSize]; ///// about
    [self addChild:aboutButton z:2];
    aboutButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:aboutButtonBg z:1];
    aboutButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:aboutButtonStroke z:2];
    aboutButtonText = [CCLabelTTF labelWithString:LGLocalizedString(@"aboutButtonUnsel", nil) fontName:kFontComicSans fontSize:buttonsTextFontSize];
    [self addChild:aboutButtonText z:1];
    
    facebookButton = [CCLabelTTF labelWithString:@"f" fontName:kFontArialBlack fontSize:socialButtonsFontSize]; ///// soundOnButton
    [self addChild:facebookButton z:5];
    facebookButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:facebookButtonBg z:4];
    facebookButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:facebookButtonStroke z:5];
    
    int minusSize;
    if (kDevicePhone) minusSize = 4;
    else minusSize = 8;
    
    vkontakteButton = [CCLabelTTF labelWithString:@"В" fontName:kFontArialBlack fontSize:socialButtonsFontSize-minusSize]; ///// soundOffButton
    [self addChild:vkontakteButton z:5];
    vkontakteButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:vkontakteButtonBg z:4];
    vkontakteButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:vkontakteButtonStroke z:5];
    
    twitterButton = [CCLabelTTF labelWithString:@"t" fontName:kFontArialBlack fontSize:socialButtonsFontSize]; ///// soundOffButton
    [self addChild:twitterButton z:5];
    twitterButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:twitterButtonBg z:4];
    twitterButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:twitterButtonStroke z:5];
    
    [self setPropertiesForButton:facebookButton
                        buttonBg:facebookButtonBg
                    buttonStroke:facebookButtonStroke
                      buttonText:nil
                        position:ccp(0, 0)
                           color:kColorLight];
    
    [self setPropertiesForButton:vkontakteButton
                        buttonBg:vkontakteButtonBg
                    buttonStroke:vkontakteButtonStroke
                      buttonText:nil
                        position:ccp(0, 0)
                           color:kColorLight];
    
    [self setPropertiesForButton:twitterButton
                        buttonBg:twitterButtonBg
                    buttonStroke:twitterButtonStroke
                      buttonText:nil
                        position:ccp(0, 0)
                           color:kColorLight];
    
    [self setPropertiesForButton:purchasesButton
                        buttonBg:purchasesButtonBg
                    buttonStroke:purchasesButtonStroke
                      buttonText:purchasesButtonText
                        position:ccp(winSize.width-purchasesButtonBg.contentSize.width/2+purchasesButtonBg.contentSize.width*0.16, purchasesButtonBg.contentSize.height/2-purchasesButtonBg.contentSize.height*0.20)
                           color:kColorDark];
    
    [self setPropertiesForButton:moreGamesButton
                        buttonBg:moreGamesButtonBg
                    buttonStroke:moreGamesButtonStroke
                      buttonText:moreGamesButtonText
                        position:ccp(winSize.width-moreGamesButtonBg.contentSize.width/2+moreGamesButtonBg.contentSize.width*0.16, purchasesButtonBg.position.y+moreGamesButtonBg.contentSize.height)
                           color:kColorDark];
    
    if (kDevicePhone)
    {
        [self setPropertiesForButton:highscoresButton
                            buttonBg:highscoresButtonBg
                        buttonStroke:highscoresButtonStroke
                          buttonText:highscoresButtonText
                            position:ccp(highscoresButtonBg.contentSize.width/2-highscoresButtonBg.contentSize.width*0.16, highscoresButtonBg.contentSize.height/2-highscoresButtonBg.contentSize.height*0.20)
                               color:kColorDark];
        
        [self setPropertiesForButton:gamecenterButton
                            buttonBg:gamecenterButtonBg
                        buttonStroke:gamecenterButtonStroke
                          buttonText:gamecenterButtonText
                            position:ccp(gamecenterButtonBg.contentSize.width/2-gamecenterButtonBg.contentSize.width*0.16, highscoresButtonBg.position.y+gamecenterButtonBg.contentSize.height)
                               color:kColorDark];
        
        [self setPropertiesForButton:optionsButton
                            buttonBg:optionsButtonBg
                        buttonStroke:optionsButtonStroke
                          buttonText:optionsButtonText
                            position:ccp(highscoresButtonBg.position.x+optionsButtonBg.contentSize.height, optionsButtonBg.contentSize.height/2-optionsButtonBg.contentSize.height*0.20)
                               color:kColorDark];
        
        [self setPropertiesForButton:newsButton
                            buttonBg:newsButtonBg
                        buttonStroke:newsButtonStroke
                          buttonText:newsButtonText
                            position:ccp(purchasesButtonBg.position.x-newsButtonBg.contentSize.height, newsButtonBg.contentSize.height/2-newsButtonBg.contentSize.height*0.20)
                               color:kColorDark];
        
        [self setPropertiesForButton:aboutButton
                            buttonBg:aboutButtonBg
                        buttonStroke:aboutButtonStroke
                          buttonText:aboutButtonText
                            position:ccp(newsButtonBg.position.x-aboutButtonBg.contentSize.height, aboutButtonBg.contentSize.height/2-aboutButtonBg.contentSize.height*0.20)
                               color:kColorDark];
    }
    else if (kDevicePad)
    {
        [self setPropertiesForButton:optionsButton
                            buttonBg:optionsButtonBg
                        buttonStroke:optionsButtonStroke
                          buttonText:optionsButtonText
                            position:ccp(optionsButtonBg.contentSize.width/2-optionsButtonBg.contentSize.width*0.16, optionsButtonBg.contentSize.height/2-optionsButtonBg.contentSize.height*0.20)
                               color:kColorDark];
        
        [self setPropertiesForButton:gamecenterButton
                            buttonBg:gamecenterButtonBg
                        buttonStroke:gamecenterButtonStroke
                          buttonText:gamecenterButtonText
                            position:ccp(gamecenterButtonBg.contentSize.width/2-gamecenterButtonBg.contentSize.width*0.16, optionsButtonBg.position.y+gamecenterButtonBg.contentSize.height)
                               color:kColorDark];
        
        [self setPropertiesForButton:highscoresButton
                            buttonBg:highscoresButtonBg
                        buttonStroke:highscoresButtonStroke
                          buttonText:highscoresButtonText
                            position:ccp(highscoresButtonBg.contentSize.width/2-highscoresButtonBg.contentSize.width*0.16, gamecenterButtonBg.position.y+highscoresButtonBg.contentSize.height)
                               color:kColorDark];
        
        [self setPropertiesForButton:newsButton
                            buttonBg:newsButtonBg
                        buttonStroke:newsButtonStroke
                          buttonText:newsButtonText
                            position:ccp(winSize.width-newsButtonBg.contentSize.width/2+newsButtonBg.contentSize.width*0.16, moreGamesButtonBg.position.y+newsButtonBg.contentSize.height)
                               color:kColorDark];
        
        [self setPropertiesForButton:aboutButton
                            buttonBg:aboutButtonBg
                        buttonStroke:aboutButtonStroke
                          buttonText:aboutButtonText
                            position:ccp(winSize.width-aboutButtonBg.contentSize.width/2+aboutButtonBg.contentSize.width*0.16, newsButtonBg.position.y+aboutButtonBg.contentSize.height)
                               color:kColorDark];
    }
    
    copyrightButton = [CCLabelTTF labelWithString:@"©" fontName:kFontArial fontSize:closeButtonFontSize*1.1]; ///// copyright
    if (kDevicePhone) copyrightButton.position = ccp(moreGamesButton.position.x, winSize.height*0.775);
    else copyrightButton.position = ccp(winSize.width-moreGamesButtonBg.contentSize.width/2+moreGamesButtonBg.contentSize.width*0.16,
                                        winSize.height-moreGamesButtonBg.contentSize.width/2+moreGamesButtonBg.contentSize.width*0.16);
    copyrightButton.color = kColorDark;
    copyrightButton.opacity = 0;
    [self addChild:copyrightButton z:-1];
    
    [self aboutLayer];
    [self optionsLayer];
    [self newsLayer];
    [self purchasesLayer];
	[self moreGamesLayer];
    [self highscoresLayer];
    [self allSpritesAppear];
    [self schedule:@selector(actions1) interval:10];
    
    AppController *app = kAppController;
    
    if (!kIsHelpShowed)
    {
        [kStandartUserDefaults setBool:YES forKey:@"isHelpShowed"];
        
        aboutOnScreen = 1;
        bgSecondOnScreen = 1;
        
        [self bgSecondAppear];
        [self aboutLayerAppear];
        
        app.helpShownCheck = 1;
    }
    else if (!kIsNewsShowed && !app.helpShownCheck)
    {
        [kStandartUserDefaults setBool:YES forKey:@"isNewsShowed"];
        
        newsOnScreen = 1;
        bgSecondOnScreen = 1;
        
        [self bgSecondAppear];
        [self newsLayerAppear];
    }
}

#pragma mark - Buttons Creating Method

- (void) setPropertiesForButton:(CCSprite *)button
                       buttonBg:(CCSprite *)buttonBg
                   buttonStroke:(CCSprite *)buttonStroke
                     buttonText:(CCSprite *)buttonText
                       position:(CGPoint)position
                          color:(ccColor3B)color
{
    if (button == newsButton)
        button.position = ccp(position.x, position.y-button.contentSize.height*0.03);
    else if (button == aboutButton)
        button.position = ccp(position.x+button.contentSize.width*0.06, position.y-button.contentSize.height*0.03);
    else if (button == purchasesButton)
        button.position = ccp(position.x-button.contentSize.width*0.02, position.y-button.contentSize.height*0.03);
    else if (button == playButton)
        button.position = ccp(position.x-button.contentSize.width*0.03, position.y+buttonBg.contentSize.height*0.02);
    else if (button == donate1)
        button.position = ccp(position.x-button.contentSize.width*0.07, position.y+buttonBg.contentSize.height*0.02);
    else if (button == donate3)
        button.position = ccp(position.x-button.contentSize.width*0.05, position.y+buttonBg.contentSize.height*0.02);
    else if (button == donate5)
        button.position = ccp(position.x-button.contentSize.width*0.06, position.y+buttonBg.contentSize.height*0.02);
    else if (button == donate10 || button == donate25)
        button.position = ccp(position.x-button.contentSize.width*0.02, position.y+buttonBg.contentSize.height*0.02);
    else if (button == facebookButton || button == twitterButton || button == vkontakteButton)
        button.position = ccp(position.x, position.y+buttonBg.contentSize.height*0.04);
    else
        button.position = ccp(position.x, position.y+buttonBg.contentSize.height*0.02);
    button.color = color;
	button.opacity = 0;
    
    buttonBg.position = position;
    if (buttonBg == purchasesButtonBg) buttonBg.color = ccc3(0, 230, 0);
    else buttonBg.color = color;
    buttonBg.opacity = 0;
    
    buttonStroke.position = position;
    buttonStroke.color = color;
    buttonStroke.opacity = 0;
    
    if (buttonText == playButtonText)
    {
        buttonText.position = ccp(position.x, position.y-playButton.contentSize.height/2-buttonText.contentSize.height*0.3); // square снизу
    }
    else if (buttonText == highscoresButtonText || buttonText == gamecenterButtonText || buttonText == optionsButtonText)
    {
        if (kDevicePhone)
        {
            buttonText.position = ccp(buttonBg.position.x+buttonBg.contentSize.width*0.42+buttonText.contentSize.width*0.35,
                                      buttonBg.position.y+buttonBg.contentSize.height*0.47+buttonText.contentSize.width*0.35); // диагональ вправо
            buttonText.rotation = -45;
        }
        else if (kDevicePad)
        {
            buttonText.position = ccp(position.x+buttonBg.contentSize.width*0.55+buttonText.contentSize.width/2, position.y);
        }
    }
    else
    {
        if (kDevicePhone)
        {
            buttonText.position = ccp(buttonBg.position.x-buttonBg.contentSize.width*0.42-buttonText.contentSize.width*0.35,
                                      buttonBg.position.y+buttonBg.contentSize.height*0.47+buttonText.contentSize.width*0.35); // диагональ влево
            buttonText.rotation = 45;
        }
        else if (kDevicePad)
        {
            buttonText.position = ccp(position.x-buttonBg.contentSize.width*0.55-buttonText.contentSize.width/2, position.y);
        }
    }
    buttonText.color = color;
    buttonText.opacity = 0;
}

#pragma mark - Actions

- (void) actions1
{
    logo.anchorPoint = ccp(1, 0.5);
    if (kDevicePhone) logo.position = ccp(winSize.width/2+logo.contentSize.width/2, logo.position.y);
    else if (kDevicePad) logo.position = ccp(winSize.width/2+logo.contentSize.width/2*logo.scaleX, logo.position.y);
    
    id a1 = [CCScaleTo actionWithDuration:0.3 scaleX:0.8*logo.scaleX scaleY:1*logo.scaleY];
    id a2 = [CCScaleTo actionWithDuration:0.05 scaleX:1*logo.scaleX scaleY:1*logo.scaleY];
    id a3 = [CCMoveBy actionWithDuration:0.1 position:ccp(-winSize.width, 0)];
    id a4 = [CCCallFunc actionWithTarget:self selector:@selector(actions2)];
    [logo runAction:[CCSequence actions:a1, a2, a3, a4, nil]];
    
    [self scheduleOnce:@selector(actions4) delay:0.3];
}

- (void) actions2
{
    logo.anchorPoint = ccp(0.5, 0.5);
    if (kDevicePhone) logo.position = ccp(winSize.width*1.5, logo.position.y);
    else if (kDevicePad) logo.position = ccp(winSize.width*1.5, logo.position.y);
    
    id a1 = [CCMoveBy actionWithDuration:0.15 position:ccp(-winSize.width*2, 0)];
    id a2 = [CCCallFunc actionWithTarget:self selector:@selector(actions3)];
    [logo runAction:[CCSequence actions:a1, a2, nil]];
}

- (void) actions3
{
    logo.anchorPoint = ccp(0, 0.5);
    if (kDevicePhone) logo.position = ccp(winSize.width*1.5-logo.contentSize.width/2, logo.position.y);
    else if (kDevicePad) logo.position = ccp(winSize.width*1.5-logo.contentSize.width/2*logo.scaleX, logo.position.y);
    
    id a1 = [CCScaleTo actionWithDuration:0.3 scaleX:1*logo.scaleX scaleY:1*logo.scaleY];
    id a2 = [CCScaleTo actionWithDuration:0.05 scaleX:0.8*logo.scaleX scaleY:1*logo.scaleY];
    id a3 = [CCMoveBy actionWithDuration:0.1 position:ccp(-winSize.width, 0)];
    [logo runAction:[CCSequence actions:a3, a2, a1, nil]];
}

- (void) actions4
{
    id a1 = [CCRotateBy actionWithDuration:1.5 angle:-720];
    id a2 = [CCEaseInOut actionWithAction:a1 rate:3];
    [playButton runAction:a2];
}

#pragma mark - Layers Initiating

- (void) aboutLayer
{
    aboutTitle = [CCLabelTTF labelWithString:LGLocalizedString(@"aboutTitle", nil) fontName:kFontComicSans fontSize:titleFontSize];
    if (kDevicePhone) aboutTitle.position = ccp(winSize.width/2, winSize.height-aboutTitle.contentSize.height*0.7);
    else if (kDevicePad) aboutTitle.position = ccp(winSize.width/2, winSize.height-aboutTitle.contentSize.height);
	aboutTitle.color = kColorLight;
    aboutTitle.opacity = 0;
	[self addChild:aboutTitle z:4];
    
    CGSize aboutSize;
    if (kDevicePhone) aboutSize = CGSizeMake(winSize.width-20, aboutTitle.position.y-aboutTitle.contentSize.height*0.7);
    else if (kDevicePad) aboutSize = CGSizeMake(winSize.width-40, aboutTitle.position.y-aboutTitle.contentSize.height);
    
    aboutText = [CCLabelTTF labelWithString:LGLocalizedString(@"aboutText", nil)
                                   fontName:kFontComicSans
                                   fontSize:aboutTextFontSize
                                 dimensions:aboutSize
                                 hAlignment:kCCTextAlignmentLeft];
    if (kDevicePhone) aboutText.position = ccp(winSize.width*0.5, aboutTitle.position.y-aboutTitle.contentSize.height*0.7);
    else if (kDevicePad) aboutText.position = ccp(winSize.width*0.5, aboutTitle.position.y-aboutTitle.contentSize.height);
    aboutText.color = kColorLight;
    aboutText.opacity = 0;
    aboutText.anchorPoint = ccp(0.5, 1);
	[self addChild:aboutText z:4];
}

- (void) optionsLayer
{
    NSString *buttonsBg = kSquareBgString;
    NSString *buttonsStroke = kSquareStrokeString;
    
    int languageFontSize;
    int soundFontSize;
    
    if (kDevicePhone)
    {
        languageFontSize = 20;
        soundFontSize = 16;
    }
    else
    {
        languageFontSize = 40;
        soundFontSize = 32;
    }
    
    optionsTitle = [CCLabelTTF labelWithString:LGLocalizedString(@"optionsTitle", nil) fontName:kFontComicSans fontSize:titleFontSize];
    if (kDevicePhone) optionsTitle.position = ccp(winSize.width/2, winSize.height-optionsTitle.contentSize.height*0.7);
    else if (kDevicePad) optionsTitle.position = ccp(winSize.width/2, winSize.height-optionsTitle.contentSize.height);
	optionsTitle.color = kColorLight;
    optionsTitle.opacity = 0;
	[self addChild:optionsTitle z:4];
    
    selectLanguage = [CCLabelTTF labelWithString:LGLocalizedString(@"selectLanguage", nil) fontName:kFontComicSans fontSize:textButtonsFontSize];
	selectLanguage.color = kColorLight;
    if (kDevicePhone) selectLanguage.position = ccp(winSize.width*0.25, optionsTitle.position.y-optionsTitle.contentSize.height);
    else selectLanguage.position = ccp(winSize.width/2, optionsTitle.position.y-optionsTitle.contentSize.height-selectLanguage.contentSize.height/2);
    selectLanguage.opacity = 0;
	[self addChild:selectLanguage z:4];
    
    englishButton = [CCLabelTTF labelWithString:@"EN" fontName:kFontPlaytime fontSize:languageFontSize]; ///// englishButton
    [self addChild:englishButton z:5];
    englishButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:englishButtonBg z:4];
    englishButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:englishButtonStroke z:5];
    
    [self setPropertiesForButton:englishButton
                        buttonBg:englishButtonBg
                    buttonStroke:englishButtonStroke
                      buttonText:nil
                        position:ccp(selectLanguage.position.x-englishButtonBg.contentSize.width*0.7, selectLanguage.position.y-englishButtonBg.contentSize.height*0.8)
                           color:kColorLight];
    
    russianButton = [CCLabelTTF labelWithString:@"RU" fontName:kFontPlaytime fontSize:languageFontSize]; ///// russianButton
    [self addChild:russianButton z:5];
    russianButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:russianButtonBg z:4];
    russianButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:russianButtonStroke z:5];
    
    [self setPropertiesForButton:russianButton
                        buttonBg:russianButtonBg
                    buttonStroke:russianButtonStroke
                      buttonText:nil
                        position:ccp(selectLanguage.position.x+russianButtonBg.contentSize.width*0.7, selectLanguage.position.y-russianButtonBg.contentSize.height*0.8)
                           color:kColorLight];
    
    selectSound = [CCLabelTTF labelWithString:LGLocalizedString(@"selectSound", nil) fontName:kFontComicSans fontSize:textButtonsFontSize];
	selectSound.color = kColorLight;
    if (kDevicePhone) selectSound.position = ccp(winSize.width*0.75, optionsTitle.position.y-optionsTitle.contentSize.height);
    else selectSound.position = ccp(winSize.width*0.5, russianButtonBg.position.y-russianButtonBg.contentSize.height*0.5-selectSound.contentSize.height);
    selectSound.opacity = 0;
	[self addChild:selectSound z:4];
    
    soundOnButton = [CCLabelTTF labelWithString:LGLocalizedString(@"soundOn", nil) fontName:kFontComicSans fontSize:soundFontSize]; ///// soundOnButton
    [self addChild:soundOnButton z:5];
    soundOnButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:soundOnButtonBg z:4];
    soundOnButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:soundOnButtonStroke z:5];
    
    [self setPropertiesForButton:soundOnButton
                        buttonBg:soundOnButtonBg
                    buttonStroke:soundOnButtonStroke
                      buttonText:nil
                        position:ccp(selectSound.position.x-soundOnButtonBg.contentSize.width*0.7, selectSound.position.y-soundOnButtonBg.contentSize.height*0.8)
                           color:kColorLight];
    
    soundOffButton = [CCLabelTTF labelWithString:LGLocalizedString(@"soundOff", nil) fontName:kFontComicSans fontSize:soundFontSize]; ///// soundOffButton
    [self addChild:soundOffButton z:5];
    soundOffButtonBg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:soundOffButtonBg z:4];
    soundOffButtonStroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:buttonsBgFontSize];
    [self addChild:soundOffButtonStroke z:5];
    
    [self setPropertiesForButton:soundOffButton
                        buttonBg:soundOffButtonBg
                    buttonStroke:soundOffButtonStroke
                      buttonText:nil
                        position:ccp(selectSound.position.x+soundOffButtonBg.contentSize.width*0.7, selectSound.position.y-soundOffButtonBg.contentSize.height*0.8)
                           color:kColorLight];
    
    followUs = [CCLabelTTF labelWithString:LGLocalizedString(@"followUs", nil) fontName:kFontComicSans fontSize:textButtonsFontSize];
	followUs.color = kColorLight;
    if (kDevicePhone) followUs.position = ccp(winSize.width*0.5, russianButtonBg.position.y-russianButtonBg.contentSize.height);
    else followUs.position = ccp(winSize.width*0.5, soundOnButtonBg.position.y-soundOnButtonBg.contentSize.height*0.5-followUs.contentSize.height);
    followUs.opacity = 0;
	[self addChild:followUs z:4];
}

- (void) newsLayer
{
    newsTitle = [CCLabelTTF labelWithString:LGLocalizedString(@"newsTitle", nil) fontName:kFontComicSans fontSize:titleFontSize];
    if (kDevicePhone) newsTitle.position = ccp(winSize.width/2, winSize.height-newsTitle.contentSize.height*0.7);
    else if (kDevicePad) newsTitle.position = ccp(winSize.width/2, winSize.height-newsTitle.contentSize.height);
	newsTitle.color = kColorLight;
    newsTitle.opacity = 0;
	[self addChild:newsTitle z:4];
    
    CGSize newsSize;
    if (kDevicePhone) newsSize = CGSizeMake(winSize.width-20, newsTitle.position.y-newsTitle.contentSize.height*0.7);
    else if (kDevicePad) newsSize = CGSizeMake(winSize.width-40, newsTitle.position.y-newsTitle.contentSize.height);
    
    newsText = [CCLabelTTF labelWithString:LGLocalizedString(@"newsText", nil)
                                  fontName:kFontComicSans
                                  fontSize:aboutTextFontSize*1.2
                                dimensions:newsSize
                                hAlignment:kCCTextAlignmentLeft];
    if (kDevicePhone) newsText.position = ccp(winSize.width*0.5, newsTitle.position.y-newsTitle.contentSize.height*0.7);
    else if (kDevicePad) newsText.position = ccp(winSize.width*0.5, newsTitle.position.y-newsTitle.contentSize.height);
    newsText.color = kColorLight;
    newsText.opacity = 0;
    newsText.anchorPoint = ccp(0.5, 1);
	[self addChild:newsText z:4];
}

- (void) purchasesLayer
{
    int donateFontSize = 0;
    int donateFontSize2 = 0;
    int donateBgFontSize = 0;
    
    if (kDevicePhone)
    {
        donateFontSize = 30;
        donateFontSize2 = 23;
        donateBgFontSize = 60;
    }
    else if (kDevicePad)
    {
        donateFontSize = 60;
        donateFontSize2 = 46;
        donateBgFontSize = 120;
    }
    
    NSString *buttonsBg = kSquareBgString;
    NSString *buttonsStroke = kSquareStrokeString;
    
    purchasesTitle = [CCLabelTTF labelWithString:LGLocalizedString(@"purchasesTitle", nil) fontName:kFontComicSans fontSize:titleFontSize];
    if (kDevicePhone) purchasesTitle.position = ccp(winSize.width/2, winSize.height-purchasesTitle.contentSize.height*0.7);
    else if (kDevicePad) purchasesTitle.position = ccp(winSize.width/2, winSize.height-purchasesTitle.contentSize.height);
	purchasesTitle.color = kColorLight;
    purchasesTitle.opacity = 0;
	[self addChild:purchasesTitle z:4];
    
    removeAdsText = [CCLabelTTF labelWithString:LGLocalizedString(@"removeAdsText", nil) fontName:kFontComicSans fontSize:textButtonsFontSize];
    if (kDevicePhone) removeAdsText.position = ccp(winSize.width/2, purchasesTitle.position.y-purchasesTitle.contentSize.height*0.7-removeAdsText.contentSize.height/2);
    else if (kDevicePad) removeAdsText.position = ccp(winSize.width/2, purchasesTitle.position.y-purchasesTitle.contentSize.height-removeAdsText.contentSize.height/2);
	removeAdsText.color = kColorLight;
    removeAdsText.opacity = 0;
	[self addChild:removeAdsText z:4];
    
    if (kIsGameFull)
    {
        removeAdsStatus = [CCLabelTTF labelWithString:LGLocalizedString(@"removeAdsYes", nil) fontName:kFontComicSans fontSize:textButtonsFontSize];
        removeAdsStatus.color = ccc3(0, 230, 0);
    }
    else
    {
        removeAdsStatus = [CCLabelTTF labelWithString:LGLocalizedString(@"removeAdsNo", nil) fontName:kFontComicSans fontSize:textButtonsFontSize];
        removeAdsStatus.color = ccc3(230, 230, 230);
    }
    removeAdsStatus.position = ccp(winSize.width/2, removeAdsText.position.y-removeAdsStatus.contentSize.height);
    removeAdsStatus.opacity = 0;
    [self addChild:removeAdsStatus z:4];
    
    restoreText = [CCLabelTTF labelWithString:LGLocalizedString(@"restoreText", nil) fontName:kFontComicSans fontSize:textButtonsFontSize];
    restoreText.position = ccp(winSize.width/2, removeAdsStatus.position.y-restoreText.contentSize.height);
	restoreText.color = kColorLight;
    restoreText.opacity = 0;
	[self addChild:restoreText z:4];
    
    donateTitle = [CCLabelTTF labelWithString:LGLocalizedString(@"donateTitle", nil) fontName:kFontComicSans fontSize:titleFontSize];
    if (kDevicePhone) donateTitle.position = ccp(winSize.width/2, winSize.height*0.47);
    else if (kDevicePad) donateTitle.position = ccp(winSize.width/2, winSize.height*0.5);
	donateTitle.color = kColorLight;
    donateTitle.opacity = 0;
	[self addChild:donateTitle z:4];
    
    donate1 = [CCLabelTTF labelWithString:@"$1" fontName:kFontPlaytime fontSize:donateFontSize]; ///// donate1
    [self addChild:donate1 z:4];
    donate1Bg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:donateBgFontSize];
    [self addChild:donate1Bg z:4];
    donate1Stroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:donateBgFontSize];
    [self addChild:donate1Stroke z:5];
    
    if (kDevicePhone)
        [self setPropertiesForButton:donate1
                            buttonBg:donate1Bg
                        buttonStroke:donate1Stroke
                          buttonText:nil
                            position:ccp(winSize.width*0.15, donateTitle.position.y-donateTitle.contentSize.height*0.7-donate1Bg.contentSize.height*0.5)
                               color:kColorLight];
    else if (kDevicePad)
        [self setPropertiesForButton:donate1
                            buttonBg:donate1Bg
                        buttonStroke:donate1Stroke
                          buttonText:nil
                            position:ccp(winSize.width*0.15, donateTitle.position.y-donateTitle.contentSize.height-donate1Bg.contentSize.height*0.5)
                               color:kColorLight];
    
    donate3 = [CCLabelTTF labelWithString:@"$3" fontName:kFontPlaytime fontSize:donateFontSize]; ///// donate3
    [self addChild:donate3 z:4];
    donate3Bg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:donateBgFontSize];
    [self addChild:donate3Bg z:4];
    donate3Stroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:donateBgFontSize];
    [self addChild:donate3Stroke z:5];
    
    [self setPropertiesForButton:donate3
                        buttonBg:donate3Bg
                    buttonStroke:donate3Stroke
                      buttonText:nil
                        position:ccp(winSize.width*0.325, donate1.position.y)
                           color:kColorLight];
    
    donate5 = [CCLabelTTF labelWithString:@"$5" fontName:kFontPlaytime fontSize:donateFontSize]; ///// donate5
    [self addChild:donate5 z:4];
    donate5Bg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:donateBgFontSize];
    [self addChild:donate5Bg z:4];
    donate5Stroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:donateBgFontSize];
    [self addChild:donate5Stroke z:5];
    
    [self setPropertiesForButton:donate5
                        buttonBg:donate5Bg
                    buttonStroke:donate5Stroke
                      buttonText:nil
                        position:ccp(winSize.width*0.5, donate1.position.y)
                           color:kColorLight];
    
    donate10 = [CCLabelTTF labelWithString:@"$10" fontName:kFontPlaytime fontSize:donateFontSize2]; ///// donate10
    [self addChild:donate10 z:4];
    donate10Bg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:donateBgFontSize];
    [self addChild:donate10Bg z:4];
    donate10Stroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:donateBgFontSize];
    [self addChild:donate10Stroke z:5];
    
    [self setPropertiesForButton:donate10
                        buttonBg:donate10Bg
                    buttonStroke:donate10Stroke
                      buttonText:nil
                        position:ccp(winSize.width*0.675, donate1.position.y)
                           color:kColorLight];
    
    donate25 = [CCLabelTTF labelWithString:@"$25" fontName:kFontPlaytime fontSize:donateFontSize2]; ///// donate25
    [self addChild:donate25 z:4];
    donate25Bg = [CCLabelTTF labelWithString:buttonsBg fontName:kFontOsakaMono fontSize:donateBgFontSize];
    [self addChild:donate25Bg z:4];
    donate25Stroke = [CCLabelTTF labelWithString:buttonsStroke fontName:kFontOsakaMono fontSize:donateBgFontSize];
    [self addChild:donate25Stroke z:5];
    
    [self setPropertiesForButton:donate25
                        buttonBg:donate25Bg
                    buttonStroke:donate25Stroke
                      buttonText:nil
                        position:ccp(winSize.width*0.85, donate1.position.y)
                           color:kColorLight];
    
    internetAvailabilityStatus = [CCLabelTTF labelWithString:@"TEMP" fontName:kFontComicSans fontSize:textButtonsFontSize];
    internetAvailabilityStatus.position = ccp(winSize.width/2, internetAvailabilityStatus.contentSize.height*0.75);
    internetAvailabilityStatus.opacity = 0;
	[self addChild:internetAvailabilityStatus z:4];
    
    kLGReachability.label = internetAvailabilityStatus;
    
    internetAvailabilityTitle = [CCLabelTTF labelWithString:LGLocalizedString(@"internetAvailabilityTitle", nil) fontName:kFontComicSans fontSize:textButtonsFontSize];
    internetAvailabilityTitle.position = ccp(winSize.width/2, internetAvailabilityStatus.position.y+internetAvailabilityTitle.contentSize.height);
	internetAvailabilityTitle.color = kColorLight;
    internetAvailabilityTitle.opacity = 0;
	[self addChild:internetAvailabilityTitle z:4];
}

- (void) moreGamesLayer
{
    NSString *separatorString = @"_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _";
    
    int iconTextFontSize = 0;
    if (kDevicePhone) iconTextFontSize = 20;
    else if (kDevicePad) iconTextFontSize = 40;
    
	moreGamesTitle = [CCLabelTTF labelWithString:LGLocalizedString(@"moreGamesTitle", nil) fontName:kFontComicSans fontSize:titleFontSize];
    if (kDevicePhone) moreGamesTitle.position = ccp(winSize.width/2, winSize.height-moreGamesTitle.contentSize.height*0.7);
    else if (kDevicePad) moreGamesTitle.position = ccp(winSize.width/2, winSize.height-moreGamesTitle.contentSize.height);
	moreGamesTitle.color = kColorLight;
    moreGamesTitle.opacity = 0;
	[self addChild:moreGamesTitle z:4];
    
    separatorL[0] = [CCLabelTTF labelWithString:separatorString fontName:kFontComicSans fontSize:iconTextFontSize];
    if (kDevicePhone) separatorL[0].position = ccp(winSize.width/2, moreGamesTitle.position.y-moreGamesTitle.contentSize.height*0.7-separatorL[0].contentSize.height/2);
    else if (kDevicePad) separatorL[0].position = ccp(winSize.width/2, moreGamesTitle.position.y-moreGamesTitle.contentSize.height-separatorL[0].contentSize.height/2);
    separatorL[0].color = kColorLight;
    separatorL[0].opacity = 0;
    separatorL[0].anchorPoint = ccp(0.5, 0);
    [self addChild:separatorL[0] z:4];
    
    iconCYR = [CCSprite spriteWithFile:@"iconCYR.png"];
    iconCYR.scale = 0.8;
    if (kDevicePhone)
        iconCYR.position = ccp(winSize.width*0.23/iconCYR.scale, separatorL[0].position.y-separatorL[0].contentSize.height/4-iconCYR.contentSize.height*0.5*iconCYR.scale);
    else if (kDevicePad)
        iconCYR.position = ccp(iconCYR.contentSize.width*0.60*iconCYR.scale, separatorL[0].position.y-separatorL[0].contentSize.height/4-iconCYR.contentSize.height*0.5*iconCYR.scale);
    iconCYR.opacity = 0;
	[self addChild:iconCYR z:4];
    
    iconCYRName = [CCLabelTTF labelWithString:@"| Check Your Reaction" fontName:kFontComicSans fontSize:iconTextFontSize];
    iconCYRName.position = ccp(iconCYR.position.x+iconCYR.contentSize.width*0.58*iconCYR.scale, iconCYR.position.y+iconCYR.contentSize.height*0.35*iconCYR.scale);
    iconCYRName.color = kColorLight;
    iconCYRName.anchorPoint = ccp(0, 0.5);
    iconCYRName.opacity = 0;
	[self addChild:iconCYRName z:4];
    
    iconCYRPrice = [CCLabelTTF labelWithString:LGLocalizedString(@"priceFree", nil) fontName:kFontComicSans fontSize:iconTextFontSize];
    iconCYRPrice.position = ccp(iconCYR.position.x+iconCYR.contentSize.width*0.58*iconCYR.scale, iconCYR.position.y);
    iconCYRPrice.color = kColorLight;
    iconCYRPrice.anchorPoint = ccp(0, 0.5);
    iconCYRPrice.opacity = 0;
	[self addChild:iconCYRPrice z:4];
    
    iconCYRDownload = [CCLabelTTF labelWithString:LGLocalizedString(@"download", nil) fontName:kFontComicSans fontSize:iconTextFontSize];
    iconCYRDownload.position = ccp(iconCYR.position.x+iconCYR.contentSize.width*0.58*iconCYR.scale, iconCYR.position.y-iconCYR.contentSize.height*0.35*iconCYR.scale);
    iconCYRDownload.color = kColorLight;
    iconCYRDownload.anchorPoint = ccp(0, 0.5);
    iconCYRDownload.opacity = 0;
	[self addChild:iconCYRDownload z:4];
    
    separatorL[1] = [CCLabelTTF labelWithString:separatorString fontName:kFontComicSans fontSize:iconTextFontSize];
    separatorL[1].position = ccp(winSize.width/2, iconCYR.position.y-iconCYR.contentSize.height*0.5*iconCYR.scale-separatorL[0].contentSize.height/2);
    separatorL[1].color = kColorLight;
    separatorL[1].opacity = 0;
    separatorL[1].anchorPoint = ccp(0.5, 0);
    [self addChild:separatorL[1] z:4];
    
    if (kDevicePhone) goToAppStore = [CCLabelTTF labelWithString:LGLocalizedString(@"goToAppStore", nil) fontName:kFontComicSans fontSize:textButtonsFontSize];
    else goToAppStore = [CCLabelTTF labelWithString:LGLocalizedString(@"goToAppStore", nil) fontName:kFontComicSans fontSize:textButtonsFontSize-2];
    goToAppStore.position = ccp(winSize.width/2, goToAppStore.contentSize.height*0.75);
	goToAppStore.color = kColorLight;
    goToAppStore.opacity = 0;
	[self addChild:goToAppStore z:4];
}

- (void) highscoresLayer
{
    int textFontSize;
    int positionX;
    
    if (kDevicePhone)
    {
        textFontSize = 16;
        positionX = winSize.width*0.33;
    }
    else if (kDevicePad)
    {
        textFontSize = 32;
        positionX = winSize.width*0.4;
    }
    
	highscoresTitle = [CCLabelTTF labelWithString:LGLocalizedString(@"highscoresTitle", nil) fontName:kFontComicSans fontSize:titleFontSize];
    if (kDevicePhone) highscoresTitle.position = ccp(winSize.width/2, winSize.height-highscoresTitle.contentSize.height*0.7);
    else if (kDevicePad) highscoresTitle.position = ccp(winSize.width/2, winSize.height-highscoresTitle.contentSize.height);
	highscoresTitle.color = kColorLight;
    highscoresTitle.opacity = 0;
	[self addChild:highscoresTitle z:4];
    
    for (int i=0; i<3; i++)
    {
        mistakesText[i] = [CCLabelTTF labelWithString:LGLocalizedString(@"mistakes", nil) fontName:kFontComicSans fontSize:textFontSize];
        if (i == 0 && kDevicePad && kIsGameFull)
            mistakesText[i].position = ccp(positionX, highscoresTitle.position.y-highscoresTitle.contentSize.height-mistakesText[i].contentSize.height/2);
        else if (i == 0)
            mistakesText[i].position = ccp(positionX, highscoresTitle.position.y-highscoresTitle.contentSize.height*0.7-mistakesText[i].contentSize.height/2);
        else if (i == 1 && kIsGameFull && kDevicePad) mistakesText[i].position = ccp(positionX, mistakesText[0].position.y-mistakesText[i].contentSize.height*5);
        else if (i == 1 && kIsGameFull) mistakesText[i].position = ccp(positionX, mistakesText[0].position.y-mistakesText[i].contentSize.height*6);
        else if (i == 1 && !kIsGameFull) mistakesText[i].position = ccp(positionX, mistakesText[0].position.y-mistakesText[i].contentSize.height*5);
        else if (i == 2 && kIsGameFull && kDevicePad) mistakesText[i].position = ccp(positionX, mistakesText[1].position.y-mistakesText[i].contentSize.height*5);
        else if (i == 2 && kIsGameFull) mistakesText[i].position = ccp(positionX, mistakesText[1].position.y-mistakesText[i].contentSize.height*6);
        else if (i == 2 && !kIsGameFull) mistakesText[i].position = ccp(positionX, mistakesText[1].position.y-mistakesText[i].contentSize.height*5);
        mistakesText[i].color = kColorLight;
        mistakesText[i].opacity = 0;
        mistakesText[i].anchorPoint = ccp(1, 0.5);
        [self addChild:mistakesText[i] z:4];
        
        timeText[i] = [CCLabelTTF labelWithString:LGLocalizedString(@"time", nil) fontName:kFontComicSans fontSize:textFontSize];
        if (i == 0) timeText[i].position = ccp(positionX, mistakesText[i].position.y-timeText[i].contentSize.height);
        else if (i >= 1) timeText[i].position = ccp(positionX, mistakesText[i].position.y-timeText[i].contentSize.height);
        timeText[i].color = kColorLight;
        timeText[i].opacity = 0;
        timeText[i].anchorPoint = ccp(1, 0.5);
        [self addChild:timeText[i] z:4];
        
        squaresMovedText[i] = [CCLabelTTF labelWithString:LGLocalizedString(@"squaresMoved", nil) fontName:kFontComicSans fontSize:textFontSize];
        if (i == 0) squaresMovedText[i].position = ccp(positionX, timeText[i].position.y-squaresMovedText[i].contentSize.height);
        else if (i >= 1) squaresMovedText[i].position = ccp(positionX, timeText[i].position.y-squaresMovedText[i].contentSize.height);
        squaresMovedText[i].color = kColorLight;
        squaresMovedText[i].opacity = 0;
        squaresMovedText[i].anchorPoint = ccp(1, 0.5);
        [self addChild:squaresMovedText[i] z:4];
        
        scoreText[i] = [CCLabelTTF labelWithString:LGLocalizedString(@"score", nil) fontName:kFontComicSans fontSize:textFontSize];
        if (i == 0) scoreText[i].position = ccp(positionX, squaresMovedText[i].position.y-scoreText[i].contentSize.height);
        else if (i >= 1) scoreText[i].position = ccp(positionX, squaresMovedText[i].position.y-scoreText[i].contentSize.height);
        scoreText[i].color = ccc3(230, 20, 20);
        scoreText[i].opacity = 0;
        scoreText[i].anchorPoint = ccp(1, 0.5);
        [self addChild:scoreText[i] z:4];
    }
    
    for (int i=0; (i < 4 && kDevicePhone) || (i < 3 && kDevicePad); i++)
    {
        NSString *sepString;
        
        if (kDevicePhone)
        {
            if (kIsGameFull)
                sepString = [NSString stringWithFormat:@"|\n|\n|\n|\n|\n|\n|\n|\n|\n|"];
            else sepString = [NSString stringWithFormat:@"|\n|\n|\n|\n|\n|\n|\n|\n|"];
            
            separator[i] = [CCLabelTTF labelWithString:sepString
                                              fontName:kFontComicSans
                                              fontSize:textFontSize
                                            dimensions:CGSizeMake(winSize.width*0.1, winSize.height)
                                            hAlignment:kCCTextAlignmentCenter];
        }
        else if (kDevicePad)
        {
            sepString = [NSString stringWithFormat:@"|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|"];
            
            separator[i] = [CCLabelTTF labelWithString:sepString
                                              fontName:kFontComicSans
                                              fontSize:textFontSize
                                            dimensions:CGSizeMake(winSize.width*0.1, winSize.height)
                                            hAlignment:kCCTextAlignmentCenter];
        }
        
        if (kDevicePhone) separator[i].position = ccp(positionX+winSize.width*0.02+winSize.width*0.18*i, mistakesText[0].position.y+mistakesText[0].contentSize.height/2);
        else if (kDevicePad) separator[i].position = ccp(positionX+winSize.width*0.02+winSize.width*0.25*i, mistakesText[0].position.y+mistakesText[0].contentSize.height/2);
        separator[i].color = kColorLight;
        separator[i].opacity = 0;
        separator[i].anchorPoint = ccp(0.5, 1);
        [self addChild:separator[i] z:4];
    }
    
    for (int i=0; i<6; i++)
    {
        mistakesResult[i] = [CCLabelTTF labelWithString:@"0" fontName:kFontComicSans fontSize:textFontSize];
        if (i < 3 && kDevicePhone) mistakesResult[i].position = ccp(separator[i+1].position.x-winSize.width*0.02, mistakesText[0].position.y);
        else if (i > 2 && kDevicePhone) mistakesResult[i].position = ccp(separator[i-2].position.x-winSize.width*0.02, mistakesText[1].position.y);
        else if (i <= 1 && kDevicePad) mistakesResult[i].position = ccp(separator[i+1].position.x-winSize.width*0.02, mistakesText[0].position.y);
        else if (i >= 2 && i <= 3 && kDevicePad) mistakesResult[i].position = ccp(separator[i-1].position.x-winSize.width*0.02, mistakesText[1].position.y);
        else if (i >= 4 && kDevicePad) mistakesResult[i].position = ccp(separator[i-3].position.x-winSize.width*0.02, mistakesText[2].position.y);
        mistakesResult[i].color = kColorLight;
        mistakesResult[i].opacity = 0;
        mistakesResult[i].anchorPoint = ccp(1, 0.5);
        [self addChild:mistakesResult[i] z:4];
        
        timeResult[i] = [CCLabelTTF labelWithString:@"00:00" fontName:kFontComicSans fontSize:textFontSize];
        if (i < 3 && kDevicePhone) timeResult[i].position = ccp(separator[i+1].position.x-winSize.width*0.02, timeText[0].position.y);
        else if (i > 2 && kDevicePhone) timeResult[i].position = ccp(separator[i-2].position.x-winSize.width*0.02, timeText[1].position.y);
        else if (i <= 1 && kDevicePad) timeResult[i].position = ccp(separator[i+1].position.x-winSize.width*0.02, timeText[0].position.y);
        else if (i >= 2 && i <= 3 && kDevicePad) timeResult[i].position = ccp(separator[i-1].position.x-winSize.width*0.02, timeText[1].position.y);
        else if (i >= 4 && kDevicePad) timeResult[i].position = ccp(separator[i-3].position.x-winSize.width*0.02, timeText[2].position.y);
        timeResult[i].color = kColorLight;
        timeResult[i].opacity = 0;
        timeResult[i].anchorPoint = ccp(1, 0.5);
        [self addChild:timeResult[i] z:4];
        
        squaresMovedResult[i] = [CCLabelTTF labelWithString:@"0" fontName:kFontComicSans fontSize:textFontSize];
        if (i < 3 && kDevicePhone) squaresMovedResult[i].position = ccp(separator[i+1].position.x-winSize.width*0.02, squaresMovedText[0].position.y);
        else if (i > 2 && kDevicePhone) squaresMovedResult[i].position = ccp(separator[i-2].position.x-winSize.width*0.02, squaresMovedText[1].position.y);
        else if (i <= 1 && kDevicePad) squaresMovedResult[i].position = ccp(separator[i+1].position.x-winSize.width*0.02, squaresMovedText[0].position.y);
        else if (i >= 2 && i <= 3 && kDevicePad) squaresMovedResult[i].position = ccp(separator[i-1].position.x-winSize.width*0.02, squaresMovedText[1].position.y);
        else if (i >= 4 && kDevicePad) squaresMovedResult[i].position = ccp(separator[i-3].position.x-winSize.width*0.02, squaresMovedText[2].position.y);
        squaresMovedResult[i].color = kColorLight;
        squaresMovedResult[i].opacity = 0;
        squaresMovedResult[i].anchorPoint = ccp(1, 0.5);
        [self addChild:squaresMovedResult[i] z:4];
        
        scoreResult[i] = [CCLabelTTF labelWithString:@"0" fontName:kFontComicSans fontSize:textFontSize];
        if (i < 3 && kDevicePhone) scoreResult[i].position = ccp(separator[i+1].position.x-winSize.width*0.02, scoreText[0].position.y);
        else if (i > 2 && kDevicePhone) scoreResult[i].position = ccp(separator[i-2].position.x-winSize.width*0.02, scoreText[1].position.y);
        else if (i <= 1 && kDevicePad) scoreResult[i].position = ccp(separator[i+1].position.x-winSize.width*0.02, scoreText[0].position.y);
        else if (i >= 2 && i <= 3 && kDevicePad) scoreResult[i].position = ccp(separator[i-1].position.x-winSize.width*0.02, scoreText[1].position.y);
        else if (i >= 4 && kDevicePad) scoreResult[i].position = ccp(separator[i-3].position.x-winSize.width*0.02, scoreText[2].position.y);
        scoreResult[i].color = ccc3(230, 20, 20);
        scoreResult[i].opacity = 0;
        scoreResult[i].anchorPoint = ccp(1, 0.5);
        [self addChild:scoreResult[i] z:4];
    }
    
    NSMutableArray *highscoresArray = [NSMutableArray arrayWithArray:[kStandartUserDefaults arrayForKey:@"highscoresArray"]];
    
    for (int i=0; i<highscoresArray.count; i++)
    {
        NSArray *highscoreArray = [highscoresArray objectAtIndex:i];
        [mistakesResult[i] setString:[NSString stringWithFormat:@"%@", [highscoreArray objectAtIndex:0]]];
        
        int playTimeSec = 0;
        int playTimeMin = 0;
        
        for (playTimeSec = [[highscoreArray objectAtIndex:1] intValue]; playTimeSec >= 60; playTimeSec = playTimeSec - 60)
        {
            playTimeMin = playTimeMin + 1;
        }
        
        [timeResult[i] setString:[NSString stringWithFormat:@"%.2d:%.2d", playTimeMin, playTimeSec]];
        
        [squaresMovedResult[i] setString:[NSString stringWithFormat:@"%@", [highscoreArray objectAtIndex:2]]];
        [scoreResult[i] setString:[NSString stringWithFormat:@"%@", [highscoreArray objectAtIndex:3]]];
    }
    
    if (kDevicePhone) submitScore = [CCLabelTTF labelWithString:LGLocalizedString(@"submitScore", nil) fontName:kFontComicSans fontSize:textButtonsFontSize];
    else submitScore = [CCLabelTTF labelWithString:LGLocalizedString(@"submitScore", nil) fontName:kFontComicSans fontSize:textButtonsFontSize-2];
    submitScore.position = ccp(winSize.width/2, submitScore.contentSize.height*0.75);
	submitScore.color = kColorLight;
    submitScore.opacity = 0;
	[self addChild:submitScore z:4];
}

#pragma mark - Layers Appear / Disappear

- (void) bgSecondAppear
{
    float duration = .3;
    int opacity = 255;
    
    [kLGKit spriteFade:bgSecond duration:duration opacity:230];
    [kLGKit spriteFade:closeButton duration:duration opacity:opacity];
    [kLGKit spriteFade:closeButtonStroke duration:duration opacity:opacity];
}

- (void) aboutLayerAppear
{
    [self bgSecondAppear];
    
    float duration = .3;
    int opacity = 255;
    
    [kLGKit spriteFade:aboutTitle duration:duration opacity:opacity];
    [kLGKit spriteFade:aboutText duration:duration opacity:opacity];
}

- (void) optionsLayerAppear
{
    [self bgSecondAppear];
    
    float k;
    if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"]) k = 1.4;
    else k = 0.7;
    
    [self setPropertiesForButton:facebookButton
                        buttonBg:facebookButtonBg
                    buttonStroke:facebookButtonStroke
                      buttonText:nil
                        position:ccp(followUs.position.x-facebookButtonBg.contentSize.width*k, followUs.position.y-facebookButtonBg.contentSize.height*0.8)
                           color:kColorLight];
    
    [self setPropertiesForButton:vkontakteButton
                        buttonBg:vkontakteButtonBg
                    buttonStroke:vkontakteButtonStroke
                      buttonText:nil
                        position:ccp(followUs.position.x, followUs.position.y-vkontakteButtonBg.contentSize.height*0.8)
                           color:kColorLight];
    
    [self setPropertiesForButton:twitterButton
                        buttonBg:twitterButtonBg
                    buttonStroke:twitterButtonStroke
                      buttonText:nil
                        position:ccp(followUs.position.x+twitterButtonBg.contentSize.width*k, followUs.position.y-twitterButtonBg.contentSize.height*0.8)
                           color:kColorLight];
    
    float duration = .3;
    int opacity = 255;
    
    [kLGKit spriteFade:optionsTitle duration:duration opacity:opacity];
    [kLGKit spriteFade:selectLanguage duration:duration opacity:opacity];
    [kLGKit spriteFade:selectSound duration:duration opacity:opacity];
    [kLGKit spriteFade:followUs duration:duration opacity:opacity];
    
    [kLGKit spriteFade:facebookButton duration:duration opacity:opacity];
    [kLGKit spriteFade:facebookButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:facebookButtonBg duration:duration opacity:50];
    [kLGKit spriteFade:twitterButton duration:duration opacity:opacity];
    [kLGKit spriteFade:twitterButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:twitterButtonBg duration:duration opacity:50];
    if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"])
    {
        [kLGKit spriteFade:vkontakteButton duration:duration opacity:opacity];
        [kLGKit spriteFade:vkontakteButtonStroke duration:duration opacity:opacity];
        [kLGKit spriteFade:vkontakteButtonBg duration:duration opacity:50];
    }
    
    if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"])
    {
        [kLGKit spriteFade:englishButton duration:duration opacity:200];
        [kLGKit spriteFade:englishButtonStroke duration:duration opacity:200];
        [kLGKit spriteFade:englishButtonBg duration:duration opacity:0];
        [kLGKit spriteFade:russianButton duration:duration opacity:opacity];
        [kLGKit spriteFade:russianButtonStroke duration:duration opacity:opacity];
        [kLGKit spriteFade:russianButtonBg duration:duration opacity:50];
    }
    else if ([LGLocalizationGetPreferredLanguage isEqualToString:@"en"])
    {
        [kLGKit spriteFade:englishButton duration:duration opacity:opacity];
        [kLGKit spriteFade:englishButtonStroke duration:duration opacity:opacity];
        [kLGKit spriteFade:englishButtonBg duration:duration opacity:50];
        [kLGKit spriteFade:russianButton duration:duration opacity:200];
        [kLGKit spriteFade:russianButtonStroke duration:duration opacity:200];
        [kLGKit spriteFade:russianButtonBg duration:duration opacity:0];
    }
    
    if ([kStandartUserDefaults boolForKey:@"soundIsOn"] == YES)
    {
        [kLGKit spriteFade:soundOnButtonBg duration:duration opacity:50];
        [kLGKit spriteFade:soundOnButton duration:duration opacity:opacity];
        [kLGKit spriteFade:soundOnButtonStroke duration:duration opacity:opacity];
        [kLGKit spriteFade:soundOffButtonBg duration:duration opacity:0];
        [kLGKit spriteFade:soundOffButton duration:duration opacity:200];
        [kLGKit spriteFade:soundOffButtonStroke duration:duration opacity:200];
    }
    else if ([kStandartUserDefaults boolForKey:@"soundIsOn"] == NO)
    {
        [kLGKit spriteFade:soundOnButtonBg duration:duration opacity:0];
        [kLGKit spriteFade:soundOnButton duration:duration opacity:200];
        [kLGKit spriteFade:soundOnButtonStroke duration:duration opacity:200];
        [kLGKit spriteFade:soundOffButtonBg duration:duration opacity:50];
        [kLGKit spriteFade:soundOffButton duration:duration opacity:opacity];
        [kLGKit spriteFade:soundOffButtonStroke duration:duration opacity:opacity];
    }
}

- (void) newsLayerAppear
{
    /*
     if (kDevicePhone)
     separatorL[0].position = ccp(winSize.width/2, iconCYR.contentSize.height*iconCYR.scale+separatorL[0].contentSize.height/2);
     else if (kDevicePad)
     separatorL[0].position = ccp(winSize.width/2, iconCYR.contentSize.height*iconCYR.scale+separatorL[0].contentSize.height/2);
     if (kDevicePhone)
     iconCYR.position = ccp(winSize.width*0.23/iconCYR.scale, separatorL[0].position.y-separatorL[0].contentSize.height/4-iconCYR.contentSize.height*0.5*iconCYR.scale);
     else if (kDevicePad)
     iconCYR.position = ccp(iconCYR.contentSize.width*0.60*iconCYR.scale, separatorL[0].position.y-separatorL[0].contentSize.height/4-iconCYR.contentSize.height*0.5*iconCYR.scale);
     iconCYRName.position = ccp(iconCYR.position.x+iconCYR.contentSize.width*0.58*iconCYR.scale, iconCYR.position.y+iconCYR.contentSize.height*0.35*iconCYR.scale);
     iconCYRPrice.position = ccp(iconCYR.position.x+iconCYR.contentSize.width*0.58*iconCYR.scale, iconCYR.position.y);
     iconCYRDownload.position = ccp(iconCYR.position.x+iconCYR.contentSize.width*0.58*iconCYR.scale, iconCYR.position.y-iconCYR.contentSize.height*0.35*iconCYR.scale);
     separatorL[1].position = ccp(winSize.width/2, iconCYR.position.y-iconCYR.contentSize.height*0.5*iconCYR.scale-separatorL[0].contentSize.height/2);
     */
    [self bgSecondAppear];
    
    float duration = .3;
    int opacity = 255;
    
    [kLGKit spriteFade:newsTitle duration:duration opacity:opacity];
    [kLGKit spriteFade:newsText duration:duration opacity:opacity];
    /*
     [kLGKit spriteFade:separatorL[0] duration:duration opacity:opacity];
     [kLGKit spriteFade:separatorL[1] duration:duration opacity:opacity];
     [kLGKit spriteFade:iconCYR duration:duration opacity:opacity];
     [kLGKit spriteFade:iconCYRName duration:duration opacity:opacity];
     [kLGKit spriteFade:iconCYRPrice duration:duration opacity:opacity];
     [kLGKit spriteFade:iconCYRDownload duration:duration opacity:opacity];
     */
}

- (void) purchasesLayerAppear
{
    [self bgSecondAppear];
    
    float duration = .3;
    int opacity = 255;
    
    [kLGKit spriteFade:donate1 duration:duration opacity:opacity];
    [kLGKit spriteFade:donate1Stroke duration:duration opacity:opacity];
    [kLGKit spriteFade:donate3 duration:duration opacity:opacity];
    [kLGKit spriteFade:donate3Stroke duration:duration opacity:opacity];
    [kLGKit spriteFade:donate5 duration:duration opacity:opacity];
    [kLGKit spriteFade:donate5Stroke duration:duration opacity:opacity];
    [kLGKit spriteFade:donate10 duration:duration opacity:opacity];
    [kLGKit spriteFade:donate10Stroke duration:duration opacity:opacity];
    [kLGKit spriteFade:donate25 duration:duration opacity:opacity];
    [kLGKit spriteFade:donate25Stroke duration:duration opacity:opacity];
    [kLGKit spriteFade:purchasesTitle duration:duration opacity:opacity];
    [kLGKit spriteFade:removeAdsText duration:duration opacity:opacity];
    if (kIsGameFull) [kLGKit spriteFade:removeAdsStatus duration:duration opacity:opacity];
    else [kLGKit spriteFade:removeAdsStatus duration:duration opacity:100];
    [kLGKit spriteFade:donateTitle duration:duration opacity:opacity];
    [kLGKit spriteFade:internetAvailabilityTitle duration:duration opacity:opacity];
    [kLGKit spriteFade:internetAvailabilityStatus duration:duration opacity:opacity];
    [kLGKit spriteFade:restoreText duration:duration opacity:opacity];
    
    opacity = 30;
    
    [kLGKit spriteFade:donate1Bg duration:duration opacity:opacity];
    [kLGKit spriteFade:donate3Bg duration:duration opacity:opacity];
    [kLGKit spriteFade:donate5Bg duration:duration opacity:opacity];
    [kLGKit spriteFade:donate10Bg duration:duration opacity:opacity];
    [kLGKit spriteFade:donate25Bg duration:duration opacity:opacity];
}

- (void) moreGamesLayerAppear
{
    if (kDevicePhone)
        separatorL[0].position = ccp(winSize.width/2, moreGamesTitle.position.y-moreGamesTitle.contentSize.height*0.7-separatorL[0].contentSize.height/2);
    else if (kDevicePad)
        separatorL[0].position = ccp(winSize.width/2, moreGamesTitle.position.y-moreGamesTitle.contentSize.height-separatorL[0].contentSize.height/2);
    if (kDevicePhone)
        iconCYR.position = ccp(winSize.width*0.23/iconCYR.scale, separatorL[0].position.y-separatorL[0].contentSize.height/4-iconCYR.contentSize.height*0.5*iconCYR.scale);
    else if (kDevicePad)
        iconCYR.position = ccp(iconCYR.contentSize.width*0.60*iconCYR.scale, separatorL[0].position.y-separatorL[0].contentSize.height/4-iconCYR.contentSize.height*0.5*iconCYR.scale);
    iconCYRName.position = ccp(iconCYR.position.x+iconCYR.contentSize.width*0.58*iconCYR.scale, iconCYR.position.y+iconCYR.contentSize.height*0.35*iconCYR.scale);
    iconCYRPrice.position = ccp(iconCYR.position.x+iconCYR.contentSize.width*0.58*iconCYR.scale, iconCYR.position.y);
    iconCYRDownload.position = ccp(iconCYR.position.x+iconCYR.contentSize.width*0.58*iconCYR.scale, iconCYR.position.y-iconCYR.contentSize.height*0.35*iconCYR.scale);
    separatorL[1].position = ccp(winSize.width/2, iconCYR.position.y-iconCYR.contentSize.height*0.5*iconCYR.scale-separatorL[0].contentSize.height/2);
    
    [self bgSecondAppear];
    
    float duration = .3;
    int opacity = 255;
    
    [kLGKit spriteFade:moreGamesTitle duration:duration opacity:opacity];
    [kLGKit spriteFade:separatorL[0] duration:duration opacity:opacity];
    [kLGKit spriteFade:separatorL[1] duration:duration opacity:opacity];
    [kLGKit spriteFade:iconCYR duration:duration opacity:opacity];
    [kLGKit spriteFade:iconCYRName duration:duration opacity:opacity];
    [kLGKit spriteFade:iconCYRPrice duration:duration opacity:opacity];
    [kLGKit spriteFade:iconCYRDownload duration:duration opacity:opacity];
    [kLGKit spriteFade:goToAppStore duration:duration opacity:opacity];
}

- (void) highscoresLayerAppear
{
    [self bgSecondAppear];
    
    CGPoint facebookButtonPos;
    CGPoint vkontakteButtonPos;
    CGPoint twitterButtonPos;
    
    if (kDevicePhone)
    {
        float k;
        if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"]) k = 0.7;
        else k = 0.62;
        
        facebookButtonPos = CGPointMake(winSize.width-facebookButtonBg.contentSize.width/2+facebookButtonBg.contentSize.width*0.16, winSize.height*k);
        vkontakteButtonPos = CGPointMake(winSize.width-vkontakteButtonBg.contentSize.width/2+vkontakteButtonBg.contentSize.width*0.16, winSize.height/2);
        twitterButtonPos = CGPointMake(winSize.width-twitterButtonBg.contentSize.width/2+twitterButtonBg.contentSize.width*0.16, winSize.height*(1-k));
    }
    else
    {
        float k;
        if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"]) k = 1.4;
        else k = 0.7;
        
        facebookButtonPos = CGPointMake(winSize.width/2-facebookButtonBg.contentSize.width*k, winSize.height*0.11);
        vkontakteButtonPos = CGPointMake(winSize.width/2, winSize.height*0.11);
        twitterButtonPos = CGPointMake(winSize.width/2+twitterButtonBg.contentSize.width*k, winSize.height*0.11);
    }
    
    [self setPropertiesForButton:facebookButton
                        buttonBg:facebookButtonBg
                    buttonStroke:facebookButtonStroke
                      buttonText:nil
                        position:facebookButtonPos
                           color:kColorLight];
    
    [self setPropertiesForButton:vkontakteButton
                        buttonBg:vkontakteButtonBg
                    buttonStroke:vkontakteButtonStroke
                      buttonText:nil
                        position:vkontakteButtonPos
                           color:kColorLight];
    
    [self setPropertiesForButton:twitterButton
                        buttonBg:twitterButtonBg
                    buttonStroke:twitterButtonStroke
                      buttonText:nil
                        position:twitterButtonPos
                           color:kColorLight];
    
    float duration = .3;
    int opacity = 255;
    
    NSMutableArray *highscoresArray = [NSMutableArray arrayWithArray:[kStandartUserDefaults arrayForKey:@"highscoresArray"]];
    
    [kLGKit spriteFade:highscoresTitle duration:duration opacity:opacity];
    [kLGKit spriteFade:submitScore duration:duration opacity:opacity];
    
    [kLGKit spriteFade:facebookButton duration:duration opacity:opacity];
    [kLGKit spriteFade:facebookButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:facebookButtonBg duration:duration opacity:50];
    [kLGKit spriteFade:twitterButton duration:duration opacity:opacity];
    [kLGKit spriteFade:twitterButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:twitterButtonBg duration:duration opacity:50];
    if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"])
    {
        [kLGKit spriteFade:vkontakteButton duration:duration opacity:opacity];
        [kLGKit spriteFade:vkontakteButtonStroke duration:duration opacity:opacity];
        [kLGKit spriteFade:vkontakteButtonBg duration:duration opacity:50];
    }
    
    for (int i=0; i<6; i++)
    {
        if ((i < 2 && kDevicePhone) || (i < 3 && kDevicePad))
        {
            opacity = 255;
            if (highscoresArray.count == 0 && i == 0) opacity = 100;
            if (kDevicePhone)
            {
                if (highscoresArray.count <= 3 && i > 0) opacity = 100;
            }
            if (kDevicePad)
            {
                if (highscoresArray.count <= 2 && i > 0 && i < 2) opacity = 100;
                if (highscoresArray.count <= 4 && i > 1) opacity = 100;
            }
            
            [kLGKit spriteFade:mistakesText[i] duration:duration opacity:opacity];
            [kLGKit spriteFade:timeText[i] duration:duration opacity:opacity];
            [kLGKit spriteFade:squaresMovedText[i] duration:duration opacity:opacity];
            [kLGKit spriteFade:scoreText[i] duration:duration opacity:opacity];
        }
        if ((i < 4 && kDevicePhone) || (i < 3 && kDevicePad))
        {
            opacity = 255;
            if (highscoresArray.count == 0 && i >= 0) opacity = 100;
            else if (highscoresArray.count == 1 && i > 1) opacity = 100;
            else if (highscoresArray.count == 2 && i > 2) opacity = 100;
            else if (highscoresArray.count == 3 && i > 3 && kDevicePhone) opacity = 100;
            
            [kLGKit spriteFade:separator[i] duration:duration opacity:opacity];
        }
        if (i < highscoresArray.count)
        {
            opacity = 255;
            
            [kLGKit spriteFade:mistakesResult[i] duration:duration opacity:opacity];
            [kLGKit spriteFade:timeResult[i] duration:duration opacity:opacity];
            [kLGKit spriteFade:squaresMovedResult[i] duration:duration opacity:opacity];
            [kLGKit spriteFade:scoreResult[i] duration:duration opacity:opacity];
        }
        else
        {
            opacity = 100;
            
            [kLGKit spriteFade:mistakesResult[i] duration:duration opacity:opacity];
            [kLGKit spriteFade:timeResult[i] duration:duration opacity:opacity];
            [kLGKit spriteFade:squaresMovedResult[i] duration:duration opacity:opacity];
            [kLGKit spriteFade:scoreResult[i] duration:duration opacity:opacity];
        }
    }
}

- (void) bgSecondDisappear
{
    float duration = .3;
    int opacity = 0;
    
    [kLGKit spriteFade:bgSecond duration:duration opacity:opacity];
    [kLGKit spriteFade:closeButton duration:duration opacity:opacity];
    [kLGKit spriteFade:closeButtonStroke duration:duration opacity:opacity];
}

- (void) aboutLayerDisappear
{
    [self bgSecondDisappear];
    
    float duration = .3;
    int opacity = 0;
    
    [kLGKit spriteFade:aboutTitle duration:duration opacity:opacity];
    [kLGKit spriteFade:aboutText duration:duration opacity:opacity];
    
    [kLGKit buttonUnselect:aboutButtonBg color:kColorDark buttonText:aboutButtonText withText:@"aboutButtonUnsel"];
}

- (void) optionsLayerDisappear
{
    [self bgSecondDisappear];
    
    float duration = .3;
    int opacity = 0;
    
    [kLGKit spriteFade:optionsTitle duration:duration opacity:opacity];
    [kLGKit spriteFade:selectLanguage duration:duration opacity:opacity];
    [kLGKit spriteFade:englishButton duration:duration opacity:opacity];
    [kLGKit spriteFade:englishButtonBg duration:duration opacity:opacity];
    [kLGKit spriteFade:englishButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:russianButton duration:duration opacity:opacity];
    [kLGKit spriteFade:russianButtonBg duration:duration opacity:opacity];
    [kLGKit spriteFade:russianButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:selectSound duration:duration opacity:opacity];
    [kLGKit spriteFade:soundOnButton duration:duration opacity:opacity];
    [kLGKit spriteFade:soundOnButtonBg duration:duration opacity:opacity];
    [kLGKit spriteFade:soundOnButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:soundOffButton duration:duration opacity:opacity];
    [kLGKit spriteFade:soundOffButtonBg duration:duration opacity:opacity];
    [kLGKit spriteFade:soundOffButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:followUs duration:duration opacity:opacity];
    [kLGKit spriteFade:facebookButton duration:duration opacity:opacity];
    [kLGKit spriteFade:facebookButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:facebookButtonBg duration:duration opacity:opacity];
    [kLGKit spriteFade:twitterButton duration:duration opacity:opacity];
    [kLGKit spriteFade:twitterButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:twitterButtonBg duration:duration opacity:opacity];
    if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"])
    {
        [kLGKit spriteFade:vkontakteButton duration:duration opacity:opacity];
        [kLGKit spriteFade:vkontakteButtonStroke duration:duration opacity:opacity];
        [kLGKit spriteFade:vkontakteButtonBg duration:duration opacity:opacity];
    }
    
    [kLGKit buttonUnselect:optionsButtonBg color:kColorDark buttonText:optionsButtonText withText:@"optionsButtonUnsel"];
}

- (void) newsLayerDisappear
{
    [self bgSecondDisappear];
    
    float duration = .3;
    int opacity = 0;
    
    [kLGKit spriteFade:newsTitle duration:duration opacity:opacity];
    [kLGKit spriteFade:newsText duration:duration opacity:opacity];
    /*
     [kLGKit spriteFade:separatorL[0] duration:duration opacity:opacity];
     [kLGKit spriteFade:separatorL[1] duration:duration opacity:opacity];
     [kLGKit spriteFade:iconCYR duration:duration opacity:opacity];
     [kLGKit spriteFade:iconCYRName duration:duration opacity:opacity];
     [kLGKit spriteFade:iconCYRPrice duration:duration opacity:opacity];
     [kLGKit spriteFade:iconCYRDownload duration:duration opacity:opacity];
     */
    [kLGKit buttonUnselect:newsButtonBg color:kColorDark buttonText:newsButtonText withText:@"newsButtonUnsel"];
}

- (void) purchasesLayerDisappear
{
    [self bgSecondDisappear];
    
    float duration = .3;
    int opacity = 0;
    
    [kLGKit spriteFade:donate1 duration:duration opacity:opacity];
    [kLGKit spriteFade:donate1Stroke duration:duration opacity:opacity];
    [kLGKit spriteFade:donate3 duration:duration opacity:opacity];
    [kLGKit spriteFade:donate3Stroke duration:duration opacity:opacity];
    [kLGKit spriteFade:donate5 duration:duration opacity:opacity];
    [kLGKit spriteFade:donate5Stroke duration:duration opacity:opacity];
    [kLGKit spriteFade:donate10 duration:duration opacity:opacity];
    [kLGKit spriteFade:donate10Stroke duration:duration opacity:opacity];
    [kLGKit spriteFade:donate25 duration:duration opacity:opacity];
    [kLGKit spriteFade:donate25Stroke duration:duration opacity:opacity];
    [kLGKit spriteFade:purchasesTitle duration:duration opacity:opacity];
    [kLGKit spriteFade:removeAdsText duration:duration opacity:opacity];
    [kLGKit spriteFade:removeAdsStatus duration:duration opacity:opacity];
    [kLGKit spriteFade:donateTitle duration:duration opacity:opacity];
    [kLGKit spriteFade:internetAvailabilityTitle duration:duration opacity:opacity];
    [kLGKit spriteFade:internetAvailabilityStatus duration:duration opacity:opacity];
    [kLGKit spriteFade:restoreText duration:duration opacity:opacity];
    [kLGKit spriteFade:donate1Bg duration:duration opacity:opacity];
    [kLGKit spriteFade:donate3Bg duration:duration opacity:opacity];
    [kLGKit spriteFade:donate5Bg duration:duration opacity:opacity];
    [kLGKit spriteFade:donate10Bg duration:duration opacity:opacity];
    [kLGKit spriteFade:donate25Bg duration:duration opacity:opacity];
    
    [kLGKit buttonUnselect:purchasesButtonBg color:kColorGreen buttonText:purchasesButtonText withText:@"purchasesButtonUnsel"];
}

- (void) moreGamesLayerDisappear
{
    [self bgSecondDisappear];
    
    float duration = .3;
    int opacity = 0;
    
    [kLGKit spriteFade:moreGamesTitle duration:duration opacity:opacity];
    [kLGKit spriteFade:separatorL[0] duration:duration opacity:opacity];
    [kLGKit spriteFade:separatorL[1] duration:duration opacity:opacity];
    [kLGKit spriteFade:iconCYR duration:duration opacity:opacity];
    [kLGKit spriteFade:iconCYRName duration:duration opacity:opacity];
    [kLGKit spriteFade:iconCYRPrice duration:duration opacity:opacity];
    [kLGKit spriteFade:iconCYRDownload duration:duration opacity:opacity];
    [kLGKit spriteFade:goToAppStore duration:duration opacity:opacity];
    
    [kLGKit buttonUnselect:moreGamesButtonBg color:kColorDark buttonText:moreGamesButtonText withText:@"moreGamesButtonUnsel"];
}

- (void) highscoresLayerDisappear
{
    [self bgSecondDisappear];
    
    float duration = .3;
    int opacity = 0;
    
    [kLGKit spriteFade:highscoresTitle duration:duration opacity:opacity];
    [kLGKit spriteFade:submitScore duration:duration opacity:opacity];
    
    [kLGKit spriteFade:facebookButton duration:duration opacity:opacity];
    [kLGKit spriteFade:facebookButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:facebookButtonBg duration:duration opacity:opacity];
    [kLGKit spriteFade:twitterButton duration:duration opacity:opacity];
    [kLGKit spriteFade:twitterButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:twitterButtonBg duration:duration opacity:opacity];
    if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"])
    {
        [kLGKit spriteFade:vkontakteButton duration:duration opacity:opacity];
        [kLGKit spriteFade:vkontakteButtonStroke duration:duration opacity:opacity];
        [kLGKit spriteFade:vkontakteButtonBg duration:duration opacity:opacity];
    }
    
    for (int i=0; i<6; i++)
    {
        if ((i < 2 && kDevicePhone) || (i < 3 && kDevicePad))
        {
            [kLGKit spriteFade:mistakesText[i] duration:duration opacity:opacity];
            [kLGKit spriteFade:timeText[i] duration:duration opacity:opacity];
            [kLGKit spriteFade:squaresMovedText[i] duration:duration opacity:opacity];
            [kLGKit spriteFade:scoreText[i] duration:duration opacity:opacity];
        }
        if (i < 4)
        {
            [kLGKit spriteFade:separator[i] duration:duration opacity:opacity];
        }
        
        [kLGKit spriteFade:mistakesResult[i] duration:duration opacity:opacity];
        [kLGKit spriteFade:timeResult[i] duration:duration opacity:opacity];
        [kLGKit spriteFade:squaresMovedResult[i] duration:duration opacity:opacity];
        [kLGKit spriteFade:scoreResult[i] duration:duration opacity:opacity];
    }
    
    [kLGKit buttonUnselect:highscoresButtonBg color:kColorDark buttonText:highscoresButtonText withText:@"highscoresButtonUnsel"];
}

#pragma mark - All Sprites Appear / Disappear

- (void) allSpritesAppear
{
    float duration = .3;
    int opacity = 255;
    
    [kLGKit spriteFade:logo duration:duration opacity:opacity];
    [kLGKit spriteFade:playButton duration:duration opacity:opacity];
    [kLGKit spriteFade:gamecenterButton duration:duration opacity:opacity];
    [kLGKit spriteFade:optionsButton duration:duration opacity:opacity];
    [kLGKit spriteFade:highscoresButton duration:duration opacity:opacity];
    [kLGKit spriteFade:aboutButton duration:duration opacity:opacity];
    [kLGKit spriteFade:newsButton duration:duration opacity:opacity];
    [kLGKit spriteFade:purchasesButton duration:duration opacity:opacity];
    [kLGKit spriteFade:moreGamesButton duration:duration opacity:opacity];
    [kLGKit spriteFade:playButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:optionsButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:highscoresButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:gamecenterButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:aboutButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:newsButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:purchasesButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:moreGamesButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:aboutButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:newsButtonStroke duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 0 && [kStandartUserDefaults integerForKey:@"goToMenuFromTest"] == 0) [kLGKit spriteFade:purchasesButtonStroke duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 0) [kLGKit spriteFade:moreGamesButtonStroke duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 0 && [kStandartUserDefaults integerForKey:@"goToMenuFromTest"] == 0 && kDevicePhone)
        [kLGKit spriteFade:highscoresButtonStroke duration:duration opacity:opacity];
    else if (kDevicePad) [kLGKit spriteFade:highscoresButtonStroke duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 0) [kLGKit spriteFade:gamecenterButtonStroke duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 0 && [kStandartUserDefaults integerForKey:@"goToMenuFromTest"] == 0 && kDevicePad)
        [kLGKit spriteFade:optionsButtonStroke duration:duration opacity:opacity];
    else if (kDevicePhone) [kLGKit spriteFade:optionsButtonStroke duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 0 && [kStandartUserDefaults integerForKey:@"goToMenuFromTest"] == 0) [kLGKit spriteFade:adsBanner duration:duration opacity:opacity];
    
    opacity = 30;
    
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 0 && [kStandartUserDefaults integerForKey:@"goToMenuFromTest"] == 0 && kDevicePad)
        [kLGKit spriteFade:optionsButtonBg duration:duration opacity:opacity];
    else if (kDevicePhone) [kLGKit spriteFade:optionsButtonBg duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 0 && [kStandartUserDefaults integerForKey:@"goToMenuFromTest"] == 0 && kDevicePhone)
        [kLGKit spriteFade:highscoresButtonBg duration:duration opacity:opacity];
    else if (kDevicePad) [kLGKit spriteFade:highscoresButtonBg duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 0) [kLGKit spriteFade:gamecenterButtonBg duration:duration opacity:opacity];
    [kLGKit spriteFade:aboutButtonBg duration:duration opacity:opacity];
    [kLGKit spriteFade:newsButtonBg duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 0 && [kStandartUserDefaults integerForKey:@"goToMenuFromTest"] == 0) [kLGKit spriteFade:purchasesButtonBg duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 0) [kLGKit spriteFade:moreGamesButtonBg duration:duration opacity:opacity];
    
    if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 1 || [kStandartUserDefaults integerForKey:@"goToMenuFromTest"] == 1)
    {
        if ([kStandartUserDefaults integerForKey:@"goToMenuFromResults"] == 1)
        {
            gamecenterButtonBg.opacity = 30;
            gamecenterButtonStroke.opacity = 255;
            
            moreGamesButtonBg.opacity = 30;
            moreGamesButtonStroke.opacity = 255;
        }
        
        if (kDevicePhone)
        {
            highscoresButtonBg.opacity = 30;
            highscoresButtonStroke.opacity = 255;
        }
        else if (kDevicePad)
        {
            optionsButtonBg.opacity = 30;
            optionsButtonStroke.opacity = 255;
        }
        
        purchasesButtonBg.opacity = 30;
        purchasesButtonStroke.opacity = 255;
        
        if (!kIsGameFull) adsBanner.opacity = 255;
        
        [kStandartUserDefaults setInteger:0 forKey:@"goToMenuFromResults"];
        [kStandartUserDefaults setInteger:0 forKey:@"goToMenuFromTest"];
    }
    
    [kLGKit spriteFade:copyrightButton duration:duration opacity:125];
}

- (void) allSpritesDisappear
{
    float duration = .3;
    int opacity = 0;
    
	[kLGKit spriteFade:logo duration:duration opacity:opacity];
    [kLGKit spriteFade:playButton duration:duration opacity:opacity];
    [kLGKit spriteFade:gamecenterButton duration:duration opacity:opacity];
    [kLGKit spriteFade:optionsButton duration:duration opacity:opacity];
    [kLGKit spriteFade:highscoresButton duration:duration opacity:opacity];
    [kLGKit spriteFade:aboutButton duration:duration opacity:opacity];
    [kLGKit spriteFade:newsButton duration:duration opacity:opacity];
    [kLGKit spriteFade:purchasesButton duration:duration opacity:opacity];
    [kLGKit spriteFade:moreGamesButton duration:duration opacity:opacity];
    [kLGKit spriteFade:playButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:optionsButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:highscoresButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:gamecenterButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:aboutButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:newsButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:purchasesButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:moreGamesButtonText duration:duration opacity:opacity];
    [kLGKit spriteFade:aboutButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:newsButtonStroke duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToTest"] == 0) [kLGKit spriteFade:purchasesButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:moreGamesButtonStroke duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToTest"] == 0 && kDevicePhone) [kLGKit spriteFade:highscoresButtonStroke duration:duration opacity:opacity];
    else if (kDevicePad) [kLGKit spriteFade:highscoresButtonStroke duration:duration opacity:opacity];
    [kLGKit spriteFade:gamecenterButtonStroke duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToTest"] == 0 && kDevicePad) [kLGKit spriteFade:optionsButtonStroke duration:duration opacity:opacity];
    else if (kDevicePhone) [kLGKit spriteFade:optionsButtonStroke duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToTest"] == 0 && kDevicePad) [kLGKit spriteFade:optionsButtonBg duration:duration opacity:opacity];
    else if (kDevicePhone) [kLGKit spriteFade:optionsButtonBg duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToTest"] == 0 && kDevicePhone) [kLGKit spriteFade:highscoresButtonBg duration:duration opacity:opacity];
    else if (kDevicePad) [kLGKit spriteFade:highscoresButtonBg duration:duration opacity:opacity];
    [kLGKit spriteFade:gamecenterButtonBg duration:duration opacity:opacity];
    [kLGKit spriteFade:aboutButtonBg duration:duration opacity:opacity];
    [kLGKit spriteFade:newsButtonBg duration:duration opacity:opacity];
    if ([kStandartUserDefaults integerForKey:@"goToTest"] == 0) [kLGKit spriteFade:purchasesButtonBg duration:duration opacity:opacity];
    [kLGKit spriteFade:moreGamesButtonBg duration:duration opacity:opacity];
    [kLGKit spriteFade:copyrightButton duration:duration opacity:opacity];
}

#pragma mark - Refresh All Strings

- (void) refreshAllStrings
{
    [selectLanguage setString:LGLocalizedString(@"selectLanguage", nil)];
    [selectSound setString:LGLocalizedString(@"selectSound", nil)];
    [followUs setString:LGLocalizedString(@"followUs", nil)];
    [soundOnButton setString:LGLocalizedString(@"soundOn", nil)];
    [soundOffButton setString:LGLocalizedString(@"soundOff", nil)];
    
    [playButtonText setString:LGLocalizedString(@"playButtonUnsel", nil)];
    [newsButtonText setString:LGLocalizedString(@"newsButtonUnsel", nil)];
    [purchasesButtonText setString:LGLocalizedString(@"purchasesButtonUnsel", nil)];
    [optionsButtonText setString:LGLocalizedString(@"optionsButtonUnsel", nil)];
    [highscoresButtonText setString:LGLocalizedString(@"highscoresButtonUnsel", nil)];
    [aboutButtonText setString:LGLocalizedString(@"aboutButtonUnsel", nil)];
    [moreGamesButtonText setString:LGLocalizedString(@"moreGamesButtonUnsel", nil)];
    
    if (kDevicePhone)
    {
        newsButtonText.position = ccp(newsButtonBg.position.x-newsButtonBg.contentSize.width*0.42-newsButtonText.contentSize.width*0.35,
                                      newsButtonBg.position.y+newsButtonBg.contentSize.height*0.47+newsButtonText.contentSize.width*0.35);
        purchasesButtonText.position = ccp(purchasesButtonBg.position.x-purchasesButtonBg.contentSize.width*0.42-purchasesButtonText.contentSize.width*0.35,
                                           purchasesButtonBg.position.y+purchasesButtonBg.contentSize.height*0.47+purchasesButtonText.contentSize.width*0.35);
        optionsButtonText.position = ccp(optionsButtonBg.position.x+optionsButtonBg.contentSize.width*0.42+optionsButtonText.contentSize.width*0.35,
                                         optionsButtonBg.position.y+optionsButtonBg.contentSize.height*0.47+optionsButtonText.contentSize.width*0.35);
        highscoresButtonText.position = ccp(highscoresButtonBg.position.x+highscoresButtonBg.contentSize.width*0.42+highscoresButtonText.contentSize.width*0.35,
                                            highscoresButtonBg.position.y+highscoresButtonBg.contentSize.height*0.47+highscoresButtonText.contentSize.width*0.35);
        aboutButtonText.position = ccp(aboutButtonBg.position.x-aboutButtonBg.contentSize.width*0.42-aboutButtonText.contentSize.width*0.35,
                                       aboutButtonBg.position.y+aboutButtonBg.contentSize.height*0.47+aboutButtonText.contentSize.width*0.35);
        moreGamesButtonText.position = ccp(moreGamesButtonBg.position.x-moreGamesButtonBg.contentSize.width*0.42-moreGamesButtonText.contentSize.width*0.35,
                                           moreGamesButtonBg.position.y+moreGamesButtonBg.contentSize.height*0.47+moreGamesButtonText.contentSize.width*0.35);
    }
    else if (kDevicePad)
    {
        newsButtonText.position = ccp(newsButtonBg.position.x-newsButtonBg.contentSize.width*0.55-newsButtonText.contentSize.width/2, newsButtonBg.position.y);
        purchasesButtonText.position = ccp(purchasesButtonBg.position.x-purchasesButtonBg.contentSize.width*0.55-purchasesButtonText.contentSize.width/2, purchasesButtonBg.position.y);
        optionsButtonText.position = ccp(optionsButtonBg.position.x+optionsButtonBg.contentSize.width*0.55+optionsButtonText.contentSize.width/2, optionsButtonBg.position.y);
        highscoresButtonText.position = ccp(highscoresButtonBg.position.x+highscoresButtonBg.contentSize.width*0.55+highscoresButtonText.contentSize.width/2, highscoresButtonBg.position.y);
        aboutButtonText.position = ccp(aboutButtonBg.position.x-aboutButtonBg.contentSize.width*0.55-aboutButtonText.contentSize.width/2, aboutButtonBg.position.y);
        moreGamesButtonText.position = ccp(moreGamesButtonBg.position.x-moreGamesButtonBg.contentSize.width*0.55-moreGamesButtonText.contentSize.width/2, moreGamesButtonBg.position.y);
    }
    
    [optionsButtonText setString:LGLocalizedString(@"optionsButtonSel", nil)];
    
    [newsTitle setString:LGLocalizedString(@"newsTitle", nil)];
    [purchasesTitle setString:LGLocalizedString(@"purchasesTitle", nil)];
    [optionsTitle setString:LGLocalizedString(@"optionsTitle", nil)];
    [aboutTitle setString:LGLocalizedString(@"aboutTitle", nil)];
    [highscoresTitle setString:LGLocalizedString(@"highscoresTitle", nil)];
    [moreGamesTitle setString:LGLocalizedString(@"moreGamesTitle", nil)];
    
    [newsText setString:LGLocalizedString(@"newsText", nil)];
    [aboutText setString:LGLocalizedString(@"aboutText", nil)];
    
    int count;
    if (kDevicePhone) count = 2;
    else count = 3;
    
    for (int i=0; i<count; i++)
    {
        [mistakesText[i] setString:LGLocalizedString(@"mistakes", nil)];
        [timeText[i] setString:LGLocalizedString(@"time", nil)];
        [squaresMovedText[i] setString:LGLocalizedString(@"squaresMoved", nil)];
        [scoreText[i] setString:LGLocalizedString(@"score", nil)];
    }
    [submitScore setString:LGLocalizedString(@"submitScore", nil)];
    
    [removeAdsText setString:LGLocalizedString(@"removeAdsText", nil)];
    if (kIsGameFull) [removeAdsStatus setString:LGLocalizedString(@"removeAdsYes", nil)];
    else [removeAdsStatus setString:LGLocalizedString(@"removeAdsNo", nil)];
    [restoreText setString:LGLocalizedString(@"restoreText", nil)];
    [donateTitle setString:LGLocalizedString(@"donateTitle", nil)];
    [internetAvailabilityTitle setString:LGLocalizedString(@"internetAvailabilityTitle", nil)];
    
    [iconCYRPrice setString:LGLocalizedString(@"priceFree", nil)];
    [iconCYRDownload setString:LGLocalizedString(@"download", nil)];
    [goToAppStore setString:LGLocalizedString(@"goToAppStore", nil)];
    
    float k;
    if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"])
    {
        vkontakteButton.opacity = 255;
        vkontakteButtonBg.opacity = 50;
        vkontakteButtonStroke.opacity = 255;
        
        k = 1.4;
    }
    else
    {
        vkontakteButton.opacity = 0;
        vkontakteButtonBg.opacity = 0;
        vkontakteButtonStroke.opacity = 0;
        
        k = 0.7;
    }
    
    [self setPropertiesForButton:facebookButton
                        buttonBg:facebookButtonBg
                    buttonStroke:facebookButtonStroke
                      buttonText:nil
                        position:ccp(followUs.position.x-facebookButtonBg.contentSize.width*k, followUs.position.y-facebookButtonBg.contentSize.height*0.8)
                           color:kColorLight];
    
    facebookButton.opacity = 255;
    facebookButtonBg.opacity = 50;
    facebookButtonStroke.opacity = 255;
    
    [self setPropertiesForButton:twitterButton
                        buttonBg:twitterButtonBg
                    buttonStroke:twitterButtonStroke
                      buttonText:nil
                        position:ccp(followUs.position.x+twitterButtonBg.contentSize.width*k, followUs.position.y-twitterButtonBg.contentSize.height*0.8)
                           color:kColorLight];
    
    twitterButton.opacity = 255;
    twitterButtonBg.opacity = 50;
    twitterButtonStroke.opacity = 255;
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
        
        [kLGKit buttonUnselect:gamecenterButtonBg color:kColorDark buttonText:gamecenterButtonText withText:@"gamecenterButtonUnsel"];
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

#pragma mark - Переходы

- (void) goToTest
{
    if (kDevicePad) [[CCDirector sharedDirector] replaceScene:[TestLayer_iPad scene]];
    else if (kDevicePhone) [[CCDirector sharedDirector] replaceScene:[TestLayer_iPhone scene]];
}

#pragma mark -

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
    
    if (CGRectContainsPoint(playButton.boundingBox, touchPoint) && bgSecondOnScreen == 0) ////////// play
    {
        [playButton setTexture:playButtonTappedT2D];
        [playButtonText setString:LGLocalizedString(@"playButtonSel", nil)];
        
        [self soundButton];
        
        z = 1;
    }
    else if (CGRectContainsPoint(gamecenterButtonBg.boundingBox, touchPoint) && bgSecondOnScreen == 0) ////////// gamecenter
    {
        [kLGKit buttonSelect:gamecenterButtonBg color:kColorLight buttonText:gamecenterButtonText withText:@"gamecenterButtonSel"];
        
        [self soundButton];
        
        z = 2;
    }
    else if (CGRectContainsPoint(optionsButtonBg.boundingBox, touchPoint) && bgSecondOnScreen == 0) ////////// options
    {
        [kLGKit buttonSelect:optionsButtonBg color:kColorLight buttonText:optionsButtonText withText:@"optionsButtonSel"];
        
        [self soundButton];
        
        z = 3;
    }
    else if (CGRectContainsPoint(highscoresButtonBg.boundingBox, touchPoint) && bgSecondOnScreen == 0) ////////// highscores
    {
        [kLGKit buttonSelect:highscoresButtonBg color:kColorLight buttonText:highscoresButtonText withText:@"highscoresButtonSel"];
        
        [self soundButton];
        
        z = 4;
    }
    else if (CGRectContainsPoint(aboutButtonBg.boundingBox, touchPoint) && bgSecondOnScreen == 0) ////////// about
    {
        [kLGKit buttonSelect:aboutButtonBg color:kColorLight buttonText:aboutButtonText withText:@"aboutButtonSel"];
        
        [self soundButton];
        
        z = 5;
    }
    else if (CGRectContainsPoint(newsButtonBg.boundingBox, touchPoint) && bgSecondOnScreen == 0) ////////// news
    {
        [kLGKit buttonSelect:newsButtonBg color:kColorLight buttonText:newsButtonText withText:@"newsButtonSel"];
        
        [self soundButton];
        
        z = 6;
    }
    else if (CGRectContainsPoint(purchasesButtonBg.boundingBox, touchPoint) && bgSecondOnScreen == 0) ////////// purchases
    {
        [kLGKit buttonSelect:purchasesButtonBg color:kColorGreen buttonText:purchasesButtonText withText:@"purchasesButtonSel"];
        
        [self soundButton];
        
        z = 7;
    }
    else if (CGRectContainsPoint(moreGamesButtonBg.boundingBox, touchPoint) && bgSecondOnScreen == 0) ////////// moreGames
    {
        [kLGKit buttonSelect:moreGamesButtonBg color:kColorLight buttonText:moreGamesButtonText withText:@"moreGamesButtonSel"];
        
        [self soundButton];
        
        z = 8;
    }
    else if (CGRectContainsPoint(closeButtonStroke.boundingBox, touchPoint) && bgSecondOnScreen == 1) ////////// close
    {
        if (aboutOnScreen == 1) [self aboutLayerDisappear];
        else if (optionsOnScreen == 1) [self optionsLayerDisappear];
        else if (newsOnScreen == 1) [self newsLayerDisappear];
        else if (purchasesOnScreen == 1) [self purchasesLayerDisappear];
        else if (moreGamesOnScreen == 1) [self moreGamesLayerDisappear];
        else if (highscoresOnScreen == 1) [self highscoresLayerDisappear];
        
        aboutOnScreen = 0;
        optionsOnScreen = 0;
        newsOnScreen = 0;
        purchasesOnScreen = 0;
        moreGamesOnScreen = 0;
        highscoresOnScreen = 0;
        bgSecondOnScreen = 0;
        
        [self soundButton];
    }
    else if (CGRectContainsPoint(englishButtonBg.boundingBox, touchPoint) && optionsOnScreen == 1) ////////// English
	{
        [self soundChoose];
        
        LGLocalizationSetLanguage(@"en");
        
        englishButton.opacity = 255;
        englishButtonBg.opacity = 50;
        englishButtonStroke.opacity = 255;
        russianButton.opacity = 200;
        russianButtonBg.opacity = 0;
        russianButtonStroke.opacity = 200;
        
        [self refreshAllStrings];
	}
    else if (CGRectContainsPoint(russianButtonBg.boundingBox, touchPoint) && optionsOnScreen == 1) ////////// Russian
	{
        [self soundChoose];
        
        LGLocalizationSetLanguage(@"ru");
        
        englishButton.opacity = 200;
        englishButtonBg.opacity = 0;
        englishButtonStroke.opacity = 200;
        russianButton.opacity = 255;
        russianButtonBg.opacity = 50;
        russianButtonStroke.opacity = 255;
        
        [self refreshAllStrings];
	}
    else if (CGRectContainsPoint(soundOnButtonBg.boundingBox, touchPoint) && optionsOnScreen == 1) ////////// Sound On
	{
        kSimpleAudioEngine.effectsVolume = 1;
        
        [kStandartUserDefaults setBool:YES forKey:@"soundIsOn"];
        
        soundOnButton.opacity = 255;
        soundOnButtonBg.opacity = 50;
        soundOnButtonStroke.opacity = 255;
        soundOffButton.opacity = 200;
        soundOffButtonBg.opacity = 0;
        soundOffButtonStroke.opacity = 200;
        
        [self soundChoose];
	}
    else if (CGRectContainsPoint(soundOffButtonBg.boundingBox, touchPoint) && optionsOnScreen == 1) ////////// Sound Off
	{
        kSimpleAudioEngine.effectsVolume = 0;
        
        [kStandartUserDefaults setBool:NO forKey:@"soundIsOn"];
        
        soundOnButton.opacity = 200;
        soundOnButtonBg.opacity = 0;
        soundOnButtonStroke.opacity = 200;
        soundOffButton.opacity = 255;
        soundOffButtonBg.opacity = 50;
        soundOffButtonStroke.opacity = 255;
        
        [self soundChoose];
	}
    else if (CGRectContainsPoint(submitScore.boundingBox, touchPoint) && highscoresOnScreen == 1) ////////// Submit score to GC
	{
        [self soundChoose];
        
        if ([kLGGameCenter isGameCenterEnable])
        {
            if ([kStandartUserDefaults arrayForKey:@"highscoresArray"])
            {
                NSMutableArray *highscoresArray = [NSMutableArray arrayWithArray:[kStandartUserDefaults arrayForKey:@"highscoresArray"]];
                NSArray *highscoreArray = [highscoresArray objectAtIndex:0];
                int bestScore = [[highscoreArray objectAtIndex:3] intValue];
                
                [kLGGameCenter submitScore:bestScore forCategory:@"com.ApogeeStudio.CheckYourCV.Score" withAlert:YES];
            }
            else [kLGGameCenter submitScore:0 forCategory:@"com.ApogeeStudio.CheckYourCV.Score" withAlert:YES];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:LGLocalizedString(@"GCErrorTitle", nil)
                                        message:LGLocalizedString(@"GCErrorMessage", nil)
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
	}
    else if (CGRectContainsPoint(goToAppStore.boundingBox, touchPoint) && moreGamesOnScreen == 1) ////////// Перейти в аппстор на мою стр
	{
        [self soundChoose];
        
        if (kInternetStatus)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.com/apps/ApogeeStudio"]];
        }
        else [kLGKit createAlertNoInternet];
	}
    else if (touchPoint.y < separatorL[0].position.y && touchPoint.y > separatorL[1].position.y && (moreGamesOnScreen || newsOnScreen)) ////////// Перейти на стр CheckYourR
	{
        [self soundChoose];
        
        if (kInternetStatus)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.com/apps/apogeeStudio/CheckYourReactionFree"]];
        }
        else [kLGKit createAlertNoInternet];
	}
    else if ((CGRectContainsPoint(removeAdsText.boundingBox, touchPoint) || CGRectContainsPoint(removeAdsStatus.boundingBox, touchPoint)) && purchasesOnScreen == 1) ////////// Remove Ads
	{
        [self soundChoose];
        
        if ([kLGInAppPurchases canMakePurchases] && [kLGInAppPurchases storeLoaded]) [kLGInAppPurchases purchaseProduct:@"com.ApogeeStudio.CheckYourCV.RemoveAds"];
	}
    else if (CGRectContainsPoint(restoreText.boundingBox, touchPoint) && purchasesOnScreen == 1) ////////// restore
	{
        [self soundChoose];
        
        if ([kLGInAppPurchases canMakePurchases] && [kLGInAppPurchases storeLoaded]) [kLGInAppPurchases restoreCompletedTransactions];
	}
    else if (CGRectContainsPoint(donate1Bg.boundingBox, touchPoint) && purchasesOnScreen == 1) ////////// Donate $1
	{
        [self soundChoose];
        
        if ([kLGInAppPurchases canMakePurchases] && [kLGInAppPurchases storeLoaded]) [kLGInAppPurchases purchaseProduct:@"com.ApogeeStudio.CheckYourCV.Donate1"];
	}
    else if (CGRectContainsPoint(donate3Bg.boundingBox, touchPoint) && purchasesOnScreen == 1) ////////// Donate $3
	{
        [self soundChoose];
        
        if ([kLGInAppPurchases canMakePurchases] && [kLGInAppPurchases storeLoaded]) [kLGInAppPurchases purchaseProduct:@"com.ApogeeStudio.CheckYourCV.Donate3"];
	}
    else if (CGRectContainsPoint(donate5Bg.boundingBox, touchPoint) && purchasesOnScreen == 1) ////////// Donate $5
	{
        [self soundChoose];
        
        if ([kLGInAppPurchases canMakePurchases] && [kLGInAppPurchases storeLoaded]) [kLGInAppPurchases purchaseProduct:@"com.ApogeeStudio.CheckYourCV.Donate5"];
	}
    else if (CGRectContainsPoint(donate10Bg.boundingBox, touchPoint) && purchasesOnScreen == 1) ////////// Donate $10
	{
        [self soundChoose];
        
        if ([kLGInAppPurchases canMakePurchases] && [kLGInAppPurchases storeLoaded]) [kLGInAppPurchases purchaseProduct:@"com.ApogeeStudio.CheckYourCV.Donate10"];
	}
    else if (CGRectContainsPoint(donate25Bg.boundingBox, touchPoint) && purchasesOnScreen == 1) ////////// Donate $25
	{
        [self soundChoose];
        
        if ([kLGInAppPurchases canMakePurchases] && [kLGInAppPurchases storeLoaded]) [kLGInAppPurchases purchaseProduct:@"com.ApogeeStudio.CheckYourCV.Donate25"];
	}
    else if (CGRectContainsPoint(copyrightButton.boundingBox, touchPoint) && !bgSecondOnScreen) ////////// Copyright
	{
        NSString *gameName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        NSString *gameVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        NSString *title = [NSString stringWithFormat:@"%@ %@", gameName, gameVersion];
        
        NSString *message = [NSString stringWithFormat:@"%@: %@\n\n%@: Cocos2d\n\n%@: www.freesound.org",
                             LGLocalizedString(@"developer", nil), LGLocalizedString(@"myName", nil),
                             LGLocalizedString(@"engine", nil), LGLocalizedString(@"sounds", nil)];
        
        [[[UIAlertView alloc] initWithTitle:title
                                    message:message
                                   delegate:self
                          cancelButtonTitle:LGLocalizedString(@"close", nil)
                          otherButtonTitles:nil] show];
	}
    else if (CGRectContainsPoint(facebookButtonBg.boundingBox, touchPoint) && (optionsOnScreen == 1 || highscoresOnScreen == 1)) ////////// Facebook
	{
        [self soundChoose];
        
        if (kInternetStatus)
        {
            if (optionsOnScreen == 1)
            {
                if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"])
                {
                    NSURL *url = [NSURL URLWithString:@"fb://profile/484109101637910"];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) [[UIApplication sharedApplication] openURL:url];
                    else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/484109101637910"]];
                }
                else
                {
                    NSURL *url = [NSURL URLWithString:@"fb://profile/142385912600384"];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) [[UIApplication sharedApplication] openURL:url];
                    else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/ApogeeStudio.en"]];
                }
            }
            else if (highscoresOnScreen == 1)
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
        }
        else [kLGKit createAlertNoInternet];
	}
    else if (CGRectContainsPoint(twitterButtonBg.boundingBox, touchPoint) && (optionsOnScreen == 1 || highscoresOnScreen == 1)) ////////// Twitter
	{
        [self soundChoose];
        
        if (kInternetStatus)
        {
            if (optionsOnScreen == 1)
            {
                if ([LGLocalizationGetPreferredLanguage isEqualToString:@"ru"])
                {
                    NSURL *url = [NSURL URLWithString:@"twitter://user?screen_name=ApogeeStudioRu"];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) [[UIApplication sharedApplication] openURL:url];
                    else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/ApogeeStudioRu"]];
                }
                else
                {
                    NSURL *url = [NSURL URLWithString:@"twitter://user?screen_name=ApogeeStudioEn"];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) [[UIApplication sharedApplication] openURL:url];
                    else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/ApogeeStudioEn"]];
                }
            }
            else if (highscoresOnScreen == 1)
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
        }
        else [kLGKit createAlertNoInternet];
	}
    else if (CGRectContainsPoint(vkontakteButtonBg.boundingBox, touchPoint) && [LGLocalizationGetPreferredLanguage isEqualToString:@"ru"] && (optionsOnScreen == 1 || highscoresOnScreen == 1)) ////////// ВКонтакте
	{
        [self soundChoose];
        
        if (kInternetStatus)
        {
            if (optionsOnScreen == 1) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://vk.com/apogeestudio"]];
            else if (highscoresOnScreen == 1)
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
        }
        else [kLGKit createAlertNoInternet];
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	touch = [touches anyObject];
	touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
	
    if (CGRectContainsPoint(playButton.boundingBox, touchPoint) && z == 1) ////////// play
    {
        self.isTouchEnabled = NO;
        
        [kStandartUserDefaults setInteger:1 forKey:@"goToTest"];
        
        [self allSpritesDisappear];
        
        [self performSelector:@selector(goToTest) withObject:nil afterDelay:0.3];
    }
    else if (z == 1)
    {
        [playButton setTexture:playButtonT2D];
        [playButtonText setString:LGLocalizedString(@"playButtonUnsel", nil)];
    }
    
    if (CGRectContainsPoint(gamecenterButtonBg.boundingBox, touchPoint) && z == 2) ////////// gamecenter
    {
        alertGC = [[UIAlertView alloc] initWithTitle:nil
                                             message:nil
                                            delegate:self
                                   cancelButtonTitle:LGLocalizedString(@"cancel", nil)
                                   otherButtonTitles:LGLocalizedString(@"leaderboards", nil), LGLocalizedString(@"achievements", nil), nil];
        [alertGC show];
    }
    else if (z == 2) [kLGKit buttonUnselect:gamecenterButtonBg color:kColorDark buttonText:gamecenterButtonText withText:@"gamecenterButtonUnsel"];
    
    if (CGRectContainsPoint(optionsButtonBg.boundingBox, touchPoint) && z == 3) ////////// options
    {
        self.isTouchEnabled = NO;
        
        optionsOnScreen = 1;
        bgSecondOnScreen = 1;
        
        [self optionsLayerAppear];
        
        [kLGKit performSelector:@selector(touchEnableWithTarget:) withObject:self afterDelay:0.3];
    }
    else if (z == 3) [kLGKit buttonUnselect:optionsButtonBg color:kColorDark buttonText:optionsButtonText withText:@"optionsButtonUnsel"];
    
    if (CGRectContainsPoint(highscoresButtonBg.boundingBox, touchPoint) && z == 4) ////////// highscores
    {
        self.isTouchEnabled = NO;
        
        highscoresOnScreen = 1;
        bgSecondOnScreen = 1;
        
        [self highscoresLayerAppear];
        
        [kLGKit performSelector:@selector(touchEnableWithTarget:) withObject:self afterDelay:0.3];
    }
    else if (z == 4) [kLGKit buttonUnselect:highscoresButtonBg color:kColorDark buttonText:highscoresButtonText withText:@"highscoresButtonUnsel"];
    
    if (CGRectContainsPoint(aboutButtonBg.boundingBox, touchPoint) && z == 5) ////////// about
    {
        self.isTouchEnabled = NO;
        
        aboutOnScreen = 1;
        bgSecondOnScreen = 1;
        
        [self aboutLayerAppear];
        
        [kLGKit performSelector:@selector(touchEnableWithTarget:) withObject:self afterDelay:0.3];
    }
    else if (z == 5) [kLGKit buttonUnselect:aboutButtonBg color:kColorDark buttonText:aboutButtonText withText:@"aboutButtonUnsel"];
    
    if (CGRectContainsPoint(newsButtonBg.boundingBox, touchPoint) && z == 6) ////////// news
    {
        self.isTouchEnabled = NO;
        
        newsOnScreen = 1;
        bgSecondOnScreen = 1;
        
        [self newsLayerAppear];
        
        [kLGKit performSelector:@selector(touchEnableWithTarget:) withObject:self afterDelay:0.3];
    }
    else if (z == 6) [kLGKit buttonUnselect:newsButtonBg color:kColorDark buttonText:newsButtonText withText:@"newsButtonUnsel"];
    
    if (CGRectContainsPoint(purchasesButtonBg.boundingBox, touchPoint) && z == 7) ////////// purchases
    {
        self.isTouchEnabled = NO;
        
        purchasesOnScreen = 1;
        bgSecondOnScreen = 1;
        
        kInternetStatus;
        
        [self purchasesLayerAppear];
        
        [kLGKit performSelector:@selector(touchEnableWithTarget:) withObject:self afterDelay:0.3];
    }
    else if (z == 7) [kLGKit buttonUnselect:purchasesButtonBg color:kColorGreen buttonText:purchasesButtonText withText:@"purchasesButtonUnsel"];
    
    if (CGRectContainsPoint(moreGamesButtonBg.boundingBox, touchPoint) && z == 8) ////////// moreGames
    {
        self.isTouchEnabled = NO;
        
        moreGamesOnScreen = 1;
        bgSecondOnScreen = 1;
        
        [self moreGamesLayerAppear];
        
        [kLGKit performSelector:@selector(touchEnableWithTarget:) withObject:self afterDelay:0.3];
    }
    else if (z == 8) [kLGKit buttonUnselect:moreGamesButtonBg color:kColorDark buttonText:moreGamesButtonText withText:@"moreGamesButtonUnsel"];
    
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