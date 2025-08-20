//
//  ValidationUseCase.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/20/25.
//

import RxSwift
import RxCocoa

protocol ValidationUseCaseProtocol {
    func createUserIDValidationMessage(from userID: Observable<String>) -> Driver<String?>
    func createPasswordValidationMessage(from password: Observable<String>) -> Driver<String?>
    func createConfirmPasswordValidationMessage(password: Observable<String>, confirmPassword: Observable<String>) -> Driver<String?>
    func createIsSignUpButtonEnabled(
        userID: Observable<String>,
        password: Observable<String>,
        confirmPassword: Observable<String>,
        nickname: Observable<String>
    ) -> Driver<Bool>
}

final class ValidationUseCase: ValidationUseCaseProtocol {

    private func isValidEmail(_ id: String) -> Bool {
        guard !id.isEmpty else { return false }

        let parts = id.split(separator: "@")
        guard parts.count == 2 else { return false }

        let local = String(parts[0])
        let domain = String(parts[1])

        // local part 체크
        if local.prefix(1).range(of: "^[0-9]$", options: .regularExpression) != nil {
            return false
        }
        guard (6...20).contains(local.count) else { return false }
        guard local.range(of: "^[a-z0-9]+$", options: .regularExpression) != nil else {
            return false
        }

        // domain part 체크
        // 예: gmail.com, test.co.kr 등
        let domainPattern = "^[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        guard domain.range(of: domainPattern, options: .regularExpression) != nil else {
            return false
        }
        return true
    }


    private func isValidPassword(_ pwd: String) -> Bool {
        return pwd.count >= 8
    }

    private func isValidConfirm(_ pwd: String, _ confirm: String) -> Bool {
        return !confirm.isEmpty && pwd == confirm
    }

    func createUserIDValidationMessage(from userID: Observable<String>) -> Driver<String?> {
        return userID
            .map { id -> String? in
                if id.isEmpty { return nil }
                let parts = id.split(separator: "@")
                guard parts.count == 2 else { return "이메일 주소 형식이어야 합니다. (예: abc@gmail.com)" }

                let localPart = String(parts[0])
                let domainPart = String(parts[1])

                if localPart.prefix(1).range(of: "^[0-9]$", options: .regularExpression) != nil {
                    return "아이디는 숫자로 시작할 수 없습니다."
                }
                if localPart.count < 6 || localPart.count > 20 {
                    return "아이디는 6자 이상, 20자 이하여야 합니다."
                }
                if localPart.range(of: "^[a-z0-9]+$", options: .regularExpression) == nil {
                    return "아이디는 영문 소문자와 숫자만 허용됩니다."
                }
                // domain part 검사
                let domainPattern = "^[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
                if domainPart.range(of: domainPattern, options: .regularExpression) == nil {
                    return "이메일 주소 형식이어야 합니다. (예: abc@gmail.com)"
                }
                return nil
            }
            .asDriver(onErrorJustReturn: nil)
    }

    func createPasswordValidationMessage(from password: Observable<String>) -> Driver<String?> {
        return password
            .map { pwd -> String? in
                if pwd.isEmpty { return nil }
                if pwd.count < 8 { return "비밀번호는 최소 8자 이상이어야 합니다." }
                return nil
            }
            .asDriver(onErrorJustReturn: nil)
    }

    func createConfirmPasswordValidationMessage(password: Observable<String>, confirmPassword: Observable<String>) -> Driver<String?> {
        return Observable.combineLatest(password, confirmPassword)
            .map { pwd, confirm -> String? in
                if confirm.isEmpty { return nil }
                if pwd != confirm { return "입력한 비밀번호가 다릅니다." }
                return nil
            }
            .asDriver(onErrorJustReturn: nil)
    }

    func createIsSignUpButtonEnabled(
        userID: Observable<String>,
        password: Observable<String>,
        confirmPassword: Observable<String>,
        nickname: Observable<String>
    ) -> Driver<Bool> {

        let idOK = userID.map { [weak self] in self?.isValidEmail($0) ?? false }
        let pwOK = password.map { [weak self] in self?.isValidPassword($0) ?? false }
        let cfOK = Observable.combineLatest(password, confirmPassword)
            .map { [weak self] pwd, cf in self?.isValidConfirm(pwd, cf) ?? false }
        let nickOK = nickname.map { !$0.isEmpty }

        return Observable.combineLatest(idOK, pwOK, cfOK, nickOK)
            .map { $0 && $1 && $2 && $3 }
            .asDriver(onErrorJustReturn: false)
    }
}
