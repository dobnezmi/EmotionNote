//
//  ChartViewCell.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/28.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit

class ChartViewCell: UICollectionViewCell {
    func createCaptionLabel(baseView: UIView, targetLabel: UILabel, caption: String, offsetY: CGFloat) {
        targetLabel.text = caption
        targetLabel.font = UIFont.boldSystemFont(ofSize: 17) // TODO: 変更する
        targetLabel.textColor = UIColor.white
        targetLabel.textAlignment = .center
        targetLabel.frame = CGRect(x: 0, y: offsetY, width: self.frame.width, height: 40)
        baseView.addSubview(targetLabel)
    }
    
    func emptyLabel(baseView: UIView, rect: CGRect) {
        let label = UILabel(frame: rect)
        label.text = "データなし"
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        
        baseView.addSubview(label)
    }
}
