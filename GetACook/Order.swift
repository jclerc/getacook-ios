//
//  Order.swift
//  GetACook
//
//  Created by Jonathan on 08/06/2017.
//
//

import UIKit

class Order {
    
    var address: String
    var people: Int
    var date: Date
    var time: Int
    
    init(address: String, people: Int, date: Date, time: Int) {
        self.address = address
        self.people = people
        self.date = date
        self.time = time
    }
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self.date)
    }
    
}
