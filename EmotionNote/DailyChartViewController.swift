//
//  DailyChartViewController.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/08/11.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit
import RxSwift

class DailyChartViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var closeButton: UIButton!
    
    let disposeBag = DisposeBag()
    var router: DailyChartViewRouter!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(ChartCollectionViewCell.nib(),
                                   forCellWithReuseIdentifier: ChartCollectionViewCell.DailyChartCellID)
        collectionView.register(ChartCollectionViewCell.nib(),
                                   forCellWithReuseIdentifier: ChartCollectionViewCell.HourlyChartCellID)
        collectionView.register(ChartCollectionViewCell.nib(),
                                   forCellWithReuseIdentifier: ChartCollectionViewCell.PeriodicChartCellID)
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ChartCollectionViewCell!
        switch(indexPath.item) {
        case 0:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.DailyChartCellID, for: indexPath as IndexPath) as! ChartCollectionViewCell
            cell.showMentalIndexChart()
        case 1:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.HourlyChartCellID, for: indexPath as IndexPath) as! ChartCollectionViewCell
            cell.showHourlyEmoteChart()
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.PeriodicChartCellID, for: indexPath as IndexPath) as! ChartCollectionViewCell
            cell.showPeriodicEmotionChart()
        }
        
        return cell
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
}
