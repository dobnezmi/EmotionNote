//
//  DailyChartViewController.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/08/11.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit

class DailyChartViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.registerNib(ChartCollectionViewCell.nib(),
                                   forCellWithReuseIdentifier: ChartCollectionViewCell.DailyChartCellID)
        collectionView.registerNib(ChartCollectionViewCell.nib(),
                                   forCellWithReuseIdentifier: ChartCollectionViewCell.HourlyChartCellID)
        collectionView.registerNib(ChartCollectionViewCell.nib(),
                                   forCellWithReuseIdentifier: ChartCollectionViewCell.PeriodicChartCellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: ChartCollectionViewCell!
        switch(indexPath.item) {
        case 0:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(ChartCollectionViewCell.DailyChartCellID, forIndexPath: indexPath) as! ChartCollectionViewCell
            cell.showDailyEmotionalChart()
        case 1:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(ChartCollectionViewCell.HourlyChartCellID, forIndexPath: indexPath) as! ChartCollectionViewCell
            cell.showHourlyEmoteChart()
        default:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(ChartCollectionViewCell.PeriodicChartCellID, forIndexPath: indexPath) as! ChartCollectionViewCell
            cell.showPeriodicEmotionChart()
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = UIScreen.mainScreen().bounds.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    // MARK:UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / collectionView.frame.width
        pageControl.currentPage = Int(ceil(page))
    }
}
