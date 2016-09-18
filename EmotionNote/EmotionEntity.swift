//
//  EmotionEntity.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/08/12.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import Foundation
import RealmSwift

enum EmotionPeriod {
    case Week
    case Month
    case All
}

struct EmotionCount {
    var happyCount: Int
    var enjoyCount: Int
    var sadCount: Int
    var frustCount: Int
    
    init(happy: Int = 0, enjoy: Int = 0, sad: Int = 0, frust: Int = 0) {
        happyCount = happy
        enjoyCount = enjoy
        sadCount = sad
        frustCount = frust
    }
    
    func addHappy() -> EmotionCount {
        return EmotionCount(happy: happyCount+1, enjoy: enjoyCount, sad: sadCount, frust: frustCount)
    }
    
    func addEnjoy() -> EmotionCount {
        return EmotionCount(happy: happyCount, enjoy: enjoyCount+1, sad: sadCount, frust: frustCount)
    }
    
    func addSad() -> EmotionCount {
        return EmotionCount(happy: happyCount, enjoy: enjoyCount, sad: sadCount+1, frust: frustCount)
    }
    
    func addFrustrate() -> EmotionCount {
        return EmotionCount(happy: happyCount, enjoy: enjoyCount, sad: sadCount, frust: frustCount+1)
    }
}

enum SSWeekday: Int {
    case Sunday = 1
    case Monday = 2
    case Tuesday = 3
    case Wednesday = 4
    case Thursday  = 5
    case Friday    = 6
    case Saturday  = 7
}

enum Emotion: Int {
    case Happy
    case Enjoy
    case Sad
    case Frustrated
    
    func toString() -> String {
        switch self {
        case .Happy:
            return "嬉しい"
        case .Enjoy:
            return "楽しい"
        case .Sad:
            return "悲しい"
        case .Frustrated:
            return "イライラ"
        }
    }
}

class EmotionEntity: Object {

    dynamic var emoteAt: Date = Date(timeIntervalSince1970: 1)
    dynamic var weekday: Int = SSWeekday.Sunday.rawValue
    dynamic var hour: Int = 0
    dynamic var emotion: Int = Emotion.Happy.rawValue
    
    override class func indexedProperties() -> [String] {
        return ["emoteAt"]
    }
}

