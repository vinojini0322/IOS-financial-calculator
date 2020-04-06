//
//  Double.swift
//  FinancialCalculatorCW1
//
//  Created by Devon Wijesinghe on 3/9/20.
//  Copyright © 2020 Devon Wijesinghe. All rights reserved.
//
import Foundation

extension Double {
    func toFixed(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (divisor*self).rounded() / divisor
    }
}
