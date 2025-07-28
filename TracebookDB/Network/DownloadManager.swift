//
//  DownloadManager.swift
//  TracebookDB
//
//  Created by Marcus Painter on 08/07/2025.
//

import Foundation
import Network
import SwiftData

class DownloadManager {

    var api = TracebookAPI()
    
    init() {
    }
    
    func download() async {
        let fromDate = "2001-01-01T00:00:00Z"
        if let response = await api.getMeasurementListbyDate(fromDate: fromDate) {
            print(response.response.remaining)
            response.response.results.forEach { print($0.title) }
        }
    }
    
}
