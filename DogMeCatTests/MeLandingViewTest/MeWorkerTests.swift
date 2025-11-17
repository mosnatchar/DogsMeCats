//
//  MeWorkerTests.swift
//  DogMeCatTests
//
//  Created on 16/11/2568 BE.
//

import XCTest
@testable import DogMeCat

class MeMockAPIClient: APIClientProtocol {
    
    var shouldSucceed = true
    var responseToReturn: RandomUserResponseDTO?
    var errorToReturn: Error?
    
    var requestCallCount = 0
    var lastEndpoint: APIEndpoint?
    
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        lastEndpoint = endpoint
        requestCallCount += 1
        
        // Simulate async behavior
        DispatchQueue.main.async {
            if self.shouldSucceed {
                if let response = self.responseToReturn, let typedResponse = response as? T {
                    completion(.success(typedResponse))
                } else {
                    completion(.failure(NSError(domain: "MockError", code: 400, userInfo: nil)))
                }
            } else {
                let error = self.errorToReturn ?? NSError(domain: "MockError", code: 500, userInfo: nil)
                completion(.failure(error))
            }
        }
    }
}


final class MeWorkerTests: XCTestCase {
    
    // System Under Test
    var sut: MeWorker!
    
    // Test Doubles
    var mockAPIClient: MeMockAPIClient!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        
        mockAPIClient = MeMockAPIClient()
        sut = MeWorker(apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        sut = nil
        mockAPIClient = nil
        
        super.tearDown()
    }
    
    private func createMockRandomUserDTO() -> RandomUserDTO {
        return RandomUserDTO(
            gender: "male",
            name: RandomUserDTO.NameDTO(
                title: "Mr",
                first: "John",
                last: "Doe"
            ),
            dob: RandomUserDTO.DobDTO(
                date: "1993-06-15T00:00:00.000Z",
                age: 30
            ),
            nat: "US",
            phone: "+1234567890",
            cell: "+1234567890",
            location: RandomUserDTO.LocationDTO(
                street: RandomUserDTO.LocationDTO.StreetDTO(
                    number: 123,
                    name: "Main Street"
                ),
                city: "New York",
                state: "NY",
                country: "USA",
                postcode: .string("10001")
            ),
            picture: RandomUserDTO.PictureDTO(
                large: "https://randomuser.me/api/portraits/men/1.jpg",
                medium: "https://randomuser.me/api/portraits/med/men/1.jpg",
                thumbnail: "https://randomuser.me/api/portraits/thumb/men/1.jpg"
            )
        )
    }
    
    // MARK: - fetchProfile Tests
    
    func testFetchMeResponseSuccess() {
        let expectation = self.expectation(description: "Fetch profile success")
        let mockDTO = createMockRandomUserDTO()
        let mockResponse = RandomUserResponseDTO(results: [mockDTO])
        
        mockAPIClient.shouldSucceed = true
        mockAPIClient.responseToReturn = mockResponse
        
        var resultData: UserProfile?
        
        sut.fetchProfile { result in
            switch result {
            case .success(let profile):
                resultData = profile
            case .failure(_):
                break
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            XCTAssertNotNil(resultData, "Should have profile")
            XCTAssertEqual(resultData?.title, "Mr")
        }
    }
    
    func testFetchMeResponsefailure() {
        let expectation = self.expectation(description: "Fetch profile failure")
        
        mockAPIClient.shouldSucceed = false
        var resultError: Error?
        
        sut.fetchProfile { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                resultError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            XCTAssertNotNil(resultError, "Should have error")
        }
    }
    
    func testFetchMeResponseEmpty() {
        let expectation = self.expectation(description: "Empty response")
        
        mockAPIClient.shouldSucceed = true
        mockAPIClient.responseToReturn = RandomUserResponseDTO(results: [])
        
        var resultData: UserProfile?
        
        sut.fetchProfile { result in
            switch result {
            case .success(let data):
                resultData = data
            case .failure(_):
                break
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            XCTAssertNil(resultData, "Response noData")
        }
    }
    
    //    MARK: - AI MOCK
    /// Test 1: fetchProfile สำเร็จ - ควรได้ UserProfile ที่ถูกต้อง
//    func testFetchProfile_Success_ShouldReturnUserProfile() {
//        // Given
//        let expectation = self.expectation(description: "Fetch profile success")
//        
//        let mockDTO = createMockRandomUserDTO()
//        let mockResponse = RandomUserResponseDTO(results: [mockDTO])
//        
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseToReturn = mockResponse
//        
//        var resultProfile: UserProfile?
//        var resultError: Error?
//        
//        // When
//        sut.fetchProfile { result in
//            switch result {
//            case .success(let profile):
//                resultProfile = profile
//            case .failure(let error):
//                resultError = error
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNil(resultError, "Should not have error")
//            XCTAssertNotNil(resultProfile, "Should have profile")
//            
//            XCTAssertEqual(resultProfile?.title, "Mr")
//            XCTAssertEqual(resultProfile?.firstName, "John")
//            XCTAssertEqual(resultProfile?.lastName, "Doe")
//            XCTAssertEqual(resultProfile?.age, 30)
//            XCTAssertEqual(resultProfile?.gender, "male")
//            XCTAssertEqual(resultProfile?.nationality, "US")
//            XCTAssertEqual(resultProfile?.mobile, "+1234567890")
//            XCTAssertNotNil(resultProfile?.profileImageURL)
//        }
//    }
//    
//    func testFetchProfile_Failure_ShouldReturnError() {
//        // Given
//        let expectation = self.expectation(description: "Fetch profile failure")
//        let mockError = NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Network error"])
//        
//        mockAPIClient.shouldSucceed = false
//        mockAPIClient.errorToReturn = mockError
//        
//        var resultProfile: UserProfile?
//        var resultError: Error?
//        
//        // When
//        sut.fetchProfile { result in
//            switch result {
//            case .success(_): break
//            case .failure(let error):
//                resultError = error
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNotNil(resultError, "Should have error")
//            XCTAssertNil(resultProfile, "Should not have profile")
//            XCTAssertEqual((resultError as? NSError)?.domain, "TestError")
//            XCTAssertEqual((resultError as? NSError)?.code, 500)
//        }
//    }
//    
//    /// Test 3: fetchProfile กับ response ว่าง - ควรได้ APIError.noData
//    func testFetchProfile_WithEmptyResponse_ShouldReturnNoDataError() {
//        // Given
//        let expectation = self.expectation(description: "Empty response")
//        
//        let emptyResponse = RandomUserResponseDTO(results: [])
//        
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseToReturn = emptyResponse
//        
//        var resultError: Error?
//        
//        // When
//        sut.fetchProfile { result in
//            if case .failure(let error) = result {
//                resultError = error
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNotNil(resultError, "Should have error")
//            
//            if let apiError = resultError as? APIError {
//                switch apiError {
//                case .noData:
//                    XCTAssertTrue(true, "Should be noData error")
//                default:
//                    XCTFail("Should be noData error, got \(apiError)")
//                }
//            } else {
//                XCTFail("Error should be APIError.noData")
//            }
//        }
//    }
//    
//    /// Test 4: fetchProfile ควรเรียก API ด้วย endpoint ที่ถูกต้อง
//    func testFetchProfile_ShouldCallAPIWithCorrectEndpoint() {
//        // Given
//        let expectation = self.expectation(description: "API call")
//        
//        let mockDTO = createMockRandomUserDTO()
//        let mockResponse = RandomUserResponseDTO(results: [mockDTO])
//        
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseToReturn = mockResponse
//        
//        // When
//        sut.fetchProfile { _ in
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertEqual(self.mockAPIClient.requestCallCount, 1, "Should call API once")
//            
//            let endpoint = self.mockAPIClient.lastEndpoint
//            XCTAssertNotNil(endpoint, "Should have endpoint")
//            XCTAssertEqual(endpoint?.path.pathURLString, "https://randomuser.me/api")
//        }
//    }
//    
//    /// Test 5: fetchProfile หลายครั้ง - ควรเรียก API ทุกครั้ง
//    func testFetchProfile_MultipleTimes_ShouldCallAPIEachTime() {
//        // Given
//        let firstExpectation = self.expectation(description: "First call")
//        let secondExpectation = self.expectation(description: "Second call")
//        
//        let mockDTO = createMockRandomUserDTO()
//        let mockResponse = RandomUserResponseDTO(results: [mockDTO])
//        
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseToReturn = mockResponse
//        
//        // When - First call
//        sut.fetchProfile { _ in
//            firstExpectation.fulfill()
//        }
//        
//        wait(for: [firstExpectation], timeout: 1.0)
//        
//        // When - Second call
//        sut.fetchProfile { _ in
//            secondExpectation.fulfill()
//        }
//        
//        // Then
//        wait(for: [secondExpectation], timeout: 1.0)
//        
//        XCTAssertEqual(mockAPIClient.requestCallCount, 2, "Should call API twice")
//    }
//    
//    /// Test 6: fetchProfile กับ female gender - ควร map ข้อมูลถูกต้อง
//    func testFetchProfile_WithFemaleGender_ShouldMapCorrectly() {
//        // Given
//        let expectation = self.expectation(description: "Female profile")
//        
//        var mockDTO = createMockRandomUserDTO()
//        // Update to female
//        mockDTO = RandomUserDTO(
//            gender: "female",
//            name: RandomUserDTO.NameDTO(title: "Ms", first: "Jane", last: "Smith"),
//            dob: RandomUserDTO.DobDTO(date: "1995-06-25T00:00:00.000Z", age: 28),
//            nat: "UK",
//            phone: "+44123456789",
//            cell: "+44987654321",
//            location: mockDTO.location,
//            picture: RandomUserDTO.PictureDTO(
//                large: "https://randomuser.me/api/portraits/women/1.jpg",
//                medium: "https://randomuser.me/api/portraits/med/women/1.jpg",
//                thumbnail: "https://randomuser.me/api/portraits/thumb/women/1.jpg"
//            )
//        )
//        
//        let mockResponse = RandomUserResponseDTO(results: [mockDTO])
//        
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseToReturn = mockResponse
//        
//        var resultProfile: UserProfile?
//        
//        // When
//        sut.fetchProfile { result in
//            if case .success(let profile) = result {
//                resultProfile = profile
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertEqual(resultProfile?.gender, "female")
//            XCTAssertEqual(resultProfile?.title, "Ms")
//            XCTAssertEqual(resultProfile?.firstName, "Jane")
//            XCTAssertEqual(resultProfile?.lastName, "Smith")
//        }
//    }
//    
//    /// Test 7: fetchProfile ควร convert DTO เป็น Domain model ถูกต้อง
//    func testFetchProfile_ShouldConvertDTOToDomainCorrectly() {
//        // Given
//        let expectation = self.expectation(description: "DTO conversion")
//        
//        let mockDTO = createMockRandomUserDTO()
//        let mockResponse = RandomUserResponseDTO(results: [mockDTO])
//        
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseToReturn = mockResponse
//        
//        var resultProfile: UserProfile?
//        
//        // When
//        sut.fetchProfile { result in
//            if case .success(let profile) = result {
//                resultProfile = profile
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNotNil(resultProfile)
//            
//            // Verify all fields are mapped
//            XCTAssertFalse(resultProfile!.title.isEmpty)
//            XCTAssertFalse(resultProfile!.firstName.isEmpty)
//            XCTAssertFalse(resultProfile!.lastName.isEmpty)
//            XCTAssertGreaterThan(resultProfile!.age, 0)
//            XCTAssertFalse(resultProfile!.gender.isEmpty)
//            XCTAssertFalse(resultProfile!.nationality.isEmpty)
//            XCTAssertFalse(resultProfile!.mobile.isEmpty)
//            XCTAssertFalse(resultProfile!.address.isEmpty)
//        }
//    }
//    
//    /// Test 8: fetchProfile กับ address - ควร format address ถูกต้อง
//    func testFetchProfile_ShouldFormatAddressCorrectly() {
//        // Given
//        let expectation = self.expectation(description: "Address formatting")
//        
//        let mockDTO = createMockRandomUserDTO()
//        let mockResponse = RandomUserResponseDTO(results: [mockDTO])
//        
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseToReturn = mockResponse
//        
//        var resultProfile: UserProfile?
//        
//        // When
//        sut.fetchProfile { result in
//            if case .success(let profile) = result {
//                resultProfile = profile
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            let address = resultProfile?.address ?? ""
//            
//            // Address should contain all components
//            XCTAssertTrue(address.contains("123"), "Should contain street number")
//            XCTAssertTrue(address.contains("Main Street"), "Should contain street name")
//            XCTAssertTrue(address.contains("New York"), "Should contain city")
//            XCTAssertTrue(address.contains("NY"), "Should contain state")
//            XCTAssertTrue(address.contains("10001"), "Should contain postcode")
//            XCTAssertTrue(address.contains("USA"), "Should contain country")
//        }
//    }
//    
//    /// Test 9: fetchProfile กับ network error - ควรส่งต่อ error
//    func testFetchProfile_WithNetworkError_ShouldForwardError() {
//        // Given
//        let expectation = self.expectation(description: "Network error")
//        
//        enum NetworkError: Error {
//            case timeout
//        }
//        
//        mockAPIClient.shouldSucceed = false
//        mockAPIClient.errorToReturn = NetworkError.timeout
//        
//        var resultError: Error?
//        
//        // When
//        sut.fetchProfile { result in
//            if case .failure(let error) = result {
//                resultError = error
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNotNil(resultError)
//            XCTAssertTrue(resultError is NetworkError)
//        }
//    }
//    
//    /// Test 10: fetchProfile กับ postcode เป็น Int - ควร handle ได้
//    func testFetchProfile_WithIntPostcode_ShouldHandleCorrectly() {
//        // Given
//        let expectation = self.expectation(description: "Int postcode")
//        
//        var mockDTO = createMockRandomUserDTO()
//        // Update location with Int postcode
//        mockDTO = RandomUserDTO(
//            gender: mockDTO.gender,
//            name: mockDTO.name,
//            dob: mockDTO.dob,
//            nat: mockDTO.nat,
//            phone: mockDTO.phone,
//            cell: mockDTO.cell,
//            location: RandomUserDTO.LocationDTO(
//                street: mockDTO.location.street,
//                city: mockDTO.location.city,
//                state: mockDTO.location.state,
//                country: mockDTO.location.country,
//                postcode: .int(12345)
//            ),
//            picture: mockDTO.picture
//        )
//        
//        let mockResponse = RandomUserResponseDTO(results: [mockDTO])
//        
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseToReturn = mockResponse
//        
//        var resultProfile: UserProfile?
//        
//        // When
//        sut.fetchProfile { result in
//            if case .success(let profile) = result {
//                resultProfile = profile
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNotNil(resultProfile)
//            XCTAssertTrue(resultProfile!.address.contains("12345"), "Should contain numeric postcode")
//        }
//    }
//    
//    /// Test 11: fetchProfile กับ postcode เป็น String - ควร handle ได้
//    func testFetchProfile_WithStringPostcode_ShouldHandleCorrectly() {
//        // Given
//        let expectation = self.expectation(description: "String postcode")
//        
//        var mockDTO = createMockRandomUserDTO()
//        // Update location with String postcode
//        mockDTO = RandomUserDTO(
//            gender: mockDTO.gender,
//            name: mockDTO.name,
//            dob: mockDTO.dob,
//            nat: mockDTO.nat,
//            phone: mockDTO.phone,
//            cell: mockDTO.cell,
//            location: RandomUserDTO.LocationDTO(
//                street: mockDTO.location.street,
//                city: mockDTO.location.city,
//                state: mockDTO.location.state,
//                country: mockDTO.location.country,
//                postcode: .string("AB12 3CD")
//            ),
//            picture: mockDTO.picture
//        )
//        
//        let mockResponse = RandomUserResponseDTO(results: [mockDTO])
//        
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseToReturn = mockResponse
//        
//        var resultProfile: UserProfile?
//        
//        // When
//        sut.fetchProfile { result in
//            if case .success(let profile) = result {
//                resultProfile = profile
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNotNil(resultProfile)
//            XCTAssertTrue(resultProfile!.address.contains("AB12 3CD"), "Should contain string postcode")
//        }
//    }
//    
//    /// Test 12: fetchProfile กับ invalid date format - ควรใช้ default date
//    func testFetchProfile_WithInvalidDate_ShouldUseDefaultDate() {
//        // Given
//        let expectation = self.expectation(description: "Invalid date")
//        
//        var mockDTO = createMockRandomUserDTO()
//        mockDTO = RandomUserDTO(
//            gender: mockDTO.gender,
//            name: mockDTO.name,
//            dob: RandomUserDTO.DobDTO(date: "invalid-date", age: 30),
//            nat: mockDTO.nat,
//            phone: mockDTO.phone,
//            cell: mockDTO.cell,
//            location: mockDTO.location,
//            picture: mockDTO.picture
//        )
//        
//        let mockResponse = RandomUserResponseDTO(results: [mockDTO])
//        
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseToReturn = mockResponse
//        
//        var resultProfile: UserProfile?
//        
//        // When
//        sut.fetchProfile { result in
//            if case .success(let profile) = result {
//                resultProfile = profile
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNotNil(resultProfile)
//            // Should not crash and should have a date (current date as fallback)
//            XCTAssertNotNil(resultProfile?.dateOfBirth)
//        }
//    }
    
}
