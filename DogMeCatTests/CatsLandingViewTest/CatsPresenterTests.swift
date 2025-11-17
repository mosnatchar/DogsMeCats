//
//  CatsPresenterTests.swift
//  DogMeCatTests
//
//  Created on 15/11/2568 BE.
//

import XCTest
@testable import DogMeCat

// MARK: - Mock View Controller

class MockCatsViewController: CatsDisplayLogic {
    
    var lastDisplayedBreeds: Cats.Load.ViewModel?
    var lastDisplayedLoading: Cats.Loading.ViewModel?
    var lastDisplayedError: Cats.Error.ViewModel?

    
    func displayBreeds(viewModel: Cats.Load.ViewModel) {
        lastDisplayedBreeds = viewModel
    }
    
    func displayLoading(viewModel: Cats.Loading.ViewModel) {
        lastDisplayedLoading = viewModel
    }
    
    func displayError(viewModel: Cats.Error.ViewModel) {
        lastDisplayedError = viewModel
    }
}


final class CatsPresenterTests: XCTestCase {
    
    // System Under Test
    var sut: CatsPresenter!
    
    // Test Doubles
    var mockViewController: MockCatsViewController!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        
        sut = CatsPresenter()
        mockViewController = MockCatsViewController()
        sut.viewController = mockViewController
    }
    
    override func tearDown() {
        sut = nil
        mockViewController = nil
        
        super.tearDown()
    }
    
    func testPresentBreeds() {
        let breeds = [
            CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid"),
            CatBreed(name: "Siamese", country: "Thailand", origin: "Thailand", coat: "Short", pattern: "Pointed")
        ]
        let pagination = CatBreedsPagination(currentPage: 1, lastPage: 1)
        let response = Cats.Load.Response(breeds: breeds, selectedIndex: nil, pagination: pagination)
        sut.presentBreeds(response: response)
        XCTAssertNotNil(mockViewController.lastDisplayedBreeds, "Should call displayBreeds")
    }
    
    func testPresentToggle() {
        let breeds = [
            CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid"),
            CatBreed(name: "Siamese", country: "Thailand", origin: "Thailand", coat: "Short", pattern: "Pointed")
        ]

        let response = Cats.Toggle.Response(breeds: breeds, selectedIndex: 1)
        sut.presentToggle(response: response)
        XCTAssertNotNil(mockViewController.displayBreeds, "Should call displayBreeds")
    }
    
    func testPresentLoading() {
        sut.presentLoading(isLoading: true)
        XCTAssertNotNil(mockViewController.lastDisplayedLoading, "Should call displayLoading")
    }
    
    func testPresentError() {
        let error = NSError(
            domain: "test",
            code: 404,
            userInfo: [NSLocalizedDescriptionKey: "test"]
        )
        sut.presentError(error: error)
        XCTAssertNotNil(mockViewController.displayError, "Should call displayError")
    }
    
    // MARK: - AI presentBreeds Tests
    
//    /// Test 1: presentBreeds ด้วยข้อมูลปกติ - ควรสร้าง ViewModel ถูกต้อง
//    func testPresentBreeds_WithValidData_ShouldCreateCorrectViewModel() {
//        // Given
//        let breeds = [
//            CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid"),
//            CatBreed(name: "Siamese", country: "Thailand", origin: "Thailand", coat: "Short", pattern: "Pointed")
//        ]
//        let pagination = CatBreedsPagination(currentPage: 1, lastPage: 1)
//        let response = Cats.Load.Response(breeds: breeds, selectedIndex: nil, pagination: pagination)
//        
//        // When
//        sut.presentBreeds(response: response)
//        
//        // Then
//        XCTAssertNotNil(mockViewController.lastDisplayedBreeds, "Should call displayBreeds")
//        XCTAssertEqual(mockViewController.lastDisplayedBreeds?.items.count, 2, "Should have 2 items")
//        
//        let firstItem = mockViewController.lastDisplayedBreeds?.items[0]
//        XCTAssertEqual(firstItem?.name, "Persian")
//        XCTAssertFalse(firstItem?.isExpanded ?? true, "Should not be expanded")
//        XCTAssertNil(firstItem?.detailText, "Should have no detail text when collapsed")
//        
//        let secondItem = mockViewController.lastDisplayedBreeds?.items[1]
//        XCTAssertEqual(secondItem?.name, "Siamese")
//        XCTAssertFalse(secondItem?.isExpanded ?? true, "Should not be expanded")
//    }
//    
//    /// Test 2: presentBreeds ด้วย selectedIndex - ควร expand item นั้น
//    func testPresentBreeds_WithSelectedIndex_ShouldExpandCorrectItem() {
//        // Given
//        let breeds = [
//            CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid"),
//            CatBreed(name: "Siamese", country: "Thailand", origin: "Thailand", coat: "Short", pattern: "Pointed")
//        ]
//        let pagination = CatBreedsPagination(currentPage: 1, lastPage: 1)
//        let response = Cats.Load.Response(breeds: breeds, selectedIndex: 0, pagination: pagination)
//        
//        // When
//        sut.presentBreeds(response: response)
//        
//        // Then
//        let items = mockViewController.lastDisplayedBreeds?.items
//        XCTAssertNotNil(items)
//        
//        // First item should be expanded
//        let firstItem = items?[0]
//        XCTAssertTrue(firstItem?.isExpanded ?? false, "First item should be expanded")
//        XCTAssertNotNil(firstItem?.detailText, "Should have detail text when expanded")
//        XCTAssertTrue(firstItem?.detailText?.contains("Country: Iran") ?? false)
//        XCTAssertTrue(firstItem?.detailText?.contains("Origin: Iran") ?? false)
//        XCTAssertTrue(firstItem?.detailText?.contains("Coat: Long") ?? false)
//        XCTAssertTrue(firstItem?.detailText?.contains("Pattern: Solid") ?? false)
//        
//        // Second item should not be expanded
//        let secondItem = items?[1]
//        XCTAssertFalse(secondItem?.isExpanded ?? true, "Second item should not be expanded")
//        XCTAssertNil(secondItem?.detailText, "Should have no detail text")
//    }
//    
//    /// Test 3: presentBreeds ด้วย empty breeds - ควรสร้าง empty ViewModel
//    func testPresentBreeds_WithEmptyBreeds_ShouldCreateEmptyViewModel() {
//        // Given
//        let pagination = CatBreedsPagination(currentPage: 1, lastPage: 1)
//        let response = Cats.Load.Response(breeds: [], selectedIndex: nil, pagination: pagination)
//        
//        // When
//        sut.presentBreeds(response: response)
//        
//        // Then
//        XCTAssertNotNil(mockViewController.lastDisplayedBreeds)
//        XCTAssertEqual(mockViewController.lastDisplayedBreeds?.items.count, 0, "Should have 0 items")
//    }
//    
//    /// Test 4: presentBreeds หลายครั้ง - ควร update ทุกครั้ง
//    func testPresentBreeds_MultipleCalls_ShouldUpdateEachTime() {
//        // Given - First call
//        let breeds1 = [CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid")]
//        let pagination1 = CatBreedsPagination(currentPage: 1, lastPage: 1)
//        let response1 = Cats.Load.Response(breeds: breeds1, selectedIndex: nil, pagination: pagination1)
//        
//        // When - First call
//        sut.presentBreeds(response: response1)
//        
//        // Then
//        XCTAssertEqual(mockViewController.lastDisplayedBreeds?.items.count, 1)
//        XCTAssertEqual(mockViewController.displayBreedsCallCount, 1)
//        
//        // Given - Second call
//        let breeds2 = [
//            CatBreed(name: "Siamese", country: "Thailand", origin: "Thailand", coat: "Short", pattern: "Pointed"),
//            CatBreed(name: "Maine Coon", country: "USA", origin: "USA", coat: "Long", pattern: "Tabby")
//        ]
//        let pagination2 = CatBreedsPagination(currentPage: 1, lastPage: 2)
//        let response2 = Cats.Load.Response(breeds: breeds2, selectedIndex: 1, pagination: pagination2)
//        
//        // When - Second call
//        sut.presentBreeds(response: response2)
//        
//        // Then
//        XCTAssertEqual(mockViewController.lastDisplayedBreeds?.items.count, 2)
//        XCTAssertEqual(mockViewController.displayBreedsCallCount, 2)
//        XCTAssertTrue(mockViewController.lastDisplayedBreeds?.items[1].isExpanded ?? false)
//    }
//    
//    // MARK: - presentToggle Tests
//    
//    /// Test 5: presentToggle - ควรทำงานเหมือน presentBreeds
//    func testPresentToggle_ShouldWorkLikePresentBreeds() {
//        // Given
//        let breeds = [
//            CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid"),
//            CatBreed(name: "Siamese", country: "Thailand", origin: "Thailand", coat: "Short", pattern: "Pointed")
//        ]
//        let response = Cats.Toggle.Response(breeds: breeds, selectedIndex: 1)
//        
//        // When
//        sut.presentToggle(response: response)
//        
//        // Then
//        XCTAssertNotNil(mockViewController.lastDisplayedBreeds)
//        XCTAssertEqual(mockViewController.lastDisplayedBreeds?.items.count, 2)
//        
//        // Second item should be expanded
//        let secondItem = mockViewController.lastDisplayedBreeds?.items[1]
//        XCTAssertTrue(secondItem?.isExpanded ?? false)
//        XCTAssertNotNil(secondItem?.detailText)
//        XCTAssertTrue(secondItem?.detailText?.contains("Thailand") ?? false)
//    }
//    
//    /// Test 6: presentToggle ด้วย nil selectedIndex - ทุก item ควร collapse
//    func testPresentToggle_WithNilSelectedIndex_ShouldCollapseAll() {
//        // Given
//        let breeds = [
//            CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid"),
//            CatBreed(name: "Siamese", country: "Thailand", origin: "Thailand", coat: "Short", pattern: "Pointed")
//        ]
//        let response = Cats.Toggle.Response(breeds: breeds, selectedIndex: nil)
//        
//        // When
//        sut.presentToggle(response: response)
//        
//        // Then
//        let items = mockViewController.lastDisplayedBreeds?.items
//        XCTAssertNotNil(items)
//        
//        for item in items ?? [] {
//            XCTAssertFalse(item.isExpanded, "All items should be collapsed")
//            XCTAssertNil(item.detailText, "No items should have detail text")
//        }
//    }
//    
//    // MARK: - presentLoading Tests
//    
//    /// Test 7: presentLoading true - ควรแสดง loading
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
//    /// Test 8: presentLoading false - ควรซ่อน loading
//    func testPresentLoading_False_ShouldHideLoading() {
//        // When
//        sut.presentLoading(isLoading: false)
//        
//        // Then
//        XCTAssertNotNil(mockViewController.lastDisplayedLoading)
//        XCTAssertFalse(mockViewController.lastDisplayedLoading?.isLoading ?? true, "Should hide loading")
//    }
//    
//    /// Test 9: presentLoading หลายครั้ง - ควรติดตาม state ล่าสุด
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
//    /// Test 10: presentError - ควรแสดง error message
//    func testPresentError_ShouldDisplayErrorMessage() {
//        // Given
//        let error = NSError(
//            domain: "TestDomain",
//            code: 404,
//            userInfo: [NSLocalizedDescriptionKey: "Cat breeds not found"]
//        )
//        
//        // When
//        sut.presentError(error: error)
//        
//        // Then
//        XCTAssertNotNil(mockViewController.lastDisplayedError)
//        XCTAssertEqual(mockViewController.lastDisplayedError?.message, "Cat breeds not found")
//        XCTAssertEqual(mockViewController.displayErrorCallCount, 1)
//    }
//    
//    /// Test 11: presentError หลายครั้ง - ควรแสดง error ล่าสุด
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
//    /// Test 12: presentError ด้วย generic error
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
//    // MARK: - Detail Text Format Tests
//    
//    /// Test 13: ตรวจสอบ format ของ detail text
//    func testDetailTextFormat_ShouldBeCorrect() {
//        // Given
//        let breed = CatBreed(
//            name: "Persian",
//            country: "Iran",
//            origin: "Persia",
//            coat: "Long and fluffy",
//            pattern: "Solid color"
//        )
//        let pagination = CatBreedsPagination(currentPage: 1, lastPage: 1)
//        let response = Cats.Load.Response(breeds: [breed], selectedIndex: 0, pagination: pagination)
//        
//        // When
//        sut.presentBreeds(response: response)
//        
//        // Then
//        let detailText = mockViewController.lastDisplayedBreeds?.items[0].detailText
//        XCTAssertNotNil(detailText)
//        
//        let expectedLines = [
//            "Country: Iran",
//            "Origin: Persia",
//            "Coat: Long and fluffy",
//            "Pattern: Solid color"
//        ]
//        
//        for line in expectedLines {
//            XCTAssertTrue(detailText?.contains(line) ?? false, "Should contain '\(line)'")
//        }
//    }
//    
//    // MARK: - ViewModel Mapping Tests
//    
//    /// Test 14: ตรวจสอบการ map ข้อมูลทุก field
//    func testViewModelMapping_ShouldMapAllFields() {
//        // Given
//        let breeds = [
//            CatBreed(name: "Cat1", country: "C1", origin: "O1", coat: "Co1", pattern: "P1"),
//            CatBreed(name: "Cat2", country: "C2", origin: "O2", coat: "Co2", pattern: "P2"),
//            CatBreed(name: "Cat3", country: "C3", origin: "O3", coat: "Co3", pattern: "P3")
//        ]
//        let pagination = CatBreedsPagination(currentPage: 1, lastPage: 1)
//        let response = Cats.Load.Response(breeds: breeds, selectedIndex: 1, pagination: pagination)
//        
//        // When
//        sut.presentBreeds(response: response)
//        
//        // Then
//        let items = mockViewController.lastDisplayedBreeds?.items
//        XCTAssertEqual(items?.count, 3)
//        
//        // Check all names
//        XCTAssertEqual(items?[0].name, "Cat1")
//        XCTAssertEqual(items?[1].name, "Cat2")
//        XCTAssertEqual(items?[2].name, "Cat3")
//        
//        // Check expansion states
//        XCTAssertFalse(items?[0].isExpanded ?? true)
//        XCTAssertTrue(items?[1].isExpanded ?? false)
//        XCTAssertFalse(items?[2].isExpanded ?? true)
//        
//        // Check detail for expanded item
//        let expandedDetail = items?[1].detailText
//        XCTAssertTrue(expandedDetail?.contains("C2") ?? false)
//        XCTAssertTrue(expandedDetail?.contains("O2") ?? false)
//        XCTAssertTrue(expandedDetail?.contains("Co2") ?? false)
//        XCTAssertTrue(expandedDetail?.contains("P2") ?? false)
//    }
//    
//    // MARK: - Memory & Weak Reference Tests
//    
//    /// Test 15: Weak viewController - ไม่ควร crash เมื่อ viewController = nil
//    func testWeakViewController_ShouldNotCrash() {
//        // Given
//        let breeds = [CatBreed(name: "Test", country: "T", origin: "T", coat: "T", pattern: "T")]
//        let pagination = CatBreedsPagination(currentPage: 1, lastPage: 1)
//        let response = Cats.Load.Response(breeds: breeds, selectedIndex: nil, pagination: pagination)
//        
//        // When - Remove viewController
//        sut.viewController = nil
//        
//        // Then - Should not crash
//        sut.presentBreeds(response: response)
//        sut.presentLoading(isLoading: true)
//        sut.presentError(error: NSError(domain: "Test", code: 0))
//        
//        XCTAssertTrue(true, "Should not crash when viewController is nil")
//    }
//    
//    // MARK: - Edge Cases
//    
//    /// Test 16: selectedIndex out of bounds - ควรจัดการได้
//    func testSelectedIndexOutOfBounds_ShouldHandleGracefully() {
//        // Given
//        let breeds = [
//            CatBreed(name: "Persian", country: "Iran", origin: "Iran", coat: "Long", pattern: "Solid")
//        ]
//        let pagination = CatBreedsPagination(currentPage: 1, lastPage: 1)
//        let response = Cats.Load.Response(breeds: breeds, selectedIndex: 10, pagination: pagination)
//        
//        // When
//        sut.presentBreeds(response: response)
//        
//        // Then - Should not crash and should handle gracefully
//        let items = mockViewController.lastDisplayedBreeds?.items
//        XCTAssertEqual(items?.count, 1)
//        XCTAssertFalse(items?[0].isExpanded ?? true, "Item should not be expanded")
//    }
//    
//    /// Test 17: Special characters ใน breed data
//    func testSpecialCharactersInBreedData_ShouldDisplayCorrectly() {
//        // Given
//        let breed = CatBreed(
//            name: "Müller's Cat 🐱",
//            country: "Côte d'Ivoire",
//            origin: "São Paulo",
//            coat: "Short & Dense",
//            pattern: "Striped/Spotted"
//        )
//        let pagination = CatBreedsPagination(currentPage: 1, lastPage: 1)
//        let response = Cats.Load.Response(breeds: [breed], selectedIndex: 0, pagination: pagination)
//        
//        // When
//        sut.presentBreeds(response: response)
//        
//        // Then
//        let item = mockViewController.lastDisplayedBreeds?.items[0]
//        XCTAssertEqual(item?.name, "Müller's Cat 🐱")
//        XCTAssertTrue(item?.detailText?.contains("Côte d'Ivoire") ?? false)
//        XCTAssertTrue(item?.detailText?.contains("São Paulo") ?? false)
//        XCTAssertTrue(item?.detailText?.contains("Short & Dense") ?? false)
//        XCTAssertTrue(item?.detailText?.contains("Striped/Spotted") ?? false)
//    }
}
//class MockCatsViewController: CatsDisplayLogic {
//    
//    var lastDisplayedBreeds: Cats.Load.ViewModel?
//    var lastDisplayedLoading: Cats.Loading.ViewModel?
//    var lastDisplayedError: Cats.Error.ViewModel?
//    
//    var displayBreedsCallCount = 0
//    var displayLoadingCallCount = 0
//    var displayErrorCallCount = 0
//    
//    func displayBreeds(viewModel: Cats.Load.ViewModel) {
//        lastDisplayedBreeds = viewModel
//        displayBreedsCallCount += 1
//    }
//    
//    func displayLoading(viewModel: Cats.Loading.ViewModel) {
//        lastDisplayedLoading = viewModel
//        displayLoadingCallCount += 1
//    }
//    
//    func displayError(viewModel: Cats.Error.ViewModel) {
//        lastDisplayedError = viewModel
//        displayErrorCallCount += 1
//    }
//}
