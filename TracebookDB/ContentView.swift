//
//  ContentView.swift
//  TracebookDB
//
//  Created by Marcus Painter on 07/07/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var path = [MeasurementItem]()
    @State private var sortOrder = SortDescriptor(\MeasurementItem.createdDate, order: .reverse)
    @State private var searchText = ""
    
    private var downloadManager = DownloadManager()
    private var bubbleAPI = BubbleAPI()
    
    init() {

    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                MeasurementListView(sort: sortOrder, searchText: searchText)
            }
            .navigationTitle("TracebookDB")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: MeasurementItem.self, destination: MeasurementDetailView.init)
            .searchable(text: $searchText)
        }
    }
}

#Preview {
    ContentView()
}
