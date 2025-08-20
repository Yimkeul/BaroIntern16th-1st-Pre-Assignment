//
//  InitialView.swift
//  BaroInterniOS
//
//  Created by yimkeul on 8/19/25.
//

import UIKit
import SnapKit
import Then

final class InitialView: UIView {

    // MARK: - UI Components
    private let _backgroundImageView = UIImageView()
    private let _titleLabel = UILabel()
    private let _subTitleLabel = UILabel()
    private let _startButton = UIButton()

    var startButton: UIButton { _startButton }

    // MARK: - Initializer, Deinit, requiered
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension InitialView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        _backgroundImageView.do {
            $0.image = UIImage(named: "bg")
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }

        _titleLabel.do {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineSpacing = 15

            $0.numberOfLines = 0
            $0.attributedText = NSAttributedString(
                string: "실무 경험 필요할 때,\n바로인턴",
                attributes: [
                    .paragraphStyle: paragraphStyle,
                    .font: UIFont.boldSystemFont(ofSize: 30),
                    .foregroundColor: UIColor.cBrown
                ]
            )
        }

        _subTitleLabel.do {
            $0.text = "내일배움캠프 수료생만을 위한 인턴십 혜택"
            $0.textColor = .gray
            $0.textAlignment = .center
            $0.numberOfLines = .zero
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }

        _startButton.do {
            var config = UIButton.Configuration.filled()
            config.title = "시작하기"
            config.baseForegroundColor = .white
            config.baseBackgroundColor = .cRed
            config.cornerStyle = .large
            $0.configuration = config
            $0.layer.cornerRadius = 14
            $0.layer.masksToBounds = true
            $0.heightAnchor.constraint(equalToConstant: 56).isActive = true

            $0.configurationUpdateHandler = { btn in
                guard var cfg = btn.configuration else { return }
                if !btn.isEnabled {
                    cfg.baseBackgroundColor = .systemGray4
                    cfg.baseForegroundColor = .white
                } else if btn.isHighlighted {
                    cfg.baseBackgroundColor = .darkGray
                    cfg.baseForegroundColor = .white
                } else {
                    cfg.baseBackgroundColor = .cRed
                    cfg.baseForegroundColor = .white
                }
                btn.configuration = cfg
            }
        }
    }

    func setHierarchy() {
        self.addSubviews(
            _backgroundImageView,
            _titleLabel,
            _subTitleLabel,
            _startButton
        )
    }

    func setConstraints() {
        _backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        _titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(_subTitleLabel.snp.top).offset(-70)
        }
        _subTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        _startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(56)
        }
    }
}

