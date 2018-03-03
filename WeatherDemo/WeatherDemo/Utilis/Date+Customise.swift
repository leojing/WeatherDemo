//
//  Date+Customise.swift
//  techchallenge_jingluo
//
//  Created by JINGLUO on 27/1/18.
//  Copyright © 2018 JINGLUO. All rights reserved.
//

import Foundation

extension Date {
    
    func timeOfHour() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
