//
//  ChartCollectionViewCell+MentalIndexChart.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/03.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit
import RxSwift

extension ChartCollectionViewCell {
    
    func showMentalIndexChart() {
        if captionLabel1st != nil {
            return
        }
        
        captionLabel1st = UILabel()
        createCaptionLabel(targetLabel: captionLabel1st, caption: "今日の感情", offsetY: 44)
        var posY = captionLabel1st.frame.origin.y + captionLabel1st.frame.height + 8
        lineChartViewToday = LineChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createLineChart(lineChartView: lineChartViewToday, emotionVariable: mentalIndexPresenter.rx_todayEmotions)
        
        posY = lineChartViewToday.frame.origin.y + lineChartViewToday.frame.height + 16
        captionLabel2nd = UILabel()
        createCaptionLabel(targetLabel: captionLabel2nd, caption: "昨日の感情", offsetY: posY)
        posY = captionLabel2nd.frame.origin.y + captionLabel2nd.frame.height + 8
        lineChartViewYesterday = LineChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createLineChart(lineChartView: lineChartViewYesterday, emotionVariable: mentalIndexPresenter.rx_yesterdayEmotins)
        
        posY = lineChartViewYesterday.frame.origin.y + lineChartViewYesterday.frame.height + 16
        captionLabel3rd = UILabel()
        createCaptionLabel(targetLabel: captionLabel3rd, caption: "一昨日の感情", offsetY: posY)
        posY = captionLabel3rd.frame.origin.y + captionLabel3rd.frame.height + 8
        lineChartViewBefore = LineChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createLineChart(lineChartView: lineChartViewBefore, emotionVariable: mentalIndexPresenter.rx_oldEmotions)
        
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: posY + 250 + 16 + 100)
    }
    
    func createCaptionLabel(targetLabel: UILabel, caption: String, offsetY: CGFloat) {
        targetLabel.text = caption
        targetLabel.font = UIFont.boldSystemFont(ofSize: 17) // TODO: 変更する
        targetLabel.textColor = UIColor.white
        targetLabel.textAlignment = .center
        targetLabel.frame = CGRect(x: 0, y: offsetY, width: self.frame.width, height: 40)
        scrollView.addSubview(targetLabel)
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
