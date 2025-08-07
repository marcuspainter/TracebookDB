//
//  MeasurementListView.swift
//  TracebookDB
//
//  Created by Marcus Painter on 07/07/2025.
//

import SwiftData
import SwiftUI

struct MeasurementListView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\MeasurementItem.createdDate, order: .reverse)]) var measurements: [MeasurementItem]

    private var bubbleAPI = BubbleAPI()

    init(sort: SortDescriptor<MeasurementItem>, searchText: String) {
        _measurements = Query(filter: #Predicate {
            if searchText.isEmpty {
                return true
            } else {
                return $0.title.localizedStandardContains(searchText)
            }
        }, sort: [sort])
    }

    var body: some View {
        List {
            ForEach(measurements) { measurement in
                NavigationLink(value: measurement) {
                    MeasurementItemView(measurement: measurement)
                }
            }
        }
        
        Button("Add") {
            let m = MeasurementItem(id: UUID().uuidString, title: UUID().uuidString)
            modelContext.insert(m)
            do {
                try modelContext.save()
            } catch {
                print(error)
            }
        }

        Button("Delete") {
            let descriptor1 = FetchDescriptor<MeasurementItem>()
            if let all = try? modelContext.fetch(descriptor1) {
                for m in all {
                    modelContext.delete(m)
                }
                try? modelContext.save()
            }
            let descriptor2 = FetchDescriptor<MeasurementContent>()
            if let all = try? modelContext.fetch(descriptor2) {
                for m in all {
                    modelContext.delete(m)
                }
                try? modelContext.save()
            }
        }

        Button("Download 2") {
            Task {
                var list = [MeasurementItem]()
                let measurements = await bubbleAPI.getMeasurementLong()
                for measurement in measurements {
                    
                    let m = MeasurementMapper.toModel(body: measurement)
                    
                    //if let content = await bubbleAPI.getMeasurementContent(id: m.contentId) {
                    //    if let c = DataMapper.mapMeasurementContent(body: content) {
                    //        m.content = c
                    //        c.item = m
                    //   }
                    //}
                    
                    print(m.title)
                    
                    do {
                        modelContext.insert(m)
                        try modelContext.save()
                        list.append(m)
                    }
                    catch {
                        print("Error: \(error)")
                    }
                }
                
                for m in list {
                    if m.additionalContent == "" { continue }
                    if let content = await bubbleAPI.getMeasurementContent(id: m.additionalContent) {
                        if let c = MeasurementContentMapper.toModel(body: content) {
                            assert(m.additionalContent == c.id, "No match")
                            m.content = c
                            c.item = m
                        }
                    }
                    print(m.title)
                }
                print("Done")
            }
        }
    }
}

#Preview {
    MeasurementListView(sort: SortDescriptor(\MeasurementItem.createdDate, order: .reverse), searchText: "")
}
