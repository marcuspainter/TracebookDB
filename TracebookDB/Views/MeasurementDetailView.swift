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
    
    let frequency: [Double]
    let magnitude: [Double]
    let phase: [Double]
    let coherence: [Double]
    
    @State var isPolarityInverted: Bool = false
    @State var delay: Double = 0.0
    @State var threshold: Double = 0.0
    
    init(measurement: MeasurementItem) {
        self.frequency = measurement.content?.tfFrequency ?? []
        self.magnitude = measurement.content?.tfMagnitude ?? []
        self.phase = measurement.content?.tfPhase ?? []
        self.coherence = measurement.content?.tfCoherence ?? []
        
        self.measurement = measurement
    }
    
    var body: some View {
        VStack {
            

            
            MagnitudeChart(frequency: frequency, magnitude: magnitude, coherence: coherence)
            
            PhaseChart(frequency: frequency, phase: phase, originalPhase: phase)
            
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
                print(">>> Invert polarity\n")
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
                // Process phase
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
    
    func resetChart() {
        delay = 0.0
        threshold = 0.0
        isPolarityInverted = false
    }
}

