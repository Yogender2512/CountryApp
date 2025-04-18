import XCTest
@testable import CountriesChallenge

final class CountryCellTests: XCTestCase {

    func test_configure_setsLabelsCorrectly() {

        let cell = CountryCell(style: .default, reuseIdentifier: "testCell")
        let viewModel = CountriesViewModel.CountryViewModel(
            name: "France",
            capital: "Capital: Paris",
            region: "Region: Europe",
            population: "Population: 67,000,000",
            flagURL: nil,
            country: Country(
                capital: "Paris",
                code: "FR",
                currency: Currency(code: "EUR", name: "Euro", symbol: "€"),
                flag: "https://flag.url",
                language: Language(code: "fr", name: "French"),
                name: "France",
                region: "Europe",
                population: 67000000
            )
        )

        cell.configure(with: viewModel)

        // Then
        XCTAssertEqual(cell.nameLabel.text, "France")
        XCTAssertEqual(cell.capitalLabel.text, "Capital: Paris")
        XCTAssertEqual(cell.regionLabel.text, "Region: Europe")
        XCTAssertEqual(cell.populationLabel.text, "Population: 67,000,000")
    }
}