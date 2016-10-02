//
//  HourlyChartViewCell.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/09/28.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit
import RxSwift

class HourlyChartViewCell: ChartViewCell {
    @IBOutlet weak var scrollView: UIScrollView!
    
    let disposeBag = DisposeBag()
    
    // Cell ID
    static let HourlyChartCellID = "HourlyCell"
    
    // Presenter
    let hourlyChartPresenter: HourlyChartPresenter = Injector.container.resolve(HourlyChartPresenter.self)!
    
    // キャプションラベル
    var captionLabel1st: UILabel!
    var captionLabel2nd: UILabel!
    var captionLabel3rd: UILabel!
    var captionLabel4th: UILabel!
    
    // 時間帯ごとの感情別データ
    var hourlyBarChartHappy: BarChartView!
    var hourlyBarChartEnjoy: BarChartView!
    var hourlyBarChartSad:   BarChartView!
    var hourlyBarChartFrust: BarChartView!

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
    
    func showHourlyEmoteChart() {
        if captionLabel1st != nil {
            return
        }
        
        captionLabel1st = UILabel()
        createCaptionLabel(baseView: scrollView, targetLabel: captionLabel1st, caption: "嬉しい時間帯", offsetY: 44)
        var posY = captionLabel1st.frame.origin.y + captionLabel1st.frame.height + 8
        hourlyBarChartHappy = BarChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createHourlyBarChart(barChartView: hourlyBarChartHappy,
                             emotion: .Happy,
                             emotionCount: hourlyChartPresenter.rx_happyEmotion)
        
        posY = hourlyBarChartHappy.frame.origin.y + hourlyBarChartHappy.frame.height + 16
        captionLabel2nd = UILabel()
        createCaptionLabel(baseView: scrollView, targetLabel: captionLabel2nd, caption: "楽しい時間帯", offsetY: posY)
        posY = captionLabel2nd.frame.origin.y + captionLabel2nd.frame.height + 8
        hourlyBarChartEnjoy = BarChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createHourlyBarChart(barChartView: hourlyBarChartEnjoy,
                             emotion: .Enjoy,
                             emotionCount: hourlyChartPresenter.rx_enjoyEmotin)
        
        posY = hourlyBarChartEnjoy.frame.origin.y + hourlyBarChartEnjoy.frame.height + 16
        captionLabel3rd = UILabel()
        createCaptionLabel(baseView: scrollView, targetLabel: captionLabel3rd, caption: "悲しい時間帯", offsetY: posY)
        posY = captionLabel3rd.frame.origin.y + captionLabel3rd.frame.height + 8
        hourlyBarChartSad = BarChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createHourlyBarChart(barChartView: hourlyBarChartSad,
                             emotion: .Sad,
                             emotionCount: hourlyChartPresenter.rx_sadEmotion)
        
        posY = hourlyBarChartSad.frame.origin.y + hourlyBarChartSad.frame.height + 16
        captionLabel4th = UILabel()
        createCaptionLabel(baseView: scrollView, targetLabel: captionLabel4th, caption: "イライラする時間帯", offsetY: posY)
        posY = captionLabel4th.frame.origin.y + captionLabel4th.frame.height + 8
        hourlyBarChartFrust = BarChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createHourlyBarChart(barChartView: hourlyBarChartFrust,
                             emotion: .Frustrated,
                             emotionCount: hourlyChartPresenter.rx_frustEmotion)
        
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: posY + 250 + 16 + 100)
    }
    
    func createHourlyBarChart(barChartView: BarChartView, emotion: Emotion, emotionCount: Variable<[Int]>) {
        barChartView.rightAxis.drawLabelsEnabled = false
        //        barChartView.drawGridBackgroundEnabled = true
        barChartView.xAxis.drawLabelsEnabled = true
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.gridColor = UIColor.white
        barChartView.xAxis.gridLineWidth = 2
        barChartView.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        barChartView.xAxis.labelTextColor = UIColor.white
        barChartView.leftAxis.gridColor = UIColor.white
        barChartView.leftAxis.gridLineWidth = 2
        barChartView.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        barChartView.leftAxis.labelTextColor = UIColor.white
        barChartView.descriptionTextColor = UIColor.white
        barChartView.descriptionFont = UIFont.boldSystemFont(ofSize: 10)
        barChartView.descriptionText = "(時)"
        
        emotionCount.asObservable().subscribe(onNext: { hourlyCounts in
            var emotionValues: [BarChartDataEntry] = []
            var i: Double = 0.0
            for count in hourlyCounts {
                emotionValues.append(BarChartDataEntry(x: i, y: Double(count)))
                i += 1.0
            }
            
            let chartData = BarChartData()
            let dataSet = BarChartDataSet(values: emotionValues, label: "時間帯別「\(emotion.toString())」")
            dataSet.colors = [NSUIColor(red: 245/255.0, green: 199/255.0, blue: 0/255.0, alpha: 1.0)]
            dataSet.drawValuesEnabled = false
            chartData.addDataSet(dataSet)
            
            barChartView.data = chartData
            barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
            
        }).addDisposableTo(disposeBag)
        scrollView.addSubview(barChartView)
        
    }
}
