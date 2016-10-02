//
//  DailyChartViewController.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/08/11.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit
import RxSwift

class DailyChartViewController: UIViewController,
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout,
                                UIViewControllerTransitioningDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var closeButton: UIButton!
    
    let transitionAnimator = FadeTransition()
    let disposeBag = DisposeBag()
    var router: DailyChartViewRouter!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(ChartCollectionViewCell.nib(),
                                   forCellWithReuseIdentifier: ChartCollectionViewCell.DailyChartCellID)
        collectionView.register(HourlyChartViewCell.nib(),
                                   forCellWithReuseIdentifier: HourlyChartViewCell.HourlyChartCellID)
        collectionView.register(StatisticViewCell.nib(),
                                   forCellWithReuseIdentifier: StatisticViewCell.StatisticChartCellID)
        collectionView.register(WeeklyViewCell.nib(),
                                    forCellWithReuseIdentifier: WeeklyViewCell.WeeklyChartCellID)
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.router.closeAction(viewController: self)
        }).addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch(indexPath.item) {
        case 0:
            let cell: StatisticViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticViewCell.StatisticChartCellID, for: indexPath as IndexPath) as! StatisticViewCell
            cell.showPeriodicEmotionChart()
            return cell
        case 1:
            let cell: ChartCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.DailyChartCellID, for: indexPath as IndexPath) as! ChartCollectionViewCell
            cell.showMentalIndexChart()
            return cell
        case 2:
            let cell: HourlyChartViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyChartViewCell.HourlyChartCellID, for: indexPath as IndexPath) as! HourlyChartViewCell
            cell.showHourlyEmoteChart()
            return cell
        default:
            let cell: WeeklyViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyViewCell.WeeklyChartCellID, for: indexPath as IndexPath) as! WeeklyViewCell
            cell.showWeeklyEmotionChart()
            return cell
        }
        
        
    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK:UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / collectionView.frame.width
        pageControl.currentPage = Int(ceil(page))
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimator
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimator
    }
}
