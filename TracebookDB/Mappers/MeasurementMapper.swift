//
//  MeasurementMapper.swift
//  TracebookDB
//
//  Created by Marcus Painter on 30/07/2025.
//

class MeasurementMapper {
    
    static func toModel(body: MeasurementBody) -> MeasurementItem {
        
        let model = MeasurementItem(
            id: body.id,
            additionalContent: body.additionalContent ?? "",
            approved: body.approved == "Approved",
            commentCreator: body.commentCreator ?? "",
            productLaunchDateText: body.productLaunchDateText ?? "",
            thumbnailImage: body.thumbnailImage ?? "",
            upvotes: body.upvotes?.joined(separator: ",") ?? "",
            createdDate: DataMapper.parseISODate(body.createdDate),
            createdBy: body.createdBy ?? "",
            modifiedDate: DataMapper.parseISODate(body.modifiedDate),
            slug: body.slug ?? "",
            moderator1: body.moderator1 ?? "",
            isPublic: body.isPublic ?? false,
            title: body.title ?? "",
            publishDate: DataMapper.parseISODate(body.publishDate),
            admin1Approved: body.admin1Approved == "Approved",
            moderator2: body.moderator2 ?? "",
            admin2Approved: body.admin2Approved == "Approved",
            loudspeakerTags: body.loudspeakerTags?.joined(separator: ",") ?? "",
            emailSent: body.emailSent ?? false,
                 
            content: nil
        )

        return model
    }
}
