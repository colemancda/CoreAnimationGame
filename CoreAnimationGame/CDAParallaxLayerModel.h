//
//  CDAParallaxLayerModel.h
//  Cocos2D BootyRun
//
//  Created by Alsey Coleman Miller on 3/8/13.
//  Copyright (c) 2013 TeclaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDAParallaxLayerModel : NSObject
{
    NSArray *_arrayOfSpriteParts;
}

@property NSString *fileNamePrefix;

@property NSString *fileExtension;

@property NSInteger numberOfSpriteParts;

@property CGPoint anchorPoint;

@property float relativeSpeed;

@property CGFloat y;

-(NSArray *)arrayOfSpriteParts;


@end
