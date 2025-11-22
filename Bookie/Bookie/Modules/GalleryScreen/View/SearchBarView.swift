import UIKit
import SnapKit

protocol ISearchBarView: AnyObject
{
    func searchBar(_ searchBar: SearchBarView, didChangeSearchText searchText: String)
}

final class SearchBarView: UIView
{
    private enum Constants
    {
        static let searchBarHeight: CGFloat = 56
        static let horizontalPadding: CGFloat = 16
        static let halfHorizontalPadding: CGFloat = horizontalPadding / 2
        static let searchBarCornerRadius: CGFloat = 12
        static let searchIconSize: CGFloat = 24
        static let searchIconLeftInset: CGFloat = 12
        static let searchIconRightInset: CGFloat = 8
        static let clearButtonSize: CGFloat = 20
        static let clearButtonRightInset: CGFloat = 12
        static let animationDuration: TimeInterval = 0.2
        static let placeholderText = AppStrings.SearchBar.placeholder
        static let searchIconName = "magnifyingglass"
        static let clearIconName = "xmark.circle.fill"
    }

    weak var delegate: ISearchBarView?

    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.placeholderText
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .search
        textField.clearButtonMode = .never
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()

    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Constants.searchIconName)
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constants.clearIconName), for: .normal)
        button.tintColor = .systemGray
        button.isHidden = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.searchTextField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .systemGray6
        self.layer.cornerRadius = Constants.searchBarCornerRadius

        self.addSubview(self.searchIcon)
        self.addSubview(self.searchTextField)
        self.addSubview(self.clearButton)

        self.clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)

        self.setupConstraints()
    }

    private func setupConstraints() {
        self.searchIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.searchIconLeftInset)
            make.centerY.equalToSuperview()
            make.size.equalTo(Constants.searchIconSize)
        }

        self.clearButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.clearButtonRightInset)
            make.centerY.equalToSuperview()
            make.size.equalTo(Constants.clearButtonSize)
        }

        self.searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(searchIcon.snp.trailing).offset(Constants.searchIconRightInset)
            make.trailing.equalTo(clearButton.snp.leading).offset(-Constants.halfHorizontalPadding)
            make.top.bottom.equalToSuperview()
        }

        self.snp.makeConstraints { make in
            make.height.equalTo(Constants.searchBarHeight)
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        self.clearButton.isHidden = searchText.isEmpty
        self.delegate?.searchBar(self, didChangeSearchText: searchText)
    }

    @objc private func clearButtonTapped() {
        self.searchTextField.text = ""
        self.clearButton.isHidden = true
        self.delegate?.searchBar(self, didChangeSearchText: "")
    }

    func resignFirstResponder() {
        self.searchTextField.resignFirstResponder()
    }
}

extension SearchBarView: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTextField.resignFirstResponder()
        return true
    }
}
