import XCTest
@testable import CountriesChallenge

final class NetworkingTests: XCTestCase {

    var mockService: MockCountriesService!

    override func setUp() {
        super.setUp()
        mockService = MockCountriesService()
    }

    override func tearDown() {
        mockService = nil
        super.tearDown()
    }

    func test_fetchCountries_returnsMockData() async throws {
        let expected = Country(
            capital: "Berlin",
            code: "DE",
            currency: Currency(code: "EUR", name: "Euro", symbol: "€"),
            flag: "https://flag.url",
            language: Language(code: "de", name: "German"),
            name: "Germany",
            region: "Europe",
            population: 83000000
        )
        mockService.mockCountries = [expected]

        let result = try await mockService.fetchCountries()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Germany")
    }

    func test_fetchCountries_failure_throwsError() async {
        mockService.shouldFail = true
        mockService.error = CountriesServiceError.invalidData

        do {
            _ = try await mockService.fetchCountries()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? CountriesServiceError, CountriesServiceError.invalidData)
        }
    }
}