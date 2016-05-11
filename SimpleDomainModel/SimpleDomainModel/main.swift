//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

public class TestMe {
  public func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(to: String) -> Money {
    // 1 USD = .5 GBP (2 USD = 1 GBP) 1 USD = 1.5 EUR (2 USD = 3 EUR) 1 USD = 1.25 CAN (4 USD = 5 CAN)
    var conversionDict = [String : Int]()
    conversionDict["USD"] = 15
    conversionDict["GBP"] = 30
    conversionDict["EUR"] = 10
    conversionDict["CAN"] = 12
    
    if conversionDict.keys.contains(to) {
        return Money(amount: ((self.amount * conversionDict[self.currency]!) / conversionDict[to]!), currency: to)
    } else {
        print("ERROR: I'm sorry, you entered an unsupported currency.")
        return self
    }
  }
    
  public func add(to: Money) -> Money {
    if self.currency == to.currency {
        return Money(amount: (self.amount + to.amount), currency: self.currency)
    } else {
        return self.convert(to.currency).add(to)
    }
  }
    
  public func subtract(from: Money) -> Money {
    if self.currency == from.currency {
        return Money(amount: (self.amount - from.amount), currency: self.currency)
    } else {
        return self.subtract(from.convert(self.currency))
    }
  }
}

////////////////////////////////////
// Job
//
public class Job {
  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }

  public var title : String
  public var salary : JobType
  
  public init(title : String, type : JobType) {
    self.title = title
    self.salary = type
  }
  
  public func calculateIncome(hours: Int) -> Int {
    switch self.salary {
    case .Hourly(let wage):
        return Int(Double(hours) * wage)
    case .Salary(let sal):
        return sal
    }
  }
  
  public func raise(amt : Double) {
    switch self.salary {
    case .Hourly(let wage):
        self.salary = .Hourly(wage + amt)
    case .Salary(let sal):
        self.salary = .Salary(Int(Double(sal) + amt))
    }
  }
}

////////////////////////////////////
// Person
//
public class Person {
  public var firstName : String = ""
  public var lastName : String = ""
  public var age : Int = 0
    
  public var _job : Job? = nil
  public var job : Job? {
    get {
        return self._job
    }
    set(value) {
        if ((self.age) >= 16) {
            self._job = value
        }
    }
  }
    
  public var _spouse : Person? = nil
  public var spouse : Person? {
    get {
        return self._spouse
    }
    set(value) {
        if (self.age >= 18) {
            self._spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  public func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
  }
}

////////////////////////////////////
// Family
//
public class Family {
  private var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if (spouse1.spouse == nil && spouse2.spouse == nil) && (spouse1.age > 21 || spouse2.age > 21) {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
  }
  
  public func haveChild(child: Person) -> Bool {
    members.append(child)
    return true
  }
  
  public func householdIncome() -> Int {
    var out = 0
    for person in members {
        if (person.job != nil) {
            out += (person.job!.calculateIncome(2000))
        }
    }
    return out
  }
}





