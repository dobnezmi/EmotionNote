//
//  UIColor+Util.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/10/05.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit

extension UIColor {
    static var colorForSad: UIColor { //　悲しいときは前向きになれるオレンジ
        return UIColor(red: 0xF5/0xFF, green: 0x7C/0xFF, blue: 0, alpha: 1.0)
    }
    
    static var colorForJoy: UIColor { // 楽しいときは楽しさがつづくように黄色
        return UIColor(red: 1, green: 0xEB/0xFF, blue: 0x3B/0xFF, alpha: 1.0)
    }
    
    static var colorForHappy: UIColor { // 嬉しいときはハメを外さないように緑色
        return UIColor(red: 0, green: 0x96/0xFF, blue: 0x88/0xFF, alpha: 1.0)
    }
    
    static var colorForFrustrated: UIColor { // イライラしたときは落ち着ける青
        return UIColor(red: 0x21 / 0xff, green: 0x96 / 0xff, blue: 0xf3 / 0xff, alpha: 1.0)
    }
}
