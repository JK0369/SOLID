//
//  BillingViewController.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/18.
//

import UIKit
import RxSwift
import SnapKit

class BillingViewController: UIViewController {

    var viewModel: BillingViewModel!
    let disposeBag = DisposeBag()

    lazy var feeButton: UIButton = {
        let button = UIButton()
        button.setTitle("fee 계산하기", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .systemGray.withAlphaComponent(0.5)

        return button
    }()

    lazy var billingListContainerStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 16.0

        return view
    }()

    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray

        return label
    }()

    init(viewModel: BillingViewModel) {
        super.init(nibName: nil, bundle: nil)

        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError()
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
        view.addSubview(feeButton)
        view.addSubview(resultLabel)
    }

    private func makeConstraints() {
        feeButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(120)
            maker.centerX.equalToSuperview()
        }

        resultLabel.snp.makeConstraints { maker in
            maker.top.equalTo(feeButton.snp.bottom).offset(30)
            maker.centerX.equalTo(feeButton)
        }
    }

    private func bindInput() {
        feeButton.rx.tap.subscribe(onNext: { [weak self] in self?.didTapButton() }).disposed(by: disposeBag)
    }

    private func didTapButton() {
        viewModel.didTapButton()
    }

    private func bindOutput() {
        viewModel.licenseInfo.subscribe(onNext: { [weak self] in self?.resultLabel.text = $0 }).disposed(by: disposeBag)
    }
}
