//
//  MeasurementViewModel.swift
//  TracebookDB
//
//  Created by Marcus Painter on 07/07/2025.
//

import Foundation
import Observation
import SwiftData

@Observable
class MeasurementItemViewModel {

    private(set) var items: [MeasurementItem] = []
    var modelContext: ModelContext?
    
    var searchText: String = "" {
           didSet {
               if !searchText.isEmpty {
                   fetchFiltered(titleContains: searchText)
               }
           }
       }

    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }

    // Fetch filtered by title
     func fetchFiltered(titleContains: String) {
         guard let context = modelContext else { return }
         let predicate = #Predicate<MeasurementItem> { item in
             item.title.localizedStandardContains(titleContains)
         }
         
         let descriptor = FetchDescriptor<MeasurementItem>(
             predicate: predicate,
             sortBy: [SortDescriptor(\.createdDate, order: .reverse)]
         )
         
         do {
             items = try context.fetch(descriptor)
         } catch {
             print("Failed to fetch filtered items: \(error)")
             items = []
         }
     }
    
    func fetchAll() {
        guard let context = modelContext else { return }
        let descriptor = FetchDescriptor<MeasurementItem>(
            sortBy: [SortDescriptor(\MeasurementItem.createdDate, order: .reverse)]
        )

        do {
            items = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch items: \(error)")
            items = []
        }
    }
    
    func deleteAll() {
        guard let context = modelContext else { return }
        let descriptor = FetchDescriptor<MeasurementItem>()
        if let all = try? context.fetch(descriptor) {
            for m in all {
                context.delete(m)
            }
        }
    }
}
