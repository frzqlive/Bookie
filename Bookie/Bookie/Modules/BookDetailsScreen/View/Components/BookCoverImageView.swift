import UIKit
import SnapKit
import Kingfisher

final class BookCoverImageView: UIView
{
    private enum Constants
    {
        static let cornerRadius: CGFloat = 8
        static let height: CGFloat = 220
        static let width: CGFloat = 150
    }

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with url: URL?) {
        self.imageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "book.closed")
        )
    }
}

private extension BookCoverImageView
{
    func setupUI() {
        self.addSubview(self.imageView)

        self.imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(Constants.height)
            $0.width.equalTo(Constants.width)
        }
    }
}
