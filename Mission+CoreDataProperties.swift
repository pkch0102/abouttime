//
//  Mission+CoreDataProperties.swift
//  gongmojeon
//
//  Created by 박기찬 on 2018. 7. 9..
//  Copyright © 2018년 박기찬. All rights reserved.
//
//

import Foundation
import CoreData


extension Mission {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mission> {
        return NSFetchRequest<Mission>(entityName: "Mission")
    }

    @NSManaged public var costtime: Int32
    @NSManaged public var descript: String?
    @NSManaged public var idx: Int32
    @NSManaged public var title: String?
    @NSManaged public var type: Int32
    @NSManaged public var relationship: CompleteMission?

}
