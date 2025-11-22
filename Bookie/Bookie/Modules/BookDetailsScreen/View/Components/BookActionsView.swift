import UIKit
import SnapKit

final class BookActionsView: UIView
{
    var didTapRead: (() -> Void)?
    var didTapFavorite: (() -> Void)?

    private enum Constants
    {
        static let stackSpacing: CGFloat = 8
        static let buttonHeight: CGFloat = 48
        static let readButtonFontSize: CGFloat = 18
        static let favoriteButtonFontSize: CGFloat = 18
        static let readButtonCornerRadius: CGFloat = 10
        static let favoriteButtonCornerRadius: CGFloat = 10
        static let favoriteButtonDisabledAlpha: CGFloat = 0.5
    }

    private lazy var readButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .boldSystemFont(ofSize: Constants.readButtonFontSize)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = Constants.readButtonCornerRadius
        return button
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: Constants.favoriteButtonFontSize)
        button.backgroundColor = .systemGray5
        button.tintColor = .label
        button.layer.cornerRadius = Constants.favoriteButtonCornerRadius
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.configureActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(readButtonTitle: String, favoriteButtonTitle: String, isFavoriteEnabled: Bool, isFavoriteHidden: Bool) {
        self.readButton.setTitle(readButtonTitle, for: .normal)
        self.favoriteButton.setTitle(favoriteButtonTitle, for: .normal)
        self.favoriteButton.isEnabled = isFavoriteEnabled
        self.favoriteButton.alpha = isFavoriteEnabled ? 1 : Constants.favoriteButtonDisabledAlpha
        self.favoriteButton.isHidden = isFavoriteHidden
    }

    func configureFavoriteButton(isEnabled: Bool, title: String? = nil, isHidden: Bool? = nil) {
        if let title = title {
            self.favoriteButton.setTitle(title, for: .normal)
        }

        self.favoriteButton.isEnabled = isEnabled
        self.favoriteButton.alpha = isEnabled ? 1 : Constants.favoriteButtonDisabledAlpha

        if let isHidden = isHidden {
            self.favoriteButton.isHidden = isHidden
        }
    }
}

private extension BookActionsView
{
    func setupUI() {
        self.addSubview(self.stackView)

        [self.readButton, self.favoriteButton].forEach {
            self.stackView.addArrangedSubview($0)
        }

        self.stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        [self.readButton, self.favoriteButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(Constants.buttonHeight)
            }
        }
    }

    func configureActions() {
        self.readButton.addTarget(self, action: #selector(self.didTapReadButton), for: .touchUpInside)
        self.favoriteButton.addTarget(self, action: #selector(self.didTapFavoriteButton), for: .touchUpInside)
    }

    @objc func didTapReadButton() {
        self.didTapRead?()
    }

    @objc func didTapFavoriteButton() {
        self.didTapFavorite?()
    }
}

