//
//  Created by Grigory Lutkov on 01.10.12.
//  Copyright (c) 2012 Grigory Lutkov. All rights reserved.
//

#import "cocos2d.h"
#import "Vkontakte.h"

@interface TestLayer_iPad : CCLayer <VkontakteDelegate>
{
    int             squaresMoved;
    int             textFontSize;
    int             titleFontSize;
    int             buttonsFontSize;
    int             take;
    int             gameFinish;
    int             mistakesOnScreen;
    int             tryAgain;
    int             number;
    int             newPlace[100];
    int             lol[100];
    int             playTime;
    int             buttonsBgFontSize;
    int             helpOnScreen;
    int             socialButtonsFontSize;
    
    CCSprite        *bgSecond;
    CCLabelTTF      *help;
    CCSprite        *stripeL;
    
    CCLabelTTF      *timer;
    CCLabelTTF      *squaresMovedText;
    CCLabelTTF      *squaresMovedResult;
    CCLabelTTF      *mistakesText;
    CCLabelTTF      *mistakesResult;
    CCLabelTTF      *timeText;
    CCLabelTTF      *scoreText;
    CCLabelTTF      *scoreResult;
    
    CCTexture2D     *squareT;
    CCTexture2D     *stripeT;
    
    CGPoint         place[100];
    CCSprite        *square[100];
    CCSprite        *squareBig;
    CCSprite        *stripe[10];
    
    CCLabelTTF      *nextButtonText;
    CCLabelTTF      *nextButtonBg;
    CCLabelTTF      *nextButtonStroke;
    CCLabelTTF      *nextText;
    
    CCLabelTTF      *previousButtonText;
    CCLabelTTF      *previousButtonBg;
    CCLabelTTF      *previousButtonStroke;
    CCLabelTTF      *previousText;
    
    CCLabelTTF      *menuButton;
    CCLabelTTF      *menuButtonBg;
    CCLabelTTF      *menuButtonStroke;
    CCLabelTTF      *menuButtonText;
    
    CCLabelTTF      *gamecenterButton;
    CCLabelTTF      *gamecenterButtonBg;
    CCLabelTTF      *gamecenterButtonStroke;
    
    CCLabelTTF      *facebookButton;
    CCLabelTTF      *facebookButtonBg;
    CCLabelTTF      *facebookButtonStroke;
    
    CCLabelTTF      *twitterButton;
    CCLabelTTF      *twitterButtonBg;
    CCLabelTTF      *twitterButtonStroke;
    
    CCLabelTTF      *vkontakteButton;
    CCLabelTTF      *vkontakteButtonBg;
    CCLabelTTF      *vkontakteButtonStroke;
    
    CCSprite        *tryAgainButtonImg;
    CCLabelTTF      *results;
    CCLabelTTF      *sure;
    CCLabelTTF      *yesButton;
    CCLabelTTF      *noButton;
    CCLabelTTF      *tryAgainButton;
    CCLabelTTF      *showMistakesButtonText;
    CCLabelTTF      *squareMistakeText[100];
    
    NSMutableArray  *array[10];
    NSMutableArray  *arraySupport[10];
    
    NSDate  *startTime;
    NSDate  *endTime;
    
    UIAlertView     *alertGC;
    UIAlertView         *alertVK;
}

+ (CCScene *) scene;
- (void) sceneItems;

@end
