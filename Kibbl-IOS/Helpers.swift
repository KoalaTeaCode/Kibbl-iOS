//
//  Helpers.swift
//  Kibbl-IOS
//
//  Created by Craig Holliday on 5/11/17.
//  Copyright © 2017 Koala Tea. All rights reserved.
//

import UIKit
import SwifterSwift
import RealmSwift
import PKHUD

extension Helpers {
    static var alert: UIAlertController!
    
    enum Alerts {
        static let error = "Error"
        static let success = "Success"
    }
    
    enum Messages {
        static let emailEmpty = "Email Field Empty"
        static let passwordEmpty = "Password Field Empty"
        static let passwordConfirmEmpty = "Confirm Password Field Empty"
        static let emailWrongFormat = "Invalid Email Format"
        static let passwordNotLongEnough = "Password must be longer than 6 characters"
        static let passwordsDonotMatch = "Password do not match"
        static let firstNameEmpty = "First Name Field Empty"
        static let firstNameNotLongEnough = "First Name must be longer than 1 characters"
        static let lastNameEmpty = "Last Name Field Empty"
        static let lastNameNotLongEnough = "Last Name must be longer than 1 characters"
        static let pleaseLogin = "Please Login"
        static let issueWithUserToken = "Issue with User Token"
        static let noWebsite = "No linked webste."
        static let youMustLogin = "You must login to use this feature."
        static let logoutSuccess = "Successfully Logged Out"
    }
}

class Helpers {
    class func calculateHeight(forHeight height: CGFloat) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let divisor: CGFloat = 667 / height
        let calculatedHeight = screenHeight / divisor
        return calculatedHeight
    }
    
    class func calculateWidth(forWidth width: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let divisor: CGFloat = 375.0 / width
        let calculatedWidth = screenWidth / divisor
        return calculatedWidth
    }
    
    class func formatDateForFull(startDate: String, endDate: String) -> String {
        let startMonth = Helpers.formatDateForStartMonth(startDate: startDate, endDate: endDate)
        let day = Helpers.formatDateForDay(startDate: startDate, endDate: endDate)
        let time = Helpers.formatDateForTime(startDate: startDate, endDate: endDate)
        return startMonth + " " + day + ", " + time
    }
    
    class func formatDateForStartMonthandDay(startDate: String, endDate: String) -> String {
        let startMonth = Helpers.formatDateForStartMonth(startDate: startDate, endDate: endDate)
        let day = Helpers.formatDateForDay(startDate: startDate, endDate: endDate)
        return startMonth + " " + day
    }
    
    class func formatDateForTime(startDate startString: String,endDate endString: String) -> String {
        let startDate = Date(iso8601String: startString)
        let startTime = startDate?.timeString(ofStyle: .short)
        let endDate = Date(iso8601String: endString)
        let endTime = endDate?.timeString(ofStyle: .short)
        
        var time = startTime! + " - " + endTime!
        
        if startTime == endTime {
            time = startTime!
        }
        return time
    }
    
    class func formatDateForStartMonth(startDate startString: String,endDate endString: String) -> String {
        let startDate = Date(iso8601String: startString)
        let startMonth = startDate!.monthName(ofStyle: .threeLetters)

        return startMonth
    }
    
    class func formatDateForDay(startDate startString: String,endDate endString: String) -> String {
        let startDate = Date(iso8601String: startString)
        let startDay = String(describing: startDate!.day)
        let endDate = Date(iso8601String: endString)
        let endDay = String(describing: endDate!.day)
        
        var day = startDay + " - " + endDay
        
        if startDay == endDay {
            day = startDay
        }
        return day
    }
    
    static func alertWithMessage(title: String!, message: String!, completionHandler: (() -> ())? = nil) {
        HUD.hide()
        //@TODO: Guard if there's already an alert message
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            guard !(topController is UIAlertController) else {
                // There's already a alert preseneted
                return
            }
            
            alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            topController.present(alert, animated: true, completion: nil)
            completionHandler?()
        }
    }
    
    class func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
}

extension Results{
    
    func get <T:Object> (offset: Int, limit: Int ) -> Array<T>{
        //create variables
        var lim = 0 // how much to take
        var off = 0 // start from
        var l: Array<T> = Array<T>() // results list
        
        //check indexes
        if off<=offset && offset<self.count - 1 {
            off = offset
        }
        if limit > self.count {
            lim = self.count
        }else{
            lim = limit
        }
        
        //do slicing
        for i in off..<lim{
            let dog = self[i] as! T
            l.append(dog)
        }
        
        //results
        return l
    }
}

public extension String {
    /// Decodes string with html encoding.
    var htmlDecoded: String {
        guard let encodedData = self.data(using: .utf8) else { return self }
        
        let attributedOptions: [String : Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue]
        
        do {
            let attributedString = try NSAttributedString(data: encodedData,
                                                          options: attributedOptions,
                                                          documentAttributes: nil)
            return attributedString.string
        } catch {
            print("Error: \(error)")
            return self
        }
    }
}

extension Date {
    
    var startOfDay : Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
    
    var endOfDay : Date {
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }
}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

extension Int {
    func calculateHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let divisor: CGFloat = 667 / CGFloat(self)
        let calculatedHeight = screenHeight / divisor
        return calculatedHeight
    }
    
    func calculateWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let divisor: CGFloat = 375.0 / CGFloat(self)
        let calculatedWidth = screenWidth / divisor
        return calculatedWidth
    }
}

extension Double {
    func calculateHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let divisor: CGFloat = 667 / CGFloat(self)
        let calculatedHeight = screenHeight / divisor
        return calculatedHeight
    }
    
    func calculateWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let divisor: CGFloat = 375.0 / CGFloat(self)
        let calculatedWidth = screenWidth / divisor
        return calculatedWidth
    }
}


//extension Formatter {
//    static let iso8601: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
//        return formatter
//    }()
//}
//
//extension Date {
//    var iso8601: String {
//        return Formatter.iso8601.string(from: self)
//    }
//}
//
//extension String {
//    var dateFromISO8601: Date? {
//        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
//    }
//}
