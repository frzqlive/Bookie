import UIKit
import SnapKit

final class BookMetadataView: UIView
{
    private enum Constants
    {
        static let stackSpacing: CGFloat = 8
        static let metaValueFontSize: CGFloat = 15
    }

    private lazy var metadataLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.metaValueFontSize)
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

    func configure(metadata: String, isMetadataHidden: Bool) {
        self.metadataLabel.text = metadata
        self.metadataLabel.isHidden = isMetadataHidden
    }
}

private extension BookMetadataView
{
    func setupUI() {
        self.addSubview(self.stackView)

        self.stackView.addArrangedSubview(self.metadataLabel)

        self.stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
