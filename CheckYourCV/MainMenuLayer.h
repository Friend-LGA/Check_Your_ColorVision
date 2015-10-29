//
//  Created by Grigory Lutkov on 01.10.12.
//  Copyright (c) 2012 Grigory Lutkov. All rights reserved.
//

#import "cocos2d.h"
#import "Reachability.h"
#import "Vkontakte.h"

@interface MainMenuLayer : CCLayer <VkontakteDelegate>
{
    int                 titleFontSize;
    int                 aboutTextFontSize;
    int                 bgSecondOnScreen;
    int                 aboutOnScreen;
    int                 optionsOnScreen;
    int                 newsOnScreen;
    int                 purchasesOnScreen;
    int                 moreGamesOnScreen;
    int                 highscoresOnScreen;
    
    int                 buttonsBgFontSize;
    int                 playButtonBgFontSize;
    int                 closeButtonFontSize;
    int                 closeButtonBgFontSize;
    int                 buttonsTextFontSize;
    int                 playButtonTextFontSize;
    int                 aboutButtonFontSize;
    int                 textButtonsFontSize;
    int                 socialButtonsFontSize;
    
    CCSprite            *bgSecond;
    CCSprite            *logo;
    
    CCLabelTTF          *closeButton;
    CCLabelTTF          *closeButtonStroke;
    
    CCLabelTTF          *copyrightButton;
    
    CCSprite            *playButton;
    CCLabelTTF          *playButtonText;
    CCTexture2D         *playButtonT2D;
    CCTexture2D         *playButtonTappedT2D;
    
    CCLabelTTF          *aboutButton;
    CCLabelTTF          *aboutButtonBg;
    CCLabelTTF          *aboutButtonStroke;
    CCLabelTTF          *aboutButtonText;
    
    CCLabelTTF          *newsButton;
    CCLabelTTF          *newsButtonBg;
    CCLabelTTF          *newsButtonStroke;
    CCLabelTTF          *newsButtonText;
    
    CCLabelTTF          *purchasesButton;
    CCLabelTTF          *purchasesButtonBg;
    CCLabelTTF          *purchasesButtonStroke;
    CCLabelTTF          *purchasesButtonText;
    
    CCSprite            *moreGamesButton;
    CCLabelTTF          *moreGamesButtonBg;
    CCLabelTTF          *moreGamesButtonStroke;
    CCLabelTTF          *moreGamesButtonText;
    
    CCSprite            *highscoresButton;
    CCLabelTTF          *highscoresButtonBg;
    CCLabelTTF          *highscoresButtonStroke;
    CCLabelTTF          *highscoresButtonText;
    
    CCSprite            *gamecenterButton;
    CCLabelTTF          *gamecenterButtonBg;
    CCLabelTTF          *gamecenterButtonStroke;
    CCLabelTTF          *gamecenterButtonText;
    
    CCSprite            *optionsButton;
    CCLabelTTF          *optionsButtonBg;
    CCLabelTTF          *optionsButtonStroke;
    CCLabelTTF          *optionsButtonText;
    
    CCLabelTTF          *englishButton;
    CCLabelTTF          *englishButtonBg;
    CCLabelTTF          *englishButtonStroke;
    
    CCLabelTTF          *russianButton;
    CCLabelTTF          *russianButtonBg;
    CCLabelTTF          *russianButtonStroke;
    
    CCLabelTTF          *soundOnButton;
    CCLabelTTF          *soundOnButtonBg;
    CCLabelTTF          *soundOnButtonStroke;
    
    CCLabelTTF          *soundOffButton;
    CCLabelTTF          *soundOffButtonBg;
    CCLabelTTF          *soundOffButtonStroke;
    
    CCLabelTTF          *facebookButton;
    CCLabelTTF          *facebookButtonBg;
    CCLabelTTF          *facebookButtonStroke;
    
    CCLabelTTF          *twitterButton;
    CCLabelTTF          *twitterButtonBg;
    CCLabelTTF          *twitterButtonStroke;
    
    CCLabelTTF          *vkontakteButton;
    CCLabelTTF          *vkontakteButtonBg;
    CCLabelTTF          *vkontakteButtonStroke;
    
    CCLabelTTF          *newsTitle;
    CCLabelTTF          *newsText;
    
    CCLabelTTF          *purchasesTitle;
    CCLabelTTF          *removeAdsText;
    CCLabelTTF          *removeAdsStatus;
    CCLabelTTF          *restoreText;
    CCLabelTTF          *donateTitle;
    CCLabelTTF          *donate1;
    CCLabelTTF          *donate1Bg;
    CCLabelTTF          *donate1Stroke;
    CCLabelTTF          *donate3;
    CCLabelTTF          *donate3Bg;
    CCLabelTTF          *donate3Stroke;
    CCLabelTTF          *donate5;
    CCLabelTTF          *donate5Bg;
    CCLabelTTF          *donate5Stroke;
    CCLabelTTF          *donate10;
    CCLabelTTF          *donate10Bg;
    CCLabelTTF          *donate10Stroke;
    CCLabelTTF          *donate25;
    CCLabelTTF          *donate25Bg;
    CCLabelTTF          *donate25Stroke;
    CCLabelTTF          *internetAvailabilityTitle;
    CCLabelTTF          *internetAvailabilityStatus;
    
    CCLabelTTF          *aboutTitle;
    CCLabelTTF          *aboutText;
    
    CCLabelTTF          *optionsTitle;
    CCLabelTTF          *selectLanguage;
    CCLabelTTF          *selectSound;
    CCLabelTTF          *followUs;
    
    CCLabelTTF          *moreGamesTitle;
    CCSprite            *iconCYR;
    CCLabelTTF          *iconCYRName;
    CCLabelTTF          *iconCYRPrice;
    CCLabelTTF          *iconCYRDownload;
    CCLabelTTF          *goToAppStore;
    
    CCLabelTTF          *highscoresTitle;
    CCLabelTTF          *mistakesText[3];
    CCLabelTTF          *timeText[3];
    CCLabelTTF          *squaresMovedText[3];
    CCLabelTTF          *scoreText[3];
    CCLabelTTF          *separator[4];
    CCLabelTTF          *separatorL[2];
    CCLabelTTF          *mistakesResult[6];
    CCLabelTTF          *timeResult[6];
    CCLabelTTF          *squaresMovedResult[6];
    CCLabelTTF          *scoreResult[6];
    CCLabelTTF          *submitScore;
    
    Reachability        *internetReach;
    
    UIAlertView         *alertGC;
    UIAlertView         *alertVK;
}

+ (CCScene *) scene;

@end
