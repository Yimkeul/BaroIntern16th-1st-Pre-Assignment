//
//  DIContainer.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/20/25.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()

    /// Manager
    private let coreDataManager: CoreDataManager

    /// Repository
    private let userDataRepository: UserDataRepository


    /// UseCase
    private let userDataUseCase: UserDataUseCase
    private let memberDataUseCase: MemberDataUseCase
    private let validationUseCase: ValidationUseCase

    private init() {
        self.coreDataManager = CoreDataManager()
        self.userDataRepository = UserDataRepositoryImpl(coreDataManager: coreDataManager)
        self.userDataUseCase = UserDataUseCaseImpl(userDataRepository: userDataRepository)
        self.memberDataUseCase = MemeberDataUseCaseImpl()
        self.validationUseCase = ValidationUseCase()
    }

    func makeInitialViewController() -> InitialViewController {
        let viewModel = InitialViewModel(memberDataUseCase: memberDataUseCase)
        return InitialViewController(viewModel: viewModel)
    }

    func makeSignInViewController() -> SignInViewController {
        let viewModel = SignInViewModel(
            userDataUseCase: userDataUseCase,
            memberDataUseCase: memberDataUseCase,
            validationUseCase: validationUseCase
        )
        return SignInViewController(viewModel: viewModel)
    }

    func makeMainViewController() -> MainViewController {
        let viewModel = MainViewModel(
            userDataUseCase: userDataUseCase,
            memberDataUseCase: memberDataUseCase
        )
        return MainViewController(viewModel: viewModel)
    }
}
