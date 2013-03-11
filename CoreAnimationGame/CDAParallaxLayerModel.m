//
//  CDAParallaxLayerModel.m
//  Cocos2D BootyRun
//
//  Created by Alsey Coleman Miller on 3/8/13.
//  Copyright (c) 2013 TeclaLabs. All rights reserved.
//

#import "CDAParallaxLayerModel.h"
#import <QuartzCore/QuartzCore.h>
#import "CDAExpressSpriteMaker.h"

@implementation CDAParallaxLayerModel

@synthesize numberOfSpriteParts = _numberOfSpriteParts;

- (id)init
{
    self = [super init];
    if (self) {
        // default values
        self.fileNamePrefix = @"road";
        self.numberOfSpriteParts = 1;
        self.relativeSpeed = 1;
        self.y = 0;
        self.anchorPoint = CGPointZero;
        
    }
    return self;
}


-(NSArray *)arrayOfSpriteParts
{
    // if the sprite parts where not created, create 'em
    if (_arrayOfSpriteParts.count != self.numberOfSpriteParts) {
        
        // create mutable array of sprite parts
        NSMutableArray *sprites = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.numberOfSpriteParts; i++) {
            
            // get the filename
            NSString *extension = @"";
            
            // if a file extension exists, prefix it with a dot
            if (self.fileExtension) {
                extension = [NSString stringWithFormat:@".%@", self.fileExtension];
            }
            // get the file name, suffixed with '_n', number of sprite part
            NSString *fileName = [NSString stringWithFormat:@"%@_%d%@", self.fileNamePrefix, i + 1, extension];
            
            if (![UIImage imageNamed:fileName]) {
                NSLog(@"< %@ -%@ > image named '%@' doesn't exist", NSStringFromClass(self.class), NSStringFromSelector(_cmd), fileName);
            }
            else {
                NSLog(@"< %@ -%@ > adding image '%@'", NSStringFromClass(self.class), NSStringFromSelector(_cmd), fileName);
            }
            
            CALayer *sprite = [CDAExpressSpriteMaker spriteFromImage:[UIImage imageNamed:fileName]];
            
            [sprites addObject:sprite];
        }
        
        // position parts
        // add parts one after another
        for (CALayer *spritePart in sprites)
        {
            
            // set the anchorpoint
            spritePart.anchorPoint = self.anchorPoint;
            
            // if first sprite
            if (spritePart == sprites[0]) {
                
                spritePart.position = CGPointMake(0, self.y);
            }
            // else
            else {
                
                // get the previous sprite
                NSInteger index = [sprites indexOfObject:spritePart];
                NSInteger previousIndex = index - 1;
                CALayer *previousSprite = sprites[previousIndex];
                
                // put the sprite after the last one
                spritePart.position = CGPointMake(previousSprite.position.x + previousSprite.frame.size.width, self.y);
            }
        }
        
        // copy to the model's array
        _arrayOfSpriteParts = (NSArray *)sprites;

    }
    
    return _arrayOfSpriteParts;
    
}

#pragma mark
#pragma mark Properties

-(void)setNumberOfSpriteParts:(NSInteger)numberOfSpriteParts
{
    // check if number less then 1
    if (numberOfSpriteParts < 1) {
        NSLog(@"< %@ %@ > numberOfSpriteParts is %d, you need at least one", NSStringFromClass(self.class), NSStringFromSelector(_cmd), numberOfSpriteParts);
        return;
    }
    
    // if 1 or more, save
    _numberOfSpriteParts = numberOfSpriteParts;
}

-(NSInteger)numberOfSpriteParts
{
    return _numberOfSpriteParts;
}

#pragma mark

-(NSString *)description
{
    return [NSString stringWithFormat:@"< %@: fileNamePrefix: '%@' fileExtension: '%@' numberOfSpriteParts: '%d' relativeSpeed: '%f' y: '%f' >",
            NSStringFromClass(self.class),
            self.fileNamePrefix,
            self.fileExtension,
            self.numberOfSpriteParts,
            self.relativeSpeed,
            self.y];
}

@end
