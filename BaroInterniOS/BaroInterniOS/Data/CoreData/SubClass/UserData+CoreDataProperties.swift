//
//  UserData+CoreDataProperties.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/20/25.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var nickName: String?
    @NSManaged public var password: String?
    @NSManaged public var userID: String?

}

extension UserData : Identifiable {

}
