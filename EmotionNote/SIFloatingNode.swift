//
//  SIFloatingNode.swift
//  SIFloatingCollectionExample_Swift
//
//  Created by Neverland on 15.08.15.
//  Copyright (c) 2015 ProudOfZiggy. All rights reserved.
//
//
//  Modified by Shingo Suzuki on 16.08.11.

import SpriteKit

public enum SIFloatingNodeState {
    case Normal
    case Selected
    case Removing
    case Commit
}

public class SIFloatingNode: SKShapeNode {
    private(set) var previousState: SIFloatingNodeState = .Normal
    private var _state: SIFloatingNodeState = .Normal
    public var state: SIFloatingNodeState {
        get {
            return _state
        }
        set {
            if _state != newValue {
                previousState = _state
                _state = newValue
                stateChaged()
            }
        }
    }
    
    public static let removingKey = "action.removing"
    public static let selectingKey = "action.selecting"
    public static let normalizeKey = "action.normalize"
    public static let commitKey    = "action.commit"
    
    private func stateChaged() {
        var action: SKAction?
        var actionKey: String?
        
        switch state {
        case .Normal:
            action = normalizeAnimation()
            actionKey = SIFloatingNode.normalizeKey
        case .Selected:
            action = selectingAnimation()
            actionKey = SIFloatingNode.selectingKey
        case .Removing:
            action = removingAnimation()
            actionKey = SIFloatingNode.removingKey
        case .Commit:
            action = commitAnimation()
            actionKey = SIFloatingNode.commitKey
        }
        
        if let a = action, let ak = actionKey {
            run(a, withKey: ak)
        }
    }
    
    override public func removeFromParent() {
        if let action = removeAnimation() {
            run(action, completion: { () -> Void in
                super.removeFromParent()
            })
        } else {
            super.removeFromParent()
        }
    }
    
    // MARK: -
    // MARK: Animations
    public func selectingAnimation() -> SKAction? {return nil}
    public func normalizeAnimation() -> SKAction? {return nil}
    public func removeAnimation() -> SKAction? {return nil}
    public func removingAnimation() -> SKAction? {return nil}
    public func commitAnimation() -> SKAction? {return nil}
}
