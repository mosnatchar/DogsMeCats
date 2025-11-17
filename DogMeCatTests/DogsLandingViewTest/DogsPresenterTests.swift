//
//  DogsPresenterTests.swift
//  DogMeCatTests
//
//  Created on 15/11/2568 BE.
//

import XCTest
@testable import DogMeCat

// MARK: - Mock View Controller

class MockDogsViewController: DogsDisplayLogic {
    
    var lastDisplayedDogs: Dogs.Load.ViewModel?
    var lastDisplayedReloadSequential: Dogs.ReloadSequential.ViewModel?
    var lastDisplayedLoading: Dogs.Loading.ViewModel?
    var lastDisplayedError: Dogs.Error.ViewModel?
    
    var displayDogsCallCount = 0
    var displayReloadSequentialCallCount = 0
    var displayLoadingCallCount = 0
    var displayErrorCallCount = 0
    
    func displayDogs(viewModel: Dogs.Load.ViewModel) {
        lastDisplayedDogs = viewModel
        displayDogsCallCount += 1
    }
    
    func displayReloadSequential(viewModel: Dogs.ReloadSequential.ViewModel) {
        lastDisplayedReloadSequential = viewModel
        displayReloadSequentialCallCount += 1
    }
    
    func displayLoading(viewModel: Dogs.Loading.ViewModel) {
        lastDisplayedLoading = viewModel
        displayLoadingCallCount += 1
    }
    
    func displayError(viewModel: Dogs.Error.ViewModel) {
        lastDisplayedError = viewModel
        displayErrorCallCount += 1
    }
}


final class DogsPresenterTests: XCTestCase {
    
    // System Under Test
    var sut: DogsPresenter!
    
    // Test Doubles
    var mockViewController: MockDogsViewController!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        
        sut = DogsPresenter()
        mockViewController = MockDogsViewController()
        sut.viewController = mockViewController
    }
    
    override func tearDown() {
        sut = nil
        mockViewController = nil
        
        super.tearDown()
    }
    
    func testPresentDogs() {
        let images = [
            DogImage(url: URL(string: "https://example.com/dog1.jpg")!, time: Date()),
            DogImage(url: URL(string: "https://example.com/dog2.jpg")!, time: Date()),
            DogImage(url: URL(string: "https://example.com/dog3.jpg")!, time: Date())
        ]
        let response = Dogs.Load.Response(images: images)
        sut.presentDogs(response: response)
        XCTAssertNotNil(mockViewController.lastDisplayedDogs, "Should call displayDogs")
    }
    
    func testPresentReloadConcurrent() {
        let images = [
            DogImage(url: URL(string: "https://example.com/dog1.jpg")!, time: Date()),
            DogImage(url: URL(string: "https://example.com/dog2.jpg")!, time: Date()),
            DogImage(url: URL(string: "https://example.com/dog3.jpg")!, time: Date())
        ]
        let response = Dogs.ReloadConcurrent.Response(images: images)
        sut.presentReloadConcurrent(response: response)
        XCTAssertNotNil(mockViewController.lastDisplayedDogs, "Should call displayDogs")
    }
    
    func testPresentReloadSequential() {
        let images = [
            DogImage(url: URL(string: "https://example.com/dog1.jpg")!, time: Date()),
            DogImage(url: URL(string: "https://example.com/dog2.jpg")!, time: Date()),
            DogImage(url: URL(string: "https://example.com/dog3.jpg")!, time: Date())
        ]
        let response = Dogs.ReloadSequential.Response(images: images,delaySeconds: 2)
        sut.presentReloadSequential(response: response)
        XCTAssertNotNil(mockViewController.lastDisplayedReloadSequential, "Should call displayDogs")
    }
    
    func testPresentLoading() {
        sut.presentLoading(isLoading: true)
        XCTAssertTrue(mockViewController.lastDisplayedLoading?.isLoading ?? false, "Should show loading")
    }
    
    func testPresentError() {
        let error = NSError(
            domain: "TestDomain",
            code: 404,
            userInfo: [NSLocalizedDescriptionKey: "Dogs not found"]
        )
        sut.presentError(error: error)
        XCTAssertNotNil(mockViewController.lastDisplayedError, "Should show error")
    }
    
    // MARK: - AI presentDogs Tests
    
    /// Test 1: presentDogs ด้วยข้อมูลปกติ - ควรสร้าง ViewModel ถูกต้อง
//    func testPresentDogs_WithValidData_ShouldCreateCorrectViewModel() {
//        // Given
//        var components = DateComponents()
//        components.year = 2024
//        components.month = 11
//        components.day = 15
//        components.hour = 14
//        components.minute = 30
//        components.second = 45
//        let testDate = Calendar.current.date(from: components)!
//        
//        let images = [
//            DogImage(url: URL(string: "https://example.com/dog1.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog2.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog3.jpg")!, time: testDate)
//        ]
//        
//        let response = Dogs.Load.Response(images: images)
//        
//        // When
//        sut.presentDogs(response: response)
//        
//        // Then
//        XCTAssertNotNil(mockViewController.lastDisplayedDogs, "Should call displayDogs")
//        XCTAssertEqual(mockViewController.lastDisplayedDogs?.items.count, 3, "Should have 3 items")
//        
//        // Check first item
//        let firstItem = mockViewController.lastDisplayedDogs?.items[0]
//        XCTAssertEqual(firstItem?.title, "Dog#1")
//        XCTAssertEqual(firstItem?.imageURL.absoluteString, "https://example.com/dog1.jpg")
//        XCTAssertEqual(firstItem?.timestampText, "2024-11-15 14:30:45")
//        
//        // Check second item
//        let secondItem = mockViewController.lastDisplayedDogs?.items[1]
//        XCTAssertEqual(secondItem?.title, "Dog#2")
//        XCTAssertEqual(secondItem?.imageURL.absoluteString, "https://example.com/dog2.jpg")
//        
//        // Check third item
//        let thirdItem = mockViewController.lastDisplayedDogs?.items[2]
//        XCTAssertEqual(thirdItem?.title, "Dog#3")
//        XCTAssertEqual(thirdItem?.imageURL.absoluteString, "https://example.com/dog3.jpg")
//    }
//    
//    /// Test 2: presentDogs ด้วย empty images - ควรสร้าง empty ViewModel
//    func testPresentDogs_WithEmptyImages_ShouldCreateEmptyViewModel() {
//        // Given
//        let response = Dogs.Load.Response(images: [])
//        
//        // When
//        sut.presentDogs(response: response)
//        
//        // Then
//        XCTAssertNotNil(mockViewController.lastDisplayedDogs)
//        XCTAssertEqual(mockViewController.lastDisplayedDogs?.items.count, 0, "Should have 0 items")
//    }
//    
//    /// Test 3: presentDogs ด้วย single image - ควร format ถูกต้อง
//    func testPresentDogs_WithSingleImage_ShouldFormatCorrectly() {
//        // Given
//        let images = [DogImage(url: URL(string: "https://example.com/dog.jpg")!, time: Date())]
//        let response = Dogs.Load.Response(images: images)
//        
//        // When
//        sut.presentDogs(response: response)
//        
//        // Then
//        XCTAssertEqual(mockViewController.lastDisplayedDogs?.items.count, 1)
//        XCTAssertEqual(mockViewController.lastDisplayedDogs?.items[0].title, "Dog#1")
//    }
//    
//    /// Test 4: presentDogs หลายครั้ง - ควร update ทุกครั้ง
//    func testPresentDogs_MultipleCalls_ShouldUpdateEachTime() {
//        // Given - First call
//        let images1 = [DogImage(url: URL(string: "https://example.com/dog1.jpg")!, time: Date())]
//        let response1 = Dogs.Load.Response(images: images1)
//        
//        // When - First call
//        sut.presentDogs(response: response1)
//        
//        // Then
//        XCTAssertEqual(mockViewController.displayDogsCallCount, 1)
//        XCTAssertEqual(mockViewController.lastDisplayedDogs?.items.count, 1)
//        
//        // Given - Second call
//        let images2 = [
//            DogImage(url: URL(string: "https://example.com/dog2.jpg")!, time: Date()),
//            DogImage(url: URL(string: "https://example.com/dog3.jpg")!, time: Date())
//        ]
//        let response2 = Dogs.Load.Response(images: images2)
//        
//        // When - Second call
//        sut.presentDogs(response: response2)
//        
//        // Then
//        XCTAssertEqual(mockViewController.displayDogsCallCount, 2)
//        XCTAssertEqual(mockViewController.lastDisplayedDogs?.items.count, 2)
//    }
//    
//    /// Test 5: presentDogs timestamp format - ควรเป็น "yyyy-MM-dd HH:mm:ss"
//    func testPresentDogs_TimestampFormat_ShouldBeCorrect() {
//        // Given
//        var components = DateComponents()
//        components.year = 2024
//        components.month = 1
//        components.day = 5
//        components.hour = 9
//        components.minute = 8
//        components.second = 7
//        let testDate = Calendar.current.date(from: components)!
//        
//        let images = [DogImage(url: URL(string: "https://example.com/dog.jpg")!, time: testDate)]
//        let response = Dogs.Load.Response(images: images)
//        
//        // When
//        sut.presentDogs(response: response)
//        
//        // Then
//        XCTAssertEqual(mockViewController.lastDisplayedDogs?.items[0].timestampText, "2024-01-05 09:08:07")
//    }
//    
//    // MARK: - presentReloadConcurrent Tests
//    
//    /// Test 6: presentReloadConcurrent สำเร็จ - ควรสร้าง ViewModel ถูกต้อง
//    func testPresentReloadConcurrent_Success_ShouldCreateCorrectViewModel() {
//        // Given
//        var components = DateComponents()
//        components.year = 2024
//        components.month = 11
//        components.day = 15
//        components.hour = 16
//        components.minute = 45
//        components.second = 30
//        let testDate = Calendar.current.date(from: components)!
//        
//        let images = [
//            DogImage(url: URL(string: "https://example.com/dog1.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog2.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog3.jpg")!, time: testDate)
//        ]
//        
//        let response = Dogs.ReloadConcurrent.Response(images: images)
//        
//        // When
//        sut.presentReloadConcurrent(response: response)
//        
//        // Then
//        XCTAssertNotNil(mockViewController.lastDisplayedDogs)
//        XCTAssertEqual(mockViewController.lastDisplayedDogs?.items.count, 3)
//        
//        let firstItem = mockViewController.lastDisplayedDogs?.items[0]
//        XCTAssertEqual(firstItem?.title, "Dog#1")
//        XCTAssertEqual(firstItem?.timestampText, "2024-11-15 16:45:30")
//    }
//    
//    /// Test 7: presentReloadConcurrent ด้วย empty images
//    func testPresentReloadConcurrent_WithEmptyImages_ShouldCreateEmptyViewModel() {
//        // Given
//        let response = Dogs.ReloadConcurrent.Response(images: [])
//        
//        // When
//        sut.presentReloadConcurrent(response: response)
//        
//        // Then
//        XCTAssertNotNil(mockViewController.lastDisplayedDogs)
//        XCTAssertEqual(mockViewController.lastDisplayedDogs?.items.count, 0)
//    }
//    
//    // MARK: - presentReloadSequential Tests
//    
//    /// Test 8: presentReloadSequential ด้วย delay 2 วินาที
//    func testPresentReloadSequential_WithDelay2_ShouldCreateCorrectViewModel() {
//        // Given
//        var components = DateComponents()
//        components.year = 2024
//        components.month = 11
//        components.day = 15
//        components.hour = 10
//        components.minute = 20
//        components.second = 30
//        let testDate = Calendar.current.date(from: components)!
//        
//        let images = [
//            DogImage(url: URL(string: "https://example.com/dog1.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog2.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog3.jpg")!, time: testDate)
//        ]
//        
//        let response = Dogs.ReloadSequential.Response(
//            images: images,
//            delaySeconds: 2
//        )
//        
//        // When
//        sut.presentReloadSequential(response: response)
//        
//        // Then
//        XCTAssertNotNil(mockViewController.lastDisplayedReloadSequential)
//        XCTAssertEqual(mockViewController.lastDisplayedReloadSequential?.items.count, 3)
//        XCTAssertEqual(mockViewController.lastDisplayedReloadSequential?.delayDescription, "Delay 2s")
//        
//        let firstItem = mockViewController.lastDisplayedReloadSequential?.items[0]
//        XCTAssertEqual(firstItem?.title, "Dog#1")
//        XCTAssertEqual(firstItem?.timestampText, "2024-11-15 10:20:30")
//    }
//    
//    /// Test 9: presentReloadSequential ด้วย delay 3 วินาที
//    func testPresentReloadSequential_WithDelay3_ShouldCreateCorrectViewModel() {
//        // Given
//        let images = [DogImage(url: URL(string: "https://example.com/dog.jpg")!, time: Date())]
//        let response = Dogs.ReloadSequential.Response(
//            images: images,
//            delaySeconds: 3
//        )
//        
//        // When
//        sut.presentReloadSequential(response: response)
//        
//        // Then
//        XCTAssertEqual(mockViewController.lastDisplayedReloadSequential?.delayDescription, "Delay 3s")
//    }
//    
//    /// Test 10: presentReloadSequential ด้วย empty images
//    func testPresentReloadSequential_WithEmptyImages_ShouldCreateEmptyViewModel() {
//        // Given
//        let response = Dogs.ReloadSequential.Response(
//            images: [],
//            delaySeconds: 2
//        )
//        
//        // When
//        sut.presentReloadSequential(response: response)
//        
//        // Then
//        XCTAssertEqual(mockViewController.lastDisplayedReloadSequential?.items.count, 0)
//        XCTAssertEqual(mockViewController.lastDisplayedReloadSequential?.delayDescription, "Delay 2s")
//    }
//    
//    /// Test 11: presentReloadSequential - ควรเรียก displayReloadSequential ไม่ใช่ displayDogs
//    func testPresentReloadSequential_ShouldCallDisplayReloadSequential() {
//        // Given
//        let images = [DogImage(url: URL(string: "https://example.com/dog.jpg")!, time: Date())]
//        let response = Dogs.ReloadSequential.Response(
//            images: images,
//            delaySeconds: 2
//        )
//        
//        // When
//        sut.presentReloadSequential(response: response)
//        
//        // Then
//        XCTAssertEqual(mockViewController.displayReloadSequentialCallCount, 1)
//        XCTAssertEqual(mockViewController.displayDogsCallCount, 0, "Should NOT call displayDogs")
//    }
//    
//    // MARK: - presentLoading Tests
//    
//    /// Test 12: presentLoading true - ควรแสดง loading
//    func testPresentLoading_True_ShouldDisplayLoading() {
//        // When
//        sut.presentLoading(isLoading: true)
//        
//        // Then
//        XCTAssertNotNil(mockViewController.lastDisplayedLoading)
//        XCTAssertTrue(mockViewController.lastDisplayedLoading?.isLoading ?? false, "Should show loading")
//        XCTAssertEqual(mockViewController.displayLoadingCallCount, 1)
//    }
//    
//    /// Test 13: presentLoading false - ควรซ่อน loading
//    func testPresentLoading_False_ShouldHideLoading() {
//        // When
//        sut.presentLoading(isLoading: false)
//        
//        // Then
//        XCTAssertNotNil(mockViewController.lastDisplayedLoading)
//        XCTAssertFalse(mockViewController.lastDisplayedLoading?.isLoading ?? true, "Should hide loading")
//    }
//    
//    /// Test 14: presentLoading หลายครั้ง - ควรติดตาม state ล่าสุด
//    func testPresentLoading_MultipleCalls_ShouldTrackLatestState() {
//        // When
//        sut.presentLoading(isLoading: true)
//        sut.presentLoading(isLoading: false)
//        sut.presentLoading(isLoading: true)
//        
//        // Then
//        XCTAssertEqual(mockViewController.displayLoadingCallCount, 3)
//        XCTAssertTrue(mockViewController.lastDisplayedLoading?.isLoading ?? false, "Should be loading")
//    }
//    
//    // MARK: - presentError Tests
//    
//    /// Test 15: presentError - ควรแสดง error message
//    func testPresentError_ShouldDisplayErrorMessage() {
//        // Given
//        let error = NSError(
//            domain: "TestDomain",
//            code: 404,
//            userInfo: [NSLocalizedDescriptionKey: "Dogs not found"]
//        )
//        
//        // When
//        sut.presentError(error: error)
//        
//        // Then
//        XCTAssertNotNil(mockViewController.lastDisplayedError)
//        XCTAssertEqual(mockViewController.lastDisplayedError?.message, "Dogs not found")
//        XCTAssertEqual(mockViewController.displayErrorCallCount, 1)
//    }
//    
//    /// Test 16: presentError หลายครั้ง - ควรแสดง error ล่าสุด
//    func testPresentError_MultipleCalls_ShouldDisplayLatestError() {
//        // Given
//        let error1 = NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error 1"])
//        let error2 = NSError(domain: "Test", code: 2, userInfo: [NSLocalizedDescriptionKey: "Error 2"])
//        
//        // When
//        sut.presentError(error: error1)
//        sut.presentError(error: error2)
//        
//        // Then
//        XCTAssertEqual(mockViewController.displayErrorCallCount, 2)
//        XCTAssertEqual(mockViewController.lastDisplayedError?.message, "Error 2")
//    }
//    
//    /// Test 17: presentError ด้วย generic error
//    func testPresentError_WithGenericError_ShouldUseLocalizedDescription() {
//        // Given
//        enum CustomError: LocalizedError {
//            case networkFailed
//            
//            var errorDescription: String? {
//                return "Network connection failed"
//            }
//        }
//        
//        // When
//        sut.presentError(error: CustomError.networkFailed)
//        
//        // Then
//        XCTAssertEqual(mockViewController.lastDisplayedError?.message, "Network connection failed")
//    }
//    
//    // MARK: - Title Numbering Tests
//    
//    /// Test 18: Dog numbering ควรเริ่มจาก 1 ไม่ใช่ 0
//    func testDogNumbering_ShouldStartFromOne() {
//        // Given
//        let testDate = Date()
//        let images = [
//            DogImage(url: URL(string: "https://example.com/dog1.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog2.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog3.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog4.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog5.jpg")!, time: testDate)
//        ]
//        let response = Dogs.Load.Response(images: images)
//        
//        // When
//        sut.presentDogs(response: response)
//        
//        // Then
//        let items = mockViewController.lastDisplayedDogs?.items
//        XCTAssertEqual(items?[0].title, "Dog#1")
//        XCTAssertEqual(items?[1].title, "Dog#2")
//        XCTAssertEqual(items?[2].title, "Dog#3")
//        XCTAssertEqual(items?[3].title, "Dog#4")
//        XCTAssertEqual(items?[4].title, "Dog#5")
//    }
//    
//    /// Test 19: ตรวจสอบ URL mapping ถูกต้องทุก item
//    func testURLMapping_ShouldBeCorrectForAllItems() {
//        // Given
//        let testDate = Date()
//        let images = [
//            DogImage(url: URL(string: "https://example.com/dog-a.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog-b.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog-c.jpg")!, time: testDate)
//        ]
//        let response = Dogs.Load.Response(images: images)
//        
//        // When
//        sut.presentDogs(response: response)
//        
//        // Then
//        let items = mockViewController.lastDisplayedDogs?.items
//        XCTAssertEqual(items?[0].imageURL.absoluteString, "https://example.com/dog-a.jpg")
//        XCTAssertEqual(items?[1].imageURL.absoluteString, "https://example.com/dog-b.jpg")
//        XCTAssertEqual(items?[2].imageURL.absoluteString, "https://example.com/dog-c.jpg")
//    }
//    
//    /// Test 20: ทุก item ควรมี timestamp เหมือนกัน
//    func testAllItems_ShouldHaveSameTimestamp() {
//        // Given
//        var components = DateComponents()
//        components.year = 2024
//        components.month = 11
//        components.day = 15
//        components.hour = 12
//        components.minute = 0
//        components.second = 0
//        let testDate = Calendar.current.date(from: components)!
//        
//        let images = [
//            DogImage(url: URL(string: "https://example.com/dog1.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog2.jpg")!, time: testDate),
//            DogImage(url: URL(string: "https://example.com/dog3.jpg")!, time: testDate)
//        ]
//        
//        let response = Dogs.Load.Response(images: images)
//        
//        // When
//        sut.presentDogs(response: response)
//        
//        // Then
//        let items = mockViewController.lastDisplayedDogs?.items
//        let expectedTimestamp = "2024-11-15 12:00:00"
//        
//        XCTAssertEqual(items?[0].timestampText, expectedTimestamp)
//        XCTAssertEqual(items?[1].timestampText, expectedTimestamp)
//        XCTAssertEqual(items?[2].timestampText, expectedTimestamp)
//    }
//    
//    // MARK: - Memory & Weak Reference Tests
//    
//    /// Test 21: Weak viewController - ไม่ควร crash เมื่อ viewController = nil
//    func testWeakViewController_ShouldNotCrash() {
//        // Given
//        let testDate = Date()
//        let images = [DogImage(url: URL(string: "https://example.com/dog.jpg")!, time: testDate)]
//        let response = Dogs.Load.Response(images: images)
//        
//        // When - Remove viewController
//        sut.viewController = nil
//        
//        // Then - Should not crash
//        sut.presentDogs(response: response)
//        sut.presentReloadConcurrent(response: Dogs.ReloadConcurrent.Response(images: images))
//        sut.presentReloadSequential(response: Dogs.ReloadSequential.Response(images: images, delaySeconds: 2))
//        sut.presentLoading(isLoading: true)
//        sut.presentError(error: NSError(domain: "Test", code: 0))
//        
//        XCTAssertTrue(true, "Should not crash when viewController is nil")
//    }
//    
//    // MARK: - Edge Cases
//    
//    /// Test 22: Special characters ใน URL
//    func testSpecialCharactersInURL_ShouldHandleCorrectly() {
//        // Given
//        let testDate = Date()
//        let images = [
//            DogImage(url: URL(string: "https://example.com/dog%20image.jpg?param=value&test=123")!, time: testDate)
//        ]
//        let response = Dogs.Load.Response(images: images)
//        
//        // When
//        sut.presentDogs(response: response)
//        
//        // Then
//        let item = mockViewController.lastDisplayedDogs?.items[0]
//        XCTAssertNotNil(item?.imageURL)
//        XCTAssertTrue(item?.imageURL.absoluteString.contains("dog%20image.jpg") ?? false)
//    }
//    
//    /// Test 23: Midnight timestamp - ควร format ถูกต้อง
//    func testMidnightTimestamp_ShouldFormatCorrectly() {
//        // Given
//        var components = DateComponents()
//        components.year = 2024
//        components.month = 12
//        components.day = 31
//        components.hour = 0
//        components.minute = 0
//        components.second = 0
//        let testDate = Calendar.current.date(from: components)!
//        
//        let images = [DogImage(url: URL(string: "https://example.com/dog.jpg")!, time: testDate)]
//        let response = Dogs.Load.Response(images: images)
//        
//        // When
//        sut.presentDogs(response: response)
//        
//        // Then
//        XCTAssertEqual(mockViewController.lastDisplayedDogs?.items[0].timestampText, "2024-12-31 00:00:00")
//    }
//    
//    /// Test 24: presentReloadSequential กับ presentReloadConcurrent ควรมี output format เหมือนกันยกเว้น delay
//    func testReloadSequentialVsConcurrent_ShouldHaveSimilarFormat() {
//        // Given
//        let timestamp = Date()
//        let images = [DogImage(url: URL(string: "https://example.com/dog.jpg")!, time: timestamp)]
//        
//        // When
//        sut.presentReloadConcurrent(response: Dogs.ReloadConcurrent.Response(images: images))
//        let concurrentItem = mockViewController.lastDisplayedDogs?.items[0]
//        
//        sut.presentReloadSequential(response: Dogs.ReloadSequential.Response(images: images, delaySeconds: 2))
//        let sequentialItem = mockViewController.lastDisplayedReloadSequential?.items[0]
//        
//        // Then
//        XCTAssertEqual(concurrentItem?.title, sequentialItem?.title)
//        XCTAssertEqual(concurrentItem?.imageURL, sequentialItem?.imageURL)
//        XCTAssertEqual(concurrentItem?.timestampText, sequentialItem?.timestampText)
//    }
}
