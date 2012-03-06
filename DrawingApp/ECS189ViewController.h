//
//  ECS189ViewController.h
//  DrawingApp
//
//  Created by Lion User on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myShape.h"

@interface ECS189ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *drawingPad;
@property (strong, atomic) myShape *currentShape;
@property (strong, nonatomic) UIColor *currentColor;
@property (strong, nonatomic) NSMutableArray *collection;
@property (weak, nonatomic) IBOutlet UISlider *lineWidthSlider;
@property (weak, nonatomic) IBOutlet UISwitch *dashedLineSelector;
@property (weak, nonatomic) IBOutlet UIPickerView *colorPicker;
@property (strong, nonatomic) NSMutableArray *pickerArray;


@property (weak, nonatomic) IBOutlet UISegmentedControl *shapeSelector;
- (UIColor *)colorForRow:(NSInteger)row;
- (void)drawShapes;
- (void)drawShapesSubroutine:(myShape *)shapeToBeDrawn contextRef:(CGContextRef) context;
//- (void)initPoints;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)setCurrentShapeProperties;
- (IBAction)clearDrawingPad:(id)sender;
- (IBAction)colorPickerButton:(id)sender;
@end
