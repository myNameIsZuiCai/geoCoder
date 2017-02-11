//
//  ViewController.m
//  地理编码1
//
//  Created by 上海均衡 on 2016/10/10.
//  Copyright © 2016年 上海均衡. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()
@property(strong,nonatomic) CLGeocoder *coder;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) IBOutlet UITextField *latitude;
@property (strong, nonatomic) IBOutlet UITextField *longtitude;



@end

@implementation ViewController
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(CLGeocoder *)coder{
    if (_coder==nil) {
        _coder=[[CLGeocoder alloc]init];
    }
    return _coder;
}
- (IBAction)geoCoder:(id)sender {
    
    NSString *address=self.textView.text;
    //容错处理
    if (address.length==0) {
        return;
    }
    //根据地址关键字进行地址编码
    [self.coder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       /*
            CLPlacemark：地标对象
            location：对应的位置对象
            name：地址的全称
            locality：城市
        */
        CLPlacemark *pl=[placemarks firstObject];
        
        if (error==nil) {
            NSLog(@"%f------------%f",pl.location.coordinate.latitude,pl.location.coordinate.longitude);
            NSLog(@"%@",pl.name);
//            self.textView.text=pl.name;
            self.latitude.text=@(pl.location.coordinate.latitude).stringValue;
            self.longtitude.text=@(pl.location.coordinate.longitude).stringValue;
        }
        
    }];
    
    
}
//把经纬度转换为详细地址
- (IBAction)reverseGeoCoder:(id)sender {
    double latitude=[self.latitude.text doubleValue];
    double longtitude=[self.longtitude.text doubleValue];
    
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longtitude];
    
    NSString *strLa=[NSString stringWithFormat:@"%f",latitude];
    NSString *strLo=[NSString stringWithFormat:@"%f",longtitude];
    
    NSArray *laArr=[strLa componentsSeparatedByString:@"."];
    NSArray *loArr=[strLo componentsSeparatedByString:@"."];
    
    if (laArr.count&&loArr.count) {
        [self.coder reverseGeocodeLocation:location    completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            CLPlacemark *pl=[placemarks firstObject];
            
            if (error==nil) {
                NSLog(@"%f------------%f",pl.location.coordinate.latitude,pl.location.coordinate.longitude);
                NSLog(@"%@",pl.name);
                self.textView.text=pl.name;
                self.latitude.text=@(pl.location.coordinate.latitude).stringValue;
                self.longtitude.text=@(pl.location.coordinate.longitude).stringValue;
                
                
            }
            
        }];
    }
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
