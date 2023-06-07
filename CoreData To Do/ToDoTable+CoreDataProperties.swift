//
//  ToDoTable+CoreDataProperties.swift
//  CoreData To Do
//
//  Created by Dhiraj on 6/6/23.
//
//

import Foundation
import CoreData


extension ToDoTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoTable> {
        return NSFetchRequest<ToDoTable>(entityName: "ToDoTable")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var done: Bool

}

extension ToDoTable : Identifiable {

}
