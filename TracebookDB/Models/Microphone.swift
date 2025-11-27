//
//  Microphone.swift
//  TracebookDB
//
//  Created by Marcus Painter on 25/11/2025.
//

import Foundation
import SwiftData

@Model
final class Microphone {
    var id: String
    var micBrandModel: String?
    var createdBy: String?
    var createdDate: String?
    var modifiedDate: String?

    init(id: String,
    ) {
        self.id = id
    }
}
