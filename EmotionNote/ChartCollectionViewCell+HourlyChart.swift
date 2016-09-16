//
//  ChartCollectionViewCell+HourlyChart.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/03.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit

extension ChartCollectionViewCell {
    // TODO: 時間帯ごとの感情集計グラフ描画
    func showHourlyEmoteChart() {
        if captionLabel1st != nil {
            return
        }
        
        captionLabel1st = UILabel()
        createCaptionLabel(captionLabel1st, caption: "嬉しい時間帯", offsetY: 44)
        var posY = captionLabel1st.frame.origin.y + captionLabel1st.frame.height + 8
        hourlyBarChartHappy = BarChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createHourlyBarChart(hourlyBarChartHappy, emotion: .Happy)
        
        posY = hourlyBarChartHappy.frame.origin.y + hourlyBarChartHappy.frame.height + 16
        captionLabel2nd = UILabel()
        createCaptionLabel(captionLabel2nd, caption: "楽しい時間帯", offsetY: posY)
        posY = captionLabel2nd.frame.origin.y + captionLabel2nd.frame.height + 8
        hourlyBarChartEnjoy = BarChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createHourlyBarChart(hourlyBarChartEnjoy, emotion: .Enjoy)
        
        posY = hourlyBarChartEnjoy.frame.origin.y + hourlyBarChartEnjoy.frame.height + 16
        captionLabel3rd = UILabel()
        createCaptionLabel(captionLabel3rd, caption: "悲しい時間帯", offsetY: posY)
        posY = captionLabel3rd.frame.origin.y + captionLabel3rd.frame.height + 8
        hourlyBarChartSad = BarChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createHourlyBarChart(hourlyBarChartSad, emotion: .Sad)
        
        posY = hourlyBarChartSad.frame.origin.y + hourlyBarChartSad.frame.height + 16
        captionLabel4th = UILabel()
        createCaptionLabel(captionLabel4th, caption: "イライラする時間帯", offsetY: posY)
        posY = captionLabel4th.frame.origin.y + captionLabel4th.frame.height + 8
        hourlyBarChartFrust = BarChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createHourlyBarChart(hourlyBarChartFrust, emotion: .Frustrated)
        
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: posY + 250 + 16 + 100)
    }
    
    func createHourlyBarChart(barChartView: BarChartView, emotion: Emotion) {
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartView.drawGridBackgroundEnabled = false
        barChartView.xAxis.drawLabelsEnabled = true
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.xAxis.gridColor = UIColor.whiteColor()
        barChartView.xAxis.gridLineWidth = 2
        barChartView.xAxis.labelFont = UIFont.boldSystemFontOfSize(10)
        barChartView.xAxis.labelTextColor = UIColor.whiteColor()
        barChartView.leftAxis.gridColor = UIColor.whiteColor()
        barChartView.leftAxis.gridLineWidth = 2
        barChartView.leftAxis.labelFont = UIFont.boldSystemFontOfSize(10)
        barChartView.leftAxis.labelTextColor = UIColor.whiteColor()
        barChartView.descriptionTextColor = UIColor.whiteColor()
        barChartView.descriptionFont = UIFont.boldSystemFontOfSize(10)
        barChartView.descriptionText = "(時)"
        
        let emotions: [EmotionCount] = EmotionDataStore.emotionsWithPeriodPerHours(.All)
        var emotionValues: [BarChartDataEntry] = []
        for i in 0..<24 {
            var entry: BarChartDataEntry!
            switch emotion {
            case .Happy:
                entry = BarChartDataEntry(x: Double(i), y: Double(emotions[i].happyCount))
            case .Enjoy:
                entry = BarChartDataEntry(x: Double(i), y: Double(emotions[i].enjoyCount))
            case .Sad:
                entry = BarChartDataEntry(x: Double(i), y: Double(emotions[i].sadCount))
            case .Frustrated:
                entry = BarChartDataEntry(x: Double(i), y: Double(emotions[i].frustCount))
            }
            emotionValues.append(entry)
        }
        
        
        let chartData = BarChartData()
        let dataSet = BarChartDataSet(values: emotionValues, label: "時間帯別「\(emotion.toString())」")
        //dataSet.colors = ChartColorTemplates.material()
        dataSet.colors = [NSUIColor.darkGrayColor()]
        chartData.addDataSet(dataSet)
        
        barChartView.data = chartData
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        scrollView.addSubview(barChartView)
    }
}