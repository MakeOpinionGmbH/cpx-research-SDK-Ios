//
//  File.swift
//  
//
//  Created by Daniel Fredrich on 08.02.21.
//

import Foundation

extension String {
    var replacedHtmlTags: String {
        self.replacingOccurrences(of: "<br>", with: "\n")
    }

    var withoutLeadingHashTag: String {
        if hasPrefix("#") {
            return String(dropFirst())
        }

        return self
    }

    var withLeadingDot: String {
        if hasPrefix("#") {
            return replacingCharacters(in: ...startIndex, with: ".")
        }

        return ".\(self)"
    }
}
