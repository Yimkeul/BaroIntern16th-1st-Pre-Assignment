//
//  UserDataRepositoryImpl.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/20/25.
//

import Foundation

final class UserDataRepositoryImpl: UserDataRepository {

    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    func signUp(userID: String, password: String, nickName: String) {
        let context = coreDataManager.context
        let newUser = UserData(context: context)
        newUser.userID = userID
        newUser.password = password
        newUser.nickName = nickName
        coreDataManager.saveContext()
    }

    func isUserIDExist(userID: String) -> Bool {
        return coreDataManager.isUserIDExist(userID: userID)
    }
    
    func deleteUser(userID: String) {
        return coreDataManager.deleteUser(userID: userID)
    }
    
    func fetchNickname(by userID: String) -> String? {
        return coreDataManager.fetchNickname(by: userID)
    }
}
