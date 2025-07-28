//
//  MeasurementMapper.swift
//  TracebookDB
//
//  Created by Marcus Painter on 13/07/2025.
//

import Foundation
import SwiftData

class DataMapper {
    
    static func mapMeasurementItem(body: MeasurementBody) -> MeasurementItem {
        let item = MeasurementItem(
            id: body.id,
            additionalContent: body.additionalContent ?? "",
            approved: body.approved == "Approved",
            commentCreator: body.commentCreator ?? "",
            productLaunchDateText: body.productLaunchDateText ?? "",
            thumbnailImage: body.thumbnailImage ?? "",
            upvotes: body.upvotes?.joined(separator: ",") ?? "",
            createdDate: parseISODate(body.createdDate),
            createdBy: body.createdBy ?? "",
            modifiedDate: parseISODate(body.modifiedDate),
            slug: body.slug ?? "",
            moderator1: body.moderator1 ?? "",
            isPublic: body.isPublic ?? false,
            title: body.title ?? "",
            publishDate: parseISODate(body.publishDate),
            admin1Approved: body.admin1Approved == "Approved",
            moderator2: body.moderator2 ?? "",
            admin2Approved: body.admin2Approved == "Approved",
            loudspeakerTags: body.loudspeakerTags?.joined(separator: ",") ?? "",
            emailSent: body.emailSent ?? false,
                 
            content: nil
        )

        return item
    }

    static func mapMeasurementContent(body: MeasurementContentBody) -> MeasurementContent? {
        
        let f = parseDoublesWithZeros(body.tfJSONFrequency ?? "")
        
        let content = MeasurementContent(
            id: body.id,
            firmwareVersion: body.firmwareVersion ?? "",
            loudspeakerBrand: body.loudspeakerBrand ?? "",
            category: body.category ?? "",
            delayLocator: body.delayLocator,
            distance: body.distance,
            dspPreset: body.dspPreset ?? "",
            photoSetup: body.photoSetup ?? "",
            fileAdditional: body.fileAdditional ?? [],
            fileTFCSV: body.fileTFCSV ?? "",
            notes: body.notes ?? "",
            createdDate: parseISODate(body.createdDate),
            createdBy: body.createdBy ?? "",
            modifiedDate: parseISODate(body.modifiedDate),
            distanceUnits: body.distanceUnits ?? "",
            crestFactorM: body.crestFactorM,
            crestFactorPink: body.crestFactorPink,
            loudspeakerModel: body.loudspeakerModel ?? "",
            calibrator: body.calibrator ?? "",
            measurementType: body.measurementType ?? "",
            presetVersion: body.presetVersion ?? "",
            temperature: body.temperature,
            tempUnits: body.tempUnits ?? "",
            responseLoudspeakerBrand: body.responseLoudspeakerBrand ?? "",
            coherenceScale: body.coherenceScale ?? "",
            analyzer: body.analyzer ?? "",
            fileTFNative: body.fileTFNative ?? "",
            splGroundPlane: body.splGroundPlane ?? false,
            responseLoudspeakerModel: body.responseLoudspeakerModel ?? "",
            systemLatency: body.systemLatency,
            microphone: body.microphone ?? "",
            measurement: body.measurement ?? "",
            interface: body.interface ?? "",
            interfaceBrandModel: body.interfaceBrandModel ?? "",
            micCorrectionCurve: body.micCorrectionCurve ?? "",
            
            tfFrequency: parseDoublesWithZeros(body.tfJSONFrequency ?? ""),
            tfMagnitude: parseDoublesWithZeros(body.tfJSONMagnitude ?? ""),
            tfPhase: parseDoublesWithZeros(body.tfJSONPhase ?? ""),
            tfCoherence: parseDoublesWithZeros(body.tfJSONCoherence ?? ""),
            
            medal: body.medal ?? "",
            fileIRWAV: body.fileIRWAV ?? "",
            windscreen: body.windscreen ?? "",
            presetNA: body.presetNA ?? false,
            presetVersionNA: body.presetVersionNA ?? false,
            firmwareVersionNA: body.firmwareVersionNA ?? false,
            inputMeter: body.inputMeter,
            
            item: nil
        )
        return content
    }

    static func parseISODate(_ dateString: String?) -> Date {
        let isoString = dateString ?? ""
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = formatter.date(from: isoString) ?? Date()
        return date
    }
    
    static func parseDoublesWithZeros(_ string: String) -> [Double] {
        
        if string.isEmpty {
           return []
        }
        
        return string
            .split(separator: ",")
            .map { substring in
                let trimmed = substring.trimmingCharacters(in: .whitespaces)
                return Double(trimmed) ?? 0.0
            }
    }
}
