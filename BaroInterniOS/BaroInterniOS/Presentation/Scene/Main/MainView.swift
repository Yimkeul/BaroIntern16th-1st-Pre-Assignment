//
//  MainView.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/19/25.
//

import UIKit

import SnapKit
import Then

final class MainView: UIView {

    // MARK: - UI Components
    private let _welcomeLabel = UILabel()
    private let _logoutButton = UIButton(type: .system)
    private let _deleteAccountButton = UIButton(type: .system)
    private let _buttonStackView = UIStackView()

    var logoutButton: UIButton { _logoutButton }
    var deleteAccountButton: UIButton { _deleteAccountButton }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Public Method
    func configureMessage(nickname: String) {
        _welcomeLabel.text = "\(nickname) 님 환영합니다."
    }
}

private extension MainView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .systemBackground

        _welcomeLabel.do {
            $0.textAlignment = .center
            $0.font = .boldSystemFont(ofSize: 24)
            $0.textColor = .label
        }

        _buttonStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 10
        }

        _logoutButton.do {
            var config = UIButton.Configuration.filled()
            config.title = "로그아웃"
            config.baseForegroundColor = .white
            config.baseBackgroundColor = .systemGray
            config.cornerStyle = .large
            $0.configuration = config
            $0.heightAnchor.constraint(equalToConstant: 56).isActive = true
        }

        _deleteAccountButton.do {
            var config = UIButton.Configuration.filled()
            config.title = "회원탈퇴"
            config.baseForegroundColor = .white
            config.baseBackgroundColor = .systemRed
            config.cornerStyle = .large
            $0.configuration = config
            $0.heightAnchor.constraint(equalToConstant: 56).isActive = true
        }
    }

    func setHierarchy() {
        addSubviews(_welcomeLabel, _buttonStackView)
        _buttonStackView.addArrangedSubview(_logoutButton)
        _buttonStackView.addArrangedSubview(_deleteAccountButton)
    }

    func setConstraints() {
        _welcomeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        _buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(24)
        }
    }
}
