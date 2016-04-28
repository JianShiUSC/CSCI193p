# CSCI193p
iOS development from Stanford
###Lecture 14
####Core Location
* Framework for managing location and heading  
No user-interface
* Basic object is CLLocation  
properties: coordinate, altitude, horizontal/verticalAccuracy, timestamp, speed, course
* Where (approximately) is this location?  
```swift
  var coordinate: CLLocationCoordinate2D
  struct CLLocationCoordinate2D {
      CLLocationDegrees latitude // a Double
      CLLocationDegrees longitude // a Double
  }
  var altitude: CLLocationDistance // meters
```
  A negative value means “below sea level”
