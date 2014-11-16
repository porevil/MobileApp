//
//  ViewController.swift
//  perfectWeather
//
//  Created by Natapong Saratham on 11/15/2557 BE.
//  Copyright (c) 2557 Porevil. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    private let apiKey = "6f7989a82e4724554fbfd622eb86cd63"
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humadityLabel: UILabel!
    @IBOutlet weak var preciptationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var refreshActIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshActIndicator.hidden = true
        self.getCurrentWeather()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    @IBAction func refreshPush() {
        self.getCurrentWeather()
        refreshButton.hidden = true
        refreshActIndicator.hidden = false
        refreshActIndicator.startAnimating()
    }
    
    func getCurrentWeather()-> Void{
        let forcastURL = "https://api.forecast.io/forecast/"
        
        let serviceUrl = forcastURL+apiKey+"/"
        println("Goto : "+serviceUrl)
        
        let baseUrl = NSURL(string: serviceUrl)
        let forcastUrl = NSURL(string: "37.8267,-122.423", relativeToURL: baseUrl)
        
        let shareSession = NSURLSession.sharedSession()
        let downloadTask:NSURLSessionDownloadTask = shareSession.downloadTaskWithURL(forcastUrl!, completionHandler:
            { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
                
                if(error==nil){
                    
                var e: NSError?
                let string = NSString(contentsOfURL: forcastUrl!, encoding: NSUTF8StringEncoding, error: &e)
                println(string)
                
                let dataObj = NSData(contentsOfURL: forcastUrl!)
                let weatherDic : NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObj!, options: nil, error: nil)                as NSDictionary
                let currentWeather = Current(weatherDictionary: weatherDic)
                println(currentWeather.temperature)
                println(currentWeather.humadity)
                println(currentWeather.currentTime)
                
                dispatch_async(dispatch_get_main_queue()!, { () -> Void in
                    self.temperatureLabel.text =  "\(currentWeather.temperature)";
                    self.humadityLabel.text = "\(currentWeather.humadity)";
                    self.preciptationLabel.text = "\(currentWeather.precipProbability)";
                    self.currentTimeLabel.text = "\(currentWeather.currentTime)";
                    self.iconView.image = currentWeather.icon
                    self.summaryLabel.text = "\(currentWeather.summary)";
                    
                    self.refreshActIndicator.stopAnimating()
                    self.refreshActIndicator.hidden = true
                    self.refreshButton.hidden = false
                    
                    
                })

                }else{
                    
                    self.summaryLabel.text = "Wait hold sec";
                    
                    println("=========== Try to Connect =============")
                    let networkIssueController = UIAlertController(title: "Problem", message: "Houston we've a Problem", preferredStyle: .Alert)
                    
                    let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    networkIssueController.addAction(okButton)
                    self.presentViewController(networkIssueController, animated: true, completion: nil)
                    //self.refreshPush()
                    dispatch_async(dispatch_get_main_queue()!, { () -> Void in                        
                        self.refreshActIndicator.stopAnimating()
                        self.refreshActIndicator.hidden = true
                        self.refreshButton.hidden = false
                        
                        
                    })

                    
                }
                
        })
        
        downloadTask.resume()
        //}
  
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    



}

