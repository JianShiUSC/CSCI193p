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
* How do you get a CLLocation?
Almost always from a CLLocationManager (sent to you via its delegate).
* CLLocationManager
    General approach to using it:  
    1. Check if the hardware you are on/user supports the kind of location updating you want.
    2. Create a CLLocationManager instance and set the delegate to receive updates.  
    3. Configure the manager according to what kind of location updating you want.  
    4. Start the manager monitoring for location changes.   
* Kinds of location monitoring
    Accuracy-based continual updates.  
    Updates only when “significant” changes in location occur.  
    Region-based updates.  
    Heading monitoring.  
* Asking CLLocationManager what your hardware can do
```swift
    class func authorizationStatus() -> CLAuthorizationStatus // Authorized, Denied or Restricted
    class func locationServicesEnabled() -> Bool // user enabled (or not) locations for your app
    class func significantLocationChangeMonitoringAvailable() -> Bool
    class func isMonitoringAvailableForClass(AnyClass!) -> Bool // CLBeacon/CLCircularRegion
    class func isRangingAvailable() -> Bool // device can tell how far it is from beacons
```
* Getting the location information from the CLLocationManager
You can just ask the CLLocationManager for the location or heading, but usually we don’t. Instead, we let it update us when the location changes (enough) via its delegate ...
* Accuracy-based continuous location monitoring
```swift
    var desiredAccuracy: CLLocationAccuracy // always set this as low as will work for you
```
Can also limit updates to only occurring if the change in location exceeds a certain distance ...
```swift
    var distanceFilter: CLLocationDistance
```
* Starting and stopping normal position monitoring
```swift
    func startUpdatingLocation()
    func stopUpdatingLocation()
```
Be sure to turn updating off when your application is not going to consume the changes!
* Now get notified via the CLLocationManager’s delegate
```swift
    func locationManager(CLLocationManager, didUpdateLocations: [CLLocation])
```
* Similar API for heading (CLHeading, et. al.)
