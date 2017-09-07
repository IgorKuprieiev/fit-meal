//
//  Day+CoreDataProperties.swift
//  PickMe
//
//  Created by MAC_A_120413 on 8/25/17.
//  Copyright © 2017 qarea. All rights reserved.
//

import Foundation
import MagicalRecord

extension Day {
    @NSManaged var title: String?
    @NSManaged var meals: NSSet?
}
