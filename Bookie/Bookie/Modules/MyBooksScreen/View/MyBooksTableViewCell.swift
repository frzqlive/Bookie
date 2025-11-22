import UIKit
import SnapKit
import Kingfisher

final class MyBooksTableViewCell: UITableViewCell
{
    static let reuseIdentifier = "MyBooksTableViewCell"

    private enum Constants
    {
        static let coverCornerRadius: CGFloat = 8
        static let coverImageWidth: CGFloat = 60
        static let coverImageHeight: CGFloat = 80
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 16
        static let spacingBetweenImageAndText: CGFloat = 12
        static let titleTopSpacing: CGFloat = 16
        static let authorTopSpacing: CGFloat = 4
        static let readingDaysTopSpacing: CGFloat = 4
        static let titleFontSize: CGFloat = 16
        static let authorFontSize: CGFloat = 14
        static let readingDaysFontSize: CGFloat = 12
    }

    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.coverCornerRadius
        imageView.backgroundColor = .systemGray5
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.authorFontSize)
        label.textColor = .secondaryLabel
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.readingDaysFontSize)
        label.textColor = .tertiaryLabel
        label.numberOfLines = 1
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        self.contentView.addSubview(self.coverImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.authorLabel)
        self.contentView.addSubview(self.subtitleLabel)

        self.coverImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.horizontalInset)
            make.centerY.equalToSuperview()
            make.width.equalTo(Constants.coverImageWidth)
            make.height.equalTo(Constants.coverImageHeight)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.coverImageView.snp.trailing)
                .offset(Constants.spacingBetweenImageAndText)
            make.trailing.equalToSuperview().inset(Constants.horizontalInset)
            make.top.equalToSuperview().inset(Constants.titleTopSpacing)
        }

        self.authorLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom)
                .offset(Constants.authorTopSpacing)
        }

        self.subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.titleLabel)
            make.top.equalTo(self.authorLabel.snp.bottom)
                .offset(Constants.readingDaysTopSpacing)
            make.bottom.lessThanOrEqualToSuperview().inset(Constants.verticalInset)
        }
    }

    func configure(with book: BookViewModel) {
        self.titleLabel.text = book.title
        self.authorLabel.text = book.author
        if let subtitle = book.subtitle, !subtitle.isEmpty {
            self.subtitleLabel.isHidden = false
            self.subtitleLabel.text = subtitle
        } else {
            self.subtitleLabel.isHidden = true
            self.subtitleLabel.text = nil
        }

        self.coverImageView.kf.indicatorType = .activity

        if let url = book.coverURL {
            self.coverImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "book.closed")
            )
        } else {
            self.coverImageView.image = UIImage(systemName: "book.closed")
        }
    }
}
