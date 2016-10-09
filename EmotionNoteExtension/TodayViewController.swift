//
//  TodayViewController.swift
//  EmotionNoteExtension
//
//  Created by Shingo Suzuki on 2016/10/08.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var buttonFrust: UIButton!
    @IBOutlet weak var buttonSad: UIButton!
    @IBOutlet weak var buttonJoy: UIButton!
    @IBOutlet weak var buttonHappy: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        buttonFrust.layer.cornerRadius = 5
        buttonFrust.layer.masksToBounds = true
        buttonSad.layer.cornerRadius = 5
        buttonSad.layer.masksToBounds = true
        buttonJoy.layer.cornerRadius = 5
        buttonJoy.layer.masksToBounds = true
        buttonHappy.layer.cornerRadius = 5
        buttonHappy.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    @IBAction func onFrustrate(_ sender: AnyObject) {
        addValue(emotion: .Frustrated)
    }
    
    @IBAction func onSad(_ sender: AnyObject) {
        addValue(emotion: .Sad)
    }
    
    @IBAction func onJoy(_ sender: AnyObject) {
        addValue(emotion: .Enjoy)
    }
    
    @IBAction func onHappy(_ sender: AnyObject) {
        addValue(emotion: .Happy)
    }
    
    func addValue(emotion: Emotion) {
        let ud = UserDefaults(suiteName: groupSuiteName)
        var values = ud?.array(forKey: "emotions") as? [Int] ?? []
        var times  = ud?.array(forKey: "times") as? [Date] ?? []
        values.append(emotion.rawValue)
        times.append(Date())
        ud?.set(values, forKey: "emotions")
        ud?.set(times, forKey: "times")
        ud?.synchronize()
    }
}
