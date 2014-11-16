//
//  Current.swift
//  PerfectStromII
//
//  Created by Natapong Saratham on 11/15/2557 BE.
//  Copyright (c) 2557 Porevil. All rights reserved.
//

import Foundation
import UIKit


struct Current {
    var currentTime : String?
    var temperature : Double
    var humadity : Double
    var precipProbability : Double
    var summary : String
    var icon : UIImage?
    
    init(weatherDictionary:NSDictionary){
        let currentWeather:NSDictionary = weatherDictionary["currently"] as NSDictionary
        temperature = currentWeather["apparentTemperature"] as Double;
        humadity =  currentWeather["humidity"] as Double;
        precipProbability = currentWeather["precipProbability"] as Double;
        summary = currentWeather["summary"] as String;
        var iconString = currentWeather["icon"] as String;
        icon = weatherIconFromString(iconString)
        var currentTimeInt = currentWeather["time"] as? Int;
        currentTime = convertUnixTimeToString(currentTimeInt!)
        
        
    }
    
    func convertUnixTimeToString(unixTime:Int) ->String{
        let timeInsecond = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInsecond)
        var formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle;
        
        return formatter.stringFromDate(weatherDate);
    }
    
    func weatherIconFromString(iconString:NSString ) ->UIImage {
        
        println("iconSting : \(iconString)")
        var imageName : String
        
        switch iconString{
        case "clear-day" :
            imageName = "clear-day"
        case "clear-night" :
            imageName = "clear-night"
        case "rain" :
            imageName = "rain"
        case "snow" :
            imageName = "snow"
        case "sleet" :
            imageName = "sleet"
        case "fog" :
            imageName = "fog"
        case "cloudy" :
            imageName = "cloudy"
        case "partly-cloudy-day" :
            imageName = "cloudy-day"
        case "partly-cloudy-night" :
            imageName = "cloudy-night"
        default :imageName = "default"
            
        }
        var iconImage = UIImage(named: imageName)
        return iconImage!;
        
        
    }
}