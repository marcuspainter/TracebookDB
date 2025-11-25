//
//  MeasurementAPI.swift
//  TracebookDB
//
//  Created by Marcus Painter on 25/11/2025.
//

import Foundation
import Network

class MeasurementAPI {
    let bubbleAPI = BubbleAPI()
    
    func getMeasurementContent(id: String) async -> MeasurementContentBody? {
        let bubbleRequest = BubbleRequest(entity: "measurementcontent", id: id)
        
        let response = await bubbleAPI.getItemResponse(MeasurementContentItemResponse.self, for: bubbleRequest)
        
        return response?.response
    }
    
    func getMeasurementLong() async -> [MeasurementBody] {
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
        return users
    }
}
