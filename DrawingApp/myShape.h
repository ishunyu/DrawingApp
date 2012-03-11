//
//  myShape.h
//  DrawingApp
//
//  Created by Lion User on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myShape : NSObject <NSCoding, NSCopying>
-(id)init;
-(id)initCopy:(myShape *)input;

-(bool)pointContainedInShape:(CGPoint) point;

@property CGPoint startPoint;
@property CGPoint endPoint;
@property NSInteger color;
@property int shape;
@property bool selected;
@property bool isDashed;
@property int lineWidth;
@end
