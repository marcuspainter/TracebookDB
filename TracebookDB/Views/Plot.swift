//
//  Plot.swift
//  TracebookDB
//
//  Created by Marcus Painter on 06/08/2025.
//


import SwiftUI

struct Plot: View {
    var points: [CGPoint]
    
    @State private var panOffset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @GestureState private var gesturePan: CGSize = .zero
    @GestureState private var gestureScale: CGFloat = 1.0

    private let pointSize: CGFloat = 6
    private let axisColor: Color = .gray
    private let axisLineWidth: CGFloat = 1
    private let gridColor: Color = .gray.opacity(0.3)
    private let gridLineWidth: CGFloat = 1
    private let zeroAxisColor: Color = .black
    private let zeroAxisLineWidth: CGFloat = 2
    private let tickLength: CGFloat = 8
    private let labelFont: Font = .caption

    var body: some View {
        GeometryReader { geo in
            let bounds = dataBounds
            let transform = computeTransform(size: geo.size, bounds: bounds)
            let xTicks = niceTicks(min: bounds.minX, max: bounds.maxX, maxTicks: 8)
            let yTicks = niceTicks(min: bounds.minY, max: bounds.maxY, maxTicks: 6)
            
            ZStack {
                // Gridlines
                ForEach(xTicks, id: \.self) { tick in
                    let pt = CGPoint(x: tick, y: bounds.minY).applying(transform)
                    Path { path in
                        path.move(to: CGPoint(x: pt.x, y: 0))
                        path.addLine(to: CGPoint(x: pt.x, y: geo.size.height))
                    }
                    .stroke(gridColor, lineWidth: gridLineWidth)
                }
                ForEach(yTicks, id: \.self) { tick in
                    let pt = CGPoint(x: bounds.minX, y: tick).applying(transform)
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: pt.y))
                        path.addLine(to: CGPoint(x: geo.size.width, y: pt.y))
                    }
                    .stroke(gridColor, lineWidth: gridLineWidth)
                }

                // Zero axes (if in bounds)
                if bounds.minY <= 0 && bounds.maxY >= 0 {
                    let zeroY = CGPoint(x: bounds.minX, y: 0).applying(transform).y
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: zeroY))
                        path.addLine(to: CGPoint(x: geo.size.width, y: zeroY))
                    }
                    .stroke(zeroAxisColor, lineWidth: zeroAxisLineWidth)
                }
                if bounds.minX <= 0 && bounds.maxX >= 0 {
                    let zeroX = CGPoint(x: 0, y: bounds.minY).applying(transform).x
                    Path { path in
                        path.move(to: CGPoint(x: zeroX, y: 0))
                        path.addLine(to: CGPoint(x: zeroX, y: geo.size.height))
                    }
                    .stroke(zeroAxisColor, lineWidth: zeroAxisLineWidth)
                }

                // Axes at minX, minY
                Path { path in
                    // X axis
                    let y0 = CGPoint(x: bounds.minX, y: bounds.minY).applying(transform).y
                    path.move(to: CGPoint(x: 0, y: y0))
                    path.addLine(to: CGPoint(x: geo.size.width, y: y0))
                    // Y axis
                    let x0 = CGPoint(x: bounds.minX, y: bounds.minY).applying(transform).x
                    path.move(to: CGPoint(x: x0, y: 0))
                    path.addLine(to: CGPoint(x: x0, y: geo.size.height))
                }
                .stroke(axisColor, lineWidth: axisLineWidth)
                
                // X ticks and labels
                ForEach(xTicks, id: \.self) { tick in
                    let pt = CGPoint(x: tick, y: bounds.minY).applying(transform)
                    Path { path in
                        path.move(to: CGPoint(x: pt.x, y: pt.y))
                        path.addLine(to: CGPoint(x: pt.x, y: pt.y + tickLength))
                    }
                    .stroke(axisColor, lineWidth: axisLineWidth)
                    Text(formatTick(tick))
                        .font(labelFont)
                        .position(x: pt.x, y: pt.y + tickLength + 12)
                }
                
                // Y ticks and labels
                ForEach(yTicks, id: \.self) { tick in
                    let pt = CGPoint(x: bounds.minX, y: tick).applying(transform)
                    Path { path in
                        path.move(to: CGPoint(x: pt.x, y: pt.y))
                        path.addLine(to: CGPoint(x: pt.x - tickLength, y: pt.y))
                    }
                    .stroke(axisColor, lineWidth: axisLineWidth)
                    Text(formatTick(tick))
                        .font(labelFont)
                        .position(x: pt.x - tickLength - 20, y: pt.y)
                }
                
                // Graph line
                Path { path in
                    guard let first = points.first else { return }
                    path.move(to: first.applying(transform))
                    for p in points.dropFirst() {
                        path.addLine(to: p.applying(transform))
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
                
                // Points
                ForEach(points.indices, id: \.self) { i in
                    let pt = points[i].applying(transform)
                    Circle()
                        .fill(Color.red)
                        .frame(width: pointSize, height: pointSize)
                        .position(pt)
                }
            }
            .gesture(
                DragGesture()
                    .updating($gesturePan) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        panOffset.width += value.translation.width
                        panOffset.height += value.translation.height
                    }
            )
            .gesture(
                MagnificationGesture()
                    .updating($gestureScale) { value, state, _ in
                        state = value
                    }
                    .onEnded { value in
                        scale *= value
                    }
            )
        }
    }
    
    // Data bounds for axis scaling
    private var dataBounds: CGRect {
        guard !points.isEmpty else { return CGRect(x: 0, y: 0, width: 1, height: 1) }
        let minX = points.map { $0.x }.min() ?? 0
        let maxX = points.map { $0.x }.max() ?? 1
        let minY = points.map { $0.y }.min() ?? 0
        let maxY = points.map { $0.y }.max() ?? 1
        return CGRect(x: minX, y: minY, width: maxX-minX, height: maxY-minY)
    }
    
    // CGAffineTransform for pan, zoom, fit
    private func computeTransform(size: CGSize, bounds: CGRect) -> CGAffineTransform {
        let sx = size.width / max(bounds.width, 1e-6) * scale * gestureScale
        let sy = size.height / max(bounds.height, 1e-6) * scale * gestureScale
        let t = CGAffineTransform(translationX: -bounds.minX, y: -bounds.minY)
            .scaledBy(x: sx, y: -sy)
            .translatedBy(x: panOffset.width + gesturePan.width,
                          y: size.height + panOffset.height + gesturePan.height)
        return t
    }
    
    // "Nice" tick values for axis
    private func niceTicks(min: CGFloat, max: CGFloat, maxTicks: Int) -> [CGFloat] {
        let range = max - min
        guard range > 0 else { return [min] }
        let roughStep = range / CGFloat(maxTicks)
        let mag = pow(10, floor(log10(Double(roughStep))))
        let candidates: [CGFloat] = [1, 2, 5, 10]
        let niceStep = CGFloat(mag) * candidates.min(by: {
            abs($0 - roughStep/CGFloat(mag)) < abs($1 - roughStep/CGFloat(mag))
        })!
        let start = ceil(min/niceStep)*niceStep
        var ticks: [CGFloat] = []
        var v = start
        while v <= max {
            ticks.append(v)
            v += niceStep
        }
        // Ensure zero is included if in range
        if min < 0 && max > 0 && !ticks.contains(0) {
            ticks.append(0)
        }
        return ticks.sorted()
    }
    
    private func formatTick(_ value: CGFloat) -> String {
        if abs(value) < 1e-3 || abs(value) > 1e4 {
            return String(format: "%.2e", Double(value))
        }
        return String(format: "%.2f", Double(value))
    }
}

// Example usage:
struct ContentView2: View {
    let samplePoints = [
        CGPoint(x: -2, y: -1),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 1, y: 2),
        CGPoint(x: 2, y: 1),
        CGPoint(x: 3, y: 3)
    ]
    var body: some View {
        Plot(points: samplePoints)
            .frame(width: 400, height: 300)
            .border(Color.gray)
    }
}

#Preview {
    ContentView2()
}
