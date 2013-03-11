//
//  GamesViewController.m
//  CoreAnimationGame
//
//  Created by Alsey Coleman Miller on 3/9/13.
//  Copyright (c) 2013 CDA. All rights reserved.
//

#import "GamesViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CDAParallaxLayerModel.h"
#import "CDAExpressSpriteMaker.h"

@interface GamesViewController ()

@end

@implementation GamesViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        _arrayOfParallaxSpriteModels = [[NSMutableArray alloc] init];
        
        self.currentSpeed = 1;
        
        self.pointsPerScroll = 1;
        
    }
    return self;
}

-(void)viewDidLayoutSubviews
{
    _gameLayer = [CALayer layer];
    [self.view.layer addSublayer:self.gameLayer];
    self.gameLayer.frame = self.view.layer.frame;
    self.gameLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    _parallaxLayer = [CALayer layer];
    [self.gameLayer addSublayer:self.parallaxLayer];
    self.parallaxLayer.frame = self.gameLayer.frame;
    self.parallaxLayer.backgroundColor = [UIColor greenColor].CGColor;
    
    CALayer *player = [CDAExpressSpriteMaker spriteFromImage:[UIImage imageNamed:@"corazoncito"]];
    player.anchorPoint = CGPointMake(0.5, 1);
    player.position = CGPointMake(self.gameLayer.frame.size.width / 2.0, self.gameLayer.bounds.size.height);
    [self.gameLayer addSublayer:player];
    
    CDAParallaxLayerModel *parallax = [[CDAParallaxLayerModel alloc] init];
    parallax.numberOfSpriteParts = 2;
    parallax.y = self.gameLayer.bounds.size.height - 148;
    [self addParallax:parallax];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0
                                                  target:self
                                                selector:@selector(animate:)
                                                userInfo:nil
                                                 repeats:YES];
}

-(void)addParallax:(CDAParallaxLayerModel *)parallaxModel
{
    // check for errors
    if (!parallaxModel) {
        NSLog(@"<%@> %@ %@ was nil, it will not be added", NSStringFromClass(self.class), NSStringFromSelector(_cmd), NSStringFromClass(parallaxModel.class));
        return;
    }
    
    // add to arrayOfParallaxSpriteParts
    [_arrayOfParallaxSpriteModels addObject:parallaxModel];
    
    // add the sprite parts
    for (CALayer *spritePart in parallaxModel.arrayOfSpriteParts) {
        [self.parallaxLayer addSublayer:spritePart];
    }
    
    NSLog(@"%@", self.gameLayer.sublayers);
}

-(void)animate:(NSTimer *)timer
{
    
    // move the parallax layers
    // check for errors
    if (!_arrayOfParallaxSpriteModels.count) {
        NSLog(@"<%@> -%@ '_arrayOfParallaxSpriteModels' is empty, ending method", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
        return;
    }
    
    // move each part of the parallax models
    for (CDAParallaxLayerModel *parallaxModel in _arrayOfParallaxSpriteModels)
    {
        for (CALayer *parallaxSpritePart in parallaxModel.arrayOfSpriteParts)
        {
            // move each sprite part
            float pointsToScroll = self.pointsPerScroll * self.currentSpeed * parallaxModel.relativeSpeed;
            CGPoint scrolledPosition = CGPointMake(parallaxSpritePart.position.x - pointsToScroll, parallaxSpritePart.position.y);
            
            // create the animation
            CABasicAnimation *scrollAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
            scrollAnimation.fromValue = [NSValue valueWithCGPoint:parallaxSpritePart.position];
            scrollAnimation.toValue = [NSValue valueWithCGPoint:scrolledPosition];
            scrollAnimation.duration = timer.timeInterval;
            
            // add the animation to the sprite part
            [parallaxSpritePart addAnimation:scrollAnimation
                                      forKey:@"scrollAnimation"];
            
            // set the new position
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            parallaxSpritePart.position = scrolledPosition;
            [CATransaction commit];
            
            // re position if part is offscreen
            if (parallaxSpritePart.position.x < -parallaxSpritePart.bounds.size.width)
            {
                
                // if first part, add after last part
                if (parallaxSpritePart == parallaxModel.arrayOfSpriteParts[0]) {
                    
                    // get the last sprite
                    CALayer *lastSprite = parallaxModel.arrayOfSpriteParts.lastObject;
                    
                    // calculate new position
                    NSInteger spacingFix = parallaxModel.arrayOfSpriteParts.count + 1;
                    CGFloat newX = lastSprite.position.x + lastSprite.bounds.size.width - spacingFix;
                    
                    // disable animation while changing postition of CALayer
                    CGPoint newPosition = CGPointMake(newX, parallaxSpritePart.position.y);
                    parallaxSpritePart.position = newPosition;
                    
                }
                // for all other parts, add after previous part
                else {
                    // get the previous sprite
                    NSInteger index = [parallaxModel.arrayOfSpriteParts indexOfObject:parallaxSpritePart];
                    NSInteger previousIndex = index - 1;
                    CALayer *previousSprite = parallaxModel.arrayOfSpriteParts[previousIndex];
                    
                    // put the sprite after the last one
                    parallaxSpritePart.position = CGPointMake(previousSprite.position.x + previousSprite.bounds.size.width, parallaxSpritePart.position.y);
                }
            }
        }
    }
    // done moving parallax

}

@end
