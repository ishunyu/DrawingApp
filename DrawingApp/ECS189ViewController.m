//
//  ECS189ViewController.m
//  DrawingApp
//
//  Created by Lion User on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ECS189ViewController.h"
#import "myShape.h"

@implementation ECS189ViewController
@synthesize drawingPad = _drawingPad;
@synthesize currentShape = _currentShape;
@synthesize currentColor = _currentColor;
@synthesize shapeSelector = _shapeSelector;
@synthesize collection = _collection;
@synthesize lineWidthSlider = _lineWidthSlider;
@synthesize dashedLineSelector = _dashedLineSelector;
@synthesize colorPicker = _colorPicker;
@synthesize pickerArray = _pickerArray;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:_drawingPad];
    [_drawingPad addSubview:_colorPicker];
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
    
    //UIGraphicsBeginImageContext(_drawingPad.frame.size);
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{

    [self setShapeSelector:nil];
    [self setDrawingPad:nil];
    [self setDrawingPad:nil];
    [self setLineWidthSlider:nil];
    [self setDashedLineSelector:nil];
   // [self setColorPicker:nil];
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

- (void)drawShapes {
    //NSLog(@"In drawShapes!");
    
    UIGraphicsBeginImageContext(_drawingPad.frame.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for(myShape *i in _collection) {
        [self drawShapesSubroutine:i contextRef:context];
    }
    
     [self drawShapesSubroutine:_currentShape contextRef:context];
    
    _drawingPad.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
}

- (void)drawShapesSubroutine:(myShape *)shapeToBeDrawn contextRef:(CGContextRef)context {
    CGContextSetLineWidth(context, shapeToBeDrawn.lineWidth);
    CGContextSetStrokeColorWithColor(context, [shapeToBeDrawn.color CGColor]);
    
    // Setting the dashed parameter
    if(shapeToBeDrawn.isDashed == true){
        float num[] = {6.0, 6.0};
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"In touchesBegan!");
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
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"In touchesEnded!");
    UITouch *touch = [touches anyObject];
    CGPoint tempPoint = [touch locationInView:_drawingPad];
    
    // Setting properties
    _currentShape.endPoint = CGPointMake(tempPoint.x, tempPoint.y);
    [self setCurrentShapeProperties]; 
    
    [self.collection addObject: [[myShape alloc] initCopy:_currentShape]];
    [self drawShapes];   
}

- (void)setCurrentShapeProperties {
    _currentShape.shape = [_shapeSelector selectedSegmentIndex];
    _currentShape.lineWidth = _lineWidthSlider.value;
    _currentShape.isDashed = _dashedLineSelector.on;
    _currentShape.color = _currentColor;
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
    NSLog(@"Clicked colorPickerButton");
    
    if(_colorPicker.hidden == YES) {
        _colorPicker.hidden = NO;
    }
    else {
        _colorPicker.hidden = YES;
    }
    
    //[_drawingPad setNeedsDisplay];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [_collection removeAllObjects];
        _drawingPad.image = nil;
    }
}


@end
