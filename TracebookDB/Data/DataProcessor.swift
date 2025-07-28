//
//  DataProcessor.swift
//  TracebookDB
//
//  Created by Marcus Painter on 23/07/2025.
//

class DataProcessor {
    
    /*
    func processAll(delay: Double, threshold: Double, isPolarityInverted: Bool) -> (magnitude: [Double], phase: [Double], coherence: [Double], originalPhase: [Double]) {

        var newCoherence = [Double](repeating: 0, count: tfFrequency.count)
        var newMagnitude = [Double](repeating: 0, count: tfFrequency.count)
        var newPhase = [Double](repeating: 0, count: tfFrequency.count)
        var newOriginalPhase = [Double](repeating: 0, count: tfFrequency.count)

        for index in 0..<tfFrequency.count {
            newCoherence[index] = index < self.tfCoherence.count ? self.tfCoherence[index]  / 3.333 : Double.nan// Scaling for chart
            newMagnitude[index] = index < self.tfMagnitude.count ? self.tfMagnitude[index] : Double.nan
            newPhase[index] =  index < self.tfPhase.count ? self.tfPhase[index] : Double.nan
            newOriginalPhase[index] = index < self.tfPhase.count ? self.tfPhase[index] : Double.nan

            if index < self.tfCoherence.count {
                let coherence = self.tfCoherence[index]
                
                if coherence < threshold {
                    newCoherence[index] = Double.nan
                    newMagnitude[index] =  Double.nan
                    newPhase[index] = Double.nan
                    newOriginalPhase[index] = Double.nan
                } else {
                    let frequency = index < self.tfFrequency.count ? self.tfFrequency[index] : Double.nan
                    var phase = index < self.tfPhase.count ? self.tfPhase[index] : Double.nan
                    phase += (frequency * 360.0 * (delay * -1.0 / 1000.0))
                    if isPolarityInverted {
                        phase += 180.0
                    }
                    newPhase[index] = wrapTo180(phase)
                }
           }
        }
        return (newMagnitude, newPhase, newCoherence, newOriginalPhase)
    }
    */
    
    private func wrapTo180(_ phase: Double) -> Double {
        var newPhase = (phase + 180.0).truncatingRemainder(dividingBy: 360.0)
        if newPhase < 0.0 {
            newPhase += 360.0
        }
        return newPhase - 180.0
    }
}
