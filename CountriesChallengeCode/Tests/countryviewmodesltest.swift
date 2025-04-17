import XCTest
@testable import CountriesChallenge

final class CountriesViewModelTests: XCTestCase {

    private var viewModel: CountriesViewModel!
    private var mockService: MockCountriesService!

    override func setUp() {
        super.setUp()
        mockService = MockCountriesService()
        viewModel = CountriesViewModel(service: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    //Success Case

    func test_fetchCountries_success_populatesCountries() {
        let country = mockCountry(name: "Sweden")
        mockService.mockCountries = [country]

        let expectation = XCTestExpectation(description: "Countries loaded successfully")

        viewModel.stateChanged = { state in
            if state == .loaded {
                XCTAssertEqual(self.viewModel.numberOfCountries, 1)
                let vm = self.viewModel.countryViewModel(at: IndexPath(row: 0, section: 0))
                XCTAssertEqual(vm?.name, "Sweden")
                expectation.fulfill()
            }
        }

        viewModel.fetchCountries()
        wait(for: [expectation], timeout: 1.0)
    }

// failure case
    func test_fetchCountries_failure_setsErrorState() {
        mockService.shouldFail = true
        mockService.error = CountriesServiceError.invalidData

        let expectation = XCTestExpectation(description: "Error state triggered")

        viewModel.stateChanged = { state in
            if case .error(let message) = state {
                XCTAssertEqual(message, CountriesServiceError.invalidData.localizedDescription)
                expectation.fulfill()
            }
        }

        viewModel.fetchCountries()
        wait(for: [expectation], timeout: 1.0)
    }


    func test_filterCountries_withSearchText_filtersCorrectly() {
        mockService.mockCountries = [
            mockCountry(name: "Sweden"),
            mockCountry(name: "Norway"),
            mockCountry(name: "Finland")
        ]
        viewModel.fetchCountries()
        viewModel.filterCountries(searchText: "swe")

        XCTAssertEqual(viewModel.numberOfCountries, 1)
        let result = viewModel.countryViewModel(at: IndexPath(row: 0, section: 0))
        XCTAssertEqual(result?.name, "Sweden")
    }


    func test_countryViewModel_invalidIndex_returnsNil() {
        let result = viewModel.countryViewModel(at: IndexPath(row: 99, section: 0))
        XCTAssertNil(result)
    }

    private func mockCountry(name: String) -> Country {
        return Country(
            capital: "Capital City",
            code: "CC",
            currency: Currency(code: "CUR", name: "Currency", symbol: "$"),
            flag: "https://flag.url",
            language: Language(code: "en", name: "English"),
            name: name,
            region: "Europe",
            population: 1000000
        )
    }
}
