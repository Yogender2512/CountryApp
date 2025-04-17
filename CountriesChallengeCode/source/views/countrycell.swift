import UIKit

class CountryCell: UITableViewCell {


    let nameLabel = UILabel()
    let capitalLabel = UILabel()
    let regionLabel = UILabel()
    let populationLabel = UILabel()
    let flagImageView = UIImageView()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    func configure(with viewModel: CountriesViewModel.CountryViewModel) {
        nameLabel.text = viewModel.name
        capitalLabel.text = viewModel.capital
        regionLabel.text = viewModel.region
        populationLabel.text = viewModel.population

        if let url = viewModel.flagURL {
            loadImage(from: url)
        } else {
            flagImageView.image = nil
        }
    }

    private func setupLayout() {
        let labels = [nameLabel, capitalLabel, regionLabel, populationLabel]

        labels.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(flagImageView)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            capitalLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            capitalLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            regionLabel.topAnchor.constraint(equalTo: capitalLabel.bottomAnchor, constant: 4),
            regionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            populationLabel.topAnchor.constraint(equalTo: regionLabel.bottomAnchor, constant: 4),
            populationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            flagImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: 40),
            flagImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func loadImage(from url: URL) {
        // Simple image loading (not cached). Replace with proper loader in production.
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.flagImageView.image = image
            }
        }.resume()
    }
}
