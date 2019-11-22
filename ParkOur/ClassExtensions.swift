//
//  ClassExtensions.swift
//  WePeiYang
//
//  Created by Allen X on 3/11/17.
//  Copyright © 2017 twtstudio. All rights reserved.
//

/**
 This file wraps all universal extensions of class for convenience
 */

import UIKit

extension UILabel {
    convenience init(text: String, color: UIColor) {
        self.init()
        self.text = text
        textColor = color
        self.sizeToFit()
    }
    
    /// A convenience initializer of UILabel
    ///
    /// - Parameters:
    ///   - text: The content of your label
    ///   - color: Text color
    ///   - fontSize: Text font size
    convenience init(text: String, color: UIColor, fontSize: CGFloat) {
        self.init()
        self.text = text
        textColor = color
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.sizeToFit()
    }
    
    convenience init(text: String?) {
        self.init()
        self.text = text
        self.sizeToFit()
    }
    
    convenience init(text: String, fontSize: CGFloat) {
        self.init()
        self.text = text
        self.font = UIFont.boldSystemFont(ofSize: fontSize)
        self.sizeToFit()
    }
}

extension UIView {
    convenience init(color: UIColor) {
        self.init()
        backgroundColor = color
    }
    
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    var x: CGFloat {
        set(newValue) {
            frame.origin.x = newValue
        }
        get {
            return frame.origin.x
        }
    }
    
    var y: CGFloat {
        set(newValue) {
            frame.origin.y = newValue
        }
        get {
            return frame.origin.y
        }
    }
    
    var height: CGFloat {
        set(newValue) {
            frame.size.height = newValue
        }
        get {
            return frame.size.height
        }
    }
    
    var width: CGFloat {
        set(newValue) {
            frame.size.width = newValue
        }
        get {
            return frame.size.width
        }
    }
    
}

extension CALayer {
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    
    static func resizedImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0.0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static func resizedImageKeepingRatio(image: UIImage, scaledToWidth newWidth: CGFloat) -> UIImage {
        let scaleRatio = newWidth / image.size.width
        let newHeight = image.size.height * scaleRatio
        let foo = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: newWidth, height: newHeight))
        return foo
    }
    
    static func resizedImageKeepingRatio(image: UIImage, scaledToHeight newHeight: CGFloat) -> UIImage {
        let scaleRatio = newHeight / image.size.height
        let newWidth = image.size.width * scaleRatio
        let foo = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: newWidth, height: newHeight))
        return foo
    }
    
    func rgb(atPos pos: CGPoint) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return (r, g, b, a)
    }
    
    func with(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0)
        context!.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        context!.clip(to: rect, mask: self.cgImage!)
        context!.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    //pure color image
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIImageView {
    convenience init?(imageName: String, desiredSize: CGSize) {
        guard var foo = UIImage(named: imageName) else {
            return nil
        }
        foo = UIImage.resizedImage(image: foo, scaledToSize: desiredSize)
        self.init()
        image = foo
    }
    
}

extension UIButton {
    convenience init(title: String) {
        self.init()
        setTitle(title, for: .normal)
        titleLabel?.sizeToFit()
    }
    
    convenience init?(backgroundImageName: String, desiredSize: CGSize) {
        guard var foo = UIImage(named: backgroundImageName) else {
            return nil
        }
        foo = UIImage.resizedImage(image: foo, scaledToSize: desiredSize)
        self.init()
        setBackgroundImage(foo, for: .normal)
    }
}




extension UIViewController {
    private static func findBest(_ vc: UIViewController) -> UIViewController {
        if let next = vc.presentedViewController {
            return findBest(next)
        } else if let svc = vc as? UISplitViewController, let last = svc.viewControllers.last {
            return findBest(last)
        } else if let svc = vc as? UINavigationController, let top = svc.viewControllers.last {
            return findBest(top)
        } else if let svc = vc as? UITabBarController, let selected = svc.selectedViewController {
            return findBest(selected)
        } else {
            return vc
        }
    }
    
    static var current: UIViewController? {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            return findBest(vc)
        } else {
            return nil
        }
    }
    
    static var top: UIViewController? {
        
        if let appRootVC = UIApplication.shared.keyWindow?.rootViewController {
            var topVC: UIViewController? = appRootVC
            while topVC?.presentedViewController != nil {
                topVC = topVC?.presentedViewController
            }
            return topVC
        }
        return nil
    }
    
    var isModal: Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
}

extension UIColor {
    /**
     The six-digit hexadecimal representation of color of the form #RRGGBB.
     
     - parameter hex6: Six-digit hexadecimal value.
     */
    public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        // TODO: below
        // Store Hex converted UIColours (R, G, B, A) to a persistent file (.plist)
        // And when initializing the app, read from the plist into the memory as a static struct (Metadata.Color)
        let divisor = CGFloat(255)
        let r = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let g = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let b = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1) {
        let chars = Array(hexString.dropFirst())
        self.init(red:   .init(strtoul(String(chars[0...1]),nil,16))/255,
                  green: .init(strtoul(String(chars[2...3]),nil,16))/255,
                  blue:  .init(strtoul(String(chars[4...5]),nil,16))/255,
                  alpha: alpha)}
    
    static var readRed: UIColor {
        return UIColor(red: 237.0/255.0, green: 84.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    }
}



extension CGRect {
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width/2, y: center.y - size.height/2)
        self.init(origin: origin, size: size)
    }
}



// Encodable
extension Encodable {
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString() throws -> String? {
        return String(data: try self.jsonData(), encoding: .utf8)
    }
}

extension Decodable {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}

extension Dictionary {
    func jsonData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
    }
}

extension CGFloat {
    static var iPhoneSEWidth: CGFloat {
        return 320
    }
    
    static var iPhone8Width: CGFloat {
        return 375
    }
    
    static var iPhone8PlusWidth: CGFloat {
        return 414
    }
}

var isiPad: Bool {
    return UIDevice.current.model == "iPad"
}


struct CastingError: Error {
    let fromType: Any.Type
    let toType: Any.Type
    init<FromType, ToType>(fromType: FromType.Type, toType: ToType.Type) {
        self.fromType = fromType
        self.toType = toType
    }
}

extension CastingError: LocalizedError {
    var localizedDescription: String { return "Can not cast from \(fromType) to \(toType)" }
}

extension CastingError: CustomStringConvertible { var description: String { return localizedDescription } }

extension Data {
    func toDictionary(options: JSONSerialization.ReadingOptions = []) throws -> [String: Any] {
        return try to(type: [String: Any].self, options: options)
    }
    
    func to<T>(type: T.Type, options: JSONSerialization.ReadingOptions = []) throws -> T {
        guard let result = try JSONSerialization.jsonObject(with: self, options: options) as? T else {
            throw CastingError(fromType: type, toType: T.self)
        }
        return result
    }
}
