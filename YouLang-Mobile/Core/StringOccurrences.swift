//
//  StringOccurrences.swift
//  YouLang-Mobile
//
//  Created by Artem Kufaev on 14.01.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

extension String {
    func indicesOf(string: String) -> [Int] {
       //Converting to an array of utf8 characters makes indicing and comparing a lot easier
        let search = self.utf8.map { $0 }
        let word = string.utf8.map { $0 }

        var indices = [Int]()

       //m - the beginning of the current match in the search string
       //i - the position of the current character in the string we're trying to match
        var m = 0, i = 0
        while m + i < search.count {
            if word[i] == search[m+i] {
                if i == word.count - 1 {
                    indices.append(m)
                    m += i + 1
                    i = 0
                } else {
                    i += 1
                }
            } else {
                m += 1
                i = 0
            }
        }

        return indices
    }
    
}

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        var indices: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                indices.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return indices
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
