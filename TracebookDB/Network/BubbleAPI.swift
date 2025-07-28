//
//  BubbleAPI.swift
//  TracebookDB
//
//  Created by Marcus Painter on 12/07/2025.
//

import Foundation
import Network

class BubbleAPI {
    
    // Get an item response
    func getItemResponse<T: BubbleItemResponseProtocol>(_ type: T.Type, for request: BubbleRequest) async -> T? {
        do {
            let urlRequest = request.urlRequest()
            let (jsonData, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
            // Cast to HTTPURLResponse to get status code
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("Invalid response type")
                return nil
            }
            
            let response = try JSONDecoder().decode(type, from: jsonData)
            return response
        } catch {
            print("Request error: \(error)")
        }
        return nil
    }
    
    // Get a list response
    func getListResponse<T: BubbleListResponseProtocol>(_ type: T.Type, for request: BubbleRequest) async -> T? {
        do {
            let urlRequest = request.urlRequest()
            let (jsonData, urlResponse) = try await URLSession.shared.data(for: urlRequest)
            
            // Cast to HTTPURLResponse to get status code
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("Invalid response type")
                return nil
                
            }
            print(httpResponse.statusCode)
            
            let response = try JSONDecoder().decode(type, from: jsonData)
            

            return response
        } catch {
            print("Request error: \(error)")
        }
        return nil
    }
    
    func getListResponseLong<T: BubbleListResponseProtocol>(
        _ type: T.Type,
        for initialRequest: BubbleRequest,
        pageSize: Int = 100
    ) async -> [T] {
        var responses: [T] = []
        let request = initialRequest

        while true {
            guard let response = await getListResponse(type, for: request) else {
                break
            }

            responses.append(response)
            print(response.response.remaining)

            if response.response.remaining > 0 {
                let newCursor: Int? =  response.response.cursor + pageSize
                request.cursor = newCursor
            } else {
                break
            }
        }

        return responses
    }

    func getMeasurementContent(id: String) async -> MeasurementContentBody? {
        let bubbleRequest = BubbleRequest(entity: "measurementcontent", id: id)
        
        let response = await getItemResponse(MeasurementContentItemResponse.self, for: bubbleRequest)
        
        return response?.response
    }
    
    func getMeasurementLong() async -> [MeasurementBody] {
        let bubbleRequest = BubbleRequest(entity: "measurement")
        let fromDate = "2000-01-01T00:00:00Z"
        bubbleRequest.constraints.append(BubbleConstraint(key: MeasurementBody.CodingKeys.isPublic.rawValue, type: .equals, value: "true"))
        bubbleRequest.constraints.append(BubbleConstraint(key: MeasurementBody.CodingKeys.createdDate.rawValue, type: .greaterThan, value: fromDate))
        bubbleRequest.sortKeys.append(BubbleSortKey(sortField: MeasurementBody.CodingKeys.createdDate.rawValue, order: .descending))
        
        let responses = await getListResponseLong(MeasurementListResponse.self, for: bubbleRequest)
        
        var users = [MeasurementBody]()
        for response in responses {
            let userResults: [MeasurementBody] = response.response.results
            users += userResults
            print(userResults.first?.title)
        }
        return users
    }
}

