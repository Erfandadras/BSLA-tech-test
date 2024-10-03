//
//  BSLA_tech_taskTests.swift
//  BSLA tech taskTests
//
//  Created by Erfan mac mini on 10/3/24.
//

import XCTest
@testable import BSLA_tech_task

final class BSLA_tech_taskTests: XCTestCase {
    var dataSource: RecepieDataSource!
    var networkClient: NetworkClient!
    var offlineDataSource: MockOfflineRecepiesDataSource!
    var mockDelegate: MockRecepieDataSourceDelegate!
    var reachability: NetworkReachabilityRepo!
    
    override func setUpWithError() throws {
        networkClient = MockRecepieListNetworkClient()
        offlineDataSource = MockOfflineRecepiesDataSource()
        mockDelegate = MockRecepieDataSourceDelegate()
        reachability = MockNetworkReachability()
        dataSource = RecepieDataSource(client: networkClient,
                                       offlineDataSource: offlineDataSource,
                                       reachability: reachability)
        dataSource.delegate = mockDelegate
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.        dataSource = nil
        dataSource = nil
        networkClient = nil
        offlineDataSource = nil
        mockDelegate = nil
    }

    func testLoadAllDataWhenNotReachable() {
        // Arrange
        reachability.changeRechability(reachable: false)
        offlineDataSource.mockStoredData = UIRecepieItemModel.sampleData

        let expectation = XCTestExpectation(description: "Load all data without network")

        // Act
        dataSource.loadAllData {
            expectation.fulfill()
        }

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockDelegate.didUpdateUI)
        XCTAssertEqual(mockDelegate.updatedData?.count, 5)
    }
    
    func testSearchWithValidKeyword() {
        // Arrange
        reachability.changeRechability(reachable: true)
        let expectation = XCTestExpectation(description: "Search with valid keyword")

        // Act
        dataSource.search(with: "pasta") { success in
            XCTAssertTrue(success)
            expectation.fulfill()
        }

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockDelegate.didUpdateUI)
        XCTAssertEqual(mockDelegate.updatedData?.count, 1) // Based on json file there is one recipe with title containts 'Pasta'
    }
    
    func testSearchWithInvalidKeyword() {
        // Arrange
        reachability.changeRechability(reachable: true)
        let expectation = XCTestExpectation(description: "Search with invalid keyword")

        // Act
        dataSource.search(with: "invalid") { success in
            XCTAssertFalse(success)
            expectation.fulfill()
        }

        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertFalse(mockDelegate.didUpdateUI)
        XCTAssertTrue(mockDelegate.didHandleError)
    }

    
    func testBookmarkRecepie() {
        // Act
        let id = 1
        offlineDataSource.mockStoredData = UIRecepieItemModel.sampleData
        dataSource.bookmark(recepie: id)
        //        XCTAssertTrue(mockDelegate.updatedData?.first(where: {$0.id == id})?.bookmark == true)
        // Assert
        XCTAssertTrue(mockDelegate.didUpdateUI)
        XCTAssertTrue(mockDelegate.updatedData?.first(where: {$0.id == id})?.bookmark == true)
    }
    
    
    func testBookmarkToggleRecepie() {
        // Act
        let id = 1
        offlineDataSource.mockStoredData = UIRecepieItemModel.sampleData
        let previousBookmark = UIRecepieItemModel.sampleData.first(where: {$0.id == id})?.bookmark ?? false
        dataSource.bookmark(recepie: id)
        //        XCTAssertTrue(mockDelegate.updatedData?.first(where: {$0.id == id})?.bookmark == true)
        // Assert
        XCTAssertTrue(mockDelegate.didUpdateUI)
        XCTAssertTrue(mockDelegate.updatedData?.first(where: {$0.id == id})?.bookmark != previousBookmark)
    }
}


class MockOfflineRecepiesDataSource: OfflineRecepiesDataSourceRepo {
    var mockStoredData: [UIRecepieItemModel] = []

    func fetchBookmarked() -> [UIRecepieItemModel] {
        return mockStoredData.filter(\.bookmark)
    }
    
    func store(recepies data: [RRecepieItemModel]) {
        let uiData = data.map({UIRecepieItemModel(data: $0)})
        mockStoredData.append(contentsOf: uiData)
    }
    
    func setOfflineDataSourceOutput(output: OfflineRecepiesDataSource.Output) {
        
    }
    
    func fetchData() -> [UIRecepieItemModel] {
        return mockStoredData
    }

    func toggleBookmark(with id: Int) -> UIRecepieItemModel? {
        var data = self.mockStoredData.first(where: {$0.id == id})
        data?.toggleBookmark()
        return data
    }
}

class MockRecepieDataSourceDelegate: RecepieDataSourceDelegate {
    var didUpdateUI = false
    var didHandleError = false
    var updatedData: [UIRecepieItemModel]?

    func uiDataUpdated(data: [UIRecepieItemModel]) {
        didUpdateUI = true
        updatedData = data
    }

    func handleDataSourceError(error: Error) {
        didHandleError = true
    }
}

class MockNetworkReachability: NetworkReachabilityRepo {
    var isReachableOnCellular: Bool = true
    
    func changeRechability(reachable: Bool) {
        isReachableOnCellular = reachable
    }
}

fileprivate extension UIRecepieItemModel {
    static let sampleData: [UIRecepieItemModel] = [.init(id: 0, name: "name", description: "description"),
                                                   .init(id: 1, name: "name1", description: "description1"),
                                                   .init(id: 2, name: "name2", description: "description2"),
                                                   .init(id: 3, name: "name3", description: "description3", bookmarked: true),
                                                   .init(id: 4, name: "name4", description: "description4", bookmarked: true)
    ]
}
