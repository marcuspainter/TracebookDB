//
//  MainView.swift
//  TracebookDB
//
//  Created by Marcus Painter on 25/11/2025.
//

import Foundation
import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = MeasurementItemViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.items.isEmpty {
                    List {
                        ForEach(viewModel.items) { measurement in
                            NavigationLink(value: measurement) {
                                MeasurementItemView(measurement: measurement)
                            }
                        }.listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .refreshable {
// https://stackoverflow.com/questions/74977787/why-is-async-task-cancelled-in-a-refreshable-modifier-on-a-scrollview-ios-16
                        print("Pull")
                        await Task {
                            try? await Task.sleep(for: .seconds(5))
                        }.value
                        print("Done")
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
                        let bubbleAPI = TracebookAPI()
                        var list = [MeasurementItem]()
                        let measurements = await bubbleAPI.getMeasurementLong()
                        for measurement in measurements {
                            
                            let m = MeasurementItemMapper.toModel(body: measurement)
                            
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
            .navigationTitle("TracebookDB")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: MeasurementItem.self, destination: MeasurementDetailView.init)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // https://stackoverflow.com/questions/64269873/how-can-i-push-a-view-from-a-toolbaritem
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .task {
                viewModel.modelContext = modelContext
                viewModel.fetchAll()
            }
            .onAppear {

            }
            .searchable(text: $viewModel.searchText)
        }
    }
}

#Preview {
    //  MainView()
}
