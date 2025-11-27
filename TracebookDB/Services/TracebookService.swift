//
//  TracebookService.swift
//  TracebookDB
//
//  Created by Marcus Painter on 25/11/2025.
//

import Foundation

@Observable
@MainActor
final class TracebookService: Sendable {
    private(set) var api: TracebookAPI
    private(set) var store: TracebookStore

    init() {
        self.api = TracebookAPI()
        self.store = TracebookStore()
    }

    func synchronize() async {

        // Get DB latest date
        let date1 = fetchDBFirstMeasurementDate()
        let date2 = await getAPIFirstMeasurementDate()

        //print(date1)
        //print(date2)
    }

    func deleteAllMeasurements() {
        do {
            try store.deleteAllMeasurementItems()
        } catch {
            print("Error deleting measurements: \(error)")
        }
    }

    private func fetchDBFirstMeasurementDate() -> Date? {
        let item = try! store.fetchFirstMeasurementItem()
        return item?.createdDate
    }

    private func getAPIFirstMeasurementDate() async -> Date? {
        guard let body = await api.getLastMeasurement() else { return nil }
        return MeasurementItemMapper.toModel(body: body).createdDate
    }

    func synchronizeMeasurementItems() async {
        var list = [MeasurementItem]()
        let measurements = await api.getMeasurementLong()
        for measurement in measurements {

            let model = MeasurementItemMapper.toModel(body: measurement)

            print(model.title)

            do {
                try store.insertMeasurementItem(measurement: model)
                list.append(model)
            } catch {
                print("Error: \(error)")
            }
        }
        return
    }

    func getMicrophones() async -> [String: String] {
        var dictionary = [String: String]()
        let list = await api.getMicrophones()
        for item in list {
            dictionary[item.id] = item.micBrandModel ?? ""
        }
        return dictionary
    }
    
    func getAnalyzers() async -> [String: String] {
        var dictionary = [String: String]()
        let list = await api.getAnalyzers()
        for item in list {
            dictionary[item.id] = item.name ?? ""
        }
        return dictionary
    }
    
    func getInterfaces() async -> [String: String] {
        var dictionary = [String: String]()
        let list = await api.getInterfaces()
        for item in list {
            dictionary[item.id] = item.brandModel ?? ""
        }
        return dictionary
    }

    func synchronizeMeasurementContent() async {
        
        async let microphones = getMicrophones()
        async let analyzers   = getAnalyzers()
        async let interfaces  = getInterfaces()

        let (m, a, i) = await (microphones, analyzers, interfaces)
        
        let items = try! store.fetchMeasurementItems()
        for item in items {

            if item.additionalContent == "" { continue }

            if let contentBody = await api.getMeasurementContent(id: item.additionalContent) {
                if let content = MeasurementContentMapper.toModel(body: contentBody) {
                    
                    content.microphoneText = m[content.microphone] ?? ""
                    content.analyzerText = a[content.analyzer] ?? ""
                    content.interfaceText = i[content.interface] ?? ""
                    
                    item.content = content
                    
                    do {
                        try store.save()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
