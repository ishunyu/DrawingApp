//
//  ECS189ViewController.m
//  DrawingApp
//
//  Created by Lion User on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ECS189ViewController.h"
#import "myShape.h"


@implementation ECS189ViewController {
    bool tapped;
}
@synthesize drawingPad = _drawingPad;
@synthesize currentShape = _currentShape;
@synthesize currentColor = _currentColor;
@synthesize shapeSelector = _shapeSelector;
@synthesize collection = _collection;
@synthesize lineWidthSlider = _lineWidthSlider;
@synthesize dashedLineSelector = _dashedLineSelector;
@synthesize colorPicker = _colorPicker;
@synthesize pickerArray = _pickerArray;
@synthesize debugLabel = _debugLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentShape = [[myShape alloc] init];
    _currentColor = [[UIColor alloc] init];
    _currentColor = [UIColor blackColor];
    _collection = [[NSMutableArray alloc] init];
    
    _pickerArray = [[NSMutableArray alloc] init];
    [_pickerArray addObject:@"Black"];
    [_pickerArray addObject:@"White"];
    [_pickerArray addObject:@"Red"];
    [_pickerArray addObject:@"Orange"];
    [_pickerArray addObject:@"Yellow"];
    [_pickerArray addObject:@"Green"];
    [_pickerArray addObject:@"Blue"];
    [_pickerArray addObject:@"Cyan"];
    [_pickerArray addObject:@"Violet"];    
}

- (void)viewDidUnload
{

    [self setShapeSelector:nil];
    [self setDrawingPad:nil];
    [self setLineWidthSlider:nil];
    [self setDashedLineSelector:nil];
    [self setDebugLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(UIColor *)colorForRow:(NSInteger)row {
    switch (row) {
        case 0:
            return [UIColor blackColor];
        case 1:
            return [UIColor whiteColor];
        case 2:
            return [UIColor redColor];
        case 3:
            return [UIColor orangeColor];
        case 4:
            return [UIColor yellowColor];
        case 5:
            return [UIColor greenColor];
        case 6:
            return [UIColor blueColor];
        case 7:
            return [UIColor cyanColor];
        case 8:
            return [UIColor purpleColor];
        default:
            return [UIColor blackColor];
            break;
    }

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {    
    return [_pickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {    
    //NSLog(@"Selected Color: %@. Index of selected color: %i", [_pickerArray objectAtIndex:row], row);
    _currentColor = [self colorForRow:row];
    
}

#pragma mark - drawing functions

- (void)drawShapes {
    NSLog(@"In drawShapes!");
    
    UIGraphicsBeginImageContext(_drawingPad.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    for(myShape *i in _collection) {
        [self drawShapesSubroutine:i contextRef:context];
        if(i.selected == true) {
            CGContextSetLineWidth(context, 1.0f);
            CGContextSetStrokeColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
            float num[] = {6.0, 6.0};
            CGContextSetLineDash(context, 0.0, num, 2);
            
            CGRect rectangle;
            [self drawShapeSelector:i selectorRect: &rectangle];
            CGContextAddRect(context, rectangle);        
            CGContextStrokePath(context);
            
            
            tapped = true;
        }
    }
      
    if(!tapped)
        [self drawShapesSubroutine:_currentShape contextRef:context];

    _drawingPad.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
}

- (void)drawShapesSubroutine:(myShape *)shapeToBeDrawn contextRef:(CGContextRef)context {
    CGContextSetLineWidth(context, shapeToBeDrawn.lineWidth);
    CGContextSetStrokeColorWithColor(context, [shapeToBeDrawn.color CGColor]);
    
    // Setting the dashed parameter
    if(shapeToBeDrawn.isDashed == true){
        float num[] = {6.0f+shapeToBeDrawn.lineWidth/2.0f, 6.0f+shapeToBeDrawn.lineWidth/2.0f};
        CGContextSetLineDash(context, 0.0, num, 2); 
    }
    else {
        CGContextSetLineDash(context, 0.0, NULL, 0);
    }
    
    
    if(shapeToBeDrawn.shape == 0) { //line
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, shapeToBeDrawn.startPoint.x, shapeToBeDrawn.startPoint.y);
        CGContextAddLineToPoint(context, shapeToBeDrawn.endPoint.x, shapeToBeDrawn.endPoint.y);
        
        CGContextClosePath(context);        
        CGContextStrokePath(context);
    }
    else if(shapeToBeDrawn.shape == 1) {    //Rectangle
        
        CGRect rectangle = CGRectMake(shapeToBeDrawn.startPoint.x,
                                      shapeToBeDrawn.startPoint.y,
                                      shapeToBeDrawn.endPoint.x - shapeToBeDrawn.startPoint.x,
                                      shapeToBeDrawn.endPoint.y - shapeToBeDrawn.startPoint.y);
        
        CGContextAddRect(context, rectangle);        
        CGContextStrokePath(context);
    }
    else if(shapeToBeDrawn.shape == 2) {    //Circle
        float X = shapeToBeDrawn.endPoint.x - shapeToBeDrawn.startPoint.x;
        float Y = shapeToBeDrawn.endPoint.y - shapeToBeDrawn.startPoint.y;
        float radius = sqrtf(X*X + Y*Y);
        CGContextAddArc(context, shapeToBeDrawn.startPoint.x, shapeToBeDrawn.startPoint.y, radius, 0, M_PI * 2.0, 1);
        CGContextStrokePath(context);               
    }
}

-(void)drawShapeSelector:(myShape *)shapeToBeDrawn selectorRect:(CGRect *) rect {
    float x, y, width, height;
    
    if(shapeToBeDrawn.shape == 0 || shapeToBeDrawn.shape == 1) { //Line & rectangle
        if(shapeToBeDrawn.startPoint.x < shapeToBeDrawn.endPoint.x) {
            x = shapeToBeDrawn.startPoint.x - SELECTMARGIN;
            width = shapeToBeDrawn.endPoint.x - shapeToBeDrawn.startPoint.x + 2*SELECTMARGIN;
        }
        else {
            x = shapeToBeDrawn.endPoint.x - SELECTMARGIN;
            width = shapeToBeDrawn.startPoint.x - shapeToBeDrawn.endPoint.x + 2*SELECTMARGIN;
        }
        
        if(shapeToBeDrawn.startPoint.y < shapeToBeDrawn.endPoint.y) {
            y = shapeToBeDrawn.startPoint.y - SELECTMARGIN;
            height = shapeToBeDrawn.endPoint.y - shapeToBeDrawn.startPoint.y + 2*SELECTMARGIN;
        }
        else {
            y = shapeToBeDrawn.endPoint.y - SELECTMARGIN;
            height = shapeToBeDrawn.startPoint.y - shapeToBeDrawn.endPoint.y + 2*SELECTMARGIN;
        }
        
    }
    else if(shapeToBeDrawn.shape == 2) {    // Circle
        float r, dx, dy;
        dx = shapeToBeDrawn.endPoint.x - shapeToBeDrawn.startPoint.x;
        dy = shapeToBeDrawn.endPoint.y - shapeToBeDrawn.startPoint.y;    
        r = sqrtf(dx*dx + dy*dy);   // Radius of our shape
        
        x = shapeToBeDrawn.startPoint.x - r - SELECTMARGIN;
        y = shapeToBeDrawn.startPoint.y - r - SELECTMARGIN;
        
        width = height = 2*(r+SELECTMARGIN);        
    }
    else {
        NSLog(@"drawShapeSelector, shouldn't be here!");
    }
    
    x -= shapeToBeDrawn.lineWidth/2.0f;
    y -= shapeToBeDrawn.lineWidth/2.0f;
    width += shapeToBeDrawn.lineWidth;
    height += shapeToBeDrawn.lineWidth;
    
    *rect = CGRectMake(x, y, width, height);
}


#pragma mark - touch interface

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"In touchesBegan!");
    tapped = false;
    UITouch *touch = [touches anyObject];
    CGPoint tempPoint = [touch locationInView:_drawingPad];
    _currentShape.startPoint = CGPointMake(tempPoint.x, tempPoint.y);
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"In touchesMoved!");
    UITouch *touch = [touches anyObject];
    CGPoint tempPoint = [touch locationInView:_drawingPad];
    
    // Setting properties
    _currentShape.endPoint = CGPointMake(tempPoint.x, tempPoint.y);
    [self setCurrentShapeProperties];    
    
    [self drawShapes];
    _colorPicker.alpha = ALPHATRANSPARENT;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"In touchesEnded!");
    UITouch *touch = [touches anyObject];
    CGPoint tempPoint = [touch locationInView:_drawingPad];
    NSLog(@"%f,%f",tempPoint.x,tempPoint.y);
    NSLog(@"%@s",[_colorPicker pointInside:tempPoint withEvent:event] ? @"Yes": @"No");
    
    // Check to see if it's a tap
    if(CGPointEqualToPoint(tempPoint, _currentShape.startPoint) == NO) {    // Drag
        NSLog(@"You dragged!");
        
        // Setting properties
        _currentShape.endPoint = CGPointMake(tempPoint.x, tempPoint.y);
        [self setCurrentShapeProperties]; 
    
        [self.collection addObject: [[myShape alloc] initCopy:_currentShape]];
        [self drawShapes];
    }
    else {  // Tap
        tapped = true;
        [self selectShapeOnScreen:(CGPoint) tempPoint];
                
        for(myShape* i in _collection) {
            i.selected = false;
        }
    }
}

- (void)setCurrentShapeProperties {
    _currentShape.shape = [_shapeSelector selectedSegmentIndex];
    _currentShape.lineWidth = _lineWidthSlider.value;
    _currentShape.isDashed = _dashedLineSelector.on;
    _currentShape.color = _currentColor;
}

#pragma mark - Working...

- (void)selectShapeOnScreen:(CGPoint) tapPoint {
    NSLog(@"You tapped!");
    
    float alpha = ALPHATRANSPARENT;
    
    for(myShape* i in [_collection reverseObjectEnumerator]) {
        if([i pointContainedInShape:tapPoint]) {
            i.selected = TRUE;
            alpha = ALPHAOPAQUE;
            //NSLog(@"Selected!");
            break;
        }
    }
    
    _colorPicker.alpha = alpha;    
    [self drawShapes];
}


- (IBAction)clearDrawingPad:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear All"
                                             message:@"Are you sure you want to clear everything?"
                                             delegate:self
                                             cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"YES", nil];
    [alert show];
}

- (IBAction)colorPickerButton:(id)sender {
    //NSLog(@"Clicked colorPickerButton");
    
    _colorPicker.alpha = ALPHAOPAQUE;    
    if(_colorPicker.hidden == YES) {
        _colorPicker.hidden = NO;
    }
    else {
        _colorPicker.hidden = YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [_collection removeAllObjects];
        _drawingPad.image = nil;
    }
}


@end
