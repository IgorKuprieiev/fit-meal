//
//  MealDay.swift
//  PickMe
//
//  Created by MAC_A_120413 on 9/2/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import UIKit

class MealDay: NSObject {
    
    public var day: Int!
    public var meals: [Meal]!
}


class Meal: NSObject {
    
    public var time: NSDate!
    public var content: String!
    
}
