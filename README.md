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
* Error reporting to the delegate
```swift
    func locationManager(CLLocationManager, didFailWithError: NSError)
```
Not always a fatal thing, so pay attention to this delegate method. Some examples ...
```swift
    kCLErrorLocationUnknown //likelytemporary,keepwaiting(forawhileatleast)
    kCLErrorDenied          // user refused to allow your application to receive updates
    kCLErrorHeadingFailure  // too much local magnetic interference, keep waiting
```
* Background
It is possible to receive these kinds of updates while you are in the background. Apps that do this have to be very careful (because these updates can be power hungry). There are very cool ways to, for example, coalesce and defer location update reporting. Have to enable backgrounding (in the same area of your project settings as background fetch). But there are 2 ways to get location notifications (on a coarser scale) without doing that ...
* Significant location change monitoring in CLLocationManager
"Significant" is not strictly defined. Think vehicles, not walking. Likely uses cell towers.
```swift
    func startMonitoringSignificantLocationChanges()
    func stopMonitoringSignificantLocationChanges()
```
Be sure to turn updating off when your application is not going to consume the changes!
* Get notified via the CLLocationManager’s delegate
Same as for accuracy-based updating if your application is running.
* And this works even if your application is not running!(Or is in the background)
You will get launched and your Application Delegate’s
```swift
    func application(UIApplication, didFinishLaunchingWithOptions: [NSObject,AnyObject])
```
will have a dictionary entry for UIApplicationLaunchOptionsLocationKey  
Create a CLLocationManager (if you don’t have one), then get the latest location via ...
```swift
    var location: CLLocation
```
If you are running in the background, don’t take too long (a few seconds)!
* Region-based location monitoring in CLLocationManager
```swift
    func startMonitoringForRegion(CLRegion) // CLCircularRegion/CLBeaconRegion
    func stopMonitoringForRegion(CLRegion)
    let cr = CLCircularRegion(center: CLLocationCoordinate2D,
                              radius: CLLocationDistance,
                              identifier: String) ... to monitor an area
```
    CLBeaconRegion is for detecting when you are near another device.
* Now get notified via the CLLocationManager’s delegate
```swift
    func locationManager(CLLocationManager, didEnterRegion: CLRegion)
    func locationManager(CLLocationManager, didExitRegion: CLRegion)
    func locationManager(CLLocationManager, monitoringDidFailForRegion: CLRegion, withError: NSError)
```
* Region-monitoring also works if your application is not running
In exactly the same way as “significant location change” monitoring.  
The set of monitored regions persists across application termination/launch.  
```swift
var monitoredRegions: NSSet // of String (this is a property in CLLocationManager)
```
* CLRegions are tracked by name
Because they survive application termination/relaunch.
* Circular region monitoring size limit
```swift
    var maximumRegionMonitoringDistance: CLLocationDistance { get }
```
Attempting to monitor a region larger than this (radius in meters) will generate an error (which will be sent via the delegate method mentioned on previous slide).  
If this property returns a negative value, then region monitoring is not working.
* Beacon regions can also detect range from a beacon
```swift
    func startRangingBeaconsInRegion(CLBeaconRegion)
```
Delegate method locationManager(didRangeBeacons:inRegion:) gives you CLBeacon objects. CLBeacon objects will tell you proximity (e.g. CLProximityImmediate/Near/Far).
* To be a beacon is a bit more involved
Beacons are identified by a globally unique UUID (that you generate).  
Check out CBPeripheralManager (Core Bluetooth Framework).
