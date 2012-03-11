//
//  ECS189VectorMath.h
//  DrawingApp
//
//  Created by Lion User on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#ifndef DrawingApp_ECS189VectorMath_h
#define DrawingApp_ECS189VectorMath_h

CGPoint subtractVector(CGPoint, CGPoint);
CGPoint addVector(CGPoint, CGPoint);
CGPoint multiplyVectorByScalar(CGPoint, float);
float distanceBetweenTwoPoints(CGPoint, CGPoint);
float dotProductOfTwoPoints(CGPoint, CGPoint);
float lengthSquared(CGPoint, CGPoint);
float distanceFromPointToLineSegment(CGPoint, CGPoint, CGPoint);


// Algebraic manupulations between two points
CGPoint subtractVector(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

CGPoint addVector(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

CGPoint multiplyVectorByScalar(CGPoint a, float f) {
    return CGPointMake(f * a.x, f* a.y);
}

// Calculates distance between two points
float distanceBetweenTwoPoints(CGPoint a, CGPoint b) {
    float dx = b.x - a.x;
    float dy = b.y - a.y;
    
    return sqrtf(dx * dx + dy * dy);
}

// calculates the dot prodoct between two vectors, represented by CGPoints
float dotProductOfTwoPoints(CGPoint a, CGPoint b) {
    return a.x * b.x + a.y * b.y;
}

// Something...
float lengthSquared(CGPoint a, CGPoint b) {
    return distanceBetweenTwoPoints(a, b) * distanceBetweenTwoPoints(a, b);
}

// calculates the point to line segment distance
float distanceFromPointToLineSegment(CGPoint a, CGPoint b, CGPoint p) {
    float l2 = lengthSquared(a, b);
    
    if(l2 == 0.0f)
        return distanceBetweenTwoPoints(p, a);
    
    float t = dotProductOfTwoPoints(subtractVector(p, a), subtractVector(b, a)) / l2;
    
    if(t < 0.0f)
        return distanceBetweenTwoPoints(p, a);
    else if(t > 1.0f)
        return distanceBetweenTwoPoints(p, b);
        
    CGPoint projection = addVector(a, multiplyVectorByScalar(subtractVector(b, a), t));
    
    return distanceBetweenTwoPoints(p, projection);
}

#endif
