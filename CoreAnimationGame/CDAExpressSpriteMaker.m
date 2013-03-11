//
//  CDAExpressSpriteMaker.m
//  CoreAnimationGame
//
//  Created by Alsey Coleman Miller on 3/9/13.
//  Copyright (c) 2013 CDA. All rights reserved.
//

#import "CDAExpressSpriteMaker.h"
#import <QuartzCore/QuartzCore.h>

@implementation CDAExpressSpriteMaker

+(CALayer *)spriteFromImage:(UIImage *)image
{
    // check for errors
    if (!image) {
        return nil;
    }
    
    // create the sprite
    CALayer *sprite = [CALayer layer];
    
    // set the image
    CGImageRef imageRef = image.CGImage;
    sprite.contents = (__bridge id)(imageRef);
    
    CGRect newFrame = CGRectMake(sprite.position.x, sprite.position.y,
                                 image.size.width, image.size.height);
    sprite.frame = newFrame;
    
    return sprite;
}

@end
