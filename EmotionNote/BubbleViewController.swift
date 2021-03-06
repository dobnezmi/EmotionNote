//
//  BubbleViewController.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/07/31.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit
import SpriteKit
import RxSwift
import RxCocoa

class BubbleViewController: UIViewController, SIFloatingCollectionSceneDelegate {

    @IBOutlet weak var chartButton: UIButton!
    
    var skView: SKView!
    var floatingCollectionScene: BubblesScene!
    let disposeBag = DisposeBag()
    
    var presenter: BubbleViewPresenter!
    var router: BubbleViewRouter!
    var needResetEmotions: Bool = false
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        skView = SKView(frame: UIScreen.main.bounds)
        view.addSubview(skView)
        
        floatingCollectionScene = BubblesScene(size: skView.bounds.size)
        skView.presentScene(floatingCollectionScene)
        floatingCollectionScene.floatingDelegate = self
        self.view.bringSubview(toFront: chartButton)

        bindModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if needResetEmotions {
            needResetEmotions = false

            // 各ノードの位置をリセットする
            floatingCollectionScene.resetNodes()
        }
        
    }
    
    func bindModel() {
        presenter.rx_emotions.asObservable().subscribe(onNext: { [weak self] emotions in
            for emotion in emotions {
                let node = BubbleNode.instantiate(emotion: emotion)
                self?.floatingCollectionScene.addChild(node!)
            }
        },onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
        
        chartButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.router.nextScreen(viewController: self)
        }).addDisposableTo(disposeBag)
    }

    // MARK: SIFloatingCollectionSceneDelegate
    func floatingScene(scene: SIFloatingCollectionScene, didCommitFloatingNodeAtIndex index: Int) {
        var count = 0
        var removedCompletedCount = 0
        
        needResetEmotions = true
        presenter.didSelectAtIndex(index)
        for node in scene.floatingNodes {
            if let bubble = node as? BubbleNode {
                if count != index {
                    bubble.removeNormalNode() { [weak self] in
                        removedCompletedCount += 1
                        if removedCompletedCount == scene.floatingNodes.count - 1 {
                            self?.router?.nextScreen(viewController: self)
                        }
                    }
                }
            }
            count += 1
        }
    }

}

