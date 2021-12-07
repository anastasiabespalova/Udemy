//
//  CalculatorBrain.swift
//  BMI Calculator
//
//  Created by Анастасия Беспалова on 03.10.2021.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit

struct CalculatorBrain {
    
    var bmi: BMI?
    
    mutating func calculateBMI(height: Float, weight: Float)  {
        let bmiValue = weight / pow(height, 2)
        if bmiValue < 18.5 {
            bmi = BMI(value: bmiValue, advice: "Eat more pies!", color: .blue)
        } else if bmiValue < 24.9 {
            bmi = BMI(value: bmiValue, advice: "Fir as a fiddle!", color: .green)
        } else {
            bmi = BMI(value: bmiValue, advice: "Eat less pies!", color: .systemPink)
        }
        
        
    }
   
    func getBMIValue() -> String {
        
        return String(format: "%.1f", bmi?.value ?? 0)
    }
    
    func getAdvice() -> String {
        return bmi?.advice ?? "Eat more pies"
    }
    
    func getColor() -> UIColor {
        return bmi?.color ?? .blue
    }
    
    
}
