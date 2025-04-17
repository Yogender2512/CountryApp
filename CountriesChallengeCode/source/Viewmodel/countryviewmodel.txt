import Foundation

class CountriesViewModel {
    
    enum State: Equatable {
        case initial
        case loading
        case loaded
        case error(String)

        static func == (lhs: CountriesViewModel.State, rhs: CountriesViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case (.initial, .initial), (.loading, .loading), (.loaded, .loaded):
                return true
            case (.error(let l), .error(let r)):
                return l == r
            default:
                return false
            }
        }
    }

    struct CountryViewModel {
        let name: String
        let capital: String
        let region: String
        let population: String
        let flagURL: URL?
        let country: Country
    }

    private let service: CountriesServiceProtocol
    private var allCountries: [Country] = []
    private var displayedCountries: [Country] = []

    var state: State = .initial {
        didSet { stateChanged?(state) }
    }

    var stateChanged: ((State) -> Void)?

    init(service: CountriesServiceProtocol = CountriesService()) {
        self.service = service
    }

    var numberOfCountries: Int {
        return displayedCountries.count
    }

    func countryViewModel(at indexPath: IndexPath) -> CountryViewModel? {
        guard indexPath.row < displayedCountries.count else { return nil }

        let country = displayedCountries[indexPath.row]
        return CountryViewModel(
            name: country.name,
            capital: "Capital: \(country.capital)",
            region: "Region: \(country.region)",
            population: "Population: \(formattedPopulation(from: country.population))",
            flagURL: URL(string: country.flag),
            country: country
        )
    }

    func fetchCountries() {
        state = .loading
        service.fetchCountries { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let countries):
                self.allCountries = countries
                self.displayedCountries = countries
                self.state = .loaded

            case .failure(let error):
                self.state = .error(error.localizedDescription)
            }
        }
    }

    func filterCountries(searchText: String) {
        if searchText.isEmpty {
            displayedCountries = allCountries
        } else {
            displayedCountries = allCountries.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    private func formattedPopulation(from population: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: population)) ?? "\(population)"
    }
}
