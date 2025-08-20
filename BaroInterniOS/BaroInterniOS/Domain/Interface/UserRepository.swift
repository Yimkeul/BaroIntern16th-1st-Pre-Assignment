//
//  UserDataRepository.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/20/25.
//

import Foundation

protocol UserDataRepository {
    func signUp(userID: String, password: String, nickName: String)
    func isUserIDExist(userID: String) -> Bool
    func deleteUser(userID: String)
    func fetchNickname(by userID: String) -> String?
}
