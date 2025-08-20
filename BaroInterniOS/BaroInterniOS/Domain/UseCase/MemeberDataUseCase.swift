//
//  MemeberDataUseCase.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/20/25.
//

import Foundation

protocol MemberDataUseCase {
    func saveMemeberData(userID:String)
    func deleteMemberData(userID:String)
    func checkMemberData() -> Bool
    func fetchMemberID() -> String?
}

final class MemeberDataUseCaseImpl: MemberDataUseCase {
    func fetchMemberID() -> String? {
        return UserDefaults.standard.string(forKey: "userID")
    }
    
    func saveMemeberData(userID: String) {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(userID, forKey: "userID")
    }
    
    func deleteMemberData(userID: String) {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userID")
    }
    
    func checkMemberData() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
}
