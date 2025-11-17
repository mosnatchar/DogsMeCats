//
//  DogsWorkerTests.swift
//  DogMeCatTests
//
//  Created on 15/11/2568 BE.
//

import XCTest
@testable import DogMeCat

class DogsMockAPIClient: APIClientProtocol {
    
    var shouldSucceed = true
    var responseToReturn: DogImageResponseDTO?
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


final class DogsWorkerTests: XCTestCase {
    
    // System Under Test
    var sut: DogsWorker!
    
    // Test Doubles
    var mockAPIClient: DogsMockAPIClient!
    
    // MARK: - Setup & Teardowntype
    
    override func setUp() {
        super.setUp()
        
        mockAPIClient = DogsMockAPIClient()
        sut = DogsWorker(apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        sut = nil
        mockAPIClient = nil
        
        super.tearDown()
    }
    
    func testFetchDogsConcurrentSuccess() {
        let expectation = self.expectation(description: "Fetch dogs concurrent")
        mockAPIClient.shouldSucceed = true
        mockAPIClient.responseToReturn = DogImageResponseDTO(message:"https://images.dog.ceo/breeds/husky/1.jpg",status: "")
        var resultImages: [DogImage]?
        
        sut.fetchDogsConcurrent(count: 3) { result in
            switch result {
            case .success(let images):
                resultImages = images
            case .failure(_):
                break
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            XCTAssertNotNil(resultImages, "Should have images")
            XCTAssertEqual(resultImages?.count, 3, "Should have 3 images")
        }
    }
    
    func testFetchDogsConcurrentFailure() {
        let expectation = self.expectation(description: "Fetch dogs concurrent")
        mockAPIClient.shouldSucceed = false
        var resultError: Error?
        
        sut.fetchDogsConcurrent(count: 3) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                resultError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            XCTAssertNotNil(resultError, "Should have images")
        }
    }
    
    func testFetchDogsSequentialSuccess() {
        let expectation = self.expectation(description: "Fetch dogs concurrent")
        mockAPIClient.shouldSucceed = true
        mockAPIClient.responseToReturn = DogImageResponseDTO(message:"https://images.dog.ceo/breeds/husky/1.jpg",status: "")
        var resultImages: [DogImage]?
        
        sut.fetchDogsSequential(count: 3, delaySeconds: 0 ) { result in
            switch result {
            case .success(let images):
                resultImages = images
            case .failure(_):
                break
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            XCTAssertNotNil(resultImages, "Should have images")
            XCTAssertEqual(resultImages?.count, 3, "Should have 3 images")
        }
    }
    
    func testFetchDogsSequentialFailure() {
        let expectation = self.expectation(description: "Fetch dogs concurrent")
        mockAPIClient.shouldSucceed = false
        var resultError: Error?
        
        sut.fetchDogsSequential(count: 3, delaySeconds: 0 ) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                resultError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            XCTAssertNotNil(resultError, "Should have images")
        }
    }
    
    // MARK: - AI fetchDogsConcurrent Tests
    
    /// Test 1: fetchDogsConcurrent สำเร็จ - ควรได้ DogImage ครบตามจำนวน
//    func testFetchDogsConcurrent_Success_ShouldReturnCorrectNumberOfImages() {
//        // Given
//        let expectation = self.expectation(description: "Fetch dogs concurrent")
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseURLs = [
//            "https://images.dog.ceo/breeds/husky/1.jpg",
//            "https://images.dog.ceo/breeds/husky/2.jpg",
//            "https://images.dog.ceo/breeds/husky/3.jpg"
//        ]
//        
//        var resultImages: [DogImage]?
//        var resultError: Error?
//        
//        // When
//        sut.fetchDogsConcurrent(count: 3) { result in
//            switch result {
//            case .success(let images):
//                resultImages = images
//            case .failure(let error):
//                resultError = error
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNil(resultError, "Should not have error")
//            XCTAssertNotNil(resultImages, "Should have images")
//            XCTAssertEqual(resultImages?.count, 3, "Should have 3 images")
//            XCTAssertEqual(resultImages?[0].url.absoluteString, "https://images.dog.ceo/breeds/husky/1.jpg")
//            XCTAssertEqual(resultImages?[1].url.absoluteString, "https://images.dog.ceo/breeds/husky/2.jpg")
//            XCTAssertEqual(resultImages?[2].url.absoluteString, "https://images.dog.ceo/breeds/husky/3.jpg")
//        }
//    }
//    
//    /// Test 2: fetchDogsConcurrent ล้มเหลว - ควรได้ error
//    func testFetchDogsConcurrent_Failure_ShouldReturnError() {
//        // Given
//        let expectation = self.expectation(description: "Fetch dogs concurrent failure")
//        mockAPIClient.shouldSucceed = false
//        mockAPIClient.errorToReturn = NSError(domain: "TestError", code: 500, userInfo: nil)
//        
//        var resultImages: [DogImage]?
//        var resultError: Error?
//        
//        // When
//        sut.fetchDogsConcurrent(count: 3) { result in
//            switch result {
//            case .success(let images):
//                resultImages = images
//            case .failure(let error):
//                resultError = error
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNotNil(resultError, "Should have error")
//            XCTAssertNil(resultImages, "Should not have images")
//            XCTAssertEqual((resultError as? NSError)?.domain, "TestError")
//        }
//    }
//    
//    /// Test 3: fetchDogsConcurrent ด้วย count = 1
//    func testFetchDogsConcurrent_WithCount1_ShouldReturnOneImage() {
//        // Given
//        let expectation = self.expectation(description: "Fetch one dog")
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseURLs = ["https://images.dog.ceo/breeds/husky/1.jpg"]
//        
//        var resultImages: [DogImage]?
//        
//        // When
//        sut.fetchDogsConcurrent(count: 1) { result in
//            if case .success(let images) = result {
//                resultImages = images
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertEqual(resultImages?.count, 1)
//        }
//    }
//    
//    /// Test 4: fetchDogsConcurrent ด้วย count = 5
//    func testFetchDogsConcurrent_WithCount5_ShouldReturnFiveImages() {
//        // Given
//        let expectation = self.expectation(description: "Fetch five dogs")
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseURLs = [
//            "https://images.dog.ceo/breeds/husky/1.jpg",
//            "https://images.dog.ceo/breeds/husky/2.jpg",
//            "https://images.dog.ceo/breeds/husky/3.jpg",
//            "https://images.dog.ceo/breeds/husky/4.jpg",
//            "https://images.dog.ceo/breeds/husky/5.jpg"
//        ]
//        
//        var resultImages: [DogImage]?
//        
//        // When
//        sut.fetchDogsConcurrent(count: 5) { result in
//            if case .success(let images) = result {
//                resultImages = images
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertEqual(resultImages?.count, 5)
//        }
//    }
//    
//    /// Test 5: fetchDogsConcurrent ควรเรียก API ถูกจำนวน
//    func testFetchDogsConcurrent_ShouldCallAPICorrectNumberOfTimes() {
//        // Given
//        let expectation = self.expectation(description: "API call count")
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseURLs = ["url1", "url2", "url3"]
//        
//        // When
//        sut.fetchDogsConcurrent(count: 3) { _ in
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertEqual(self.mockAPIClient.requestCallCount, 3, "Should call API 3 times")
//        }
//    }
//    
//    /// Test 6: fetchDogsConcurrent บางรายการสำเร็จ บางล้มเหลว - ควรได้ผลลัพธ์ที่สำเร็จ
//    func testFetchDogsConcurrent_PartialSuccess_ShouldReturnSuccessfulResults() {
//        // Given
//        let expectation = self.expectation(description: "Partial success")
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.partialFailureIndices = [1] // Index 1 will fail
//        mockAPIClient.responseURLs = [
//            "https://images.dog.ceo/breeds/husky/1.jpg",
//            "invalid-url", // Will be skipped
//            "https://images.dog.ceo/breeds/husky/3.jpg"
//        ]
//        
//        var resultImages: [DogImage]?
//        
//        // When
//        sut.fetchDogsConcurrent(count: 3) { result in
//            if case .success(let images) = result {
//                resultImages = images
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            // Should still succeed with partial results
//            XCTAssertEqual(resultImages?.count, 2, "Should have 2 successful images")
//        }
//    }
//    
//    /// Test 7: fetchDogsConcurrent ด้วย invalid URL - ควรข้ามไป
//    func testFetchDogsConcurrent_WithInvalidURL_ShouldSkipIt() {
//        // Given
//        let expectation = self.expectation(description: "Invalid URL")
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseURLs = [
//            "https://images.dog.ceo/breeds/husky/1.jpg",
//            "not a valid url",
//            "https://images.dog.ceo/breeds/husky/3.jpg"
//        ]
//        
//        var resultImages: [DogImage]?
//        
//        // When
//        sut.fetchDogsConcurrent(count: 3) { result in
//            if case .success(let images) = result {
//                resultImages = images
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            // Invalid URL should be filtered out
//            XCTAssertLessThanOrEqual(resultImages?.count ?? 0, 3)
//        }
//    }
//    
//    // MARK: - fetchDogsSequential Tests
//    
//    /// Test 8: fetchDogsSequential สำเร็จ - ควรได้ DogImage ครบตามจำนวน
//    func testFetchDogsSequential_Success_ShouldReturnCorrectNumberOfImages() {
//        // Given
//        let expectation = self.expectation(description: "Fetch dogs sequential")
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseURLs = [
//            "https://images.dog.ceo/breeds/husky/1.jpg",
//            "https://images.dog.ceo/breeds/husky/2.jpg",
//            "https://images.dog.ceo/breeds/husky/3.jpg"
//        ]
//        
//        var resultImages: [DogImage]?
//        var resultError: Error?
//        
//        // When
//        sut.fetchDogsSequential(count: 3, delaySeconds: 0) { result in
//            switch result {
//            case .success(let images):
//                resultImages = images
//            case .failure(let error):
//                resultError = error
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 2.0) { _ in
//            XCTAssertNil(resultError, "Should not have error")
//            XCTAssertNotNil(resultImages, "Should have images")
//            XCTAssertEqual(resultImages?.count, 3, "Should have 3 images")
//        }
//    }
//    
//    /// Test 9: fetchDogsSequential ล้มเหลว - ควรหยุดทันทีและ return error
//    func testFetchDogsSequential_Failure_ShouldStopAndReturnError() {
//        // Given
//        let expectation = self.expectation(description: "Sequential failure")
//        mockAPIClient.shouldSucceed = false
//        mockAPIClient.errorToReturn = NSError(domain: "TestError", code: 404, userInfo: nil)
//        
//        var resultError: Error?
//        
//        // When
//        sut.fetchDogsSequential(count: 3, delaySeconds: 0) { result in
//            if case .failure(let error) = result {
//                resultError = error
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNotNil(resultError, "Should have error")
//            XCTAssertEqual((resultError as? NSError)?.code, 404)
//        }
//    }
//    
//    /// Test 10: fetchDogsSequential ควรเรียก API ทีละครั้ง
//    func testFetchDogsSequential_ShouldCallAPIOneAtATime() {
//        // Given
//        let expectation = self.expectation(description: "Sequential API calls")
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseURLs = ["url1", "url2", "url3"]
//        
//        // When
//        sut.fetchDogsSequential(count: 3, delaySeconds: 0) { _ in
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 2.0) { _ in
//            XCTAssertEqual(self.mockAPIClient.requestCallCount, 3, "Should call API 3 times")
//        }
//    }
//    
//    /// Test 11: fetchDogsSequential ด้วย delay - ควรใช้เวลามากกว่า concurrent
//    func testFetchDogsSequential_WithDelay_ShouldTakeLongerTime() {
//        // Given
//        let expectation = self.expectation(description: "Sequential with delay")
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseURLs = ["url1", "url2"]
//        
//        let startTime = Date()
//        var endTime: Date?
//        
//        // When - Use 0 second delay for testing (ในการใช้งานจริงจะใช้ 2-3 วินาที)
//        sut.fetchDogsSequential(count: 2, delaySeconds: 0) { _ in
//            endTime = Date()
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 3.0) { _ in
//            if let endTime = endTime {
//                let elapsed = endTime.timeIntervalSince(startTime)
//                // With 0 delay, should be very quick
//                XCTAssertLessThan(elapsed, 1.0, "Should complete quickly with 0 delay")
//            }
//        }
//    }
//    
//    /// Test 12: fetchDogsSequential รายการแรกล้มเหลว - ไม่ควรดึงรายการถัดไป
//    func testFetchDogsSequential_FirstRequestFails_ShouldNotFetchNext() {
//        // Given
//        let expectation = self.expectation(description: "First request fails")
//        mockAPIClient.shouldSucceed = false
//        mockAPIClient.errorToReturn = NSError(domain: "TestError", code: 500, userInfo: nil)
//        
//        // When
//        sut.fetchDogsSequential(count: 3, delaySeconds: 0) { _ in
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            // Should only call API once since first request failed
//            XCTAssertEqual(self.mockAPIClient.requestCallCount, 1, "Should only call API once")
//        }
//    }
//    
//    /// Test 13: fetchDogsSequential ด้วย count = 1 - ไม่ควรมี delay
//    func testFetchDogsSequential_WithCount1_ShouldNotDelay() {
//        // Given
//        let expectation = self.expectation(description: "One request no delay")
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseURLs = ["url1"]
//        
//        let startTime = Date()
//        var endTime: Date?
//        
//        // When
//        sut.fetchDogsSequential(count: 1, delaySeconds: 2) { _ in
//            endTime = Date()
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            if let endTime = endTime {
//                let elapsed = endTime.timeIntervalSince(startTime)
//                // Should complete quickly without delay since only 1 request
//                XCTAssertLessThan(elapsed, 1.0)
//            }
//        }
//    }
//    
//    /// Test 14: fetchDogsSequential ด้วย invalid URL ตัวกลาง - ควรยังดำเนินการต่อ
//    func testFetchDogsSequential_WithInvalidURLInMiddle_ShouldContinue() {
//        // Given
//        let expectation = self.expectation(description: "Invalid URL in middle")
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseURLs = [
//            "https://images.dog.ceo/breeds/husky/1.jpg",
//            "not-valid-url",
//            "https://images.dog.ceo/breeds/husky/3.jpg"
//        ]
//        
//        var resultImages: [DogImage]?
//        
//        // When
//        sut.fetchDogsSequential(count: 3, delaySeconds: 0) { result in
//            if case .success(let images) = result {
//                resultImages = images
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 2.0) { _ in
//            // Should continue and get valid URLs
//            XCTAssertNotNil(resultImages)
//        }
//    }
//    
//    // MARK: - Comparison Tests
//    
//    /// Test 15: concurrent vs sequential - concurrent ควรเร็วกว่า
//    func testConcurrentVsSequential_ConcurrentShouldBeFaster() {
//        // Given
//        let concurrentExpectation = self.expectation(description: "Concurrent")
//        let sequentialExpectation = self.expectation(description: "Sequential")
//        
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseURLs = ["url1", "url2", "url3"]
//        
//        var concurrentTime: TimeInterval = 0
//        var sequentialTime: TimeInterval = 0
//        
//        // When - Concurrent
//        let concurrentStart = Date()
//        sut.fetchDogsConcurrent(count: 3) { _ in
//            concurrentTime = Date().timeIntervalSince(concurrentStart)
//            concurrentExpectation.fulfill()
//        }
//        
//        wait(for: [concurrentExpectation], timeout: 2.0)
//        
//        // When - Sequential
//        let sequentialStart = Date()
//        sut.fetchDogsSequential(count: 3, delaySeconds: 0) { _ in
//            sequentialTime = Date().timeIntervalSince(sequentialStart)
//            sequentialExpectation.fulfill()
//        }
//        
//        // Then
//        wait(for: [sequentialExpectation], timeout: 3.0)
//        
//        // Note: In real scenario with actual delays, concurrent would be much faster
//        // Here we just verify both complete
//        XCTAssertGreaterThan(concurrentTime, 0)
//        XCTAssertGreaterThan(sequentialTime, 0)
//    }
//    
//    // MARK: - Edge Cases
//    
//    /// Test 16: fetchDogsConcurrent ด้วย count = 0
//    func testFetchDogsConcurrent_WithCount0_ShouldReturnEmptyArray() {
//        // Given
//        let expectation = self.expectation(description: "Count zero")
//        mockAPIClient.shouldSucceed = true
//        
//        var resultImages: [DogImage]?
//        
//        // When
//        sut.fetchDogsConcurrent(count: 0) { result in
//            if case .success(let images) = result {
//                resultImages = images
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertEqual(resultImages?.count, 0, "Should return empty array")
//            XCTAssertEqual(self.mockAPIClient.requestCallCount, 0, "Should not call API")
//        }
//    }
//    
//    /// Test 17: fetchDogsSequential ด้วย count = 0
//    func testFetchDogsSequential_WithCount0_ShouldReturnEmptyArray() {
//        // Given
//        let expectation = self.expectation(description: "Count zero")
//        mockAPIClient.shouldSucceed = true
//        
//        var resultImages: [DogImage]?
//        
//        // When
//        sut.fetchDogsSequential(count: 0, delaySeconds: 0) { result in
//            if case .success(let images) = result {
//                resultImages = images
//            }
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertEqual(resultImages?.count, 0, "Should return empty array")
//            XCTAssertEqual(self.mockAPIClient.requestCallCount, 0, "Should not call API")
//        }
//    }
//    
//    /// Test 18: ตรวจสอบว่า endpoint ที่ใช้ถูกต้อง
//    func testAPIEndpoint_ShouldUseCorrectPath() {
//        // Given
//        let expectation = self.expectation(description: "Endpoint check")
//        mockAPIClient.shouldSucceed = true
//        mockAPIClient.responseURLs = ["url1"]
//        
//        // When
//        sut.fetchDogsConcurrent(count: 1) { _ in
//            expectation.fulfill()
//        }
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNotNil(self.mockAPIClient.lastEndpoint)
//            XCTAssertEqual(self.mockAPIClient.lastEndpoint?.path.pathURLString, "https://dog.ceo/api/breeds/image/random")
//        }
//    }
}

// MARK: - Mock API Client

//class DogsMockAPIClient: APIClientProtocol {
//    
//    var requestCallCount = 0
//    var lastEndpoint: APIEndpoint?
//    var shouldSucceed = true
//    var responseURLs: [String] = []
//    var errorToReturn: Error?
//    var partialFailureIndices: [Int] = []
//    
//    private var currentIndex = 0
//    
//    func request<T: Decodable>(
//        _ endpoint: APIEndpoint,
//        completion: @escaping (Result<T, Error>) -> Void
//    ) {
//        lastEndpoint = endpoint
//        let currentRequestIndex = requestCallCount
//        requestCallCount += 1
//        
//        // Simulate async behavior
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            
//            // Check if this is a general failure (all requests fail)
//            if !self.shouldSucceed {
//                let error = self.errorToReturn ?? NSError(domain: "MockError", code: 500, userInfo: nil)
//                completion(.failure(error))
//                return
//            }
//            
//            // Check if this specific request should fail (partial failure)
//            if self.partialFailureIndices.contains(currentRequestIndex) {
//                let error = self.errorToReturn ?? NSError(domain: "MockError", code: 500, userInfo: nil)
//                completion(.failure(error))
//                return
//            }
//            
//            // Success case
//            if T.self == DogImageResponseDTO.self {
//                // Use responseURLs if available
//                if currentRequestIndex < self.responseURLs.count {
//                    let urlString = self.responseURLs[currentRequestIndex]
//                    let dto = DogImageResponseDTO(message: urlString, status: "success")
//                    completion(.success(dto as! T))
//                } else {
//                    // Fallback to default URL
//                    let dto = DogImageResponseDTO(message: "https://default.com/dog.jpg", status: "success")
//                    completion(.success(dto as! T))
//                }
//            } else {
//                completion(.failure(NSError(domain: "MockError", code: 400, userInfo: nil)))
//            }
//        }
//    }
//}
