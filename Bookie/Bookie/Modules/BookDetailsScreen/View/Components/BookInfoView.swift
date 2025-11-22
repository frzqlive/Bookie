import UIKit
import SnapKit

final class BookInfoView: UIView
{
    private enum Constants
    {
        static let stackSpacing: CGFloat = 8
        static let titleFontSize: CGFloat = 24
        static let subtitleFontSize: CGFloat = 18
        static let descriptionFontSize: CGFloat = 16
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.titleFontSize)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.subtitleFontSize)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.descriptionFontSize)
        label.textColor = .label
        label.numberOfLines = 0
        return label
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, author: String, description: String?, isDescriptionHidden: Bool) {
        self.titleLabel.text = title
        self.authorLabel.text = author
        self.descriptionLabel.text = description
        self.descriptionLabel.isHidden = isDescriptionHidden
    }
}

private extension BookInfoView
{
    func setupUI() {
        self.addSubview(self.stackView)

        [self.titleLabel, self.authorLabel, self.descriptionLabel].forEach {
            self.stackView.addArrangedSubview($0)
        }

        self.stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
