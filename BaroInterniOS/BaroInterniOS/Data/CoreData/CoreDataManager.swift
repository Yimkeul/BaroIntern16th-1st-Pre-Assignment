//
//  CoreDataManager.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/20/25.
//

import Foundation
import CoreData

final class CoreDataManager {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserData") // 프로젝트 이름에 맞게 수정
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func isUserIDExist(userID: String) -> Bool {
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        request.predicate = NSPredicate(format: "userID == %@", userID)
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Error checking user ID: \(error)")
            return false
        }
    }

    func deleteUser(userID: String) {
         let request: NSFetchRequest<UserData> = UserData.fetchRequest()
         request.predicate = NSPredicate(format: "userID == %@", userID)

         do {
             let users = try context.fetch(request)
             if let userToDelete = users.first {
                 context.delete(userToDelete)
                 saveContext() // 삭제 후 저장
             }
         } catch {
             print("Error deleting user from Core Data: \(error.localizedDescription)")
         }
     }

    // UUID를 기반으로 사용자의 닉네임을 가져오는 함수
    func fetchNickname(by userID: String) -> String? {
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        request.predicate = NSPredicate(format: "userID == %@", userID)

        do {
            let result = try context.fetch(request)
            return result.first?.nickName
        } catch {
            print("Error fetching nickname by UUID: \(error)")
            return nil
        }
    }
}
