//
//  ViewModel.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/19/25.
//

import RxSwift

/// 앱 내 ViewModel의 프로토콜
protocol ViewModel {
    associatedtype Action
    associatedtype State

    var action: AnyObserver<Action> { get }
    var state: State { get }
}

