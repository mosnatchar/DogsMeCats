//
//  MeInteractorTests.swift
//  DogMeCatTests
//
//  Created on 16/11/2568 BE.
//

import XCTest
@testable import DogMeCat

// MARK: - Mock Worker
class MeMockWorker: MeWorkerProtocol {
    
    var shouldSucceed = true
    var profileToReturn: UserProfile?
    var errorToReturn: Error?
    
    var fetchProfileCallCount = 0
    
    func fetchProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        fetchProfileCallCount += 1
        
        // Simulate async behavior
        DispatchQueue.global().async {
            if self.shouldSucceed {
                if let profile = self.profileToReturn {
                    completion(.success(profile))
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


// MARK: - Mock Presenter

class MeMockPresenter: MePresentationLogic {
    
    var presentProfileCallCount = 0
    var presentLoadingCallCount = 0
    var presentErrorCallCount = 0
    
    var lastPresentedProfile: UserProfile?
    var lastPresentedError: Error?
    var loadingStates: [Bool] = []
    
    var onPresentProfile: (() -> Void)?
    var onPresentLoading: (() -> Void)?
    var onPresentError: (() -> Void)?
    
    func presentProfile(response: Me.Load.Response) {
        presentProfileCallCount += 1
        lastPresentedProfile = response.profile
        onPresentProfile?()
    }
    
    func presentLoading(isLoading: Bool) {
        presentLoadingCallCount += 1
        loadingStates.append(isLoading)
        onPresentLoading?()
    }
    
    func presentError(error: Error) {
        presentErrorCallCount += 1
        lastPresentedError = error
        onPresentError?()
    }
}


final class MeInteractorTests: XCTestCase {
    
    // System Under Test
    var sut: MeInteractor!
    
    // Test Doubles
    var mockWorker: MeMockWorker!
    var mockPresenter: MeMockPresenter!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        
        mockWorker = MeMockWorker()
        mockPresenter = MeMockPresenter()
        
        sut = MeInteractor(worker: mockWorker)
        sut.presenter = mockPresenter
    }
    
    override func tearDown() {
        sut = nil
        mockWorker = nil
        mockPresenter = nil
        
        super.tearDown()
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
    
    // MARK: - loadProfile Tests
    
    func testloadProfile() {
        let expectation = self.expectation(description: "Load profile success")
        let response = createMockProfile()
        mockWorker.shouldSucceed = true
        mockWorker.profileToReturn = response
        sut.loadProfile(request: Me.Load.Request())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.mockPresenter.lastPresentedProfile, "Should present response")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testloadProfileFailure() {
        let expectation = self.expectation(description: "Load profile success")
        mockWorker.shouldSucceed = false
        sut.loadProfile(request: Me.Load.Request())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.mockPresenter.lastPresentedError, "Should present response")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
}
    
    
    //    MARK: - AI MOCK
    /// Test 1: loadProfile สำเร็จ - ควรเรียก presentLoading, presentProfile และเก็บ profile ใน DataStore
//    func testLoadProfile_Success_ShouldPresentLoadingAndProfile() {
//        // Given
//        let expectation = self.expectation(description: "Load profile success")
//        let mockProfile = createMockProfile()
//        
//        mockWorker.shouldSucceed = true
//        mockWorker.profileToReturn = mockProfile
//        
//        let request = Me.Load.Request()
//        
//        // When
//        sut.loadProfile(request: request)
//        
//        // Then
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            // Verify loading states
//            XCTAssertEqual(self.mockPresenter.presentLoadingCallCount, 2, "Should call presentLoading twice (start and stop)")
//            XCTAssertTrue(self.mockPresenter.loadingStates.contains(true), "Should show loading")
//            XCTAssertTrue(self.mockPresenter.loadingStates.contains(false), "Should hide loading")
//            
//            // Verify profile presentation
//            XCTAssertEqual(self.mockPresenter.presentProfileCallCount, 1, "Should call presentProfile once")
//            XCTAssertNotNil(self.mockPresenter.lastPresentedProfile, "Should present profile")
//            XCTAssertEqual(self.mockPresenter.lastPresentedProfile?.firstName, "John")
//            XCTAssertEqual(self.mockPresenter.lastPresentedProfile?.lastName, "Doe")
//            
//            // Verify DataStore
//            XCTAssertNotNil(self.sut.profile, "Should store profile in DataStore")
//            XCTAssertEqual(self.sut.profile?.firstName, "John")
//            
//            // Verify no error
//            XCTAssertEqual(self.mockPresenter.presentErrorCallCount, 0, "Should not call presentError")
//            
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 1.0)
//    }
//    
//    /// Test 2: loadProfile ล้มเหลว - ควรเรียก presentError
//    func testLoadProfile_Failure_ShouldPresentError() {
//        // Given
//        let expectation = self.expectation(description: "Load profile failure")
//        let mockError = NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Network error"])
//        
//        mockWorker.shouldSucceed = false
//        mockWorker.errorToReturn = mockError
//        
//        let request = Me.Load.Request()
//        
//        // When
//        sut.loadProfile(request: request)
//        
//        // Then
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            // Verify loading states
//            XCTAssertEqual(self.mockPresenter.presentLoadingCallCount, 2, "Should call presentLoading twice")
//            
//            // Verify error presentation
//            XCTAssertEqual(self.mockPresenter.presentErrorCallCount, 1, "Should call presentError once")
//            XCTAssertNotNil(self.mockPresenter.lastPresentedError, "Should present error")
//            XCTAssertEqual((self.mockPresenter.lastPresentedError as? NSError)?.domain, "TestError")
//            
//            // Verify profile is not set
//            XCTAssertNil(self.sut.profile, "Should not store profile when error occurs")
//            
//            // Verify profile not presented
//            XCTAssertEqual(self.mockPresenter.presentProfileCallCount, 0, "Should not call presentProfile")
//            
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 1.0)
//    }
//    
//    /// Test 3: loadProfile ควรเรียก worker.fetchProfile
//    func testLoadProfile_ShouldCallWorkerFetchProfile() {
//        // Given
//        let expectation = self.expectation(description: "Worker called")
//        let mockProfile = createMockProfile()
//        
//        mockWorker.shouldSucceed = true
//        mockWorker.profileToReturn = mockProfile
//        
//        let request = Me.Load.Request()
//        
//        // When
//        sut.loadProfile(request: request)
//        
//        // Then
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            XCTAssertEqual(self.mockWorker.fetchProfileCallCount, 1, "Should call fetchProfile once")
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 1.0)
//    }
//    
//    /// Test 4: loadProfile หลายครั้ง - ควร update profile ทุกครั้ง
//    func testLoadProfile_MultipleTimes_ShouldUpdateProfile() {
//        // Given
//        let expectation = self.expectation(description: "Multiple loads")
//        
//        let firstProfile = UserProfile(
//            title: "Mr",
//            firstName: "John",
//            lastName: "Doe",
//            dateOfBirth: Date(),
//            age: 30,
//            gender: "male",
//            nationality: "US",
//            mobile: "123456789",
//            address: "123 Main St",
//            profileImageURL: URL(string: "https://example.com/1.jpg")
//        )
//        
//        let secondProfile = UserProfile(
//            title: "Ms",
//            firstName: "Jane",
//            lastName: "Smith",
//            dateOfBirth: Date(),
//            age: 25,
//            gender: "female",
//            nationality: "UK",
//            mobile: "987654321",
//            address: "456 Oak Ave",
//            profileImageURL: URL(string: "https://example.com/2.jpg")
//        )
//        
//        mockWorker.shouldSucceed = true
//        mockWorker.profileToReturn = firstProfile
//        
//        let request = Me.Load.Request()
//        
//        // When - First load
//        sut.loadProfile(request: request)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            // Verify first load
//            XCTAssertEqual(self.sut.profile?.firstName, "John")
//            
//            // When - Second load
//            self.mockWorker.profileToReturn = secondProfile
//            self.sut.loadProfile(request: request)
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                // Then - Verify second load
//                XCTAssertEqual(self.sut.profile?.firstName, "Jane")
//                XCTAssertEqual(self.mockPresenter.presentProfileCallCount, 2, "Should present profile twice")
//                
//                expectation.fulfill()
//            }
//        }
//        
//        waitForExpectations(timeout: 1.0)
//    }
//    
//    /// Test 5: loadProfile ควรแสดง loading ก่อน และซ่อนหลังจากได้ผลลัพธ์
//    func testLoadProfile_ShouldShowLoadingBeforeAndHideAfter() {
//        // Given
//        let expectation = self.expectation(description: "Loading sequence")
//        let mockProfile = createMockProfile()
//        
//        mockWorker.shouldSucceed = true
//        mockWorker.profileToReturn = mockProfile
//        
//        let request = Me.Load.Request()
//        
//        // When
//        sut.loadProfile(request: request)
//        
//        // Then
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            // Verify loading sequence
//            XCTAssertEqual(self.mockPresenter.loadingStates.count, 2, "Should have 2 loading states")
//            XCTAssertEqual(self.mockPresenter.loadingStates.first, true, "First state should be loading")
//            XCTAssertEqual(self.mockPresenter.loadingStates.last, false, "Last state should be not loading")
//            
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 1.0)
//    }
//    
//    /// Test 6: loadProfile เมื่อ worker ส่ง error - ควรไม่ update DataStore
//    func testLoadProfile_OnError_ShouldNotUpdateDataStore() {
//        // Given
//        let expectation = self.expectation(description: "Error handling")
//        let mockError = NSError(domain: "TestError", code: 404, userInfo: nil)
//        
//        // Set initial profile
//        let initialProfile = createMockProfile()
//        sut.profile = initialProfile
//        
//        mockWorker.shouldSucceed = false
//        mockWorker.errorToReturn = mockError
//        
//        let request = Me.Load.Request()
//        
//        // When
//        sut.loadProfile(request: request)
//        
//        // Then
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            // Profile should remain unchanged
//            XCTAssertEqual(self.sut.profile?.firstName, "John", "Profile should not change on error")
//            
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 1.0)
//    }
//    
//    /// Test 7: loadProfile ควรทำงานบน main thread เมื่อ present ผลลัพธ์
//    func testLoadProfile_ShouldPresentOnMainThread() {
//        // Given
//        let expectation = self.expectation(description: "Main thread presentation")
//        let mockProfile = createMockProfile()
//        
//        mockWorker.shouldSucceed = true
//        mockWorker.profileToReturn = mockProfile
//        
//        let request = Me.Load.Request()
//        
//        mockPresenter.onPresentProfile = {
//            XCTAssertTrue(Thread.isMainThread, "Should present on main thread")
//        }
//        
//        mockPresenter.onPresentError = {
//            XCTAssertTrue(Thread.isMainThread, "Should present error on main thread")
//        }
//        
//        mockPresenter.onPresentLoading = {
//            // Note: First call might not be on main thread
//            // Only verify the second call (after async completion)
//        }
//        
//        // When
//        sut.loadProfile(request: request)
//        
//        // Then
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 1.0)
//    }
//}
