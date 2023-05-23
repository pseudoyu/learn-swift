// create  a var
import Foundation

let decimal: Decimal = 1
let decimal2 = Decimal(2)

print(decimal + decimal2)

let decimal3 = Decimal(string: "3.14")!
print(decimal + decimal3)

var number: Int = 10

number = 11
let name = "Yu ZHANG"
let float: Float = 1.0

print("Hello \(name) of \(Float(number) + float)")

print("""
你好
hello
""")


typealias Human = (String, Int, String)

let human: Human = ("Yu", 18, "Zhang")

print(human)

let range = 3...6

let range2 = 2..<5

let range3 = ...4

let range4 = 4...

let gender = "F"

switch gender {
case "F":
    print("Female")
case "M":
    print("Male")
default:
    print("Unknown")
}


struct cat {
    let name: String
    var age: Int? = nil
}

// keypath
let someKeyPath = \cat.name
print(someKeyPath)
