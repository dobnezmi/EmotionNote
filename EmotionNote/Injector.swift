//
//  Injector.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/15.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import Foundation
import Swinject

final class Injector {
    static let container = Container()
    
    class func initialize() {
        container.register(BubbleInteractor.self) { _ in
            BubbleInteractorImpl()
        }
    }
}
