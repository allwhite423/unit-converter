//
//  main.swift
//  UnitConverter2
//
//  Created by Daheen Lee on 04/04/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

struct UnitConverter {
    var base : Dictionary = [String : Double]()
    var defaultDestinationUnit: Dictionary = [String: String]()
    
    init(_ base: [String:Double], _ defaultDestinationUnit: [String: String]) {
        self.base = base
        self.defaultDestinationUnit = defaultDestinationUnit
    }
    
    func contains(_ unit: String) -> Bool {
        return base.keys.contains(unit)
    }
}

let lengthConverter = UnitConverter(["cm": 1.0, "m": 100.0, "inch" : 2.54, "yard": 91.44], ["cm": "m", "m": "cm", "inch" : "cm", "yard": "m"])
let weightConverter = UnitConverter(["g": 1.0, "kg": 1000.0, "lb" : 453.592, "oz": 28.3495], ["g": "kg", "kg": "g", "lb" : "g", "oz": "g"])
let volumeConverter = UnitConverter(["L": 1.0, "pt": 0.473176, "qt": 0.946353, "gal": 3.78541], ["L": "pt", "pt": "L", "qt" : "L", "gal": "L"])

/**
 Main function - takes user input, exit when input is 'quit'
 */
func executeUnitConverter() {
    while let inputValue = readLine(), !inputValue.contains("quit") {
        selectUnitAndConvert(from: inputValue)
    }
}

/**
Set UnitConverter instance based on user input and convert with it

 - parameters:
    -  userInput : string taken from user
 */

func selectUnitAndConvert(from userInput: String) {
    var dividedInput = seperateSourceAndDestination(from: userInput)
    
    let sourceUnit = dividedInput.sourceUnit
    
    var unitConverter: UnitConverter
    
    if lengthConverter.contains(sourceUnit) {
        unitConverter = lengthConverter
    } else if weightConverter.contains(sourceUnit) {
        unitConverter = weightConverter
    } else if volumeConverter.contains(sourceUnit) {
        unitConverter = volumeConverter
    } else {
        printNonSupportMessage()
        return
    }
   
    convert(dividedInput, using: unitConverter)
}

/**
 Seperate soure and destination by space
 
 - returns:
 a tuple with source number, source unit, and destinaion unit
 - parameters:
 - input : string taken from user
 */
func seperateSourceAndDestination(from input: String) -> (sourceNum: Double, sourceUnit: String, destinationUnit: String?){
    var trimmedInput = input.trimmingCharacters(in: .whitespaces)
    var destinationUnit: String? = nil
    
    if trimmedInput.contains(" ") {
        let dividedInput = trimmedInput.components(separatedBy: " ")
        trimmedInput = dividedInput[0]
        destinationUnit = dividedInput[1]
    }
    
    let (num, sourceUnit) = divideNumAndUnit(from: trimmedInput)
    
    return (num, sourceUnit, destinationUnit)
}

/**
 Divide single string input into number and unit
 
 - returns:
 a tuple with source number, source unit
 - parameters:
 - combinedString : string with no space, number and unit
 */
func divideNumAndUnit(from combinedString: String) -> (num: Double, fromUnit: String) {
    let alphanumerics = CharacterSet.letters
    var num = String()
    var fromUnit = String()
    
    for char in combinedString.unicodeScalars {
        if alphanumerics.contains(char){
            fromUnit.append("\(char)")
        } else {
            num.append("\(char)")
        }
    }
    
    return (Double(num) ?? 0, fromUnit)
}

/**
 print non support unit message
 
 */
func printNonSupportMessage() {
    print("지원하지 않는 단위입니다.")
}

/**
 convert number and print it
 
 - parameters:
 - dividedInput : tuple with number, source and destination unit
 */
func convert(_ dividedInput: (sourceNum: Double, sourceUnit: String, destinationUnit: String?), using converter: UnitConverter ) {
    let finalDestinationUnit = decideDestinationUnit(from: dividedInput, basedOn: converter.defaultDestinationUnit)
    
    guard converter.contains(finalDestinationUnit) else {
        printNonSupportMessage()
        return
    }
    let toRelative = converter.base[dividedInput.sourceUnit]
    let fromRelative = converter.base[finalDestinationUnit]
    
    let result = dividedInput.sourceNum * toRelative! / fromRelative!
    print("\(result)\(finalDestinationUnit)")
}

/**
 return default destinaion unit if user input doesn't have destination unit
 
 - returns:
 destination unit according to source unit
 - parameters:
 - dividedInput : tuple with number, source and destination unit
 */
func decideDestinationUnit(from dividedInput: (sourceNum: Double, sourceUnit: String, destinationUnit: String?), basedOn defaultDestination: [String: String]) -> String {
    if dividedInput.destinationUnit == nil {
        return defaultDestination[dividedInput.sourceUnit]!
    } else {
        return dividedInput.destinationUnit!
    }
}

executeUnitConverter()

