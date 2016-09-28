//
//  StatisticViewCell.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/28.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit
import RxSwift

class StatisticViewCell: ChartViewCell {
    @IBOutlet weak var scrollView: UIScrollView!
    
    let disposeBag = DisposeBag()
    
    // Cell ID
    static let StatisticChartCellID = "StatisticCell"
    
    // Presenter
    let statisticsPresenter: MentalStatisticsPresenter = Injector.container.resolve(MentalStatisticsPresenter.self)!
    
    // キャプションラベル
    var captionLabel1st: UILabel!
    var captionLabel2nd: UILabel!
    var captionLabel3rd: UILabel!
    var captionLabel4th: UILabel!
    
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

    func showPeriodicEmotionChart() {
        if captionLabel1st != nil {
            return
        }
        
        captionLabel1st = UILabel()
        createCaptionLabel(baseView: scrollView, targetLabel: captionLabel1st, caption: "１周間の感情", offsetY: 44)
        var posY = captionLabel1st.frame.origin.y + captionLabel1st.frame.height + 8
        pieChartViewWeek = PieChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        statisticsPresenter.rx_weeklyEmotion.asObservable().subscribe(onNext: { [weak self] emotionCount in
            if let count = emotionCount {
                self?.createPiechart(pieChart: self?.pieChartViewWeek, emotionCount: count)
            }
            }).addDisposableTo(disposeBag)
        pieChartViewWeek.descriptionText = ""
        
        posY = pieChartViewWeek.frame.origin.y + pieChartViewWeek.frame.height + 16
        captionLabel2nd = UILabel()
        createCaptionLabel(baseView: scrollView, targetLabel: captionLabel2nd, caption: "1ヶ月間の感情", offsetY: posY)
        posY = captionLabel2nd.frame.origin.y + captionLabel2nd.frame.height + 8
        pieChartViewMonth = PieChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        statisticsPresenter.rx_monthlyEmotion.asObservable().subscribe(onNext: { [weak self] emotionCount in
            if let count = emotionCount {
                self?.createPiechart(pieChart: self?.pieChartViewMonth, emotionCount: count)
            }
            }).addDisposableTo(disposeBag)
        pieChartViewMonth.descriptionText = ""
        
        posY = pieChartViewMonth.frame.origin.y + pieChartViewMonth.frame.height + 16
        captionLabel3rd = UILabel()
        createCaptionLabel(baseView: scrollView, targetLabel: captionLabel3rd, caption: "全期間の感情", offsetY: posY)
        posY = captionLabel3rd.frame.origin.y + captionLabel3rd.frame.height + 8
        pieChartViewAll = PieChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        statisticsPresenter.rx_entireEmotion.asObservable().subscribe(onNext: { [weak self] emotionCount in
            if let count = emotionCount {
                self?.createPiechart(pieChart: self?.pieChartViewAll, emotionCount: count)
            }
            }).addDisposableTo(disposeBag)
        pieChartViewAll.descriptionText = ""
        
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: posY + 250 + 16 + 100)
    }
    
    func createPiechart(pieChart: PieChartView?, emotionCount: EmotionCount) {
        let happyEntry = PieChartDataEntry(value: Double(emotionCount.happyCount), label: Emotion.Happy.toString())
        let enjoyEntry = PieChartDataEntry(value: Double(emotionCount.enjoyCount), label: Emotion.Enjoy.toString())
        let sadEntry   = PieChartDataEntry(value: Double(emotionCount.sadCount), label: Emotion.Sad.toString())
        let frustEntry = PieChartDataEntry(value: Double(emotionCount.frustCount), label: Emotion.Frustrated.toString())
        
        let values = datasetValues(entries: [happyEntry, enjoyEntry, sadEntry, frustEntry])
        let dataSet = PieChartDataSet(values: values, label: nil)
        dataSet.sliceSpace = 2.0
        dataSet.colors = ChartColorTemplates.material()
        
        let chartData = PieChartData(dataSet: dataSet)
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        chartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
        if let pieChart = pieChart {
            pieChart.data = chartData
            pieChart.drawHoleEnabled = false
            pieChart.legend.horizontalAlignment = .center
            scrollView.addSubview(pieChart)
        }
    }
    
    private func datasetValues(entries: [PieChartDataEntry]) -> [PieChartDataEntry] {
        var values: [PieChartDataEntry] = []
        for entry in entries {
            if entry.value > 0 {
                values.append(entry)
            }
        }
        return values
    }
    
}
