//
//  SwinjectStoryboard+EmotionNote.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/14.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import Swinject

extension SwinjectStoryboard {
    class func setup() {
        Injector.initialize()
        
        // バブル画面
        defaultContainer.register(BubbleViewPresenter.self) { _ in
            BubbleViewPresenterImpl()
        }
        defaultContainer.register(BubbleViewRouter.self) { _ in
            BubbleViewRouterImpl()
        }
        defaultContainer.registerForStoryboard(BubbleViewController.self) { r, vc in
            vc.presenter = r.resolve(BubbleViewPresenter.self)
            vc.router = r.resolve(BubbleViewRouter.self)
        }
    }
}
