//
//  myShape.m
//  DrawingApp
//
//  Created by Lion User on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "myShape.h"

@implementation myShape
@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;
@synthesize color = _color;
@synthesize selected = _selected;
@synthesize lineWidth = _lineWidth;
@synthesize isDashed = _isDashed;
@synthesize shape = _shape;

-(id)init {
    self = [super init];
    if(self) {
        _selected = false;
    }
    return self;
}


-(id)initCopy:(myShape *)input {
    self = [[myShape alloc] init];
    
    if(self) {
        _startPoint.x = input.startPoint.x;
        _startPoint.y = input.startPoint.y;
        _endPoint.x = input.endPoint.x;
        _endPoint.y = input.endPoint.y;
        _color = [[UIColor alloc] initWithCGColor:[input.color CGColor]];
        _selected = input.selected;
        _lineWidth = input.lineWidth;
        _shape = input.shape;
        _isDashed = input.isDashed;
        
    }
    
    return self;
}

@end
