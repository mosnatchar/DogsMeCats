//
//  CatsInteractorTests.swift
//  DogMeCatTests
//
//  Created on 15/11/2568 BE.
//

import XCTest
@testable import DogMeCat

class MockCatsPresenter: CatsPresentationLogic {

    var lastPresentedResponse: Cats.Load.Response?
    var lastPresentedToggleResponse: Cats.Toggle.Response?
    var lastPresentedError: Error?
    var lastPresentpLoading: Bool?
    
    var onPresentBreeds: ((Cats.Load.Response) -> Void)?
    
    func presentBreeds(response: Cats.Load.Response) {
        lastPresentedResponse = response
        onPresentBreeds?(response)
    }

    func presentToggle(response: Cats.Toggle.Response) {
        lastPresentedToggleResponse = response
    }

    func presentLoading(isLoading: Bool) {
        lastPresentpLoading = isLoading
    }

    func presentError(error: Error) {
        lastPresentedError = error
    }
}

class MockCatsWorker: CatsWorkerProtocol {
    
    var mockResult: Result<CatBreedsResponse, Error>?
    var fetchBreedsCalled = false
    var lastRequestedPage: Int?
    
    func fetchBreeds(page: Int, completion: @escaping (Result<CatBreedsResponse, Error>) -> Void) {
        fetchBreedsCalled = true
        lastRequestedPage = page
        
        if let result = mockResult {
            // Simulate async behavior
            DispatchQueue.global().async {
                completion(result)
            }
        }
    }
}
    

final class CatsInteractorTests: XCTestCase {
    
    // System Under Test
    var sut: CatsInteractor!
    
    // Test Doubles
    var mockPresenter: MockCatsPresenter!
    var mockWorker: MockCatsWorker!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        
        mockPresenter = MockCatsPresenter()
        mockWorker = MockCatsWorker()
        
        sut = CatsInteractor(worker: mockWorker)
        sut.presenter = mockPresenter
    }
    
    override func tearDown() {
        sut = nil
        mockPresenter = nil
        mockWorker = nil
        
        super.tearDown()
    }
    
    func testLoadBreeds() {
        let expectedBreeds = [
            CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid"),
            CatBreed(name: "Siamese", country: "Thailand", origin: "Thailand", coat: "Short", pattern: "Pointed")
        ]
        
        let pagination = CatBreedsPagination(currentPage: 1, lastPage: 3)
        let response = CatBreedsResponse(breeds: expectedBreeds, pagination: pagination)
        mockWorker.mockResult = .success(response)
        let expectation = self.expectation(description: "fetch Cats")
        sut.loadBreeds(request: Cats.Load.Request())
        mockPresenter.onPresentBreeds = { response in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) {_ in
            XCTAssertNotNil(self.mockPresenter.lastPresentedResponse, "Should present breeds response")
        }
    }
    
    func testLoadMoreBreeds() {
        let page1Breeds = [
            CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid")
        ]
        
        let pagination1 = CatBreedsPagination(currentPage: 1, lastPage: 3)
        let response = CatBreedsResponse(breeds: page1Breeds, pagination: pagination1)
        mockWorker.mockResult = .success(response)
        
        let expectation1 = expectation(description: "Load page 1")
        mockPresenter.onPresentBreeds = { _ in expectation1.fulfill() }
        sut.loadBreeds(request: Cats.Load.Request())
        wait(for: [expectation1], timeout: 1.0)
        
        let page2Breeds = [
            CatBreed(name: "Siamese", country: "Thailand", origin: "Thailand", coat: "Short", pattern: "Pointed")
        ]
        let pagination2 = CatBreedsPagination(currentPage: 2, lastPage: 3)
        let response2 = CatBreedsResponse(breeds: page2Breeds, pagination: pagination2)
        mockWorker.mockResult = .success(response2)
        
        let expectation2 = expectation(description: "Load page 2")
        mockPresenter.onPresentBreeds = { _ in expectation2.fulfill() }
        sut.loadMoreBreeds(request: Cats.Load.Request(page: 2))
        wait(for: [expectation2], timeout: 1.0)

        XCTAssertNotNil(self.mockPresenter.lastPresentedResponse, "Should present breeds response")
    }
    
    // MARK: - AI Load Breeds Tests
//    func testLoadBreeds_Success_ShouldPresentBreeds() {
//        // Given
//        let expectedBreeds = [
//            CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid"),
//            CatBreed(name: "Siamese", country: "Thailand", origin: "Thailand", coat: "Short", pattern: "Pointed")
//        ]
//        let pagination = CatBreedsPagination(currentPage: 1, lastPage: 3)
//        let response = CatBreedsResponse(breeds: expectedBreeds, pagination: pagination)
//        mockWorker.mockResult = .success(response)
//        
//        let expectation = expectation(description: "Wait for async completion")
//        mockPresenter.onPresentBreeds = { response in
//            expectation.fulfill()
//        }
//        
//        // When
//        sut.loadBreeds(request: Cats.Load.Request())
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            // Verify loading states
//            XCTAssertTrue(self.mockPresenter.presentLoadingCalledWith.contains(true), 
//                         "Should present loading = true")
//            XCTAssertTrue(self.mockPresenter.presentLoadingCalledWith.contains(false), 
//                         "Should present loading = false")
//            
//            // Verify worker was called
//            XCTAssertTrue(self.mockWorker.fetchBreedsCalled, "Should call fetchBreeds on worker")
//            
//            // Verify presenter received correct data
//            XCTAssertNotNil(self.mockPresenter.lastPresentedResponse, "Should present breeds response")
//            XCTAssertEqual(self.mockPresenter.lastPresentedResponse?.breeds.count, 2, "Should have 2 breeds")
//            XCTAssertEqual(self.mockPresenter.lastPresentedResponse?.breeds.first?.name, "Persian")
//            XCTAssertNil(self.mockPresenter.lastPresentedResponse?.selectedIndex, "No breed selected initially")
//            XCTAssertEqual(self.mockPresenter.lastPresentedResponse?.pagination.currentPage, 1)
//        }
//    }
//    
//    /// Test 2: loadBreeds ล้มเหลว - ควรเรียก presentError
//    func testLoadBreeds_Failure_ShouldPresentError() {
//        // Given
//        let expectedError = NSError(domain: "TestError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not found"])
//        mockWorker.mockResult = .failure(expectedError)
//        
//        let expectation = expectation(description: "Wait for async completion")
//        mockPresenter.onPresentError = { error in
//            expectation.fulfill()
//        }
//        
//        // When
//        sut.loadBreeds(request: Cats.Load.Request())
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            // Verify loading states
//            XCTAssertTrue(self.mockPresenter.presentLoadingCalledWith.contains(true))
//            XCTAssertTrue(self.mockPresenter.presentLoadingCalledWith.contains(false))
//            
//            // Verify error was presented
//            XCTAssertNotNil(self.mockPresenter.lastPresentedError, "Should present error")
//            XCTAssertEqual((self.mockPresenter.lastPresentedError as NSError?)?.code, 404)
//            
//            // Verify breeds were NOT presented
//            XCTAssertNil(self.mockPresenter.lastPresentedResponse, "Should not present breeds on error")
//        }
//    }
//    
//    /// Test 3: loadBreeds หลายครั้ง - ควรจัดการได้ถูกต้อง
//    func testLoadBreeds_MultipleCall_ShouldHandleCorrectly() {
//        // Given
//        let breeds1 = [CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid")]
//        let pagination1 = CatBreedsPagination(currentPage: 1, lastPage: 2)
//        let response1 = CatBreedsResponse(breeds: breeds1, pagination: pagination1)
//        
//        let breeds2 = [CatBreed(name: "Siamese", country: "Thailand", origin: "Thailand", coat: "Short", pattern: "Pointed")]
//        let pagination2 = CatBreedsPagination(currentPage: 1, lastPage: 1)
//        let response2 = CatBreedsResponse(breeds: breeds2, pagination: pagination2)
//        
//        mockWorker.mockResult = .success(response1)
//        
//        let expectation1 = expectation(description: "First call")
//        mockPresenter.onPresentBreeds = { _ in expectation1.fulfill() }
//        
//        // When - First call
//        sut.loadBreeds(request: Cats.Load.Request())
//        
//        wait(for: [expectation1], timeout: 1.0)
//        
//        // Then - Verify first call
//        XCTAssertEqual(mockPresenter.lastPresentedResponse?.breeds.first?.name, "Persian")
//        
//        // Given - Second call with different data
//        mockWorker.mockResult = .success(response2)
//        let expectation2 = expectation(description: "Second call")
//        mockPresenter.onPresentBreeds = { _ in expectation2.fulfill() }
//        
//        // When - Second call
//        sut.loadBreeds(request: Cats.Load.Request())
//        
//        wait(for: [expectation2], timeout: 1.0)
//        
//        // Then - Verify second call updates data
//        XCTAssertEqual(mockPresenter.lastPresentedResponse?.breeds.first?.name, "Siamese")
//    }
//    
//    /// Test 4: loadBreeds ด้วย empty data - ควรจัดการได้
//    func testLoadBreeds_EmptyData_ShouldPresentEmptyBreeds() {
//        // Given
//        let pagination = CatBreedsPagination(currentPage: 1, lastPage: 1)
//        let response = CatBreedsResponse(breeds: [], pagination: pagination)
//        mockWorker.mockResult = .success(response)
//        
//        let expectation = expectation(description: "Wait for async completion")
//        mockPresenter.onPresentBreeds = { _ in expectation.fulfill() }
//        
//        // When
//        sut.loadBreeds(request: Cats.Load.Request())
//        
//        // Then
//        waitForExpectations(timeout: 1.0) { _ in
//            XCTAssertNotNil(self.mockPresenter.lastPresentedResponse)
//            XCTAssertEqual(self.mockPresenter.lastPresentedResponse?.breeds.count, 0, "Should have 0 breeds")
//        }
//    }
//    
//    // MARK: - Toggle Breed Tests
//    
//    /// Test 5: toggleBreed ครั้งแรก - ควร expand breed นั้น
//    func testToggleBreed_FirstTime_ShouldExpandBreed() {
//        // Given - Load breeds first
//        setupBreedsData()
//        
//        // When - Toggle first breed
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 0))
//        
//        // Then
//        XCTAssertNotNil(mockPresenter.lastPresentedToggleResponse, "Should present toggle response")
//        XCTAssertEqual(mockPresenter.lastPresentedToggleResponse?.selectedIndex, 0, "Should select index 0")
//    }
//    
//    /// Test 6: toggleBreed เดิมซ้ำ - ควร collapse
//    func testToggleBreed_SameIndex_ShouldCollapse() {
//        // Given - Load breeds and expand one
//        setupBreedsData()
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 0))
//        XCTAssertEqual(mockPresenter.lastPresentedToggleResponse?.selectedIndex, 0)
//        
//        // When - Toggle same breed again
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 0))
//        
//        // Then - Should collapse (selectedIndex = nil)
//        XCTAssertNotNil(mockPresenter.lastPresentedToggleResponse)
//        XCTAssertNil(mockPresenter.lastPresentedToggleResponse?.selectedIndex, "Should deselect")
//    }
//    
//    /// Test 7: toggleBreed ต่างตัว - ควรเปลี่ยนไปตัวใหม่
//    func testToggleBreed_DifferentIndex_ShouldSelectNewOne() {
//        // Given - Load breeds and expand first one
//        setupBreedsData()
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 0))
//        XCTAssertEqual(mockPresenter.lastPresentedToggleResponse?.selectedIndex, 0)
//        
//        // When - Toggle different breed
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 1))
//        
//        // Then - Should switch to index 1 (only one expanded at a time)
//        XCTAssertNotNil(mockPresenter.lastPresentedToggleResponse)
//        XCTAssertEqual(mockPresenter.lastPresentedToggleResponse?.selectedIndex, 1, 
//                      "Should switch to index 1")
//    }
//    
//    /// Test 8: toggleBreed ก่อนโหลดข้อมูล - ไม่ควร crash
//    func testToggleBreed_BeforeLoadingData_ShouldNotCrash() {
//        // Given - No breeds loaded
//        
//        // When - Try to toggle
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 0))
//        
//        // Then - Should not crash, should not call presenter
//        XCTAssertNil(mockPresenter.lastPresentedToggleResponse, 
//                    "Should not present when no breeds available")
//    }
//    
//    /// Test 9: toggleBreed หลายครั้งติดกัน
//    func testToggleBreed_RapidToggling_ShouldHandleCorrectly() {
//        // Given
//        setupBreedsData()
//        
//        // When - Toggle multiple times rapidly
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 0))
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 1))
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 2))
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 1))
//        
//        // Then - Should end with index 1 selected
//        XCTAssertEqual(mockPresenter.lastPresentedToggleResponse?.selectedIndex, 1)
//        XCTAssertEqual(mockPresenter.presentToggleCalled, 4, "Should call presenter 4 times")
//    }
//    
//    /// Test 10: toggleBreed ด้วย out of bounds index
//    func testToggleBreed_OutOfBoundsIndex_ShouldHandleGracefully() {
//        // Given
//        setupBreedsData() // 3 breeds (index 0-2)
//        
//        // When - Toggle with invalid index
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 10))
//        
//        // Then - Should still call presenter (business logic allows it)
//        XCTAssertNotNil(mockPresenter.lastPresentedToggleResponse)
//        XCTAssertEqual(mockPresenter.lastPresentedToggleResponse?.selectedIndex, 10)
//    }
//    
//    // MARK: - Integration Tests
//    
//    /// Test 11: Load แล้ว toggle - workflow สมบูรณ์
//    func testCompleteWorkflow_LoadThenToggle() {
//        // Given
//        let breeds = [
//            CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid"),
//            CatBreed(name: "Siamese", country: "Thailand", origin: "Thailand", coat: "Short", pattern: "Pointed")
//        ]
//        let pagination = CatBreedsPagination(currentPage: 1, lastPage: 2)
//        let response = CatBreedsResponse(breeds: breeds, pagination: pagination)
//        mockWorker.mockResult = .success(response)
//        
//        let loadExpectation = expectation(description: "Load breeds")
//        mockPresenter.onPresentBreeds = { _ in loadExpectation.fulfill() }
//        
//        // When - Load breeds
//        sut.loadBreeds(request: Cats.Load.Request())
//        
//        wait(for: [loadExpectation], timeout: 1.0)
//        
//        // Then - Verify initial state
//        XCTAssertEqual(mockPresenter.lastPresentedResponse?.breeds.count, 2)
//        XCTAssertNil(mockPresenter.lastPresentedResponse?.selectedIndex)
//        
//        // When - Toggle a breed
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 0))
//        
//        // Then - Verify toggle worked
//        XCTAssertEqual(mockPresenter.lastPresentedToggleResponse?.selectedIndex, 0)
//        XCTAssertEqual(mockPresenter.lastPresentedToggleResponse?.breeds.count, 2)
//    }
//    
//    /// Test 12: Toggle sequence - expand, collapse, expand different
//    func testToggleSequence_ExpandCollapseDifferent() {
//        // Given
//        setupBreedsData()
//        
//        // When & Then - Expand first
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 0))
//        XCTAssertEqual(mockPresenter.lastPresentedToggleResponse?.selectedIndex, 0)
//        
//        // When & Then - Collapse
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 0))
//        XCTAssertNil(mockPresenter.lastPresentedToggleResponse?.selectedIndex)
//        
//        // When & Then - Expand different
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 2))
//        XCTAssertEqual(mockPresenter.lastPresentedToggleResponse?.selectedIndex, 2)
//    }
//    
//    // MARK: - Memory & State Tests
//    
//    /// Test 13: Weak presenter - ไม่ควร crash เมื่อ presenter = nil
//    func testWeakPresenter_ShouldNotCrash() {
//        // Given
//        let breeds = [CatBreed(name: "Test", country: "Test", origin: "Test", coat: "Test", pattern: "Test")]
//        let pagination = CatBreedsPagination(currentPage: 1, lastPage: 1)
//        let response = CatBreedsResponse(breeds: breeds, pagination: pagination)
//        mockWorker.mockResult = .success(response)
//        
//        // When - Remove presenter
//        sut.presenter = nil
//        
//        // Then - Should not crash
//        sut.loadBreeds(request: Cats.Load.Request())
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 0))
//        
//        // Test passes if no crash
//        XCTAssertTrue(true, "Should not crash when presenter is nil")
//    }
//    
//    /// Test 14: State persistence - toggle state ควรคงอยู่หลัง load ครั้งต่อไป
//    func testStatePersistence_ToggleStateShouldPersistAfterReload() {
//        // Given - Load and expand
//        setupBreedsData()
//        sut.toggleBreed(request: Cats.Toggle.Request(index: 1))
//        XCTAssertEqual(mockPresenter.lastPresentedToggleResponse?.selectedIndex, 1)
//        
//        // When - Load again with new mock data
//        let breeds = [
//            CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid"),
//            CatBreed(name: "Siamese", country: "Thailand", origin: "Thailand", coat: "Short", pattern: "Pointed"),
//            CatBreed(name: "Maine Coon", country: "USA", origin: "USA", coat: "Long", pattern: "Tabby")
//        ]
//        let pagination = CatBreedsPagination(currentPage: 1, lastPage: 2)
//        let response = CatBreedsResponse(breeds: breeds, pagination: pagination)
//        mockWorker.mockResult = .success(response)
//        
//        let expectation = expectation(description: "Reload")
//        mockPresenter.onPresentBreeds = { _ in expectation.fulfill() }
//        sut.loadBreeds(request: Cats.Load.Request())
//        
//        wait(for: [expectation], timeout: 1.0)
//        
//        // Then - Previous selection is maintained in the response
//        XCTAssertEqual(mockPresenter.lastPresentedResponse?.selectedIndex, 1, 
//                      "Should preserve selection through reload")
//    }
//    
//    // MARK: - Pagination Tests
//    
//    /// Test 15: loadMoreBreeds - ควร append ข้อมูลใหม่เข้ากับข้อมูลเก่า
//    func testLoadMoreBreeds_ShouldAppendToExistingData() {
//        // Given - Load page 1
//        let page1Breeds = [
//            CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid")
//        ]
//        let pagination1 = CatBreedsPagination(currentPage: 1, lastPage: 3)
//        let response1 = CatBreedsResponse(breeds: page1Breeds, pagination: pagination1)
//        mockWorker.mockResult = .success(response1)
//        
//        let expectation1 = expectation(description: "Load page 1")
//        mockPresenter.onPresentBreeds = { _ in expectation1.fulfill() }
//        sut.loadBreeds(request: Cats.Load.Request(page: 1))
//        wait(for: [expectation1], timeout: 1.0)
//        
//        XCTAssertEqual(mockPresenter.lastPresentedResponse?.breeds.count, 1)
//        
//        // When - Load page 2
//        let page2Breeds = [
//            CatBreed(name: "Siamese", country: "Thailand", origin: "Thailand", coat: "Short", pattern: "Pointed")
//        ]
//        let pagination2 = CatBreedsPagination(currentPage: 2, lastPage: 3)
//        let response2 = CatBreedsResponse(breeds: page2Breeds, pagination: pagination2)
//        mockWorker.mockResult = .success(response2)
//        
//        let expectation2 = expectation(description: "Load page 2")
//        mockPresenter.onPresentBreeds = { _ in expectation2.fulfill() }
//        sut.loadMoreBreeds(request: Cats.Load.Request(page: 2))
//        wait(for: [expectation2], timeout: 1.0)
//        
//        // Then - Should have both pages combined
//        XCTAssertEqual(mockPresenter.lastPresentedResponse?.breeds.count, 2, "Should have 2 breeds (combined)")
//        XCTAssertEqual(mockPresenter.lastPresentedResponse?.breeds[0].name, "Persian")
//        XCTAssertEqual(mockPresenter.lastPresentedResponse?.breeds[1].name, "Siamese")
//        XCTAssertEqual(mockPresenter.lastPresentedResponse?.pagination.currentPage, 2)
//    }
//    
//    /// Test 16: loadMoreBreeds เมื่อไม่มีหน้าถัดไป - ไม่ควรเรียก worker
//    func testLoadMoreBreeds_NoMorePages_ShouldNotCallWorker() {
//        // Given - Load data with no next page
//        let breeds = [CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid")]
//        let pagination = CatBreedsPagination(currentPage: 2, lastPage: 2) // last page
//        let response = CatBreedsResponse(breeds: breeds, pagination: pagination)
//        mockWorker.mockResult = .success(response)
//        
//        let expectation1 = expectation(description: "Initial load")
//        mockPresenter.onPresentBreeds = { _ in expectation1.fulfill() }
//        sut.loadBreeds(request: Cats.Load.Request())
//        wait(for: [expectation1], timeout: 1.0)
//        
//        // Reset fetch called flag
//        mockWorker.fetchBreedsCalled = false
//        
//        // When - Try to load more (should do nothing)
//        sut.loadMoreBreeds(request: Cats.Load.Request(page: 3))
//        
//        // Then - Worker should not be called
//        // Give it a small delay to ensure async operations complete
//        let delayExpectation = expectation(description: "Delay for async check")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            delayExpectation.fulfill()
//        }
//        wait(for: [delayExpectation], timeout: 0.5)
//        
//        XCTAssertFalse(mockWorker.fetchBreedsCalled, "Should not call worker when no more pages")
//    }
//    
//    // MARK: - Helper Methods
//    
//    /// Helper: Setup breeds data ใน interactor
//    private func setupBreedsData() {
//        let breeds = [
//            CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid"),
//            CatBreed(name: "Siamese", country: "Thailand", origin: "Thailand", coat: "Short", pattern: "Pointed"),
//            CatBreed(name: "Maine Coon", country: "USA", origin: "USA", coat: "Long", pattern: "Tabby")
//        ]
//        let pagination = CatBreedsPagination(currentPage: 1, lastPage: 2)
//        let response = CatBreedsResponse(breeds: breeds, pagination: pagination)
//        mockWorker.mockResult = .success(response)
//        
//        let expectation = expectation(description: "Setup breeds")
//        mockPresenter.onPresentBreeds = { _ in expectation.fulfill() }
//        
//        sut.loadBreeds(request: Cats.Load.Request())
//        wait(for: [expectation], timeout: 1.0)
//    }
}

// MARK: - Mock Presenter

//class MockCatsPresenter: CatsPresentationLogic {
//    
//    var lastPresentedResponse: Cats.Load.Response?
//    var lastPresentedToggleResponse: Cats.Toggle.Response?
//    var lastPresentedError: Error?
//    var presentLoadingCalledWith: [Bool] = []
//    var presentToggleCalled = 0
//    
//    var onPresentBreeds: ((Cats.Load.Response) -> Void)?
//    var onPresentError: ((Error) -> Void)?
//    
//    func presentBreeds(response: Cats.Load.Response) {
//        lastPresentedResponse = response
//        onPresentBreeds?(response)
//    }
//    
//    func presentToggle(response: Cats.Toggle.Response) {
//        lastPresentedToggleResponse = response
//        presentToggleCalled += 1
//    }
//    
//    func presentLoading(isLoading: Bool) {
//        presentLoadingCalledWith.append(isLoading)
//    }
//    
//    func presentError(error: Error) {
//        lastPresentedError = error
//        onPresentError?(error)
//    }
//}
//
//// MARK: - Mock Worker
//
//class MockCatsWorker: CatsWorkerProtocol {
//    
//    var mockResult: Result<CatBreedsResponse, Error>?
//    var fetchBreedsCalled = false
//    var lastRequestedPage: Int?
//    
//    func fetchBreeds(page: Int, completion: @escaping (Result<CatBreedsResponse, Error>) -> Void) {
//        fetchBreedsCalled = true
//        lastRequestedPage = page
//        
//        if let result = mockResult {
//            // Simulate async behavior
//            DispatchQueue.global().async {
//                completion(result)
//            }
//        }
//    }
//}
