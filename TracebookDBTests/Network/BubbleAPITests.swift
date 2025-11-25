//
//  BubbleAPITests.swift
//  TracebookDB
//
//  Created by Marcus Painter on 18/08/2025.
//

import XCTest
@testable import TracebookDB

final class BubbleAPITests: XCTestCase {
    
    private var bubbleAPI = BubbleAPI()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetItemResponse() async throws {
        
    }
    
    func testGetListResponse() async throws {
        
    }
    
    func testGetListResponseLong() async throws {
        let bubbleRequest = BubbleRequest(entity: "measurement")
        let fromDate = "2000-01-01T00:00:00Z"
        bubbleRequest.constraints.append(BubbleConstraint(key: MeasurementBody.CodingKeys.isPublic.rawValue, type: .equals, value: "true"))
        bubbleRequest.constraints.append(BubbleConstraint(key: MeasurementBody.CodingKeys.createdDate.rawValue, type: .greaterThan, value: fromDate))
        bubbleRequest.sortKeys.append(BubbleSortKey(sortField: MeasurementBody.CodingKeys.createdDate.rawValue, order: .descending))
        
        let responses = await bubbleAPI.getListResponseLong(MeasurementListResponse.self, for: bubbleRequest)
        
        var users = [MeasurementBody]()
        for response in responses {
            let userResults: [MeasurementBody] = response.response.results
            users += userResults
            print(userResults.first?.title)
        }
        print(users.count)
    }
    
    func testExample() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions
        // afterwards.
        
        let id = "1748335228210x830249946152173600"
        let entity = "measurementcontent"
        
        let bubbleRequest = BubbleRequest(entity: entity, id: id)
        
        let response = await bubbleAPI.getItemResponse(MeasurementContentItemResponse.self, for: bubbleRequest)
        
        print(response?.response.interfaceBrandModel ?? "")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
