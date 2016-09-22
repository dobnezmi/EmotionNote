//
//  ChartCollectionViewCell.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/08/20.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit
import RxSwift

class ChartCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let disposeBag = DisposeBag()
    
    // Cell ID
    static let DailyChartCellID = "DailyCell"
    static let HourlyChartCellID = "HourlyCell"
    static let PeriodicChartCellID = "PeriodicCell"

    // Presenter
    let mentalIndexPresenter: MentalIndexChartPresenter = Injector.container.resolve(MentalIndexChartPresenter.self)!
    let hourlyChartPresenter: HourlyChartPresenter = Injector.container.resolve(HourlyChartPresenter.self)!
    let statisticsPresenter: MentalStatisticsPresenter = Injector.container.resolve(MentalStatisticsPresenter.self)!
    
    // キャプションラベル
    var captionLabel1st: UILabel!
    var captionLabel2nd: UILabel!
    var captionLabel3rd: UILabel!
    var captionLabel4th: UILabel!
    
    // 1日ごとの感情データ
    var lineChartViewToday: LineChartView!
    var lineChartViewYesterday: LineChartView!
    var lineChartViewBefore: LineChartView!
    
    // 時間帯ごとの感情別データ
    var hourlyBarChartHappy: BarChartView!
    var hourlyBarChartEnjoy: BarChartView!
    var hourlyBarChartSad:   BarChartView!
    var hourlyBarChartFrust: BarChartView!
    
    // 感情統計
    var pieChartViewWeek: PieChartView!
    var pieChartViewMonth: PieChartView!
    var pieChartViewAll: PieChartView!
    
    let leftMargin: CGFloat = 10
    let rightMargin: CGFloat = 20
    
    let dataStore: EmotionDataStore = Injector.container.resolve(EmotionDataStore.self)!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func nib() -> UINib {
        return UINib(nibName: NSStringFromClass(self).components(separatedBy: ".").last!,
                     bundle: Bundle(for: self))
    }
}
