//
//  DataManager.swift
//  TracebookDB
//
//  Created by Marcus Painter on 10/07/2025.
//

import Foundation
import SwiftData
import Observation

@Observable
@MainActor
class DataManager {
    let container: ModelContainer
    let context: ModelContext

    // Optionally expose fetched data
    var measurements: [MeasurementItem] = []

    init() throws {
        container = try ModelContainer(for: MeasurementItem.self, MeasurementContent.self)
        context = ModelContext(container)
    }
    
    func getMeasurementItem(id: String) throws -> MeasurementItem? {
        var descriptor = FetchDescriptor<MeasurementItem>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }

    func addMeasurementItem(measurement: MeasurementItem) {
        context.insert(measurement)
        try? context.save()
    }

    func getMeasurementItems() throws -> [MeasurementItem] {
        let descriptor = FetchDescriptor<MeasurementItem>(sortBy: [.init(\.createdDate)])
        return try context.fetch(descriptor)
    }
    
    func deleteMeasurementItem(id: String) throws {
        let model = try getMeasurementItem(id: id)
        if let model {
            context.delete(model)
            try context.save()
        }
    }
    
    func deleteAllMeasurementItems(id: String) throws {
        let models = try getMeasurementItems()
        for model in models {
            context.delete(model)
        }
        try context.save()
    }
}
