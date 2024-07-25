//
//  DateValueFormatter.swift
//  CoinsApp
//
//  Created by Nguyễn Duy Linh on 22/7/24.
//

import Foundation
import Charts

class DateValueFormatter: IndexAxisValueFormatter {
    private let dateFormatter: DateFormatter

    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        super.init()
    }

    override func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
    }
}

