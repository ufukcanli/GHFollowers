//
//  Date+Extension.swift
//  GHFollowers
//
//  Created by Ufuk Canlı on 8.10.2020.
//  Copyright © 2020 Ufuk Canlı. All rights reserved.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
}
