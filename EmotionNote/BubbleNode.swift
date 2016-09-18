//
//  BubbleNode.swift
//  Example
//
//  Created by Neverland on 15.08.15.
//  Copyright (c) 2015 ProudOfZiggy. All rights reserved.
//
//  Modified by Shingo Suzuki on 16.08.11.

import Foundation

import UIKit
import SpriteKit

class BubbleNode: SIFloatingNode {
    var labelNode = SKLabelNode(fontNamed: "")
    
    class func instantiate(emotion: Emotion) -> BubbleNode! {
        let node = BubbleNode(circleOfRadius: 60)
        configureNode(node: node, text: emotion.toString())
        return node
    }
    
    class func configureNode(node: BubbleNode!, text: String) {
        let boundingBox = node.path!.boundingBox;
        let radius = boundingBox.size.width / 2.0;
        node.physicsBody = SKPhysicsBody(circleOfRadius: radius + 1.5)
        node.fillColor = SKColor.white
        node.strokeColor = node.fillColor
        
        node.labelNode.text = text
        node.labelNode.position = CGPoint(x: 0, y: 0)
        node.labelNode.fontColor = SKColor(red: 0x21 / 0xff, green: 0x96 / 0xff, blue: 0xf3 / 0xff, alpha: 1.0)
        node.labelNode.fontSize = 16
        node.labelNode.isUserInteractionEnabled = false
        node.labelNode.verticalAlignmentMode = .center
        node.labelNode.horizontalAlignmentMode = .center
        node.addChild(node.labelNode)
    }
    
    override func selectingAnimation() -> SKAction? {
        removeAction(forKey: BubbleNode.removingKey)
        return SKAction.scale(to: 1.3, duration: 0.2)
    }
    
    override func normalizeAnimation() -> SKAction? {
        removeAction(forKey: BubbleNode.removingKey)
        return SKAction.scale(to: 1, duration: 0.2)
    }
    
    override func commitAnimation() -> SKAction? {
        removeAction(forKey: BubbleNode.commitKey)

        let finishPoint = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height)
        let cgPath = CGMutablePath()
        let st = position
        let ed  = finishPoint
        
        // 目的地の半分ずつでランダム
        let edX = CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.width)))
        let edY = CGFloat(arc4random_uniform(UInt32(finishPoint.y - position.y)))
        let pt1  = CGPoint(x: edX, y: edY / 2 + position.y)
        let pt2  = CGPoint(x: edX / 2, y: edY + position.y)
        
        cgPath.move(to: st)
        cgPath.addCurve(to: ed, control1: pt1, control2: pt2)
        
        let curve = SKAction.follow(cgPath, asOffset: false, orientToPath: false, duration: 1.5)
        let fade  = SKAction.fadeOut(withDuration: 1.5)
        let scale = SKAction.scale(to: 0.1, duration: 1.5)
        
        return SKAction.group([curve, fade, scale])
    }
    
    override func removeAnimation() -> SKAction? {
        removeAction(forKey: BubbleNode.removingKey)
        return SKAction.fadeOut(withDuration: 0.2)
    }
    
    override func removingAnimation() -> SKAction {
        let pulseUp = SKAction.scale(to: xScale + 0.13, duration: 0)
        let pulseDown = SKAction.scale(to: xScale, duration: 0.3)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatForever(pulse)
        return repeatPulse
    }
    
    func removeNormalNode(completion: @escaping ()->()) {
        let cgPath = CGMutablePath()
        let st = position
        var edX = CGFloat(0)
        var dir = CGFloat(-1)
        
        // 消える方向を決める
        if st.x > UIScreen.main.bounds.width / 2 {
            edX = UIScreen.main.bounds.width
            dir = 1
        }
        let ed = CGPoint(x: edX, y: 0)
        // 非選択項目は固定値で
        let ptX = (position.x - edX) * dir
        let pt1  = CGPoint(x: position.x - (ptX / 2), y: position.y / 2)
        let pt2  = CGPoint(x: position.x - ptX, y: 0)

        cgPath.move(to: st)
        cgPath.addCurve(to: ed, control1: pt1, control2: pt2)
        
        let curve = SKAction.follow(cgPath, asOffset: false, orientToPath: true, duration: 1.0)
        let fade = SKAction.fadeOut(withDuration: 1.0)
        let scale = SKAction.scale(to: 0.1, duration: 1.0)
        
        run(SKAction.group([curve, fade, scale]), completion: completion)
    }
}
