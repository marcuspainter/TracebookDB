//
//  MeasurementView.swift
//  TracebookDB
//
//  Created by Marcus Painter on 07/07/2025.
//

import SwiftUI
import SwiftData
import Charts

struct MeasurementDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var measurement: MeasurementItem
    
    @State var isPolarityInverted: Bool = false
    @State var delay: Double = 0.0
    @State var threshold: Double = 0.0
    
    var dataProcessor: DataProcessor!
    
    init(measurement: MeasurementItem) {
        let frequency = measurement.content?.tfFrequency ?? []
        let magnitude = measurement.content?.tfMagnitude ?? []
        let phase = measurement.content?.tfPhase ?? []
        let coherence = measurement.content?.tfCoherence ?? []
        let originalPhase = measurement.content?.tfPhase ?? []
        
        self.measurement = measurement
        
        self.dataProcessor = DataProcessor(frequency: frequency, magnitude: magnitude, phase: phase, coherence: coherence)
    }
    
    var body: some View {
        VStack {
            
            MagnitudeChart(frequency: dataProcessor.frequency, magnitude: dataProcessor.magnitude, coherence: dataProcessor.coherence)
            
            PhaseChart(frequency: dataProcessor.frequency, phase: dataProcessor.phase, originalPhase: dataProcessor.originalPhase)
            
            HStack {
                Toggle("Invert", isOn: $isPolarityInverted)

                    .frame(width: 130, alignment: .leading)
                Button("Reset") {
                    resetChart()
                }
                .padding(5)
                .overlay( // Apply a rounded border
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.tint, lineWidth: 1))
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .onChange(of: isPolarityInverted) { _, _ in
                // Process phase
                updateChart()
            }
            
            HStack {
                Text("Delay").frame(maxWidth: .infinity, alignment: .leading)
                Text("\(delay, specifier: "%.1f") ms")
                    .monospacedDigit()
                    .frame(maxWidth: .infinity, alignment: .center)
                Color.clear.frame(maxWidth: .infinity)
            }
            Slider(
                value: $delay,
                in: -20 ... 20,
                step: 0.1
            ) {
                // Text("Delay")
            } minimumValueLabel: {
                Text("-20").font(.footnote)
            } maximumValueLabel: {
                Text("20").font(.footnote)
            }
            .onChange(of: delay) { _, _ in
                updateChart()
            }
            
            HStack {
                Text("Coherence").frame(maxWidth: .infinity, alignment: .leading)
                Text("\(threshold, specifier: "%.0f")%")
                    .monospacedDigit()
                    .frame(maxWidth: .infinity, alignment: .center)
                Color.clear.frame(maxWidth: .infinity)
            }

            Slider(
                value: $threshold,
                in: 0 ... 100,
                step: 1
            ) {
            } minimumValueLabel: {
                Text("0").font(.footnote)
            } maximumValueLabel: {
                Text("100").font(.footnote)
            }
            .onChange(of: threshold) { _, _ in
                // Update all
                updateChart()
            }
            
            Text(measurement.title)
            Text(measurement.content?.medal ?? "")
            Text(measurement.content?.loudspeakerBrand ?? "")
            Text(measurement.content?.microphone ?? "")
            Text(measurement.content?.interfaceBrandModel ?? "")
    
        }
        .padding()
        .navigationTitle("Measurement")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func updateChart() {
        dataProcessor.processAll(delay: delay, threshold: threshold / 100.0, isPolarityInverted: isPolarityInverted)
    }
    
    func resetChart() {
        delay = 0.0
        threshold = 0.0
        isPolarityInverted = false
        dataProcessor.reset()
    }
}

