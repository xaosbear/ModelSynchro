//
//  GeneratorDataSource.swift
//  ModelSynchro
//
//  Created by Jonathan Samudio on 11/28/17.
//  Copyright © 2017 Jonathan Samudio. All rights reserved.
//

import Foundation

final class GeneratorDataSource: GeneratorDataSourceProtocol {
    
    var contents: [LineContent]
    var currentIteration: Int = 1
    
    private var languageFormatter: LanguageFormatter
    
    init(languageFormatter: LanguageFormatter) {
        self.languageFormatter = languageFormatter
        contents = [LineContent(iteration: currentIteration, languageFormatter: languageFormatter)]
    }
    
    func fileText(name: String, config: ConfigurationFile) -> String {
        return fileString(name: name, config: config, languageFormatter: languageFormatter, lines: allLines)
    }

    func headerFileText(name: String, config: ConfigurationFile) -> String {
        guard let languageFormatter = languageFormatter.headerLanguageFormatter else {
            return ""
        }
        return fileString(name: name, config: config, languageFormatter: languageFormatter, lines: allHeaderLines)
    }
    
    func incrementModelIteration() {
        updateModelOptionals()
        currentIteration += 1
        contents.append(LineContent(iteration: currentIteration, languageFormatter: languageFormatter))
    }
    
    func appendContent(line: Line) {
        currentLineContent.fileLines.append(line)
    }

    func appendProperty(line: Line) {
        currentLineContent.propertyLines.append(line)
    }
}

private extension GeneratorDataSource {
    
    func updateModelOptionals() {
        guard contents.count > 1 else {
            return
        }
        
        for index in 0..<contents.count {
            let content = contents[index]
            if content.iteration != contents.last?.iteration {
                content.checkOptional(otherLineContent: contents[index+1])
            }
        }
    }

    func fileString(name: String, config: ConfigurationFile, languageFormatter: LanguageFormatter, lines: [String]) -> String {
        var fileLines = [String]()
        fileLines.append(languageFormatter.fileHeader(name: name,
                                                      config: config,
                                                      propertyLines: contents.map { $0.fileLines }.flatMap { $0 }))
        
        fileLines.append(languageFormatter.modelClassDeclaration(name: name))
        fileLines += lines.sorted { $0 < $1 }
        fileLines.append(languageFormatter.keyMapping(lines: contents.map { $0.fileLines }.flatMap { $0 }))
        fileLines.append(languageFormatter.modelClassEndLine)

        return fileLines.joined(separator: "\n")
    }
}
