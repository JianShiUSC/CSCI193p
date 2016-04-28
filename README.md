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
####Map Kit
* MKMapView displays a map
* The map can have annotations on it  
Each annotation is a coordinate, a title and a subtitle. They are displayed using an MKAnnotationView (MKPinAnnotationView shown here).
* Annotations can have a callout  
It appears when the annotation view is clicked. By default just shows the title and subtitle.
* But callout can also have accessory views  
In this example, the left is a UIImageView, the right is a UIButton (UIButtonTypeDetailDisclosure)
####MKMapView
* Create with initializer or drag from object palette in Xcode
```swift
    import MapKit
    let mapView = MKMapView()
```
* Displays an array of objects which implement MKAnnotation
```swift
    var annotations: [MKAnnotation] { get }
```
* MKAnnotation protocol
```swift
    protocol MKAnnotation: NSObject {
        var coordinate: CLLocationCoordinate2D { get }
        var title: String! { get } // optional, but expected to be provided
        var subtitle: String! { get }
    }
```
Remember this from CoreLocation ...
```swift
    struct CLLocationCoordinate2D {
        var latitude: CLLocationDegrees
        var longitude: CLLocationDegrees
    }
```
####MKAnnotation
* Note that the annotations property is readonly, so ...
```swift
    var annotations: [MKAnnotation] { get }
    // Must add/remove annotations with these methods ...
    func addAnnotation(MKAnnotation)
    func addAnnotations([MKAnnotation])
    func removeAnnotation(MKAnnotation)
    func removeAnnotations([MKAnnotation])
```
* Generally a good idea to add all your annotations up-front  
    Allows the MKMapView to be efficient about how it displays them.  
    Annotations are light-weight, but annotation views are not.  
    Luckily MKMapView reuses annotation views similar to how UITableView reuses cells.
* What do annotations look like on the map?  
    Annotations are drawn using an MKAnnotationView subclass.
    The default one is MKPinAnnotationView (which is why they look like pins by default).
    You can subclass or set properties on existing MKAnnotationViews to modify the look.
* What happens when you touch on an annotation (e.g. the pin)?
    Depends on the MKAnnotationView that is associated with the annotation. If canShowCallout is true in the MKAnnotationView, then a little box will appear showing the annotation’s title and subtitle. And this little box (the callout) can be enhanced with left/rightCalloutAccessoryViews.
    The following MKMapViewDelegate method is also called...
    ```swift
    func mapView(MKMapView, didSelectAnnotationView: MKAnnotationView)
    ```
    This is a great place to set up the MKAnnotationView‘s callout accessory views lazily. For example, you might want to wait until this method is called to download an image to show.
####MKAnnotationView
* How are MKAnnotationViews created & associated w/annotations?  
Very similar to UITableViewCells in a UITableView.  
Implement the following MKMapViewDelegate method (if not implemented, returns a pin view).
```swift
    func mapView(sender: MKMapView, viewForAnnotation: MKAnnotation) -> MKAnnotationView {
        var view = sender.dequeueReusableAnnotationViewWithIdentifier(IDENT)
        if !view {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: IDENT)
            view.canShowCallout = true or false
        }
        aView.annotation = annotation // yes, this happens twice if no dequeue
        // prepare and (if not too expensive) load up accessory views here
        // or reset them and wait until mapView(didSelectAnnotationView:) to load actual data
        return view
    }
```
There is no “prototype” in your storyboard, you create them in code as above.
* Interesting properties ...
```swift
    var annotation: MKAnnotation // the annotation; treat as if readonly
    var image: UIImage // instead of the pin, for example (not an image on the callout)
    var leftCalloutAccessoryView: UIView // maybe a UIImageView
    var rightCalloutAccessoryView: UIView // maybe a “disclosure” UIButton
    var enabled: Bool // false means it ignores touch events, no delegate method, no callout
    var centerOffset: CGPoint // where is the “head of the pin” is relative to the image
    var draggable: Bool // only works if the annotation’s coordinate property is { get set }
```
* If you set one of the callout accessory views to be a UIControl
```swiftview.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonTypeDetailDisclosure)```The following MKMapViewDelegate method will get called when the callout view is touched ...```swiftfunc mapView(MKMapView, annotationView: MKAnnotationView,           calloutAccessoryControlTapped: UIControl)```Maybe you might manually segue from here, for example.
* Using didSelectAnnotationView: to load up callout accessories  
Example downloading an image into a leftCalloutAccessoryView that is a UIImageView.  
In
```swift
mapView(viewForAnnotation:), let view.leftCalloutAccessoryView = UIImageView()
```
Reset the UIImageView’s image to nil there as well (because of reuse).

Then load the image on demand in mapView(didSelectAnnotationView:) ...
```swift
    func mapView(MKMapView, didSelectAnnotationView aView: MKAnnotationView)
    {
        if let imageView = aView.leftCalloutAccessoryView as? UIImageView {
            imageView.image = ... // if you do this on another thread, be careful, views are reused!
        }
    }
```
####MKMapView
* Configuring the map view’s display type
```swift
var mapType: MKMapType // .Standard, .Satellite, .Hybrid
```
* Showing the user’s current location
```swift
var showsUserLocation: Bool
var isUserLocationVisible: Bool
var userLocation: MKUserLocation
```
MKUserLocation is an object which conforms to MKAnnotation which holds the user’s location.
* Restricting the user’s interaction with the map
```swift
var zoomEnabled: Bool
var scrollEnabled: Bool
var pitchEnabled: Bool // 3D
var rotateEnabled: Bool
```
####MKMapCamera
* Setting where the user is seeing the map from (in 3D)
```swift
var camera: MKMapCamera // property in MKMapView
```
* MKMapCamera  
Specify centerCoordinate, heading, pitch and altitude of the camera.  
Or use convenient initializer in MKMapCamera ...
```swift
let camera = MKMapCamera(lookingAtCenterCoordinate: CLLocationCoordinate2D,
                                 fromEyeCoordinate: CLLocationCoordinate2D,
                                       eyeAltitude: CLLocationDistance)
```
####MKMapView
* Controlling the region (part of the world) the map is displaying
```swift
var region: MKCoordinateRegion
struct MKCoordinateRegion {
    var center: CLLocationCoordinate2D // remember from CoreLocation, this is lat/long
    var span: MKCoordinateSpan
}
struct MKCoordinateSpan {
    var latitudeDelta: CLLocationDegrees
    var longitudeDelta: CLLocationDegrees
}
func setRegion(MKCoordinateRegion, animated: Bool) // animate setting the region
```
* Can also set the center point only or set to show annotations
```swift
var centerCoordinate: CLLocationCoordinate2D
func setCenterCoordinate(CLLocationCoordinate2D, animated: Bool)
func showAnnotations([MKAnnotation], animated: Bool)
```
* Lots of C functions to convert points, regions, rects, etc.  
See documentation, e.g. MKMapRectContainsPoint, MKMapPointForCoordinate, etc.
* Converting to/from map points/rects from/to view coordinates
```swift
    func mapPointForPoint(CGPoint) -> MKMapPoint
    func mapRectForRect(CGRect) -> MKMapRect
    func pointForMapPoint(MKMapPoint) -> CGPoint
    func rectForMapRect(MKMapRect) -> CGRect
```
* Another MKMapViewDelegate method
```swift
func mapView(MKMapView, didChangeRegionAnimated: Bool)
```
This is a good place to “chain” animations to the map.
When you display somewhere new in the map that is far away, zoom out, then back in.  
This method will let you know when it’s finished zooming out, so you can then zoom in.
####MKLocalSearch
* Searching for places in the world
Can search by “natural language” strings asynchronously (uses the network)
```swift
    var request = MKLocalSearchRequest()
    request.naturalLanguageQuery = @“Ike’s”
    request.region = ... // e.g., Stanford campus
    let search = MKLocalSearch(request: request)
    search.startWithCompletionHandler { (MKLocalSearchResponse, NSError) -> Void in
        // response contains an array of MKMapItem which contains MKPlacemark
        // MKPlacemark contains location, name of location, postalCode, region, etc.
    }
```
* MKMapItem
You can open a MKMapItem that you get back from a MKLocalSearch in the Maps app ...
```swift
func openInMapsWithLaunchOptions([NSObject:AnyObject]) -> Bool // the options can specify region, show traffic, etc
```
####MKDirections
Getting directions from one place to another
Very similar API to searching.  
Specify source and destination MKMapItem.  
Asynchronous API to get a bunch of MKRoutes.  
MKRoute includes a name for the route, turn-by-turn directions, expected travel time, etc.  
Also come with MKPolyline descriptions of the routes which can be overlaid on the map ...
####Overlays
* Overlays  
    Add overlays to the MKMapView and it will later ask you for a renderer to draw the overlay.  
    ```swift
    func addOverlay(MKOverlay, level: MKOverlayLevel)
    ```
    Level is (currently) either AboveRoads or AboveLabels (over everything but annotation views).  
    ```swift
    func removeOverlay(MKOverlay)
    ```
* MKOverlay protocol  
    Protocol which includes MKAnnotation plus ...  
    ```swift
    var boundingMapRect: MKMapRect
    func intersectsMapRect(MKMapRect) -> Bool // optional, uses boundingMapRect otherwise
    ```
* Overlays are associated with MKOverlayRenderers via delegate  
    Just like annotations are associated with MKAnnotationViews ...  
    ```swift
    func mapView(MKMapView, rendererForOverlay: MKOverlay) -> MKOverlayRenderer
    ```
####MKOverlayView
* Built-in Overlays and Renderers for numerous shapes  
```swift
    MKCircleRenderer
    MKPolylineRenderer
    MKPolygonRenderer
    MKTileOverlayRenderer // can also be used to replace the map data from Apple  
```
There’s a whole set of MKShape and subclasses thereof for you to explore.
