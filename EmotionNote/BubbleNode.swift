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
        configureNode(node, text: emotion.toString())
        return node
    }
    
    class func configureNode(node: BubbleNode!, text: String) {
        let boundingBox = CGPathGetBoundingBox(node.path);
        let radius = boundingBox.size.width / 2.0;
        node.physicsBody = SKPhysicsBody(circleOfRadius: radius + 1.5)
        node.fillColor = SKColor.whiteColor()
        node.strokeColor = node.fillColor
        
        node.labelNode.text = text
        node.labelNode.position = CGPointZero
        node.labelNode.fontColor = SKColor(red: 0x21 / 0xff, green: 0x96 / 0xff, blue: 0xf3 / 0xff, alpha: 1.0)
        node.labelNode.fontSize = 16
        node.labelNode.userInteractionEnabled = false
        node.labelNode.verticalAlignmentMode = .Center
        node.labelNode.horizontalAlignmentMode = .Center
        node.addChild(node.labelNode)
    }
    
    override func selectingAnimation() -> SKAction? {
        removeActionForKey(BubbleNode.removingKey)
        return SKAction.scaleTo(1.3, duration: 0.2)
    }
    
    override func normalizeAnimation() -> SKAction? {
        removeActionForKey(BubbleNode.removingKey)
        return SKAction.scaleTo(1, duration: 0.2)
    }
    
    override func commitAnimation() -> SKAction? {
        removeActionForKey(BubbleNode.commitKey)

        let finishPoint = CGPoint(x: UIScreen.mainScreen().bounds.width/2, y: UIScreen.mainScreen().bounds.height)
        let cgPath = CGPathCreateMutable()
        let st = position
        let ed  = finishPoint
        
        // 目的地の半分ずつでランダム
        let edX = CGFloat(arc4random_uniform(UInt32(UIScreen.mainScreen().bounds.width)))
        let edY = CGFloat(arc4random_uniform(UInt32(finishPoint.y - position.y)))
        let pt1  = CGPoint(x: edX, y: edY / 2 + position.y)
        let pt2  = CGPoint(x: edX / 2, y: edY + position.y)
        
        CGPathMoveToPoint(cgPath, nil, st.x, st.y)
        CGPathAddCurveToPoint(cgPath, nil, pt1.x, pt1.y, pt2.x, pt2.y, ed.x, ed.y)
        
        let curve = SKAction.followPath(cgPath, asOffset: false, orientToPath: false, duration: 1.5)
        let fade  = SKAction.fadeOutWithDuration(1.5)
        let scale = SKAction.scaleTo(0.1, duration: 1.5)
        
        return SKAction.group([curve, fade, scale])
    }
    
    override func removeAnimation() -> SKAction? {
        removeActionForKey(BubbleNode.removingKey)
        return SKAction.fadeOutWithDuration(0.2)
    }
    
    override func removingAnimation() -> SKAction {
        let pulseUp = SKAction.scaleTo(xScale + 0.13, duration: 0)
        let pulseDown = SKAction.scaleTo(xScale, duration: 0.3)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatActionForever(pulse)
        return repeatPulse
    }
    
    func removeNormalNode(completion: ()->()) {
        let cgPath = CGPathCreateMutable()
        let st = position
        var edX = CGFloat(0)
        var dir = CGFloat(-1)
        
        // 消える方向を決める
        if st.x > UIScreen.mainScreen().bounds.width / 2 {
            edX = UIScreen.mainScreen().bounds.width
            dir = 1
        }
        let ed = CGPoint(x: edX, y: 0)
        // 非選択項目は固定値で
        let ptX = (position.x - edX) * dir
        let pt1  = CGPoint(x: position.x - (ptX / 2), y: position.y / 2)
        let pt2  = CGPoint(x: position.x - ptX, y: 0)
        
        CGPathMoveToPoint(cgPath, nil, st.x, st.y)
        CGPathAddCurveToPoint(cgPath, nil, pt1.x, pt1.y, pt2.x, pt2.y, ed.x, ed.y)
        
        let curve = SKAction.followPath(cgPath, asOffset: false, orientToPath: true, duration: 1.0)
        let fade = SKAction.fadeOutWithDuration(1.0)
        let scale = SKAction.scaleTo(0.1, duration: 1.0)
        
        runAction(SKAction.group([curve, fade, scale]), completion: completion)
    }
}