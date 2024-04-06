//
//  BuffParser.swift
//
//
//  Created by mi on 2023/12/31.
//

import Foundation

protocol SkillMorphemeMethod {

}

enum BuffMorphemeSubClassDefaultName: String {
    case _0 = "$0"
}

enum MorphemeValue: CustomStringConvertible {
    var description: String {
        switch self {
        case .bool(let bool):
            return "\(bool)"
        case .int(let int64):
            return "\(int64)"
        case .double(let double):
            return "\(double)"
        case .string(let string):
            return "\(string)"
        }
    }

    case bool(Bool)
    case int(Int64)
    case double(Double)
    case string(String)

    init(value: Any) {
        if let value = value as? String {
            self = .string(value)
        } else if let value = value as? Substring {
            self = .string(String(value))
        } else if let value = value as? Double {
            self = .double(value)
        } else if let value = value as? Int64 {
            self = .int(value)
        } else {
            fatalError("\(type(of: value))")
        }
    }
}

typealias BuffMorphemeValue = (name: String, value: MorphemeValue)

protocol BuffMorphemeSubClass: AnyObject, SkillMorphemeMethod {
    associatedtype Name: RawRepresentable<String> = BuffMorphemeSubClassDefaultName

    var rawString: Substring { get set }

    func rex() -> String

    func postBuild(name: Name, value: String)
    func postBuild(name: String, value: String)
    var _values: [BuffMorphemeValue] { get set }
    var _rexOption: (index: Int, capture: Bool) { get set }

    init()
}

class BuffMorpheme: CustomStringConvertible {
    var rawString: Substring = ""
    var _values: [BuffMorphemeValue] = []
    var _notes: [BuffMorpheme] = []

    var _rexOption: (index: Int, capture: Bool) = (0, false)

    var description: String {
"""
\(Self.self):
\(rawString)
"""
    }

    required init() { }
}

let morphemeAlias: [String: [any BuffMorphemeSubClass.Type]] = {
    func makeKey(_ string: String) -> String {
        "[[:\(string):]]"
    }
    let basicAlias: KeyValuePairs<String, any BuffMorphemeSubClass.Type> = [
        "TagName": TagMorpheme.self,
        "Room.1": Room1Morpheme.self,
        "Room.2": Room2Morpheme.self,
        "Room.3": Room3Morpheme.self,
        "Production": ProductionMorpheme.self,
        "Item": ItemMorpheme.self,
        "Unit.1": Unit1Morpheme.self,
        "Unit.2": Unit2Morpheme.self,
        "Range": RangeMorpheme.self,
        "Value.1": Value1Morpheme.self,
        "Value.2": Value2Morpheme.self,
        "Value.3": Value3Morpheme.self,
        "Value.4": Value4Morpheme.self,
        "Defer.If": DeferIFMorpheme.self,
        "Defer.Reverse": DeferReverseMorpheme.self,
        "Defer.Make": DeferMakeMorpheme.self,
        "Defer.And": DeferAndMorpheme.self,
        "Defer.For": DeferForMorpheme.self,
    ]
    var combineAlias: [String: [any BuffMorphemeSubClass.Type]] = [:]

    for (alias, morpheme) in basicAlias {
        combineAlias[makeKey(alias)] = [morpheme]
        var sections = alias.split(separator: ".")
        sections.removeLast()
        if sections.count > 0 {
            var allAlias = ""
            for section in sections {
                allAlias += allAlias.isEmpty ? "" : "."
                allAlias += section

                combineAlias[makeKey("\(allAlias).all"), default: []].append(morpheme)
            }
        }
    }

    return combineAlias
}()

private var fullRexCache: [String: [Bool: String]] = [:]
private var fullRexCache2: [String: Regex<AnyRegexOutput>] = [:]

extension BuffMorphemeSubClass {
    func fullRex(capture: Bool = false) -> String {
        self._rexOption.capture = capture
        let rawRex = self.rex()
        if let rex = fullRexCache[rawRex]?[capture] {
            return rex
        }
        var rex = rawRex
        defer {
            fullRexCache[rawRex, default: [:]][capture] = rex
        }
        if rex.contains("[[:") {
            for (alias, morpheme) in morphemeAlias {
                while rex.contains(alias) {
                    let replacedRexes = morpheme.map {
                        ($0.init() as any BuffMorphemeSubClass).fullRex(capture: false)
                    }
                    if replacedRexes.count == 1 {
                        rex.replace(alias, with: replacedRexes[0], maxReplacements: 1)
                    } else {
                        rex.replace(alias, with: "(?:\(replacedRexes.map({ "(?:\($0))" }).joined(separator: "|")))", maxReplacements: 1)
                    }
                }
            }
        }
        return rex
    }

    func build(in rawString: Substring) throws -> Range<String.Index>? {
        let fullRex = self.fullRex(capture: true)
        var targetRange = (rawString.endIndex, rawString.startIndex)
        do {
            let rex: Regex<AnyRegexOutput> = try {
                if let cache = fullRexCache2[fullRex] {
                    return cache
                } else {
                    let cache = try Regex<AnyRegexOutput>(fullRex)
                    fullRexCache2[fullRex] = cache
                    return cache
                }
            }()

            guard let matches = rawString.prefixMatch(of: rex) else {
                return nil
            }
            self._values = []
            for index in 0..<matches.count {
                let match = matches[index]
                guard let value = match.value, let range = match.range else {
                    continue
                }
                targetRange.0 = min(targetRange.0, range.lowerBound)
                targetRange.1 = max(targetRange.1, range.upperBound)

                if let value = value as? Optional<Substring>, value == nil {
                    continue
                }
                self._values.append((match.name ?? "$\(index)", MorphemeValue(value: value)))
            }

            for (name, value) in self._values {
                guard case let .string(value) = value else {
                    continue
                }
                if let name = valueNameRemoveIndex(name) {
                    self.postBuild(name: name, value: value)
                } else {
                    self.postBuild(name: name, value: value)
                }
            }
            let targetRange = targetRange.0..<targetRange.1
            self.rawString = rawString[targetRange]
            return targetRange
        } catch {
            let location = Mirror(reflecting: error).children.first { (label, value) in label == "location" }!.value
            let range = Mirror(reflecting: location).children.first { (label, value) in label == "range" }!.value as! Range<String.Index>
            print(fullRex[range.lowerBound...])
            fatalError("\(error)")
        }
    }
    func postBuild(name: Name, value: String) {

    }

    func postBuild(name: String, value: String) {

    }

    func valueNameRemoveIndex(_ value: String) -> Name? {
        let rawValue = String(value.split(separator: "____parameterIndex____")[0])
        return Name(rawValue: rawValue)
    }

    func valueName(_ value: Name) -> String {
        _rexOption.index += 1
        if _rexOption.capture {
            return "'\(value.rawValue)____parameterIndex____\(_rexOption.index)'"
        } else {
            return ":"
        }
    }
}

class TagMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        "[a-zA-Z1-9_]+"
    }
}


class Room1Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        "(?:人力办公室|会客室|制造站|发电站|宿舍|控制中枢|贸易站)"
    }
}

class Room2Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case name
    }
    func rex() -> String {
        #"<@cc\.kw>(?"# + valueName(.name) + #"[[:Room.1:]])(?:</>)+"#
    }
}

class Room3Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case id, name
    }

    func rex() -> String {
        #"<\$(?"# + valueName(.id) + #"cc\.c\.[[:TagName:]])><@cc\.kw>(?"# + valueName(.name) + #".*?)(?:</>)+"#
    }
}

class ProductionMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        "(?:作战记录|贵金属|源石)"
    }
}

class ItemMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        let items = [
            "发电站", "干员", "无人机", "联络次数", "订单", "仓库容量", "配方", "赤金生产线",
            "人间烟火", "感知信息", "木天蓼", "情报储备", "乌萨斯特饮", "巫术结晶", "心情落差", "思维链环", "工程机器人", "无声共鸣", "小节", "梦境", "记忆碎片",
        ]

        return "(?:\(items.joined(separator: "|")))(?:上限)?"
    }
}

class Unit1Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"(?:名|个|点|架|格|层|条|次|瓶|笔|间|台)"#
    }
}

class Unit2Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"(?:<@cc\.kw>[[:Unit.1:]]</>)"#
    }
}

class RangeMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        "(?:当前|所有|每[[:Unit.all:]]|该)"
    }
}


enum ValueMorpheme {
    enum Name: String {
        case direction, value
    }
}

class Value1Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"\d+%"#
    }
}

class Value2Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"\d+(?:\.\d+)?"#
    }
}

class Value3Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    typealias Name = ValueMorpheme.Name
    func rex() -> String {
        #"(?"# + valueName(.direction) + #"\+|\-)?(?"# + valueName(.value) + #"[[:Value.1:]]|[[:Value.2:]])"#
    }
}

class Value4Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    typealias Name = ValueMorpheme.Name
    func rex() -> String {
        #"(?:<@cc\.v(?"# + valueName(.direction) + #"up|down)>|<@cc\.kw>)(?"# + valueName(.value) + #"[[:Value.3:]])(?:</>)"#
    }
}

class DeferIFMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"(?:如果|若)"#
    }
}

class DeferReverseMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"(?:反之|但)"#
    }
}

class DeferMakeMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"(?:则|可?使|就|对|时|后)"#
    }
}

class DeferAndMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"(?:同时|且|；|;)"#
    }
}

class DeferForMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"(?:(?:可以)?为)"#
    }
}
