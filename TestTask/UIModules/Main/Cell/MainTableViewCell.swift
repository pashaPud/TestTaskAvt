import UIKit

class MainTableViewCell: UITableViewCell {
    static let identifier = "MainTableViewCell"
    private var didSetupConstraints = false
    var viewModel: MainTableViewCellViewModel! {
        didSet { setUpViewModel() }
    }

    lazy var nameLabel = UILabel()
    lazy var skillsLabel = UILabel()
    lazy var phoneNumberLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setUpConstraints()
        setUpLabels()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViewModel() {
        nameLabel.text = viewModel.name
        skillsLabel.text = viewModel.skills.joined(separator: " ,")
        phoneNumberLabel.text = viewModel.phoneNumber
    }

    private func setUpLabels() {
        nameLabel.font = UIFont(name: "Helvetica Neue", size: 30)
        skillsLabel.textColor = .gray
        skillsLabel.numberOfLines = 0
        phoneNumberLabel.textAlignment = .right
    }

    private func setUpConstraints() {
        guard self.didSetupConstraints == false else { return }
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        skillsLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        contentView.addSubview(skillsLabel)
        contentView.addSubview(phoneNumberLabel)
        // MARK: - nameLabel constaints
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: phoneNumberLabel.leadingAnchor ,constant: -5),
            nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])

        // MARK: - skillsLabel constaints
        NSLayoutConstraint.activate([
            skillsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            skillsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            skillsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            skillsLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            skillsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])

        // MARK: - phoneLabel constaints
        NSLayoutConstraint.activate([
            phoneNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            phoneNumberLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            phoneNumberLabel.bottomAnchor.constraint(equalTo: skillsLabel.bottomAnchor),
            phoneNumberLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        didSetupConstraints = true
    }
}
