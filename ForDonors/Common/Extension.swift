//
//  Extension.swift
//  ForDonors
//
//  Created by Manab Kumar Mal on 23/02/18.
//  Copyright © 2018 NATIT Solved Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import MapKit
class Extension
{
    
}
extension UIApplication
{
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
extension Notification.Name
{
    static let acceptcall = Notification.Name("acceptcall")
    static let rejectcall = Notification.Name("rejectcall")
    static let endcall = Notification.Name("endcall")
    static let muteCall = Notification.Name("muteCall")
    static let MoveToAppDelegate = Notification.Name("MoveFromCallRatingVC")
}
extension Int {
    var stringValue:String {
        return "\(self)"
    }
}
extension Sequence where Iterator.Element: Hashable {
    func uniq() -> [Iterator.Element] {
        var seen = Set<Iterator.Element>()
        return filter { seen.update(with: $0) == nil }
    }
}
extension UIColor {
    func isEqual(color: UIColor?) -> Bool {
        guard let color = color else { return false }
        
        var red:CGFloat   = 0
        var green:CGFloat = 0
        var blue:CGFloat  = 0
        var alpha:CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var targetRed:CGFloat   = 0
        var targetGreen:CGFloat = 0
        var targetBlue:CGFloat  = 0
        var targetAlpha:CGFloat = 0
        color.getRed(&targetRed, green: &targetGreen, blue: &targetBlue, alpha: &targetAlpha)
        
        return (Int(red*255.0) == Int(targetRed*255.0) && Int(green*255.0) == Int(targetGreen*255.0) && Int(blue*255.0) == Int(targetBlue*255.0) && alpha == targetAlpha)
    }
}
extension CGColor
{
    func isEqual(color: CGColor?) -> Bool
    {
        guard let color = color else { return false }
        let myColor = UIColor.init(cgColor: self)
        let otherColor = UIColor.init(cgColor: color)
        return myColor.isEqual(color: otherColor)
    }
}
extension String
{
    var changePlusTo2B: String
    {
        return self.replacingOccurrences(of: "+", with: "%2B")
    }
    var removeSpecialCharsFromString: String {
        let okayChars : Set<Character> =
            Set(" 1234567890+".characters)
        return String(self.characters.filter {okayChars.contains($0) })
    }
    var keepOnlyDigitAndDotOnString: String {
        let okayChars : Set<Character> =
            Set("1234567890.".characters)
        return String(self.characters.filter {okayChars.contains($0) })
    }
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    
    
    
    var hexColor: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    func toInt(defaultValue: Int) -> Int {
        if let n = Int(self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) {
            return n
        } else {
            return defaultValue
        }
    }
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

extension Date {
    init?(jsonDate: String) {
        let prefix = "/Date("
        let suffix = ")/"
        let scanner = Scanner(string: jsonDate)
        
        // Check prefix:
        guard scanner.scanString(prefix, into: nil)  else { return nil }
        
        // Read milliseconds part:
        var milliseconds : Int64 = 0
        guard scanner.scanInt64(&milliseconds) else { return nil }
        // Milliseconds to seconds:
        var timeStamp = TimeInterval(milliseconds)/1000.0
        
        // Read optional timezone part:
        var timeZoneOffset : Int = 0
        if scanner.scanInt(&timeZoneOffset) {
            let hours = timeZoneOffset / 100
            let minutes = timeZoneOffset % 100
            // Adjust timestamp according to timezone:
            timeStamp += TimeInterval(3600 * hours + 60 * minutes)
        }
        
        // Check suffix:
        guard scanner.scanString(suffix, into: nil) else { return nil }
        
        // Success! Create NSDate and return.
        self.init(timeIntervalSince1970: timeStamp)
    }
}

extension UIImage {
    
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = UIImagePNGRepresentation(self)! as NSData
        let data2: NSData = UIImagePNGRepresentation(image)! as NSData
        return data1.isEqual(data2)
    }
    
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x:0, y:0, width:self.size.width, height:self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage;
    }
}

extension UIImageView
{
    func makeMultigonal(sides:Int)
    {
        let lineWidth: CGFloat = self.layer.borderWidth;
        let cornerRadius: CGFloat = self.layer.cornerRadius;
        let path = UIBezierPath(polygonIn: self.bounds, sides: sides, lineWidth: lineWidth, cornerRadius: cornerRadius)
        
        let mask = CAShapeLayer()
        mask.path            = path.cgPath
        mask.lineWidth       = lineWidth
        mask.strokeColor     = UIColor.clear.cgColor
        mask.fillColor       = UIColor.white.cgColor
        self.layer.mask = mask
        
        let border = CAShapeLayer()
        border.path          = path.cgPath
        border.lineWidth     = lineWidth
        border.strokeColor   = UIColor.black.cgColor
        border.fillColor     = UIColor.clear.cgColor
        self.layer.addSublayer(border)
    }
    
}

extension UIBezierPath
{
    
    /// Create UIBezierPath for regular polygon with rounded corners
    ///
    /// - parameter rect:            The CGRect of the square in which the path should be created.
    /// - parameter sides:           How many sides to the polygon (e.g. 6=hexagon; 8=octagon, etc.).
    /// - parameter lineWidth:       The width of the stroke around the polygon. The polygon will be inset such that the stroke stays within the above square. Default value 1.
    /// - parameter cornerRadius:    The radius to be applied when rounding the corners. Default value 0.
    
    convenience init(polygonIn rect: CGRect, sides: Int, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 0) {
        self.init()
        
        let theta = 2 * CGFloat.pi / CGFloat(sides)                        // how much to turn at every corner
        let offset = cornerRadius * tan(theta / 2)                  // offset from which to start rounding corners
        let squareWidth = min(rect.size.width, rect.size.height)    // width of the square
        
        // calculate the length of the sides of the polygon
        
        var length = squareWidth - lineWidth
        if sides % 4 != 0 {                                         // if not dealing with polygon which will be square with all sides ...
            length = length * cos(theta / 2) + offset / 2           // ... offset it inside a circle inside the square
        }
    }
}

extension UIView
{
    func shimmer()
    {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: -0.02)
        gradient.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width*4, height: self.bounds.size.height)
        
        let lowerAlpha: CGFloat = 0.4
        let solid = UIColor(white: 1, alpha: 1).cgColor
        let clear = UIColor(white: 1, alpha: lowerAlpha).cgColor
        gradient.colors     = [ solid, solid, clear, clear, solid, solid ]
        gradient.locations  = [ 0,     0.3,   0.45,  0.55,  0.7,   1     ]
        
        let theAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        theAnimation.duration = 0.5
        theAnimation.repeatCount = Float.infinity
        theAnimation.autoreverses = false
        theAnimation.isRemovedOnCompletion = false
        theAnimation.fillMode = kCAFillModeForwards
        theAnimation.fromValue = -self.frame.size.width * 2
        theAnimation.toValue =  0
        gradient.add(theAnimation, forKey: "animateLayer")
        
        self.layer.mask = gradient
    }
}

extension Locale {
    static var preferredLanguage: String {
        get {
            return self.preferredLanguages.first ?? "en-US"
        }
        set {
            UserDefaults.standard.set([newValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }
}

extension String {
    var localized: String {
        
        var result: String
        
        let languageCode = Locale.preferredLanguage //en-US
        
        var path = Bundle.main.path(forResource: languageCode, ofType: "lproj")
        
        if path == nil, let hyphenRange = languageCode.range(of: "-") {
            let languageCodeShort = languageCode.substring(to: hyphenRange.lowerBound) // en
            path = Bundle.main.path(forResource: languageCodeShort, ofType: "lproj")
        }
        
        if let path = path, let locBundle = Bundle(path: path) {
            result = locBundle.localizedString(forKey: self, value: nil, table: nil)
        } else {
            result = NSLocalizedString(self, comment: "")
        }
        return result
    }
}


/*typealias JSONDictionary = [String:Any]

class LocationServices:NSObject,CLLocationManagerDelegate {
    
    static let shared = LocationServices()
    let locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    private let operationQueue = OperationQueue()
    
    override init()
    {
        super.init()
        
        //Pause the operation queue because
        // we don't know if we have location permissions yet
        operationQueue.isSuspended = true
        locManager.delegate = self
    }
    
    ///When the user presses the allow/don't allow buttons on the popup dialogue
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        //If we're authorized to use location services, run all operations in the queue
        // otherwise if we were denied access, cancel the operations
        if(status == .authorizedAlways || status == .authorizedWhenInUse){
            self.operationQueue.isSuspended = false
        }else if(status == .denied){
            self.operationQueue.cancelAllOperations()
        }
    }
    
    ///Checks the status of the location permission
    /// and adds the callback block to the queue to run when finished checking
    /// NOTE: Anything done in the UI should be enclosed in `DispatchQueue.main.async {}`
    func runLocationBlock(callback: @escaping () -> ()){
        
        //Get the current authorization status
        let authState = CLLocationManager.authorizationStatus()
        
        //If we have permissions, start executing the commands immediately
        // otherwise request permission
        if(authState == .authorizedAlways || authState == .authorizedWhenInUse){
            self.operationQueue.isSuspended = false
        }else{
            //Request permission
            self.locManager.requestWhenInUseAuthorization()
        }
        
        //Create a closure with the callback function so we can add it to the operationQueue
        let block = { callback() }
        
        //Add block to the queue to be executed asynchronously
        self.operationQueue.addOperation(block)
    }
    
    func getAdress(completion: @escaping (_ address: JSONDictionary?, _ error: Error?) -> ()) {
        
        let status = CLLocationManager.authorizationStatus()
        
        if(status == .authorizedAlways || status == .authorizedWhenInUse)
        {
            
            
            print(locManager.location ??  "Error fetching location")
            
            if locManager.location != nil
            {
                self.currentLocation = locManager.location

                let geoCoder = CLGeocoder()
                
                geoCoder.reverseGeocodeLocation(self.currentLocation) { placemarks, error in
                    
                    if let e = error {
                        
                        completion(nil, e)
                        
                    } else {
                        
                        let placeArray = placemarks!
                        
                        var placeMark: CLPlacemark!
                        
                        placeMark = placeArray[0]
                        
                        guard let address = placeMark.addressDictionary as? JSONDictionary else {
                            return
                        }
                        
                        completion(address, nil)
                        
                    }
                    
                }
            }
            else
            {
                print("Location Not fetched")
            }
            
            
        }
        else
        {
            print("Location Not permitted yet")
        }
        
    }
    
    
    
}*/

