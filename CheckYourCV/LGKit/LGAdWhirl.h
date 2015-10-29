//
//  Created by Grigory Lutkov on 01.10.12.
//  Copyright (c) 2012 Grigory Lutkov. All rights reserved.
//

#import "AdWhirlDelegateProtocol.h"

#define kAdWhirlApplicationKey @"6a70bf4d37a8495ab9ae287460f00051"

@interface LGAdWhirl : NSObject <AdWhirlDelegate>

@property (nonatomic, retain) AdWhirlView *adView;

+ (LGAdWhirl *)sharedManager;
- (void)initAdWhirlWithOrientation:(UIInterfaceOrientationMask)orientation;
- (void)removeAdWhirl;

@end
