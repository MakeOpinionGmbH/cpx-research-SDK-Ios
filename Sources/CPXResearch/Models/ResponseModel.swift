//
//  ResponseModel.swift
//  
//
//  Created by Daniel Fredrich on 15.02.21.
//

import Foundation

struct ResponseModel: Codable {
    enum MimeType: String {
        case unknown
        case png = "image/png"
        case gif = "image/gif"
    }

    let data: Data
    let mime: String

    var mimeType: MimeType {
        MimeType(rawValue: mime) ?? .unknown
    }
}
