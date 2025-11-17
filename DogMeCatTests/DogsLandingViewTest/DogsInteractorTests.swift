//
//  DogsInteractorTests.swift
//  DogMeCatTests
//
//  Created on 15/11/2568 BE.
//

import Testing
@testable import DogMeCat
import Foundation
import XCTest

// MARK: - Mock Presenter
class MockDogsPresenter: DogsPresentationLogic {
    
    var lastPresentedDogs: Dogs.Load.Response?
    var lastPresentedReloadConcurrent: Dogs.ReloadConcurrent.Response?
    var lastPresentedReloadSequential: Dogs.ReloadSequential.Response?
    var lastPresentedError: Error?
    var loadingStates: [Bool] = []
    
    var presentDogsCallCount = 0
    var presentReloadConcurrentCallCount = 0
    var presentReloadSequentialCallCount = 0
    var presentLoadingCallCount = 0
    var presentErrorCallCount = 0
    
    func presentDogs(response: Dogs.Load.Response) {
        lastPresentedDogs = response
        presentDogsCallCount += 1
    }
    
    func presentReloadConcurrent(response: Dogs.ReloadConcurrent.Response) {
        lastPresentedReloadConcurrent = response
        presentReloadConcurrentCallCount += 1
    }
    
    func presentReloadSequential(response: Dogs.ReloadSequential.Response) {
        lastPresentedReloadSequential = response
        presentReloadSequentialCallCount += 1
    }
    
    func presentLoading(isLoading: Bool) {
        loadingStates.append(isLoading)
        presentLoadingCallCount += 1
    }
    
    func presentError(error: Error) {
        lastPresentedError = error
        presentErrorCallCount += 1
    }
}

// MARK: - Mock Worker

class MockDogsWorker: DogsWorkerProtocol {
    
    var concurrentResult: Result<[DogImage], Error>?
    var sequentialResult: Result<[DogImage], Error>?
    
    var fetchConcurrentCallCount = 0
    var fetchSequentialCallCount = 0
    
    var lastConcurrentCount: Int?
    var lastSequentialCount: Int?
    var lastSequentialDelay: Int?
    
    func fetchDogsConcurrent(
        count: Int,
        completion: @escaping (Result<[DogImage], Error>) -> Void
    ) {
        fetchConcurrentCallCount += 1
        lastConcurrentCount = count
        
        if let result = concurrentResult {
            completion(result)
        }
    }
    
    func fetchDogsSequential(
        count: Int,
        delaySeconds: Int,
        completion: @escaping (Result<[DogImage], Error>) -> Void
    ) {
        fetchSequentialCallCount += 1
        lastSequentialCount = count
        lastSequentialDelay = delaySeconds
        
        if let result = sequentialResult {
            completion(result)
        }
    }
}

final class DogsInteractorTests: XCTestCase {
    
    // System Under Test
    var sut: DogsInteractor!
    
    // Test Doubles
    var mockPresenter: MockDogsPresenter!
    var mockWorker: MockDogsWorker!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        
        mockPresenter = MockDogsPresenter()
        mockWorker = MockDogsWorker()
        
        sut = DogsInteractor(worker: mockWorker)
        sut.presenter = mockPresenter
    }
    
    override func tearDown() {
        sut = nil
        mockPresenter = nil
        mockWorker = nil
        
        super.tearDown()
    }
    
    func testloadInitialDogsSucces() {
        let response = [
            DogImage(url: URL(string: "https://example.com/dog1.jpg")!, time: Date()),
            DogImage(url: URL(string: "https://example.com/dog2.jpg")!, time: Date()),
            DogImage(url: URL(string: "https://example.com/dog3.jpg")!, time: Date())
        ]
        mockWorker.concurrentResult = .success(response)
        sut.loadInitialDogs(request: Dogs.Load.Request())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertNotNil(self.mockPresenter.lastPresentedDogs, "Should present breeds response")
        }
    }
    
    func testReloadConcurrent() {
        let response = [
            DogImage(url: URL(string: "https://example.com/dog1.jpg")!, time: Date()),
            DogImage(url: URL(string: "https://example.com/dog2.jpg")!, time: Date()),
            DogImage(url: URL(string: "https://example.com/dog3.jpg")!, time: Date())
        ]
        mockWorker.concurrentResult = .success(response)
        sut.reloadConcurrent(request: Dogs.ReloadConcurrent.Request())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertNotNil(self.mockPresenter.lastPresentedReloadConcurrent, "Should present breeds response")
        }
    }
    
    func testReloadSequential() {
        let response = [
            DogImage(url: URL(string: "https://example.com/dog1.jpg")!, time: Date()),
            DogImage(url: URL(string: "https://example.com/dog2.jpg")!, time: Date()),
            DogImage(url: URL(string: "https://example.com/dog3.jpg")!, time: Date())
        ]
        mockWorker.sequentialResult = .success(response)
        sut.reloadSequential(request: Dogs.ReloadSequential.Request(buttonPressedAt: Date()))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertNotNil(self.mockPresenter.lastPresentedReloadSequential, "Should present breeds response")
        }
    }
    
}


//@Suite("DogsInteractor Tests")
//struct DogsInteractorTests {
//    
//    // MARK: - Test Helpers
//    
//    /// สร้าง test context สำหรับแต่ละ test
//    func makeTestContext() -> TestContext {
//        let mockWorker = MockDogsWorker()
//        let mockPresenter = MockDogsPresenter()
//        let sut = DogsInteractor(worker: mockWorker)
//        sut.presenter = mockPresenter
//        
//        return TestContext(
//            sut: sut,
//            presenter: mockPresenter,
//            worker: mockWorker
//        )
//    }
//    
//    struct TestContext {
//        let sut: DogsInteractor
//        let presenter: MockDogsPresenter
//        let worker: MockDogsWorker
//    }
    
    // MARK: - AI loadInitialDogs Tests
    
//    @Test("loadInitialDogs สำเร็จ - ควรเรียก presenter methods ถูกต้อง")
//    func loadInitialDogsSuccess() async throws {
//        // Given
//        let context = makeTestContext()
//        let expectedImages = [
//            DogImage(url: URL(string: "https://example.com/dog1.jpg")!, time: Date()),
//            DogImage(url: URL(string: "https://example.com/dog2.jpg")!, time: Date()),
//            DogImage(url: URL(string: "https://example.com/dog3.jpg")!, time: Date())
//        ]
//        context.worker.concurrentResult = .success(expectedImages)
//        let request = Dogs.Load.Request()
//        
//        // When
//        context.sut.loadInitialDogs(request: request)
//        
//        // Then - Should show loading states correctly
//        #expect(context.presenter.presentLoadingCallCount == 2, "Should call presentLoading twice")
//        #expect(context.presenter.loadingStates[0] == true, "First call should be true")
//        #expect(context.presenter.loadingStates[1] == false, "Second call should be false")
//        
//        // Should present dogs
//        #expect(context.presenter.presentDogsCallCount == 1)
//        let presentedDogs = try #require(context.presenter.lastPresentedDogs)
//        #expect(presentedDogs.images.count == 3)
//        #expect(presentedDogs.images[0].url.absoluteString == "https://example.com/dog1.jpg")
//        
//        // Should NOT call error
//        #expect(context.presenter.presentErrorCallCount == 0)
//    }
//    
//    @Test("loadInitialDogs ล้มเหลว - ควรเรียก presentError")
//    func loadInitialDogsFailure() async throws {
//        // Given
//        let context = makeTestContext()
//        let expectedError = NSError(
//            domain: "TestError", 
//            code: 500, 
//            userInfo: [NSLocalizedDescriptionKey: "Network failed"]
//        )
//        context.worker.concurrentResult = .failure(expectedError)
//        let request = Dogs.Load.Request()
//        
//        // When
//        context.sut.loadInitialDogs(request: request)
//        
//        // Then - Should show/hide loading
//        #expect(context.presenter.presentLoadingCallCount == 2)
//        #expect(context.presenter.loadingStates[0] == true)
//        #expect(context.presenter.loadingStates[1] == false)
//        
//        // Should present error
//        #expect(context.presenter.presentErrorCallCount == 1)
//        let presentedError = try #require(context.presenter.lastPresentedError as? NSError)
//        #expect(presentedError.domain == "TestError")
//        #expect(presentedError.code == 500)
//        
//        // Should NOT present dogs
//        #expect(context.presenter.presentDogsCallCount == 0)
//    }
//    
//    @Test("loadInitialDogs ด้วย empty images - ยังคงต้อง success")
//    func loadInitialDogsWithEmptyImages() async throws {
//        // Given
//        let context = makeTestContext()
//        context.worker.concurrentResult = .success([])
//        
//        // When
//        context.sut.loadInitialDogs(request: Dogs.Load.Request())
//        
//        // Then
//        #expect(context.presenter.presentDogsCallCount == 1)
//        let presentedDogs = try #require(context.presenter.lastPresentedDogs)
//        #expect(presentedDogs.images.count == 0)
//        #expect(context.presenter.presentErrorCallCount == 0)
//    }
//    
//    @Test("loadInitialDogs ควรเรียก fetchDogsConcurrent ด้วย count = 3")
//    func loadInitialDogsUsesCorrectCount() async throws {
//        // Given
//        let context = makeTestContext()
//        context.worker.concurrentResult = .success([])
//        
//        // When
//        context.sut.loadInitialDogs(request: Dogs.Load.Request())
//        
//        // Then
//        #expect(context.worker.fetchConcurrentCallCount == 1)
//        #expect(context.worker.lastConcurrentCount == 3)
//    }
//    
//    // MARK: - reloadConcurrent Tests
//    
//    @Test("reloadConcurrent สำเร็จ - ควรเรียก presentReloadConcurrent")
//    func reloadConcurrentSuccess() async throws {
//        // Given
//        let context = makeTestContext()
//        let testDate = Date()
//        let expectedImages = [
//            DogImage(url: URL(string: "https://example.com/dog1.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog2.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog3.jpg")!, time: testDate)
//        ]
//        context.worker.concurrentResult = .success(expectedImages)
//        let request = Dogs.ReloadConcurrent.Request()
//        
//        // When
//        context.sut.reloadConcurrent(request: request)
//        
//        // Then
//        #expect(context.presenter.presentLoadingCallCount == 2)
//        #expect(context.presenter.presentReloadConcurrentCallCount == 1)
//        
//        let presented = try #require(context.presenter.lastPresentedReloadConcurrent)
//        #expect(presented.images.count == 3)
//        #expect(context.presenter.presentErrorCallCount == 0)
//    }
//    
//    @Test("reloadConcurrent ล้มเหลว - ควรเรียก presentError")
//    func reloadConcurrentFailure() async throws {
//        // Given
//        let context = makeTestContext()
//        let expectedError = NSError(domain: "TestError", code: 404)
//        context.worker.concurrentResult = .failure(expectedError)
//        
//        // When
//        context.sut.reloadConcurrent(request: Dogs.ReloadConcurrent.Request())
//        
//        // Then
//        #expect(context.presenter.presentErrorCallCount == 1)
//        #expect(context.presenter.presentReloadConcurrentCallCount == 0)
//    }
//    
//    @Test("reloadConcurrent ควรใช้ fetchDogsConcurrent และส่ง count = 3")
//    func reloadConcurrentUsesCorrectParameters() async throws {
//        // Given
//        let context = makeTestContext()
//        context.worker.concurrentResult = .success([])
//        
//        // When
//        context.sut.reloadConcurrent(request: Dogs.ReloadConcurrent.Request())
//        
//        // Then
//        #expect(context.worker.fetchConcurrentCallCount == 1)
//        #expect(context.worker.lastConcurrentCount == 3)
//    }
//    
//    // MARK: - reloadSequential Tests
//    
//    @Test("reloadSequential ด้วย second < 5 - ควรใช้ delay 2 วินาที", 
//          arguments: [0, 1, 2, 3, 4, 10, 14, 20, 30, 44])
//    func reloadSequentialWithLowLastDigit(second: Int) async throws {
//        // Given
//        let context = makeTestContext()
//        let images = [
//            DogImage(url: URL(string: "https://example.com/dog1.jpg")!, time: Date())
//        ]
//        context.worker.sequentialResult = .success(images)
//        
//        var components = DateComponents()
//        components.year = 2024
//        components.month = 11
//        components.day = 15
//        components.hour = 10
//        components.minute = 30
//        components.second = second
//        let buttonPressedDate = Calendar.current.date(from: components)!
//        
//        let request = Dogs.ReloadSequential.Request(buttonPressedAt: buttonPressedDate)
//        
//        // When
//        context.sut.reloadSequential(request: request)
//        
//        // Then
//        let lastDigit = second % 10
//        #expect(lastDigit < 5, "Second \(second) should have last digit < 5")
//        #expect(context.worker.lastSequentialDelay == 2, 
//                "Second \(second) should use 2 seconds delay")
//        #expect(context.presenter.lastPresentedReloadSequential?.delaySeconds == 2)
//    }
//    
//    @Test("reloadSequential ด้วย second >= 5 - ควรใช้ delay 3 วินาที", 
//          arguments: [5, 6, 7, 8, 9, 15, 17, 25, 35, 49, 55, 59])
//    func reloadSequentialWithHighLastDigit(second: Int) async throws {
//        // Given
//        let context = makeTestContext()
//        context.worker.sequentialResult = .success([])
//        
//        var components = DateComponents()
//        components.year = 2024
//        components.month = 11
//        components.day = 15
//        components.hour = 10
//        components.minute = 30
//        components.second = second
//        let testDate = Calendar.current.date(from: components)!
//        
//        let request = Dogs.ReloadSequential.Request(buttonPressedAt: testDate)
//        
//        // When
//        context.sut.reloadSequential(request: request)
//        
//        // Then
//        let lastDigit = second % 10
//        #expect(lastDigit >= 5, "Second \(second) should have last digit >= 5")
//        #expect(context.worker.lastSequentialDelay == 3, 
//                "Second \(second) should use 3 seconds delay")
//        #expect(context.presenter.lastPresentedReloadSequential?.delaySeconds == 3)
//    }
//    
//    @Test("reloadSequential สำเร็จ - ควรเรียก presenter methods ถูกต้อง")
//    func reloadSequentialSuccess() async throws {
//        // Given
//        let context = makeTestContext()
//        let testDate = Date()
//        let images = [
//            DogImage(url: URL(string: "https://example.com/dog.jpg")!, time: testDate)
//        ]
//        context.worker.sequentialResult = .success(images)
//        
//        var components = DateComponents()
//        components.year = 2024
//        components.month = 11
//        components.day = 15
//        components.hour = 10
//        components.minute = 30
//        components.second = 20
//        let buttonPressedDate = Calendar.current.date(from: components)!
//        
//        let request = Dogs.ReloadSequential.Request(buttonPressedAt: buttonPressedDate)
//        
//        // When
//        context.sut.reloadSequential(request: request)
//        
//        // Then
//        #expect(context.presenter.presentLoadingCallCount == 2)
//        #expect(context.presenter.loadingStates[0] == true)
//        #expect(context.presenter.loadingStates[1] == false)
//        
//        #expect(context.presenter.presentReloadSequentialCallCount == 1)
//        let presented = try #require(context.presenter.lastPresentedReloadSequential)
//        #expect(presented.images.count == 1)
//        
//        #expect(context.presenter.presentErrorCallCount == 0)
//    }
//    
//    @Test("reloadSequential ล้มเหลว - ควรเรียก presentError")
//    func reloadSequentialFailure() async throws {
//        // Given
//        let context = makeTestContext()
//        let expectedError = NSError(domain: "TestError", code: 500)
//        context.worker.sequentialResult = .failure(expectedError)
//        
//        var components = DateComponents()
//        components.year = 2024
//        components.month = 11
//        components.day = 15
//        components.hour = 10
//        components.minute = 30
//        components.second = 0
//        let testDate = Calendar.current.date(from: components)!
//        
//        let request = Dogs.ReloadSequential.Request(buttonPressedAt: testDate)
//        
//        // When
//        context.sut.reloadSequential(request: request)
//        
//        // Then
//        #expect(context.presenter.presentLoadingCallCount == 2)
//        #expect(context.presenter.presentErrorCallCount == 1)
//        #expect(context.presenter.presentReloadSequentialCallCount == 0)
//    }
//    
//    @Test("reloadSequential ควรใช้ fetchDogsSequential และส่ง count = 3")
//    func reloadSequentialUsesCorrectParameters() async throws {
//        // Given
//        let context = makeTestContext()
//        context.worker.sequentialResult = .success([])
//        
//        var components = DateComponents()
//        components.year = 2024
//        components.month = 11
//        components.day = 15
//        components.hour = 10
//        components.minute = 30
//        components.second = 10
//        let testDate = Calendar.current.date(from: components)!
//        
//        let request = Dogs.ReloadSequential.Request(buttonPressedAt: testDate)
//        
//        // When
//        context.sut.reloadSequential(request: request)
//        
//        // Then
//        #expect(context.worker.fetchSequentialCallCount == 1)
//        #expect(context.worker.lastSequentialCount == 3)
//    }
//    
//    // MARK: - Edge Cases & Logic Tests
//    
//    @Test("Weak self ไม่ควร crash เมื่อ presenter = nil")
//    func weakSelfHandling() async throws {
//        // Given
//        let context = makeTestContext()
//        let testDate = Date()
//        context.worker.concurrentResult = .success([
//            DogImage(url: URL(string: "https://example.com/dog.jpg")!, time: testDate)
//        ])
//        
//        // When - Remove presenter before callback
//        context.sut.presenter = nil
//        context.sut.loadInitialDogs(request: Dogs.Load.Request())
//        
//        // Then - Should not crash
//        #expect(true, "Should handle weak self gracefully")
//    }
//    
//    @Test("หลายการเรียก loadInitialDogs - ควรทำงานได้ทุกครั้ง")
//    func multipleLoadInitialDogs() async throws {
//        // Given
//        let context = makeTestContext()
//        let testDate = Date()
//        let images1 = [DogImage(url: URL(string: "https://example.com/dog1.jpg")!, time: testDate)]
//        let images2 = [
//            DogImage(url: URL(string: "https://example.com/dog2.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog3.jpg")!, time: testDate)
//        ]
//        
//        // When - First call
//        context.worker.concurrentResult = .success(images1)
//        context.sut.loadInitialDogs(request: Dogs.Load.Request())
//        
//        // Then
//        #expect(context.presenter.presentDogsCallCount == 1)
//        #expect(context.presenter.lastPresentedDogs?.images.count == 1)
//        
//        // When - Second call
//        context.worker.concurrentResult = .success(images2)
//        context.sut.loadInitialDogs(request: Dogs.Load.Request())
//        
//        // Then
//        #expect(context.presenter.presentDogsCallCount == 2)
//        #expect(context.presenter.lastPresentedDogs?.images.count == 2)
//    }
//    
//    @Test("Image data ที่ส่งมาจาก worker ควรถูกส่งต่อไปยัง presenter โดยไม่มีการเปลี่ยนแปลง")
//    func imagesPassedThroughUnmodified() async throws {
//        // Given
//        let context = makeTestContext()
//        let expectedURL = URL(string: "https://example.com/special-dog.jpg")!
//        let expectedTime = Date(timeIntervalSince1970: 1700000000)
//        let expectedImages = [DogImage(url: expectedURL, time: expectedTime)]
//        context.worker.concurrentResult = .success(expectedImages)
//        
//        // When
//        context.sut.loadInitialDogs(request: Dogs.Load.Request())
//        
//        // Then
//        let presentedImages = try #require(context.presenter.lastPresentedDogs?.images)
//        #expect(presentedImages.count == 1)
//        #expect(presentedImages[0].url == expectedURL)
//        #expect(presentedImages[0].time == expectedTime)
//    }
//}
