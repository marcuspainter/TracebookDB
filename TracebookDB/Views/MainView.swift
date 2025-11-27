//
//  MainView.swift
//  TracebookDB
//
//  Created by Marcus Painter on 25/11/2025.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
struct MainView: View {
    @Environment(TracebookService.self) private var tracebookService
    @State private var viewModel = MeasurementItemViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
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
                            sync()
                        }.value
                        print("Done")
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
                viewModel.modelContext = self.tracebookService.store.context
                viewModel.fetchAll()
                
                await tracebookService.synchronize()
            }
            .searchable(text: $viewModel.searchText)
        }
    }
    
    func sync() {
        Task {
            tracebookService.deleteAllMeasurements()
            viewModel.fetchAll()
            print("Start items...")
            await tracebookService.synchronizeMeasurementItems()
            print("Done")
            viewModel.fetchAll()
            print("Start content...")
            await tracebookService.synchronizeMeasurementContent()
            viewModel.fetchAll()
            print("Done")
        }
    }
}

#Preview {
    //  MainView()
}
