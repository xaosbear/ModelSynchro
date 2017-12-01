//
//  Line.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 11/28/17.
//  Copyright © 2017 Jonathan Samudio. All rights reserved.
//

import Foundation

struct Line {
    let property: String
    var type: String
    var isOptional: Bool
    var customProperty: CustomProperty?
}

extension Line {
    
    func toString(languageFormatter: LanguageFormatter) -> String {
        return languageFormatter.variableString(line: self)
    }
}

extension Line: Equatable {
    
    /// Compares two variable lines. Ignores if the variable is optional.
    ///
    /// - Parameters:
    ///   - lhs: Left Line.
    ///   - rhs: Right Line.
    /// - Returns: Flag if they are equal.
    static func ==(lhs: Line, rhs: Line) -> Bool {
        return lhs.property == rhs.property && lhs.type == rhs.type
    }
}

struct CustomProperty {
    let customLine: String
    let property: String
}
