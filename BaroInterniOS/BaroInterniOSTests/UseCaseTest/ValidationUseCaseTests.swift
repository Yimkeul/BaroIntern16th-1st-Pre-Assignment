//
//  ValidationUseCaseTests.swift
//  BaroInterniOSTests
//
//  Created by yimkeul on 8/20/25.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest

@testable import BaroInterniOS

final class ValidationUseCaseTests: XCTestCase {

    private var sut: ValidationUseCaseProtocol!

    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        sut = ValidationUseCase()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        scheduler = nil
        disposeBag = nil
        super.tearDown()
    }

    // MARK: - UserID 유효성 검사 테스트
    func testUserIDValidation() {
        // Given
        let userIDInput = scheduler.createHotObservable([
            .next(100, ""), // 빈 문자열 (초기 상태)
            .next(200, "abc"), // @가 없는 경우
            .next(300, "abc@"), // @만 있는 경우
            .next(400, "12345@gmail.com"), // 숫자로 시작하는 경우
            .next(500, "abcde@gmail.com"), // 5글자 아이디 (유효성 검사 미통과)
            .next(600, "abcde.f@gmail.com"), // 영문 소문자, 숫자 외 문자 포함
            .next(700, "abcdeg@gmail.com"), // 6글자 아이디 (유효)
            .next(800, "abcdefghijklmnopqrst@gmail.com"), // 20글자 아이디 (유효)
            .next(900, "abcdefghijklmnopqrstu@gmail.com"), // 21글자 아이디 (유효성 검사 미통과)
                .next(1000, "abcdefg@g"), // domain 미통과
            .next(1100, "abcdefg@gmail"), // domain 미통과
            .next(1200, "abcdefg@gmail."), // domain 미통과
            .next(1300, "abcdefg@gmail.c"), // domain 미통과
            .next(1400, "abcdefg@gmail.com"), // domain 통과

        ])

        let observer = scheduler.createObserver(String?.self)

        // When
        sut.createUserIDValidationMessage(from: userIDInput.asObservable())
            .drive(observer)
            .disposed(by: disposeBag)

        scheduler.start()

        // Then
        XCTAssertEqual(observer.events, [
            .next(100, nil),
            .next(200, "이메일 주소 형식이어야 합니다. (예: abc@gmail.com)"),
            .next(300, "이메일 주소 형식이어야 합니다. (예: abc@gmail.com)"),
            .next(400, "아이디는 숫자로 시작할 수 없습니다."),
            .next(500, "아이디는 6자 이상, 20자 이하여야 합니다."),
            .next(600, "아이디는 영문 소문자와 숫자만 허용됩니다."),
            .next(700, nil),
            .next(800, nil),
            .next(900, "아이디는 6자 이상, 20자 이하여야 합니다."),
            .next(1000, "이메일 주소 형식이어야 합니다. (예: abc@gmail.com)"),
            .next(1100, "이메일 주소 형식이어야 합니다. (예: abc@gmail.com)"),
            .next(1200, "이메일 주소 형식이어야 합니다. (예: abc@gmail.com)"),
            .next(1300, "이메일 주소 형식이어야 합니다. (예: abc@gmail.com)"),
            .next(1400, nil),

        ])
    }

    // MARK: - Password 유효성 검사 테스트

    func testPasswordValidation() {
        // Given
        let passwordInput = scheduler.createHotObservable([
            .next(100, ""), // 빈 문자열 (초기 상태)
            .next(200, "1234567"), // 7자 비밀번호
            .next(300, "12345678"), // 8자 비밀번호 (유효)
            .next(400, "password1234")
        ])

        let observer = scheduler.createObserver(String?.self)

        // When
        sut.createPasswordValidationMessage(from: passwordInput.asObservable())
            .drive(observer)
            .disposed(by: disposeBag)

        scheduler.start()

        // Then
        XCTAssertEqual(observer.events, [
            .next(100, nil),
            .next(200, "비밀번호는 최소 8자 이상이어야 합니다."),
            .next(300, nil),
            .next(400, nil)
        ])
    }

    // MARK: - 비밀번호 확인 유효성 검사 테스트

    func testConfirmPasswordValidation() {
        // Given
        let passwordInput = scheduler.createHotObservable([
            .next(100, "password123")
            //            .next(200, "password123"),
            //            .next(300, "password123")
        ])

        let confirmPasswordInput = scheduler.createHotObservable([
            .next(150, "password123"), // 일치
            .next(250, "password1234"), // 불일치
            .next(350, "") // 빈 문자열
        ])

        let observer = scheduler.createObserver(String?.self)

        // When
        sut.createConfirmPasswordValidationMessage(password: passwordInput.asObservable(), confirmPassword: confirmPasswordInput.asObservable())
            .drive(observer)
            .disposed(by: disposeBag)

        scheduler.start()

        // Then
        XCTAssertEqual(observer.events, [
            .next(150, nil),
            .next(250, "입력한 비밀번호가 다릅니다."),
            .next(350, nil)
        ])
    }

    // MARK: - 회원가입 버튼 활성화 유효성 검사 테스트
    func testIsSignUpButtonEnabled() {
        // Given (입력 동일)
        let userIDInput = scheduler.createHotObservable([
            .next(100, "validid@gmail.com"),
            .next(200, "validid@gmail.com"),
            .next(300, "validid@gmail.com"),
            .next(400, "validid@gmail.com"),
            .next(500, "invalid@"),
            .next(600, "validid@gmail.com"),
            .next(700, "validid@gmail.com")
        ])
        let passwordInput = scheduler.createHotObservable([
            .next(100, "password123"),
            .next(200, "pass"),
            .next(300, "password123"),
            .next(400, "password123"),
            .next(500, "password123"),
            .next(600, "password123"),
            .next(700, "password123")
        ])
        let confirmPasswordInput = scheduler.createHotObservable([
            .next(100, "password123"),
            .next(200, "password123"),
            .next(300, "password1234"),
            .next(400, "password123"),
            .next(500, "password123"),
            .next(600, "password123"),
            .next(700, "")
        ])
        let nicknameInput = scheduler.createHotObservable([
            .next(100, "nickname"),
            .next(200, "nickname"),
            .next(300, "nickname"),
            .next(400, ""),
            .next(500, "nickname"),
            .next(600, "nickname"),
            .next(700, "nickname")
        ])

        let observer = scheduler.createObserver(Bool.self)

        // When
        sut.createIsSignUpButtonEnabled(
            userID: userIDInput.asObservable(),
            password: passwordInput.asObservable(),
            confirmPassword: confirmPasswordInput.asObservable(),
            nickname: nicknameInput.asObservable()
        )
        .asObservable() // Driver -> Observable
        .debounce(.milliseconds(1), scheduler: scheduler) // 동시 타임스탬프 수렴
        .subscribe(observer)
        .disposed(by: disposeBag)

        scheduler.start()

        // Then (각 시점의 최종값이 1ms 뒤에 방출)
        XCTAssertEqual(observer.events, [
            .next(101, true),   // 100ms: 모두 유효
            .next(201, false),  // 200ms: 비번 8자 미만
            .next(301, false),  // 300ms: 확인 불일치
            .next(401, false),  // 400ms: 닉네임 공백
            .next(501, false),  // 500ms: 이메일 형식 오류(이제 false)
            .next(601, true),   // 600ms: 모두 유효
            .next(701, false)   // 700ms: 확인 공백
        ])
    }

}

