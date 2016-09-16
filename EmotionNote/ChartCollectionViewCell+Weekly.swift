//
//  ChartCollectionViewCell+Weekly.swift
//  EmotionNote
//
//  Created by 鈴木 慎吾 on 2016/09/03.
//  Copyright © 2016年 dobnezmi. All rights reserved.
//

import UIKit

extension ChartCollectionViewCell {
    // TODO: 期間ごとの感情集計グラフ描画(円グラフ)
    
    func showPeriodicEmotionChart() {
        if captionLabel1st != nil {
            return
        }
        
        captionLabel1st = UILabel()
        createCaptionLabel(captionLabel1st, caption: "１周間の感情", offsetY: 44)
        var posY = captionLabel1st.frame.origin.y + captionLabel1st.frame.height + 8
        pieChartViewWeek = PieChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createPiechart(pieChartViewWeek, emotionCount: EmotionDataStore.emotionsWithPeriod(.Week))
        pieChartViewWeek.descriptionText = ""
        
        posY = pieChartViewWeek.frame.origin.y + pieChartViewWeek.frame.height + 16
        captionLabel2nd = UILabel()
        createCaptionLabel(captionLabel2nd, caption: "1ヶ月間の感情", offsetY: posY)
        posY = captionLabel2nd.frame.origin.y + captionLabel2nd.frame.height + 8
        pieChartViewMonth = PieChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createPiechart(pieChartViewMonth, emotionCount: EmotionDataStore.emotionsWithPeriod(.Month))
        pieChartViewMonth.descriptionText = ""
        
        posY = pieChartViewMonth.frame.origin.y + pieChartViewMonth.frame.height + 16
        captionLabel3rd = UILabel()
        createCaptionLabel(captionLabel3rd, caption: "全期間の感情", offsetY: posY)
        posY = captionLabel3rd.frame.origin.y + captionLabel3rd.frame.height + 8
        pieChartViewAll = PieChartView(frame:
            CGRect(x: leftMargin, y: posY, width: self.frame.width-rightMargin, height: 250))
        createPiechart(pieChartViewAll, emotionCount: EmotionDataStore.emotionsWithPeriod(.All))
        pieChartViewAll.descriptionText = ""
        
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: posY + 250 + 16 + 100)
    }
    
    func createPiechart(pieChart: PieChartView, emotionCount: EmotionCount) {
        let happyEntry = PieChartDataEntry(value: Double(emotionCount.happyCount), label: Emotion.Happy.toString())
        let enjoyEntry = PieChartDataEntry(value: Double(emotionCount.enjoyCount), label: Emotion.Enjoy.toString())
        let sadEntry   = PieChartDataEntry(value: Double(emotionCount.sadCount), label: Emotion.Sad.toString())
        let frustEntry = PieChartDataEntry(value: Double(emotionCount.frustCount), label: Emotion.Frustrated.toString())
        
        let dataSet = PieChartDataSet(values: [happyEntry, enjoyEntry, sadEntry, frustEntry], label: nil)
        dataSet.sliceSpace = 2.0
        dataSet.colors = ChartColorTemplates.material()
        
        let chartData = PieChartData(dataSet: dataSet)
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .NoStyle
        chartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
        pieChart.data = chartData
        pieChart.drawHoleEnabled = false
        pieChart.legend.horizontalAlignment = .Center
        scrollView.addSubview(pieChart)
        
    }
}
