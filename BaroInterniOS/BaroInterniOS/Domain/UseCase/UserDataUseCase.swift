//
//  UserUseCase.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/20/25.
//

import Foundation

protocol UserDataUseCase {
    func isUserIDExist(userID: String) -> Bool
    func signUp(userID: String, password: String, nickName: String)
    func deleteUser(userID: String)
    func fetchNickname(by userID: String) -> String?
}

final class UserDataUseCaseImpl: UserDataUseCase {
    private let userDataRepository: UserDataRepository

    init(userDataRepository: UserDataRepository) {
        self.userDataRepository = userDataRepository
    }

    func isUserIDExist(userID: String) -> Bool {
        return userDataRepository.isUserIDExist(userID: userID)
    }

    func signUp(userID: String, password: String, nickName: String) {
        userDataRepository.signUp(userID: userID, password: password, nickName: nickName)
    }

    func deleteUser(userID: String) {
        userDataRepository.deleteUser(userID: userID)
    }

    func fetchNickname(by userID: String) -> String? {
        userDataRepository.fetchNickname(by: userID)
    }
}
