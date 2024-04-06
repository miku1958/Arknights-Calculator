//
//  String+Extension.swift.swift
//  
//
//  Created by mi on 2024/2/16.
//

import Foundation

func ~= <T>(a: Regex<T>, b: String) -> Bool {
    (try? a.wholeMatch(in: b)) != nil
}

func ~= <T>(a: String, b: Regex<T>) -> Bool {
    (try? b.wholeMatch(in: a)) != nil
}
