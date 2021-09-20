//
//  ProductTableViewCell.swift
//  SOLID
//
//  Created by 김종권 on 2021/09/20.
//

import UIKit
import SnapKit

class ProductTableViewCell: UITableViewCell {

    var model: Product? {
        didSet {
            bind()
        }
    }

    private let checkImage = UIImage(systemName: "checkmark.square")
    private let squareImage = UIImage(systemName: "square")

    lazy var checkButton: UIButton = {
        let button = UIButton()

        return button
    }()

    lazy var titleContainerStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 8.0

        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16.0, weight: .bold)

        return label
    }()

    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16.0, weight: .regular)

        return label
    }()

    lazy var saleButton: UIButton = {
        let button = UIButton()
        button.setTitle("특가", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.blue.cgColor
        button.isUserInteractionEnabled = false
        button.contentEdgeInsets = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)

        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        bind(selected)
    }

    private func setupViews() {
        contentView.backgroundColor = .white
    }

    private func addSubviews() {
        contentView.addSubview(checkButton)
        contentView.addSubview(titleContainerStackView)
        [titleLabel, priceLabel].forEach { titleContainerStackView.addArrangedSubview($0) }
        contentView.addSubview(saleButton)
    }

    private func makeConstraints() {
        checkButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        checkButton.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(16.0)
            maker.centerY.equalToSuperview()
        }

        titleContainerStackView.snp.makeConstraints { maker in
            maker.leading.equalTo(checkButton.snp.trailing).offset(8.0)
            maker.trailing.greaterThanOrEqualTo(saleButton.snp.leading).offset(-16.0)
            maker.centerY.equalToSuperview()
        }

        saleButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        saleButton.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(16.0)
            maker.centerY.equalTo(checkButton)
        }
    }

    private func bind(_ isCheck: Bool = false) {
        let checkButtonImage = isCheck ? checkImage : squareImage

        saleButton.isHidden = model?.isSale == false
        checkButton.setImage(checkButtonImage, for: .normal)
        titleLabel.text = model?.title
        priceLabel.text = String(model?.price ?? 0)
    }
}
