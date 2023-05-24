//
//  SuffixWrapper.swift
//  FoodPicker
//
//  Created by Yu ZHANG on 2023/5/23.
//

@propertyWrapper struct Suffix: Equatable {
    var wrappedValue: Double
    private let suffix: String
    
    init(wrappedValue: Double, _ suffix: String) {
        self.wrappedValue = wrappedValue
        self.suffix = suffix
    }

    var projectedValue: String {
        wrappedValue.formatted() + " \(suffix)"
    }
}
