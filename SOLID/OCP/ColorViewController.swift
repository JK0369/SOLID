//
//  ColorViewController.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/17.
//

import UIKit
import SnapKit
import RxSwift

class ColorViewController: UIViewController {

    private let disposeBag = DisposeBag()
    var viewModel: ColorViewModel!

    lazy var buttonContainerStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 16.0

        return view
    }()

    lazy var leftButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("파란색 버튼", for: .normal)

        return button
    }()

    lazy var rightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("빨간색 버튼", for: .normal)

        return button
    }()

    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0

        return label
    }()

    init(viewModel: ColorViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addSubviews()
        makeConstraints()
        bindInput()
        bindOutput()
    }

    private func setupViews() {
        view.backgroundColor = .white
    }

    private func addSubviews() {
        view.addSubview(buttonContainerStackView)
        [leftButton, rightButton].forEach { buttonContainerStackView.addArrangedSubview($0) }
        view.addSubview(infoLabel)
    }

    private func makeConstraints() {
        buttonContainerStackView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
        }

        infoLabel.snp.makeConstraints { maker in
            maker.top.equalTo(buttonContainerStackView.snp.bottom).offset(16)
            maker.centerX.equalTo(view.snp.centerX)
        }
    }

    // Input

    private func bindInput() {
        leftButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.didTapBlueButton()
            }).disposed(by: disposeBag)

        rightButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.didTapRedButton()
            }).disposed(by: disposeBag)
    }

    // Output

    private func bindOutput() {
        viewModel.buttonInfo.subscribe(onNext: { [weak self] in self?.updateInfoLabel(to: $0) }).disposed(by: disposeBag)
    }

    private func updateInfoLabel(to contents: String) {
        infoLabel.text = contents
    }
}
