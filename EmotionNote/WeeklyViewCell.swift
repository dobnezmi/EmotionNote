//
//  WeeklyViewCell.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/29.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit
import RxSwift

class WeeklyViewCell: ChartViewCell {
    @IBOutlet weak var scrollView: UIScrollView!
    
    let disposeBag = DisposeBag()
    
    // Cell ID
    static let WeeklyChartCellID = "WeeklyCell"
    
    // Presenter
    let weeklyPresenter: WeeklyChartPresenter = Injector.container.resolve(WeeklyChartPresenter.self)!
    
    // キャプションラベル
    var captionLabels: [UILabel] = []
    
    // 感情統計
    var pieChartViews: [PieChartView] = []
    
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
    
    func showWeeklyEmotionChart() {
        if captionLabels.count > 0 {
            return
        }
        
        weeklyPresenter.rx_weeklyEmotion.asObservable().subscribe(onNext: { [weak self] emotionCount in
            self?.createCharts(emotionCount: emotionCount)
        }).addDisposableTo(disposeBag)
        
    }
    
    func createPiechart(pieChart: PieChartView?, emotionCount: EmotionCount) {
        guard emotionCount.sumAllEmotions() > 0 else {
            if let pieChart = pieChart {
                emptyLabel(baseView: scrollView, rect: pieChart.frame)
            }
            return
        }
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
    
    private func createCharts(emotionCount: [EmotionCount]) {

        var posY: CGFloat = 44.0
        for i in 0 ..< SSWeekday.weekdayCount() {
            captionLabels.append(UILabel())
            createCaptionLabel(baseView: scrollView,
                               targetLabel: captionLabels[i],
                               caption: "\(SSWeekday(rawValue: i)!.toString())の感情",
                               offsetY: posY)
            
            posY = captionLabels[i].frame.origin.y + captionLabels[i].frame.height + 8
            pieChartViews.append(PieChartView(frame:
                CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250)))
            pieChartViews[i].descriptionText = ""
            createPiechart(pieChart: pieChartViews[i], emotionCount: emotionCount[i])
            
            posY = pieChartViews[i].frame.origin.y + pieChartViews[i].frame.height + 16
        }
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: posY + 250 + 16 + 100)

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
