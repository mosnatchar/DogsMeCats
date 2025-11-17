//
//  CatsWorkerTests.swift
//  DogMeCatTests
//
//  Created on 16/11/2568 BE.
//

import XCTest
@testable import DogMeCat

// MARK: - Mock API Client

class CatsMockAPIClient: APIClientProtocol {
    
    var shouldSucceed = true
    var responseToReturn: CatBreedsResponseDTO?
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if !self.shouldSucceed {
                let error = self.errorToReturn ?? NSError(domain: "MockError", code: 500, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            // Success case
            if let response = self.responseToReturn, let typedResponse = response as? T {
                completion(.success(typedResponse))
            } else {
                completion(.failure(NSError(domain: "MockError", code: 400, userInfo: nil)))
            }
        }
    }
}


final class CatsWorkerTests: XCTestCase {
    
    // System Under Test
    var sut: CatsWorker!
    
    // Test Doubles
    var mockAPIClient: CatsMockAPIClient!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        
        mockAPIClient = CatsMockAPIClient()
        sut = CatsWorker(apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        sut = nil
        mockAPIClient = nil
        
        super.tearDown()
    }
    
    let dto = CatBreedsResponseDTO(
        data: [
            CatBreedDTO(
                breed: "Persian",
                country: "Iran",
                origin: "Iran",
                coat: "Long",
                pattern: "Solid"
            ),
            CatBreedDTO(
                breed: "Siamese",
                country: "Thailand",
                origin: "Thailand",
                coat: "Short",
                pattern: "Pointed"
            )
        ],
        last_page: 3,
        current_page: 1
    )
    
    func testFetchBreedsSuccess() {
        let expectation = self.expectation(description: "Fetch respons success")
        
        mockAPIClient.responseToReturn = dto
        mockAPIClient.shouldSucceed = true
        
        var resultResponse: CatBreedsResponse?
        
        // When
        sut.fetchBreeds(page: 1) { result in
            switch result {
            case .success(let response):
                resultResponse = response
            case .failure(_):
                break
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            XCTAssertNotNil(resultResponse, "Should have response")
        }
    }
    
    func testFetchBreedsFailure() {
        let expectation = self.expectation(description: "Fetch respons success")
        
        mockAPIClient.shouldSucceed = false
        
        var resultError: Error?
        
        // When
        sut.fetchBreeds(page: 1) { result in
            switch result {
            case .success(_):
                break
            case .failure(let Error):
                resultError = Error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            XCTAssertNotNil(resultError, "Should not have response")
        }
    }
    
    // MARK: - AI fetchBreeds Success Tests
    
    /// Test 1: fetchBreeds สำเร็จ - ควรแปลง DTO เป็น CatBreed ถูกต้อง
//    func testFetchBreeds_Success_ShouldReturnCatBreeds() {
//        // Given
//        let expectation = self.expectation(description: "Fetch breeds success")
//        
//        let dto = CatBreedsResponseDTO(
//            data: [
//                CatBreedDTO(
//                    breed: "Persian",
//                    country: "Iran",
//                    origin: "Iran",
//                    coat: "Long",
//                    pattern: "Solid"
//                ),
//                CatBreedDTO(
//                    breed: "Siamese",
//                    country: "Thailand",
//                    origin: "Thailand",
//                    coat: "Short",
//                    pattern: "Pointed"
//                )
//            ],
//            last_page: 3,
//            current_page: 1
//        )
//        
//        mockAPIClient.responseToReturn = dto
//        mockAPIClient.shouldSucceed = true
//        
//        var resultResponse: CatBreedsResponse?
//        var resultError: Error?
//        
//        // When
//        sut.fetchBreeds(page: 1) { result in
//            switch result {
//            case .success(let response):
//                resultResponse = response
//            case .failure(let error):
//                resultError = error
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNil(resultError, "Should not have error")
//            XCTAssertNotNil(resultResponse, "Should have response")
//            
//            let breeds = resultResponse?.breeds ?? []
//            XCTAssertEqual(breeds.count, 2, "Should have 2 breeds")
//            
//            // First breed
//            XCTAssertEqual(breeds[0].name, "Persian")
//            XCTAssertEqual(breeds[0].country, "Iran")
//            XCTAssertEqual(breeds[0].origin, "Iran")
//            XCTAssertEqual(breeds[0].coat, "Long")
//            XCTAssertEqual(breeds[0].pattern, "Solid")
//            
//            // Second breed
//            XCTAssertEqual(breeds[1].name, "Siamese")
//            XCTAssertEqual(breeds[1].country, "Thailand")
//            
//            // Verify pagination
//            XCTAssertEqual(resultResponse?.pagination.currentPage, 1)
//            XCTAssertEqual(resultResponse?.pagination.lastPage, 3)
//            XCTAssertTrue(resultResponse?.pagination.hasMorePages ?? false)
//            
//            // Verify API was called with correct endpoint
//            XCTAssertEqual(self.mockAPIClient.requestCallCount, 1)
//            XCTAssertEqual(self.mockAPIClient.lastEndpoint?.path.pathURLString, "https://catfact.ninja/breeds")
//        }
//    }
//    
//    /// Test 2: fetchBreeds สำเร็จ แต่ได้ empty data - ควร return empty array
//    func testFetchBreeds_SuccessWithEmptyData_ShouldReturnEmptyArray() {
//        // Given
//        let expectation = self.expectation(description: "Empty data")
//        
//        let dto = CatBreedsResponseDTO(data: [], last_page: 1, current_page: 1)
//        
//        mockAPIClient.responseToReturn = dto
//        mockAPIClient.shouldSucceed = true
//        
//        var resultResponse: CatBreedsResponse?
//        
//        // When
//        sut.fetchBreeds { result in
//            if case .success(let response) = result {
//                resultResponse = response
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertEqual(resultResponse?.breeds.count, 0, "Should have 0 breeds")
//            XCTAssertEqual(self.mockAPIClient.requestCallCount, 1)
//        }
//    }
//    
//    /// Test 3: fetchBreeds สำเร็จ แต่บาง field เป็น nil - ควรใช้ default value "-"
//    func testFetchBreeds_SuccessWithNilFields_ShouldUseDefaultValues() {
//        // Given
//        let expectation = self.expectation(description: "Nil fields")
//        
//        let dto = CatBreedsResponseDTO(
//            data: [
//                CatBreedDTO(
//                    breed: nil,
//                    country: "Thailand",
//                    origin: nil,
//                    coat: "Short",
//                    pattern: nil
//                )
//            ],
//            last_page: 1,
//            current_page: 1
//        )
//        
//        mockAPIClient.responseToReturn = dto
//        mockAPIClient.shouldSucceed = true
//        
//        var resultResponse: CatBreedsResponse?
//        
//        // When
//        sut.fetchBreeds { result in
//            if case .success(let response) = result {
//                resultResponse = response
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertEqual(resultResponse?.breeds.count, 1)
//            
//            let breed = resultResponse?.breeds[0]
//            XCTAssertEqual(breed?.name, "-", "Nil breed should use default '-'")
//            XCTAssertEqual(breed?.country, "Thailand")
//            XCTAssertEqual(breed?.origin, "-", "Nil origin should use default '-'")
//            XCTAssertEqual(breed?.coat, "Short")
//            XCTAssertEqual(breed?.pattern, "-", "Nil pattern should use default '-'")
//        }
//    }
//    
//    /// Test 4: fetchBreeds สำเร็จ ด้วยข้อมูลหลายตัว
//    func testFetchBreeds_SuccessWithMultipleBreeds_ShouldReturnAll() {
//        // Given
//        let expectation = self.expectation(description: "Multiple breeds")
//        
//        let breeds = (1...10).map { i in
//            CatBreedDTO(
//                breed: "Breed\(i)",
//                country: "Country\(i)",
//                origin: "Origin\(i)",
//                coat: "Coat\(i)",
//                pattern: "Pattern\(i)"
//            )
//        }
//        let dto = CatBreedsResponseDTO(data: breeds, last_page: 2, current_page: 1)
//        
//        mockAPIClient.responseToReturn = dto
//        mockAPIClient.shouldSucceed = true
//        
//        var resultResponse: CatBreedsResponse?
//        
//        // When
//        sut.fetchBreeds { result in
//            if case .success(let response) = result {
//                resultResponse = response
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertEqual(resultResponse?.breeds.count, 10, "Should return all 10 breeds")
//            XCTAssertEqual(resultResponse?.breeds[0].name, "Breed1")
//            XCTAssertEqual(resultResponse?.breeds[9].name, "Breed10")
//        }
//    }
//    
//    /// Test 5: fetchBreeds กับ page parameter - ควรส่ง parameter ถูกต้อง
//    func testFetchBreeds_WithPageParameter_ShouldSendCorrectParameter() {
//        // Given
//        let expectation = self.expectation(description: "Page parameter")
//        
//        let dto = CatBreedsResponseDTO(data: [], last_page: 5, current_page: 3)
//        
//        mockAPIClient.responseToReturn = dto
//        mockAPIClient.shouldSucceed = true
//        
//        // When
//        sut.fetchBreeds(page: 3) { _ in
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            let parameters = self.mockAPIClient.lastEndpoint?.parameters as? [String: Int]
//            XCTAssertEqual(parameters?["page"], 3, "Should send page parameter")
//        }
//    }
//    
//    /// Test 6: fetchBreeds โดยไม่ระบุ page - ควรใช้ default page = 1
//    func testFetchBreeds_WithoutPageParameter_ShouldUseDefaultPage1() {
//        // Given
//        let expectation = self.expectation(description: "Default page")
//        
//        let dto = CatBreedsResponseDTO(data: [], last_page: 1, current_page: 1)
//        
//        mockAPIClient.responseToReturn = dto
//        mockAPIClient.shouldSucceed = true
//        
//        // When - ไม่ส่ง page parameter
//        sut.fetchBreeds { _ in
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            let parameters = self.mockAPIClient.lastEndpoint?.parameters as? [String: Int]
//            XCTAssertEqual(parameters?["page"], 1, "Should use default page 1")
//        }
//    }
//    
//    // MARK: - fetchBreeds Failure Tests
//    
//    /// Test 7: fetchBreeds ล้มเหลว - ควร return error
//    func testFetchBreeds_Failure_ShouldReturnError() {
//        // Given
//        let expectation = self.expectation(description: "Fetch breeds failure")
//        let expectedError = APIError.invalidURL
//        
//        mockAPIClient.shouldSucceed = false
//        mockAPIClient.errorToReturn = expectedError
//        
//        var resultError: Error?
//        
//        // When
//        sut.fetchBreeds { result in
//            if case .failure(let error) = result {
//                resultError = error
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNotNil(resultError, "Should have error")
//            XCTAssertTrue(resultError is APIError, "Should return APIError")
//            XCTAssertEqual(self.mockAPIClient.requestCallCount, 1)
//        }
//    }
//    
//    /// Test 8: fetchBreeds ล้มเหลว ด้วย network error
//    func testFetchBreeds_NetworkError_ShouldReturnError() {
//        // Given
//        let expectation = self.expectation(description: "Network error")
//        let networkError = NSError(
//            domain: NSURLErrorDomain,
//            code: NSURLErrorNotConnectedToInternet,
//            userInfo: [NSLocalizedDescriptionKey: "No internet connection"]
//        )
//        
//        mockAPIClient.shouldSucceed = false
//        mockAPIClient.errorToReturn = networkError
//        
//        var resultError: Error?
//        
//        // When
//        sut.fetchBreeds { result in
//            if case .failure(let error) = result {
//                resultError = error
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNotNil(resultError)
//            let nsError = resultError as NSError?
//            XCTAssertEqual(nsError?.code, NSURLErrorNotConnectedToInternet)
//        }
//    }
//    
//    /// Test 9: fetchBreeds ล้มเหลว ด้วย decoding error
//    func testFetchBreeds_DecodingError_ShouldReturnError() {
//        // Given
//        let expectation = self.expectation(description: "Decoding error")
//        
//        mockAPIClient.shouldSucceed = false
//        mockAPIClient.errorToReturn = APIError.decodingFailed
//        
//        var resultError: Error?
//        
//        // When
//        sut.fetchBreeds { result in
//            if case .failure(let error) = result {
//                resultError = error
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNotNil(resultError)
//            
//            if let apiError = resultError as? APIError {
//                switch apiError {
//                case .decodingFailed:
//                    XCTAssertTrue(true, "Should receive decoding failed error")
//                default:
//                    XCTFail("Expected decodingFailed error")
//                }
//            } else {
//                XCTFail("Expected APIError")
//            }
//        }
//    }
//    
//    // MARK: - Multiple Calls Tests
//    
//    /// Test 10: fetchBreeds หลายครั้งติดกัน - ควรจัดการได้
//    func testFetchBreeds_MultipleCalls_ShouldHandleCorrectly() {
//        // Given
//        let expectation1 = self.expectation(description: "First call")
//        let dto1 = CatBreedsResponseDTO(
//            data: [
//                CatBreedDTO(breed: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid")
//            ],
//            last_page: 1,
//            current_page: 1
//        )
//        
//        mockAPIClient.responseToReturn = dto1
//        mockAPIClient.shouldSucceed = true
//        
//        var result1: CatBreedsResponse?
//        
//        // When - First call
//        sut.fetchBreeds { result in
//            if case .success(let response) = result {
//                result1 = response
//            }
//            expectation1.fulfill()
//        }
//        
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertEqual(result1?.breeds[0].name, "Persian")
//        }
//        
//        // Given - Second call
//        let expectation2 = self.expectation(description: "Second call")
//        let dto2 = CatBreedsResponseDTO(
//            data: [
//                CatBreedDTO(breed: "Siamese", country: "Thailand", origin: "Thailand", coat: "Short", pattern: "Pointed")
//            ],
//            last_page: 1,
//            current_page: 1
//        )
//        
//        mockAPIClient.responseToReturn = dto2
//        
//        var result2: CatBreedsResponse?
//        
//        // When - Second call
//        sut.fetchBreeds { result in
//            if case .success(let response) = result {
//                result2 = response
//            }
//            expectation2.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertEqual(result2?.breeds[0].name, "Siamese")
//            XCTAssertEqual(self.mockAPIClient.requestCallCount, 2, "Should call API twice")
//        }
//    }
//    
//    /// Test 11: fetchBreeds สลับระหว่าง success และ failure
//    func testFetchBreeds_AlternatingSuccessAndFailure_ShouldHandleBoth() {
//        // Given - Success
//        let expectation1 = self.expectation(description: "Success call")
//        let dto = CatBreedsResponseDTO(
//            data: [
//                CatBreedDTO(breed: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid")
//            ],
//            last_page: 1,
//            current_page: 1
//        )
//        
//        mockAPIClient.responseToReturn = dto
//        mockAPIClient.shouldSucceed = true
//        
//        // When - Success call
//        sut.fetchBreeds { result in
//            if case .success = result {
//                expectation1.fulfill()
//            }
//        }
//        
//        wait(for: [expectation1], timeout: 1.0)
//        
//        // Given - Failure
//        let expectation2 = self.expectation(description: "Failure call")
//        
//        mockAPIClient.shouldSucceed = false
//        mockAPIClient.errorToReturn = APIError.noData
//        
//        // When - Failure call
//        sut.fetchBreeds { result in
//            if case .failure = result {
//                expectation2.fulfill()
//            }
//        }
//        
//        wait(for: [expectation2], timeout: 1.0)
//        
//        XCTAssertEqual(mockAPIClient.requestCallCount, 2)
//    }
//    
//    // MARK: - Data Mapping Tests
//    
//    /// Test 12: ตรวจสอบการ map ข้อมูลพิเศษ
//    func testFetchBreeds_WithSpecialCharacters_ShouldMapCorrectly() {
//        // Given
//        let expectation = self.expectation(description: "Special characters")
//        
//        let dto = CatBreedsResponseDTO(
//            data: [
//                CatBreedDTO(
//                    breed: "Müller's Cat 🐱",
//                    country: "Côte d'Ivoire",
//                    origin: "São Paulo",
//                    coat: "Short & Dense",
//                    pattern: "Striped/Spotted"
//                )
//            ],
//            last_page: 1,
//            current_page: 1
//        )
//        
//        mockAPIClient.responseToReturn = dto
//        mockAPIClient.shouldSucceed = true
//        
//        var resultResponse: CatBreedsResponse?
//        
//        // When
//        sut.fetchBreeds { result in
//            if case .success(let response) = result {
//                resultResponse = response
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            let breed = resultResponse?.breeds[0]
//            XCTAssertEqual(breed?.name, "Müller's Cat 🐱")
//            XCTAssertEqual(breed?.country, "Côte d'Ivoire")
//            XCTAssertEqual(breed?.origin, "São Paulo")
//            XCTAssertEqual(breed?.coat, "Short & Dense")
//            XCTAssertEqual(breed?.pattern, "Striped/Spotted")
//        }
//    }
//    
//    /// Test 13: ตรวจสอบการ map ข้อมูลที่มี empty string
//    func testFetchBreeds_WithEmptyStrings_ShouldMapEmptyStrings() {
//        // Given
//        let expectation = self.expectation(description: "Empty strings")
//        
//        let dto = CatBreedsResponseDTO(
//            data: [
//                CatBreedDTO(
//                    breed: "",
//                    country: "",
//                    origin: "",
//                    coat: "",
//                    pattern: ""
//                )
//            ],
//            last_page: 1,
//            current_page: 1
//        )
//        
//        mockAPIClient.responseToReturn = dto
//        mockAPIClient.shouldSucceed = true
//        
//        var resultResponse: CatBreedsResponse?
//        
//        // When
//        sut.fetchBreeds { result in
//            if case .success(let response) = result {
//                resultResponse = response
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            let breed = resultResponse?.breeds[0]
//            // Empty string should remain empty, not become "-"
//            XCTAssertEqual(breed?.name, "")
//            XCTAssertEqual(breed?.country, "")
//            XCTAssertEqual(breed?.origin, "")
//            XCTAssertEqual(breed?.coat, "")
//            XCTAssertEqual(breed?.pattern, "")
//        }
//    }
//    
//    // MARK: - Pagination Tests
//    
//    /// Test 14: ตรวจสอบ pagination - หน้าสุดท้าย
//    func testFetchBreeds_OnLastPage_ShouldIndicateNoMorePages() {
//        // Given
//        let expectation = self.expectation(description: "Last page")
//        
//        let dto = CatBreedsResponseDTO(
//            data: [
//                CatBreedDTO(breed: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid")
//            ],
//            last_page: 5,
//            current_page: 5
//        )
//        
//        mockAPIClient.responseToReturn = dto
//        mockAPIClient.shouldSucceed = true
//        
//        var resultResponse: CatBreedsResponse?
//        
//        // When
//        sut.fetchBreeds(page: 5) { result in
//            if case .success(let response) = result {
//                resultResponse = response
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertEqual(resultResponse?.pagination.currentPage, 5)
//            XCTAssertEqual(resultResponse?.pagination.lastPage, 5)
//            XCTAssertFalse(resultResponse?.pagination.hasMorePages ?? true, "Should not have more pages")
//        }
//    }
//    
//    /// Test 15: ตรวจสอบ pagination - มีหน้าถัดไป
//    func testFetchBreeds_HasMorePages_ShouldIndicateMorePages() {
//        // Given
//        let expectation = self.expectation(description: "Has more pages")
//        
//        let dto = CatBreedsResponseDTO(
//            data: [
//                CatBreedDTO(breed: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid")
//            ],
//            last_page: 10,
//            current_page: 3
//        )
//        
//        mockAPIClient.responseToReturn = dto
//        mockAPIClient.shouldSucceed = true
//        
//        var resultResponse: CatBreedsResponse?
//        
//        // When
//        sut.fetchBreeds(page: 3) { result in
//            if case .success(let response) = result {
//                resultResponse = response
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertEqual(resultResponse?.pagination.currentPage, 3)
//            XCTAssertEqual(resultResponse?.pagination.lastPage, 10)
//            XCTAssertTrue(resultResponse?.pagination.hasMorePages ?? false, "Should have more pages")
//        }
//    }
//    
//    // MARK: - API Endpoint Tests
//    
//    /// Test 16: ตรวจสอบว่า endpoint ถูกต้อง
//    func testFetchBreeds_ShouldUseCorrectEndpoint() {
//        // Given
//        let expectation = self.expectation(description: "Endpoint check")
//        
//        let dto = CatBreedsResponseDTO(data: [], last_page: 1, current_page: 1)
//        
//        mockAPIClient.responseToReturn = dto
//        mockAPIClient.shouldSucceed = true
//        
//        // When
//        sut.fetchBreeds { _ in
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNotNil(self.mockAPIClient.lastEndpoint)
//            XCTAssertEqual(self.mockAPIClient.lastEndpoint?.path.pathURLString, "https://catfact.ninja/breeds")
//        }
//    }
//    
//    // MARK: - Performance Tests
//    
//    /// Test 17: fetchBreeds กับข้อมูลจำนวนมาก
//    func testFetchBreeds_WithLargeDataSet_ShouldHandleEfficiently() {
//        // Given
//        let expectation = self.expectation(description: "Large dataset")
//        
//        // 1000 breeds
//        let breeds = (1...1000).map { i in
//            CatBreedDTO(
//                breed: "Breed\(i)",
//                country: "Country\(i)",
//                origin: "Origin\(i)",
//                coat: "Coat\(i)",
//                pattern: "Pattern\(i)"
//            )
//        }
//        let dto = CatBreedsResponseDTO(data: breeds, last_page: 10, current_page: 5)
//        
//        mockAPIClient.responseToReturn = dto
//        mockAPIClient.shouldSucceed = true
//        
//        var resultResponse: CatBreedsResponse?
//        
//        // When
//        let startTime = Date()
//        sut.fetchBreeds { result in
//            if case .success(let response) = result {
//                resultResponse = response
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 2.0) { _ in
//            let elapsedTime = Date().timeIntervalSince(startTime)
//            
//            XCTAssertEqual(resultResponse?.breeds.count, 1000, "Should handle 1000 breeds")
//            XCTAssertLessThan(elapsedTime, 2.0, "Should complete within 2 seconds")
//        }
//    }
}
