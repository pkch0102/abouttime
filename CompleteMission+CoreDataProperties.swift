//
//  CompleteMission+CoreDataProperties.swift
//  gongmojeon
//
//  Created by 박기찬 on 2018. 7. 9..
//  Copyright © 2018년 박기찬. All rights reserved.
//
//

import Foundation
import CoreData


extension CompleteMission {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompleteMission> {
        return NSFetchRequest<CompleteMission>(entityName: "CompleteMission")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var missionidx: Int32
    @NSManaged public var path: String?
    @NSManaged public var text: String?
    @NSManaged public var relationship: Mission?

}
