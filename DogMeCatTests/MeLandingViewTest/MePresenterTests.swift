//
//  MePresenterTests.swift
//  DogMeCatTests
//
//  Created on 16/11/2568 BE.
//

import XCTest
@testable import DogMeCat

// MARK: - Mock ViewController

class MeMockViewController: MeDisplayLogic {
    
    var displayProfileCallCount = 0
    var displayLoadingCallCount = 0
    var displayErrorCallCount = 0
    
    var lastDisplayedViewModel: Me.Load.ViewModel?
    var lastLoadingState: Bool?
    var lastErrorMessage: String?
    
    var loadingStates: [Bool] = []
    
    func displayProfile(viewModel: Me.Load.ViewModel) {
        lastDisplayedViewModel = viewModel
    }
    
    func displayLoading(viewModel: Me.Loading.ViewModel) {
        lastLoadingState = viewModel.isLoading
        loadingStates.append(viewModel.isLoading)
    }
    
    func displayError(viewModel: Me.Error.ViewModel) {
        lastErrorMessage = viewModel.message
    }
}

final class MePresenterTests: XCTestCase {
    
    // System Under Test
    var sut: MePresenter!
    
    // Test Doubles
    var mockViewController: MeMockViewController!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        
        mockViewController = MeMockViewController()
        sut = MePresenter()
        sut.viewController = mockViewController
    }
    
    override func tearDown() {
        sut = nil
        mockViewController = nil
        
        super.tearDown()
    }
    
    private func createDate(day: Int, month: Int, year: Int) -> Date {
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        components.hour = 12 // Set noon to avoid timezone issues
        return Calendar.current.date(from: components) ?? Date()
    }
    
    private func createMockProfile() -> UserProfile {
        return UserProfile(
            title: "Mr",
            firstName: "John",
            lastName: "Doe",
            dateOfBirth: Date(),
            age: 30,
            gender: "male",
            nationality: "US",
            mobile: "+1234567890",
            address: "123 Main Street, New York, NY 10001, USA",
            profileImageURL: URL(string: "https://randomuser.me/api/portraits/men/1.jpg")
        )
    }
    
    // MARK: - presentProfile Tests
    
    func testPresentProfile() {
        let responseProfile = createMockProfile()
        
        let response = Me.Load.Response(profile: responseProfile)
        sut.presentProfile(response: response)

        XCTAssertNotNil(mockViewController.lastDisplayedViewModel, "ViewModel should not be nil")
    }
    
    func testPresentLoading() {
        sut.presentLoading(isLoading: true)
        
        XCTAssertEqual(mockViewController.lastLoadingState, true, "load successs")
    }
    
    func testPresentError() {
        let error = NSError(domain: "Test", code: 500, userInfo: [NSLocalizedDescriptionKey: "Error 1"])
        sut.presentError(error: error)
        XCTAssertNotNil(mockViewController.lastErrorMessage, "ViewModel should nil")
    }
    
//    MARK: - AI MOCK
    
//    // Test 1: presentProfile ควร format ViewModel ถูกต้องสำหรับ male
//    func testPresentProfile_WithMaleGender_ShouldFormatViewModelCorrectly() {
//        // Given
//        let mockProfile = UserProfile(
//            title: "Mr",
//            firstName: "John",
//            lastName: "Doe",
//            dateOfBirth: createDate(day: 15, month: 6, year: 1990),
//            age: 33,
//            gender: "male",
//            nationality: "US",
//            mobile: "+1234567890",
//            address: "123 Main Street, New York, NY 10001, USA",
//            profileImageURL: URL(string: "https://randomuser.me/api/portraits/men/1.jpg")
//        )
//        
//        let response = Me.Load.Response(profile: mockProfile)
//        
//        // When
//        sut.presentProfile(response: response)
//        
//        // Then
//        XCTAssertEqual(mockViewController.displayProfileCallCount, 1, "Should call displayProfile once")
//        
//        let viewModel = mockViewController.lastDisplayedViewModel
//        XCTAssertNotNil(viewModel, "ViewModel should not be nil")
//        
//        XCTAssertEqual(viewModel?.fullName, "Mr John Doe")
//        XCTAssertEqual(viewModel?.title, "Title: Mr")
//        XCTAssertEqual(viewModel?.firstName, "Firstname: John")
//        XCTAssertEqual(viewModel?.lastName, "Lastname: Doe")
//        XCTAssertEqual(viewModel?.dateOfBirth, "Date of Birth: 15/06/1990")
//        XCTAssertEqual(viewModel?.ageText, "Age: Age: 33")
//        XCTAssertEqual(viewModel?.genderIconName, "male-gender")
//        XCTAssertEqual(viewModel?.nationality, "Nationality: US")
//        XCTAssertEqual(viewModel?.mobile, "Mobile: +1234567890")
//        XCTAssertEqual(viewModel?.address, "Address: 123 Main Street, New York, NY 10001, USA")
//        XCTAssertEqual(viewModel?.profileImageURL?.absoluteString, "https://randomuser.me/api/portraits/men/1.jpg")
//    }
//    
//    /// Test 2: presentProfile ควร format ViewModel ถูกต้องสำหรับ female
//    func testPresentProfile_WithFemaleGender_ShouldFormatViewModelCorrectly() {
//        // Given
//        let mockProfile = UserProfile(
//            title: "Ms",
//            firstName: "Jane",
//            lastName: "Smith",
//            dateOfBirth: createDate(day: 25, month: 12, year: 1995),
//            age: 28,
//            gender: "female",
//            nationality: "UK",
//            mobile: "+44987654321",
//            address: "456 Oxford Street, London, UK",
//            profileImageURL: URL(string: "https://randomuser.me/api/portraits/women/2.jpg")
//        )
//        
//        let response = Me.Load.Response(profile: mockProfile)
//        
//        // When
//        sut.presentProfile(response: response)
//        
//        // Then
//        let viewModel = mockViewController.lastDisplayedViewModel
//        XCTAssertNotNil(viewModel)
//        
//        XCTAssertEqual(viewModel?.fullName, "Ms Jane Smith")
//        XCTAssertEqual(viewModel?.genderIconName, "femal-gender")
//        XCTAssertEqual(viewModel?.dateOfBirth, "Date of Birth: 25/12/1995")
//    }
//    
//    /// Test 3: presentProfile กับ gender ไม่รู้จัก - ควรใช้ default icon
//    func testPresentProfile_WithUnknownGender_ShouldUseDefaultIcon() {
//        // Given
//        let mockProfile = UserProfile(
//            title: "Mx",
//            firstName: "Alex",
//            lastName: "Johnson",
//            dateOfBirth: Date(),
//            age: 30,
//            gender: "other",
//            nationality: "CA",
//            mobile: "+1234567890",
//            address: "123 Street",
//            profileImageURL: nil
//        )
//        
//        let response = Me.Load.Response(profile: mockProfile)
//        
//        // When
//        sut.presentProfile(response: response)
//        
//        // Then
//        let viewModel = mockViewController.lastDisplayedViewModel
//        XCTAssertEqual(viewModel?.genderIconName, "icon_gender_unknown")
//    }
//    
//    /// Test 4: presentProfile กับ gender ตัวพิมพ์ใหญ่ - ควร handle ได้
//    func testPresentProfile_WithUppercaseGender_ShouldHandleCorrectly() {
//        // Given
//        let mockProfile = UserProfile(
//            title: "Mr",
//            firstName: "Bob",
//            lastName: "Williams",
//            dateOfBirth: Date(),
//            age: 35,
//            gender: "MALE",
//            nationality: "US",
//            mobile: "+1234567890",
//            address: "123 Street",
//            profileImageURL: nil
//        )
//        
//        let response = Me.Load.Response(profile: mockProfile)
//        
//        // When
//        sut.presentProfile(response: response)
//        
//        // Then
//        let viewModel = mockViewController.lastDisplayedViewModel
//        XCTAssertEqual(viewModel?.genderIconName, "male-gender", "Should handle uppercase gender")
//    }
//    
//    /// Test 5: presentProfile กับ profileImageURL เป็น nil
//    func testPresentProfile_WithNilImageURL_ShouldHandleCorrectly() {
//        // Given
//        let mockProfile = UserProfile(
//            title: "Dr",
//            firstName: "Sarah",
//            lastName: "Brown",
//            dateOfBirth: Date(),
//            age: 40,
//            gender: "female",
//            nationality: "AU",
//            mobile: "+61123456789",
//            address: "789 George Street, Sydney, AU",
//            profileImageURL: nil
//        )
//        
//        let response = Me.Load.Response(profile: mockProfile)
//        
//        // When
//        sut.presentProfile(response: response)
//        
//        // Then
//        let viewModel = mockViewController.lastDisplayedViewModel
//        XCTAssertNil(viewModel?.profileImageURL, "Image URL should be nil")
//    }
//    
//    /// Test 6: presentProfile ควร format วันที่ในรูปแบบ dd/MM/yyyy
//    func testPresentProfile_ShouldFormatDateCorrectly() {
//        // Given
//        let mockProfile = UserProfile(
//            title: "Mr",
//            firstName: "Test",
//            lastName: "User",
//            dateOfBirth: createDate(day: 1, month: 1, year: 2000),
//            age: 23,
//            gender: "male",
//            nationality: "TH",
//            mobile: "+66812345678",
//            address: "Bangkok, Thailand",
//            profileImageURL: nil
//        )
//        
//        let response = Me.Load.Response(profile: mockProfile)
//        
//        // When
//        sut.presentProfile(response: response)
//        
//        // Then
//        let viewModel = mockViewController.lastDisplayedViewModel
//        XCTAssertEqual(viewModel?.dateOfBirth, "Date of Birth: 01/01/2000")
//    }
//    
//    /// Test 7: presentProfile หลายครั้ง - ควรเรียก displayProfile ทุกครั้ง
//    func testPresentProfile_MultipleTimes_ShouldCallDisplayProfileEachTime() {
//        // Given
//        let profile1 = UserProfile(
//            title: "Mr",
//            firstName: "John",
//            lastName: "Doe",
//            dateOfBirth: Date(),
//            age: 30,
//            gender: "male",
//            nationality: "US",
//            mobile: "+1234567890",
//            address: "123 Street",
//            profileImageURL: nil
//        )
//        
//        let profile2 = UserProfile(
//            title: "Ms",
//            firstName: "Jane",
//            lastName: "Smith",
//            dateOfBirth: Date(),
//            age: 25,
//            gender: "female",
//            nationality: "UK",
//            mobile: "+44987654321",
//            address: "456 Street",
//            profileImageURL: nil
//        )
//        
//        // When
//        sut.presentProfile(response: Me.Load.Response(profile: profile1))
//        sut.presentProfile(response: Me.Load.Response(profile: profile2))
//        
//        // Then
//        XCTAssertEqual(mockViewController.displayProfileCallCount, 2, "Should call displayProfile twice")
//        XCTAssertEqual(mockViewController.lastDisplayedViewModel?.firstName, "Firstname: Jane")
//    }
//    
//    /// Test 8: presentProfile กับข้อมูลพิเศษในชื่อ (มี emoji, ตัวอักษรพิเศษ)
//    func testPresentProfile_WithSpecialCharactersInName_ShouldFormatCorrectly() {
//        // Given
//        let mockProfile = UserProfile(
//            title: "Mr",
//            firstName: "José",
//            lastName: "García",
//            dateOfBirth: Date(),
//            age: 35,
//            gender: "male",
//            nationality: "ES",
//            mobile: "+34123456789",
//            address: "Madrid, Spain",
//            profileImageURL: nil
//        )
//        
//        let response = Me.Load.Response(profile: mockProfile)
//        
//        // When
//        sut.presentProfile(response: response)
//        
//        // Then
//        let viewModel = mockViewController.lastDisplayedViewModel
//        XCTAssertEqual(viewModel?.fullName, "Mr José García")
//        XCTAssertEqual(viewModel?.firstName, "Firstname: José")
//        XCTAssertEqual(viewModel?.lastName, "Lastname: García")
//    }
//    
//    // MARK: - presentLoading Tests
//    
//    /// Test 9: presentLoading(true) - ควรแสดง loading
//    func testPresentLoading_WithTrue_ShouldDisplayLoading() {
//        // When
//        sut.presentLoading(isLoading: true)
//        
//        // Then
//        XCTAssertEqual(mockViewController.displayLoadingCallCount, 1, "Should call displayLoading once")
//        XCTAssertEqual(mockViewController.lastLoadingState, true, "Should be loading")
//    }
//    
//    /// Test 10: presentLoading(false) - ควรซ่อน loading
//    func testPresentLoading_WithFalse_ShouldHideLoading() {
//        // When
//        sut.presentLoading(isLoading: false)
//        
//        // Then
//        XCTAssertEqual(mockViewController.displayLoadingCallCount, 1, "Should call displayLoading once")
//        XCTAssertEqual(mockViewController.lastLoadingState, false, "Should not be loading")
//    }
//    
//    /// Test 11: presentLoading หลายครั้ง - ควรเรียก displayLoading ทุกครั้ง
//    func testPresentLoading_MultipleTimes_ShouldCallDisplayLoadingEachTime() {
//        // When
//        sut.presentLoading(isLoading: true)
//        sut.presentLoading(isLoading: false)
//        sut.presentLoading(isLoading: true)
//        
//        // Then
//        XCTAssertEqual(mockViewController.displayLoadingCallCount, 3, "Should call displayLoading 3 times")
//        XCTAssertEqual(mockViewController.loadingStates, [true, false, true])
//    }
//    
//    // MARK: - presentError Tests
//    
//    /// Test 12: presentError - ควรแสดง error message
//    func testPresentError_ShouldDisplayErrorMessage() {
//        // Given
//        let error = NSError(
//            domain: "TestError",
//            code: 500,
//            userInfo: [NSLocalizedDescriptionKey: "Network connection failed"]
//        )
//        
//        // When
//        sut.presentError(error: error)
//        
//        // Then
//        XCTAssertEqual(mockViewController.displayErrorCallCount, 1, "Should call displayError once")
//        XCTAssertEqual(mockViewController.lastErrorMessage, "Network connection failed")
//    }
//    
//    /// Test 13: presentError กับ error ที่ไม่มี description
//    func testPresentError_WithErrorWithoutDescription_ShouldDisplayDefaultMessage() {
//        // Given
//        let error = NSError(domain: "TestError", code: 404, userInfo: nil)
//        
//        // When
//        sut.presentError(error: error)
//        
//        // Then
//        XCTAssertEqual(mockViewController.displayErrorCallCount, 1)
//        XCTAssertNotNil(mockViewController.lastErrorMessage)
//        // NSError จะมี default localized description
//        XCTAssertFalse(mockViewController.lastErrorMessage?.isEmpty ?? true)
//    }
//    
//    /// Test 14: presentError หลายครั้ง - ควรแสดง error ทุกครั้ง
//    func testPresentError_MultipleTimes_ShouldDisplayErrorEachTime() {
//        // Given
//        let error1 = NSError(domain: "Test", code: 500, userInfo: [NSLocalizedDescriptionKey: "Error 1"])
//        let error2 = NSError(domain: "Test", code: 404, userInfo: [NSLocalizedDescriptionKey: "Error 2"])
//        
//        // When
//        sut.presentError(error: error1)
//        sut.presentError(error: error2)
//        
//        // Then
//        XCTAssertEqual(mockViewController.displayErrorCallCount, 2, "Should call displayError twice")
//        XCTAssertEqual(mockViewController.lastErrorMessage, "Error 2")
//    }
//    
//    /// Test 15: presentError กับ custom error
//    func testPresentError_WithCustomError_ShouldDisplayCustomMessage() {
//        // Given
//        enum CustomError: Error, LocalizedError {
//            case invalidData
//            
//            var errorDescription: String? {
//                return "Invalid data received from server"
//            }
//        }
//        
//        let error = CustomError.invalidData
//        
//        // When
//        sut.presentError(error: error)
//        
//        // Then
//        XCTAssertEqual(mockViewController.lastErrorMessage, "Invalid data received from server")
//    }
//    
//    // MARK: - ViewController Reference Tests
//    
//    /// Test 16: ViewController เป็น nil - ไม่ควร crash
//    func testPresenter_WithNilViewController_ShouldNotCrash() {
//        // Given
//        sut.viewController = nil
//        let mockProfile = createMockProfile()
//        
//        // When/Then - Should not crash
//        XCTAssertNoThrow {
//            self.sut.presentProfile(response: Me.Load.Response(profile: mockProfile))
//            self.sut.presentLoading(isLoading: true)
//            self.sut.presentError(error: NSError(domain: "Test", code: 500, userInfo: nil))
//        }
//    }
//    
//    // MARK: - Date Formatting Tests
//    
//    /// Test 17: Date formatting กับวันที่ต่างๆ
//    func testPresentProfile_WithVariousDates_ShouldFormatCorrectly() {
//        // Given - วันที่ต้นปี
//        var profile = UserProfile(
//            title: "Mr",
//            firstName: "Test",
//            lastName: "User",
//            dateOfBirth: createDate(day: 1, month: 1, year: 2000),
//            age: 23,
//            gender: "male",
//            nationality: "TH",
//            mobile: "+66812345678",
//            address: "Bangkok",
//            profileImageURL: nil
//        )
//        
//        // When
//        sut.presentProfile(response: Me.Load.Response(profile: profile))
//        
//        // Then
//        XCTAssertEqual(mockViewController.lastDisplayedViewModel?.dateOfBirth, "Date of Birth: 01/01/2000")
//        
//        // Given - วันที่กลางปี
//        profile = UserProfile(
//            title: "Ms",
//            firstName: "Test",
//            lastName: "User",
//            dateOfBirth: createDate(day: 15, month: 6, year: 1990),
//            age: 33,
//            gender: "female",
//            nationality: "TH",
//            mobile: "+66812345678",
//            address: "Bangkok",
//            profileImageURL: nil
//        )
//        
//        // When
//        sut.presentProfile(response: Me.Load.Response(profile: profile))
//        
//        // Then
//        XCTAssertEqual(mockViewController.lastDisplayedViewModel?.dateOfBirth, "Date of Birth: 15/06/1990")
//        
//        // Given - วันที่ปลายปี
//        profile = UserProfile(
//            title: "Mr",
//            firstName: "Test",
//            lastName: "User",
//            dateOfBirth: createDate(day: 31, month: 12, year: 1985),
//            age: 38,
//            gender: "male",
//            nationality: "TH",
//            mobile: "+66812345678",
//            address: "Bangkok",
//            profileImageURL: nil
//        )
//        
//        // When
//        sut.presentProfile(response: Me.Load.Response(profile: profile))
//        
//        // Then
//        XCTAssertEqual(mockViewController.lastDisplayedViewModel?.dateOfBirth, "Date of Birth: 31/12/1985")
//    }

}
