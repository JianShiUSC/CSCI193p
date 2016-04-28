# CSCI193p
iOS development from Stanford
###Lecture 14
####Core Location
* Framework for managing location and heading  
No user-interface
* Basic object is CLLocation  
Properties: coordinate, altitude, horizontal/vertical Accuracy, timestamp, speed, course
* Where (approximately) is this location?  
```swift
    var coordinate: CLLocationCoordinate2D
    struct CLLocationCoordinate2D {
        CLLocationDegrees latitude // a Double
        CLLocationDegrees longitude // a Double
    }
    var altitude: CLLocationDistance // meters, a negative value means “below sea level”
```
* How close to that latitude/longitude is the actual location?
```swift
    var horizontalAccuracy: CLLocationAccuracy // in meters
    var verticalAccuracy: CLLocationAccuracy // in meters, a negative value means the coordinate or altitude (respectively) is invalid.
    kCLLocationAccuracyBestForNavigation // phone should be plugged in to power source
    kCLLocationAccuracyBest
    kCLLocationAccuracyNearestTenMeters
    kCLLocationAccuracyHundredMeters
    kCLLocationAccuracyKilometer
    kCLLocationAccuracyThreeKilometers
```
* Speed
```swift
    var speed: CLLocationSpeed  // meters/second, instantaneous speed
```
* Course
```swift
    var course: CLLocationDirection  // degrees, 0 is north, clockwise
```
* Time stamp
```swift
    var timestamp: NSDate  // Pay attention to these since locations will be delivered on an inconsistent time basis.
```
