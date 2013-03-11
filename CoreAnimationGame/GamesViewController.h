//
//  GamesViewController.h
//  CoreAnimationGame
//
//  Created by Alsey Coleman Miller on 3/9/13.
//  Copyright (c) 2013 CDA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDAParallaxLayerModel;

@interface GamesViewController : UIViewController
{
    NSMutableArray *_arrayOfParallaxSpriteModels;
}

@property float currentSpeed;

@property CGFloat pointsPerScroll;

@property NSTimer *timer;

@property (readonly) CALayer *gameLayer;

@property (readonly) CALayer *parallaxLayer;

-(void)addParallax:(CDAParallaxLayerModel *)parallaxModel;

-(void)animate:(NSTimer *)timer;

@end
