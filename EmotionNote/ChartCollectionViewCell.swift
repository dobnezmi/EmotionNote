//
//  ChartCollectionViewCell.swift
//  EmotionNote
//
//  Created by Shingo Suzuki on 2016/08/20.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit
import RxSwift

class ChartCollectionViewCell: ChartViewCell {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let disposeBag = DisposeBag()
    
    // Cell ID
    static let DailyChartCellID = "DailyCell"

    // Presenter
    let mentalIndexPresenter: MentalIndexChartPresenter = Injector.container.resolve(MentalIndexChartPresenter.self)!
    
    // キャプションラベル
    var captionLabel1st: UILabel!
    var captionLabel2nd: UILabel!
    var captionLabel3rd: UILabel!
    var captionLabel4th: UILabel!
    
    // 1日ごとの感情データ
    var lineChartViewToday: LineChartView!
    var lineChartViewYesterday: LineChartView!
    var lineChartViewBefore: LineChartView!
    
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
    
    func showMentalIndexChart() {
        if captionLabel1st != nil {
            return
        }
        
        captionLabel1st = UILabel()
        createCaptionLabel(baseView: scrollView, targetLabel: captionLabel1st, caption: "今日の感情", offsetY: 44)
        var posY = captionLabel1st.frame.origin.y + captionLabel1st.frame.height + 8
        lineChartViewToday = LineChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createLineChart(lineChartView: lineChartViewToday, emotionVariable: mentalIndexPresenter.rx_todayEmotions)
        
        posY = lineChartViewToday.frame.origin.y + lineChartViewToday.frame.height + 16
        captionLabel2nd = UILabel()
        createCaptionLabel(baseView: scrollView, targetLabel: captionLabel2nd, caption: "昨日の感情", offsetY: posY)
        posY = captionLabel2nd.frame.origin.y + captionLabel2nd.frame.height + 8
        lineChartViewYesterday = LineChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createLineChart(lineChartView: lineChartViewYesterday, emotionVariable: mentalIndexPresenter.rx_yesterdayEmotins)
        
        posY = lineChartViewYesterday.frame.origin.y + lineChartViewYesterday.frame.height + 16
        captionLabel3rd = UILabel()
        createCaptionLabel(baseView: scrollView, targetLabel: captionLabel3rd, caption: "一昨日の感情", offsetY: posY)
        posY = captionLabel3rd.frame.origin.y + captionLabel3rd.frame.height + 8
        lineChartViewBefore = LineChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createLineChart(lineChartView: lineChartViewBefore, emotionVariable: mentalIndexPresenter.rx_oldEmotions)
        
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: posY + 250 + 16 + 100)
    }
    
    func createLineChart(lineChartView: LineChartView, emotionVariable: Variable<[EmotionEntity]>) {
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.xAxis.drawLabelsEnabled = true
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.gridColor = UIColor.white
        lineChartView.xAxis.gridLineWidth = 2
        lineChartView.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        lineChartView.xAxis.labelTextColor = UIColor.white
        lineChartView.leftAxis.gridColor = UIColor.white
        lineChartView.leftAxis.gridLineWidth = 2
        lineChartView.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 10)
        lineChartView.leftAxis.labelTextColor = UIColor.white
        lineChartView.descriptionTextColor = UIColor.white
        lineChartView.descriptionFont = UIFont.boldSystemFont(ofSize: 10)
        lineChartView.descriptionText = "(時)"
        
        var emotionValues: [ChartDataEntry] = []
        for i in 0..<24 {
            emotionValues.append(ChartDataEntry(x: Double(i), y: 0))
        }
        
        emotionVariable.asObservable().subscribe(onNext: { emotions in
            for emotion in emotions {
                switch emotion.emotion {
                case Emotion.Happy.rawValue:
                    emotionValues[emotion.hour].y += 1.0
                case Emotion.Enjoy.rawValue:
                    emotionValues[emotion.hour].y += 1.0
                case Emotion.Sad.rawValue:
                    emotionValues[emotion.hour].y -= 1.0
                case Emotion.Frustrated.rawValue:
                    emotionValues[emotion.hour].y -= 1.0
                default:
                    break
                }
            }
            
            let chartData = LineChartData()
            let dataSet  = LineChartDataSet(values: emotionValues, label: "感情の起伏")
            dataSet.colors = [NSUIColor(red: 0x21/0xff, green: 0x21/0xff, blue: 0x21/0xff, alpha: 1)]
            dataSet.drawCirclesEnabled = false
            dataSet.drawValuesEnabled = false
            dataSet.lineWidth = 4
            chartData.addDataSet(dataSet)
            lineChartView.data = chartData
            lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
            
        }).addDisposableTo(disposeBag)
        
        scrollView.addSubview(lineChartView)
    }
}
