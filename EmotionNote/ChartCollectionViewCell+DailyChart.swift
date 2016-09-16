//
//  ChartCollectionViewCell+DailyChart.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/03.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit

extension ChartCollectionViewCell {
    
    func showDailyEmotionalChart() {
        if captionLabel1st != nil {
            return
        }
        
        captionLabel1st = UILabel()
        createCaptionLabel(captionLabel1st, caption: "今日の感情", offsetY: 44)
        var posY = captionLabel1st.frame.origin.y + captionLabel1st.frame.height + 8
        lineChartViewToday = LineChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createLineChart(lineChartViewToday, emoteAt: NSDate())
        
        posY = lineChartViewToday.frame.origin.y + lineChartViewToday.frame.height + 16
        captionLabel2nd = UILabel()
        createCaptionLabel(captionLabel2nd, caption: "昨日の感情", offsetY: posY)
        posY = captionLabel2nd.frame.origin.y + captionLabel2nd.frame.height + 8
        lineChartViewYesterday = LineChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createLineChart(lineChartViewYesterday, emoteAt: NSDate().add(days: -1))
        
        posY = lineChartViewYesterday.frame.origin.y + lineChartViewYesterday.frame.height + 16
        captionLabel3rd = UILabel()
        createCaptionLabel(captionLabel3rd, caption: "一昨日の感情", offsetY: posY)
        posY = captionLabel3rd.frame.origin.y + captionLabel3rd.frame.height + 8
        lineChartViewBefore = LineChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createLineChart(lineChartViewBefore, emoteAt: NSDate().add(days: -2))
        
        // TODO: ↓ この計算、最後の１００が意味不明。でも無いと全て表示しきれない。時間があるときに。。
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: posY + 250 + 16 + 100)
    }
    
    func createCaptionLabel(targetLabel: UILabel, caption: String, offsetY: CGFloat) {
        targetLabel.text = caption
        targetLabel.font = UIFont.boldSystemFontOfSize(17) // TODO: 変更する
        targetLabel.textColor = UIColor.whiteColor()
        targetLabel.textAlignment = .Center
        targetLabel.frame = CGRect(x: 0, y: offsetY, width: self.frame.width, height: 40)
        scrollView.addSubview(targetLabel)
    }
    
    func createLineChart(lineChartView: LineChartView, emoteAt: NSDate) {
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.xAxis.drawLabelsEnabled = true
        lineChartView.xAxis.labelPosition = .Bottom
        lineChartView.xAxis.gridColor = UIColor.whiteColor()
        lineChartView.xAxis.gridLineWidth = 2
        lineChartView.xAxis.labelFont = UIFont.boldSystemFontOfSize(10)
        lineChartView.xAxis.labelTextColor = UIColor.whiteColor()
        lineChartView.leftAxis.gridColor = UIColor.whiteColor()
        lineChartView.leftAxis.gridLineWidth = 2
        lineChartView.leftAxis.labelFont = UIFont.boldSystemFontOfSize(10)
        lineChartView.leftAxis.labelTextColor = UIColor.whiteColor()
        lineChartView.descriptionTextColor = UIColor.whiteColor()
        lineChartView.descriptionFont = UIFont.boldSystemFontOfSize(10)
        lineChartView.descriptionText = "(時)"
        
        var emotionValues: [ChartDataEntry] = []
        for i in 0..<24 {
            emotionValues.append(ChartDataEntry(x: Double(i), y: 0))
        }
        
        let emotions = EmotionDataStore.emotionsWithDate(emoteAt)
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
        scrollView.addSubview(lineChartView)
    }
}
