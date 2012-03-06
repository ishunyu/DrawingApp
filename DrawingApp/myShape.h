//
//  myShape.h
//  DrawingApp
//
//  Created by Lion User on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myShape : NSObject
-(id)init;
-(id)initCopy:(myShape *)input;
-(bool)pointContainedInShape:(CGPoint) point;
-(bool)pointOnLine:(CGPoint) point;
-(bool)pointContainedInCircle:(CGPoint) point;


@property CGPoint startPoint;
@property CGPoint endPoint;
@property (strong, nonatomic) UIColor *color;
@property int shape;
@property bool selected;
@property bool isDashed;
@property int lineWidth;
@end
