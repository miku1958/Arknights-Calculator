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
        "ChangesElement": ChangesElementMorpheme.self,
        "Increase.1": Increase1Morpheme.self,
        "Increase.2": Increase2Morpheme.self,
        "Condition.EachValue.1": ConditionEachValue1Morpheme.self,
        "Condition.EachValue.2": ConditionEachValue2Morpheme.self,
        "Condition.EachValue.3": ConditionEachValue3Morpheme.self,
        "Condition.EachValue.4": ConditionEachValue4Morpheme.self,
        "Condition.EachValue.5": ConditionEachValue5Morpheme.self,
        "Condition.EachValue.7": ConditionEachValue7Morpheme.self,
        "Condition.EachValue.10": ConditionEachValue10Morpheme.self,
        "Condition.EachValue.13": ConditionEachValue13Morpheme.self,
        "Condition.EachValue.15": ConditionEachValue15Morpheme.self,
        "Condition.EachValue.17": ConditionEachValue17Morpheme.self,
        "Condition.Efficient.3": ConditionEfficient3Morpheme.self,
        "Condition.Formula": ConditionFormulaMorpheme.self,
        "Condition.Gang.1": ConditionGang1Morpheme.self,
        "Condition.Gang.2": ConditionGang2Morpheme.self,
        "Condition.Gang.4": ConditionGang4Morpheme.self,
        "Condition.Gang.5": ConditionGang5Morpheme.self,
        "Condition.GreaterThanValue": GreaterThanValueMorpheme.self,
        "Condition.Item": ConditionItemMorpheme.self,
        "Condition.LessThanValue": LessThanValueMorpheme.self,
        "Condition.MaximumValue.1": ConditionMaximumValue1Morpheme.self,
        "Condition.MaximumValue.2": ConditionMaximumValue2Morpheme.self,
        "Condition.MaximumValue.3": ConditionMaximumValue3Morpheme.self,
        "Condition.Mood.1": ConditionMood1Morpheme.self,
        "Condition.People.3": ConditionPeople3Morpheme.self,
        "Condition.People.4": ConditionPeople4Morpheme.self,
        "Condition.Position": ConditionPositionMorpheme.self,
        "Condition.Room.1": ConditionRoom1Morpheme.self,
        "Condition.Room.2": ConditionRoom2Morpheme.self,
        "Condition.Room.3": ConditionRoom3Morpheme.self,
        "Condition.Room.4": ConditionRoom4Morpheme.self,
        "Condition.Room.5": ConditionRoom5Morpheme.self,
        "Condition.Room.6": ConditionRoom6Morpheme.self,
        "Condition.Room.7": ConditionRoom7Morpheme.self,
        "Condition.Same_position": ConditionSamePositionMorpheme.self,
        "Condition.Trading.1": ConditionTrading1Morpheme.self,
        "EachValue.1": EachValue1Morpheme.self,
        "Event": EventMorpheme.self,
        "Event.ChangesStatement.1": EventChangesStatement1Morpheme.self,
        "Event.ChangesStatement.2": EventChangesStatement2Morpheme.self,
        "Event.Efficient.2": RemoveAllMorpheme.self,
        "Event.Efficient.1": EventEfficient1Morpheme.self,
        "Event.Efficient.4": EventEfficient4Morpheme.self,
        "Event.Efficient.5": EventEfficient5Morpheme.self,
        "Event.Efficient.6": EventEfficient6Morpheme.self,
        "Event.Efficient.7": EventEfficient7Morpheme.self,
        "Event.Efficient.8": EventEfficient8Morpheme.self,
        "Event.Efficient.MaximumValue": EventEfficientMaximumValueMorpheme.self,
        "Event.Efficient.Stepper": EventEfficientStepperMorpheme.self,
        "Event.Gang.1": EventGang1Morpheme.self,
        "Event.Gang.2": EventGang2Morpheme.self,
        "Event.Meeting.1": EventMeeting1Morpheme.self,
        "Operator.1": Operator1Morpheme.self,
        "Operator.2": Operator2Morpheme.self,
        "Operator.3": Operator3Morpheme.self,
        "Operator.4": Operator4Morpheme.self,
        "Operator.5": Operator5Morpheme.self,
        "Operator": OperatorMorpheme.self,
        "Event.Mood.1": EventMood1Morpheme.self,
        "Event.Mood.2": EventMood2Morpheme.self,
        "Event.Mood.3": EventMood3Morpheme.self,
        "Event.Mood.4": EventMood4Morpheme.self,
        "Event.Mood.6": EventMood6Morpheme.self,
        "Event.Mood.8": EventMood8Morpheme.self,
        "Event.Mood.9": EventMood9Morpheme.self,
        "Event.Mood.10": EventMood10Morpheme.self,
        "Event.Efficient": EventEfficientMorpheme.self,
        "Event.Skill": EventSkillMorpheme.self,
        "Event.Trading.1": EventTrading1Morpheme.self,
        "Event.Trading.2": EventTrading2Morpheme.self,
        "Gang.1": Gang1Morpheme.self,
        "Gang.2": Gang2Morpheme.self,
        "Gang.3": Gang3Morpheme.self,
        "IncreaseClue": IncreaseClueMorpheme.self,
        "Item.1": Item1Morpheme.self,
        "Item.2": Item2Morpheme.self,
        "Item.3": Item3Morpheme.self,
        "Item.4": Item4Morpheme.self,
        "Item.5": Item5Morpheme.self,
        "Efficient": EfficientMorpheme.self,
        "EfficientOrItem": EfficientOrItemMorpheme.self,
        "Note.1": Note1Morpheme.self,
        "Note.2": Note2Morpheme.self,
        "Note.3": Note3Morpheme.self,
        "Note.4": Note4Morpheme.self,
        "Note.5": Note5Morpheme.self,
        "Note.6": Note6Morpheme.self,
        "Note.7": Note7Morpheme.self,
        "Note.8": Note8Morpheme.self,
        "Note.9": Note9Morpheme.self,
        "Note.10": Note10Morpheme.self,
        "Note.11": Note11Morpheme.self,
        "Note.12": Note12Morpheme.self,
        "Note.13": Note13Morpheme.self,
        "Note.14": Note14Morpheme.self,
        "Note.15": Note15Morpheme.self,
        "Note.16": Note16Morpheme.self,
        "Production": ProductionMorpheme.self,
        "ProvideAction": ProvideActionMorpheme.self,
        "Range": RangeMorpheme.self,
        "Room": RoomMorpheme.self,
        "Room.1": Room1Morpheme.self,
        "Room.2": Room2Morpheme.self,
        "Room.3": Room3Morpheme.self,
        "SkillPoint": SkillPointMorpheme.self,
        "TagName": TagMorpheme.self,
        "Unit.1": Unit1Morpheme.self,
        "Unit.2": Unit2Morpheme.self,
        "Value.1": Value1Morpheme.self,
        "Value.2": Value2Morpheme.self,
        "Value.3": Value3Morpheme.self,
        "Value.4": Value4Morpheme.self,
        "ValueChanged.1": ValueChanged1Morpheme.self,
        "ValueChanged.2": ValueChanged2Morpheme.self,
        "ValueInRange": ValueInRangeMorpheme.self,
        "Defer.If": DeferIFMorpheme.self,
        "Defer.Reverse": DeferReverseMorpheme.self,
        "Defer.Make": DeferMakeMorpheme.self,
        "Defer.And": DeferAndMorpheme.self,
        "Defer.For": DeferForMorpheme.self,
        "Defer.Each": DeferEachValueMorpheme.self,
        "Defer.Room": RoomMorpheme.self,
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

func morpheme(of rawString: String, alias: String) -> (BuffMorpheme & SkillMorphemeMethod)? {
    morpheme(of: rawString[rawString.startIndex...], alias: alias)?.morpheme
}

func morpheme(of rawString: Substring, alias: String) -> (morpheme: (BuffMorpheme & SkillMorphemeMethod), range: Range<String.Index>)? {
    for Item in morphemeAlias[alias] ?? [] {
        let item = (Item.init() as any BuffMorphemeSubClass)
        do {
            if let range = try item.build(in: rawString), !item._values.isEmpty {
                return (item as! (BuffMorpheme & SkillMorphemeMethod), range)
            }
        } catch {

        }
    }
    return nil
}

class TagMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        "[a-zA-Z1-9_]+"
    }
}

protocol RoomMorphemeMethod {
    var name: String! { get }
    var id: String? { get }
}
extension RoomMorphemeMethod {
    var id: String? { nil }
}

class Room1Morpheme: BuffMorpheme, BuffMorphemeSubClass, RoomMorphemeMethod {
    func rex() -> String {
        "(?:人力办公室|会客室|制造站|发电站|宿舍|控制中枢|贸易站)"
    }

    var name: String! {
        String(rawString)
    }
}

class Room2Morpheme: BuffMorpheme, BuffMorphemeSubClass, RoomMorphemeMethod {
    enum Name: String {
        case name
    }
    func rex() -> String {
        #"<@cc\.kw>(?"# + valueName(.name) + #"[[:Room.1:]])(?:</>)+"#
    }

    var name: String!
    func postBuild(name: Name, value: String) {
        switch name {
        case .name:
            self.name = value
        }
    }
}

class Room3Morpheme: BuffMorpheme, BuffMorphemeSubClass, RoomMorphemeMethod {
    enum Name: String {
        case id, name
    }

    func rex() -> String {
        #"<\$(?"# + valueName(.id) + #"cc\.c\.[[:TagName:]])><@cc\.kw>(?"# + valueName(.name) + #".*?)(?:</>)+"#
    }
    var id: String?
    var name: String!
    func postBuild(name: Name, value: String) {
        switch name {
        case .id:
            self.id = value
        case .name:
            self.name = value
        }
    }
}

class RoomMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case roomRange, roomName
    }
    func rex() -> String {
        #"(?"# + valueName(.roomRange) + #"[[:Range:]])?(?"# + valueName(.roomName) + #"[[:Room.all:]])内?"#
    }
    var range: RangeMorpheme?
    var id: String?
    var name: String!
    func postBuild(name: Name, value: String) {
        switch name {
        case .roomRange:
            if let value = morpheme(of: value, alias: "[[:Range:]]") as? RangeMorpheme {
                self.range = value
            }
        case .roomName:
            if let value = morpheme(of: value, alias: "[[:Room.all:]]") as? RoomMorphemeMethod {
                self.name = value.name
                self.id = value.id
            }
        }
    }
}

class ProductionMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        "(?:作战记录|贵金属|源石)"
    }
}

class ProvideActionMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case extra
    }
    func rex() -> String {
        #"(?"# + valueName(.extra) + #"额外)?(?:[[:Increase.all:]]|提供)?(?:加成)?的?"#
    }

    var extra: Bool = false
    func postBuild(name: Name, value: String) {
        switch name {
        case .extra:
            self.extra = true
        }
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
    enum Range: Equatable, Encodable {
        case current, all, others
    }
    var range: Range = .current

    func postBuild(name: Name, value: String) {
        switch name {
        case ._0:
            switch value {
            case "当前", "该": range = .current
            case "所有": range = .all
            case /每*/: range = .all
            default: break
            }
        }
    }
}

protocol ItemMorpheme: SkillMorphemeMethod {

}

class Item1Morpheme: BuffMorpheme, ItemMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case gang
    }
    func rex() -> String {
        let items = [
            "发电站", "干员", "无人机", "联络次数", "订单", "仓库容量", "配方", "赤金生产线",
            "人间烟火", "感知信息", "木天蓼", "情报储备", "乌萨斯特饮", "巫术结晶", "心情落差", "思维链环", "工程机器人", "无声共鸣", "小节", "梦境", "记忆碎片",
            "除自身以外的(?" + valueName(.gang) + "[[:Gang.all:]])"
        ]

        return "(?:\(items.joined(separator: "|")))(?:上限)?"
    }

    var item: String?
    var gang: GangMorpheme?
    func postBuild(name: String, value: String) {
        if name == "$0" {
            self.item = value
        }
    }
    func postBuild(name: Name, value: String) {
        switch name {
        case .gang:
            if let gang = morpheme(of: value, alias: "[[:Gang.all:]]") as? GangMorpheme {
                self.gang = gang
                self.item = nil
            }
        }
    }
}

class Item2Morpheme: BuffMorpheme, ItemMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case itemID, itemName
    }
    func rex() -> String {
        #"<\$(?"# + valueName(.itemID) + #"cc\.(?:t|bd)\.[[:TagName:]])><@cc\.kw>(?"# + valueName(.itemName) + #"[[:Item.1:]])(?:</>)+"#
    }
    var id: String!
    var item: Item1Morpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .itemID:
            self.id = value
        case .itemName:
            if let value = morpheme(of: value, alias: "[[:Item.1:]]") as? Item1Morpheme {
                self.item = value
            }
        }
    }

}

class Item3Morpheme: BuffMorpheme, ItemMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case id, itemName
    }
    func rex() -> String {
        #"<@cc\.kw><\$(?"# + valueName(.id) + #"cc\.[[:TagName:]])>(?"# + valueName(.itemName) + #"[[:Item.1:]])(?:</>)+"#
    }
    var id: String!
    var item: Item1Morpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .id:
            self.id = value
        case .itemName:
            if let value = morpheme(of: value, alias: "[[:Item.1:]]") as? Item1Morpheme {
                self.item = value
            }
        }
    }

}

class Item4Morpheme: BuffMorpheme, ItemMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case itemID, itemName
    }
    func rex() -> String {
        // 桑葚的《救援队·灾后普查》出现了“<<$cc\.bd_b1>”的语法错误, 所以这里用<+修一下
        #"<+\$(?"# + valueName(.itemID) + #"cc\.[[:TagName:]])><@cc\.rem>(?"# + valueName(.itemName) + #"[[:Item.1:]])(?:</>)+"#
    }
    var id: String!
    var item: Item1Morpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .itemID:
            self.id = value
        case .itemName:
            if let value = morpheme(of: value, alias: "[[:Item.1:]]") as? Item1Morpheme {
                self.item = value
            }
        }
    }
}

class Item5Morpheme: BuffMorpheme, ItemMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case item
    }
    func rex() -> String {
        #"<@cc.kw>(?"# + valueName(.item) + #"[[:Item.1:]])</>"#
    }

    var item: Item1Morpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .item:
            if let value = morpheme(of: value, alias: "[[:Item.1:]]") as? Item1Morpheme {
                self.item = value
            }
        }
    }
}

// 订单获取效率
class EfficientMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        "(?:生产力|(?:订单)?(?:获取)?的?效率|(?:无人机)?的?充能速度|线索搜集速度|(?:人脉资源|人力办公室)?的?联络速度|(?:干员)?的?恢复效果|龙门币收益)"
    }
}

class EfficientOrItemMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case item, efficient
    }
    func rex() -> String {
        #"(?"# + valueName(.efficient) + #"[[:Efficient:]])|(?"# + valueName(.item) + #"[[:Item.all:]])"#
    }
    var efficient: EfficientMorpheme?
    var item: ItemMorpheme?
    func postBuild(name: Name, value: String) {
        switch name {
        case .item:
            if let value = morpheme(of: value, alias: "[[:Item.all:]]") as? ItemMorpheme {
                item = value
            }
        case .efficient:
            if let value = morpheme(of: value, alias: "[[:Efficient:]]") as? EfficientMorpheme {
                efficient = value
            }
        }
    }
}


class SkillPointMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case itemID, itemName
    }
    func rex() -> String {
        #"<\$(?"# + valueName(.itemID) + #"cc\.sk\.[[:TagName:]])><@cc\.kw>(?"# + valueName(.itemName) + #".*?)(?:</>)+"#
    }
    var id: String!
    var name: String!
    func postBuild(name: Name, value: String) {
        switch name {
        case .itemID: self.id = value
        case .itemName: self.name = value
        }
    }
}
protocol GangMorpheme: SkillMorphemeMethod {

}

class Gang1Morpheme: BuffMorpheme, GangMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case id, name
    }
    func rex() -> String {
        #"<@cc\.kw><\$(?"# + valueName(.id) + #"cc\.[[:TagName:]])>(?"# + valueName(.name) + #".*?)(?:</>)+"#
    }

    var id: String!
    var name: String!
    func postBuild(name: Name, value: String) {
        switch name {
        case .id:
            self.id = value
        case .name:
            self.name = value
        }
    }
}

class Gang2Morpheme: BuffMorpheme, GangMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case id, name
    }
    func rex() -> String {
        #"<\$(?"# + valueName(.id) + #"cc\.(?:g|tag)\.[[:TagName:]])><@cc\.kw>(?"# + valueName(.name) + #".*?)(?:</>)+(?:干员)?"#
    }
    var id: String!
    var name: String!
    func postBuild(name: Name, value: String) {
        switch name {
        case .id:
            self.id = value
        case .name:
            self.name = value
        }
    }
}

class Gang3Morpheme: BuffMorpheme, GangMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case name
    }
    func rex() -> String {
        #"<@cc\.kw>(?"# + valueName(.name) + #".*?)</>(?:干员)?"#
    }
    var name: String!
    func postBuild(name: Name, value: String) {
        switch name {
        case .name:
            self.name = value
        }
    }
}

enum ValueMorpheme {
    enum Name: String {
        case direction, value
    }

    enum Direction {
        case up, down
    }

    enum Value: Equatable, Encodable {
        case percent(Double)
        case number(Double)
        case removeAll

        static func string(_ rawString: String) -> Value {
            let value = morpheme(of: rawString, alias: "[[:Value.all:]]")
            if let value = value as? ValueMorphemeMethod {
                return value.value
            }
            fatalError("unknown type of \(String(describing: value))")
        }

        static func _string(_ rawString: String, magnification: Double = 1) -> Value {
            if rawString.hasSuffix("%") {
                return .percent((Double(rawString.dropLast()) ?? 0) * magnification)
            } else {
                return .number((Double(rawString) ?? 0) * magnification)
            }
        }

        static func + (lhs: Value, rhs: Value) -> Value {
            if case let .number(double1) = lhs, case let .number(double2) = rhs {
                return .number(double1 + double2)
            }

            if case let .percent(double1) = lhs, case let .percent(double2) = rhs {
                return .percent(double1 + double2)
            }

            fatalError("\(lhs) and \(rhs) are not the same type")
        }

        static func += (lhs: inout Value, rhs: Value){
            lhs = lhs + rhs
        }

        func isNegative() -> Bool {
            switch self {
            case .percent(let double):
                return double < 0
            case .number(let double):
                return double < 0
            case .removeAll:
                return false
            }
        }

        mutating func negate() {
            switch self {
            case .percent(let double):
                self = .percent(-double)
            case .number(let double):
                self = .number(-double)
            case .removeAll:
                break
            }
        }
    }
}

protocol ValueMorphemeMethod {
    var value: ValueMorpheme.Value! { get }
}

class Value1Morpheme: BuffMorpheme, BuffMorphemeSubClass, ValueMorphemeMethod {
    typealias Name = ValueMorpheme.Name
    func rex() -> String {
        #"\d+%"#
    }
    var value: ValueMorpheme.Value!
    func postBuild(name: String, value: String) {
        guard name == "$0" else {
            return
        }
        self.value = ._string(value)
    }
}

class Value2Morpheme: BuffMorpheme, BuffMorphemeSubClass, ValueMorphemeMethod {
    typealias Name = ValueMorpheme.Name
    func rex() -> String {
        #"\d+(?:\.\d+)?"#
    }
    var value: ValueMorpheme.Value!
    func postBuild(name: String, value: String) {
        guard name == "$0" else {
            return
        }
        self.value = ._string(value)
    }
}

class Value3Morpheme: BuffMorpheme, BuffMorphemeSubClass, ValueMorphemeMethod {
    typealias Name = ValueMorpheme.Name
    func rex() -> String {
        #"(?"# + valueName(.direction) + #"\+|\-)?(?"# + valueName(.value) + #"[[:Value.1:]]|[[:Value.2:]])"#
    }
    var direction: ValueMorpheme.Direction = .up
    var value: ValueMorpheme.Value!
    func postBuild(name: Name, value: String) {
        switch name {
        case .direction:
            self.direction = value == "+" ? .up : .down
        case .value:
            self.value = ._string(value, magnification: self.direction == .down ? -1 : 1)
        }
    }
}

class Value4Morpheme: BuffMorpheme, BuffMorphemeSubClass, ValueMorphemeMethod {
    typealias Name = ValueMorpheme.Name
    func rex() -> String {
        #"(?:<@cc\.v(?"# + valueName(.direction) + #"up|down)>|<@cc\.kw>)(?"# + valueName(.value) + #"[[:Value.3:]])(?:</>)"#
    }
    var direction: ValueMorpheme.Direction = .up
    var value3: Value3Morpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .direction:
            self.direction = value == "up" ? .up : .down
        case .value:
            if let value = morpheme(of: value, alias: "[[:Value.3:]]") as? Value3Morpheme {
                self.value3 = value
            }
        }
    }
    var value: ValueMorpheme.Value! {
        if direction == .down {
            value3.direction = .down
        }
        return value3.value
    }
}

protocol EachValueMorpheme: SkillMorphemeMethod {
}

class EachValue1Morpheme: BuffMorpheme, EachValueMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case value, item, gang, formula
    }
    // 每10个/每个/每10%
    func rex() -> String {
        #"每(?:有|产生|差)?((?"# + valueName(.formula) + #"[[:Condition.Formula:]])|(?:(?"# + valueName(.value) + #"[[:Value.all:]])[[:Unit.all:]]?|[[:Unit.all:]]))(?:(?"# + valueName(.item) + #"[[:EfficientOrItem:]])|(?"# + valueName(.gang) + #"[[:Gang.all:]]))?"#
    }

    var value: ValueMorpheme.Value = .number(1)
    var item: EfficientOrItemMorpheme?
    var gang: GangMorpheme?
    var formula: ConditionFormulaMorpheme?
    func postBuild(name: Name, value: String) {
        switch name {
        case .value:
            self.value = .string(value)
        case .formula:
            if let value = morpheme(of: value, alias: "[[:Condition.Formula:]]") as? ConditionFormulaMorpheme {
                self.formula = value
            }
        case .item:
            if let value = morpheme(of: value, alias: "[[:EfficientOrItem:]]") as? EfficientOrItemMorpheme {
                self.item = value
            }
        case .gang:
            if let value = morpheme(of: value, alias: "[[:Gang.all:]]") as? GangMorpheme {
                self.gang = value
            }
        }
    }
}

protocol ValueChangedMorpheme: SkillMorphemeMethod {
    var value: ValueMorpheme.Value! { get }
}

class ValueChanged1Morpheme: BuffMorpheme, ValueChangedMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case provideAction, value
    }
    func rex() -> String {
        #"(?"# + valueName(.provideAction) + #"[[:ProvideAction:]])?(?"# + valueName(.value) + #"[[:Value.all:]])"#
    }

    var value: ValueMorpheme.Value!
    var provideAction: ProvideActionMorpheme?
    func postBuild(name: Name, value: String) {
        switch name {
        case .provideAction:
            if let value = morpheme(of: value, alias: "[[:ProvideAction:]]") as? ProvideActionMorpheme {
                self.provideAction = value
            }
        case .value:
            self.value = .string(value)
        }
    }
}

class ValueChanged2Morpheme: BuffMorpheme, ValueChangedMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case value
    }
    func rex() -> String {
        #"转化为(?"# + valueName(.value) + #"[[:Value.all:]])"#
    }

    var value: ValueMorpheme.Value!
    func postBuild(name: Name, value: String) {
        switch name {
        case .value:
            self.value = .string(value)
        }
    }
}

class GreaterThanValueMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case value
    }
    func rex() -> String {
        #"(大于|超过)(?"# + valueName(.value) + #"[[:Value.all:]])"#
    }

    var value: ValueMorpheme.Value!

    func postBuild(name: Name, value: String) {
        switch name {
        case .value:
            self.value = .string(value)
        }
    }
}

class LessThanValueMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"(?:小于([[:Value.all:]])|(?:处于)?([[:Value.all:]])以下)"#
    }

    var value: ValueMorpheme.Value!

    func postBuild(name: String, value: String) {
        guard name != "$0" else {
            return
        }
        self.value = .string(value)
    }
}

class ValueInRangeMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case comparison
    }
    func rex() -> String {
        #"(?"# + valueName(.comparison) + #"[[:Condition.GreaterThanValue:]]|[[:Condition.LessThanValue:]])"#
    }

    enum Value {
        case greaterThan(ValueMorpheme.Value)
        case lessThan(ValueMorpheme.Value)
    }
    var value: Value!

    func postBuild(name: Name, value: String) {
        switch name {
        case .comparison:
            if let value = morpheme(of: value, alias: "[[:Condition.GreaterThanValue:]]") as? GreaterThanValueMorpheme {
                self.value = .greaterThan(value.value)
            } else if let value = morpheme(of: value, alias: "[[:Condition.LessThanValue:]]") as? LessThanValueMorpheme {
                self.value = .lessThan(value.value)
            }
        }
    }
}

class Increase1Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"(?:(?:小幅)?(?:增加|提升)|更容易获得)"#
    }
}

class Increase2Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"<@cc\.kw>[[:Increase.1:]](?:</>)+"#
    }
}

class IncreaseClueMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case gang
    }

    func rex() -> String {
        #"[[:Increase.all:]](?"# + valueName(.gang) + #"[[:Gang.all:]])的?线索(?:的概率)?"#
    }
    var gang: GangMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .gang:
            if let value = morpheme(of: value, alias: "[[:Gang.all:]]") as? GangMorpheme {
                self.gang = value
            }
        }
    }
}

class RemoveAllMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case room, operators, efficient
    }
    func rex() -> String {
        #"(?"# + valueName(.room) + #"[[:Room:]])(?"# + valueName(.operators) + #"[[:Operator:]])[[:ProvideAction:]](?"# + valueName(.efficient) + #"[[:EfficientOrItem:]])<@cc\.vdown>全部归零(?:</>)+"#
    }

    var room: RoomMorpheme!
    var operators: OperatorMorpheme!
    var efficient: EfficientOrItemMorpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        case .operators:
            if let value = morpheme(of: value, alias: "[[:Operator:]]") as? OperatorMorpheme {
                self.operators = value
            }
        case .efficient:
            if let value = morpheme(of: value, alias: "[[:EfficientOrItem:]]") as? EfficientOrItemMorpheme {
                self.efficient = value
            }
        }
    }
}

class ConditionEachValue1Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"[[:Defer.Each:]]招募位"#
    }
}

class ConditionEachValue2Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case value
    }
    func rex() -> String {
        #"制造站(?"# + valueName(.value) + #"[[:EachValue.all:]])进行加工"#
    }

    var value: EachValueMorpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .value:
            if let value = morpheme(of: value, alias: "[[:EachValue.all:]]") as? EachValueMorpheme {
                self.value = value
            }
        }
    }
}

/// "每间设施每级"
class ConditionEachValue3Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case room
    }
    func rex() -> String {
        #"(?:设施|(?"# + valueName(.room) + #"[[:Room:]]))每级"#
    }
    var room: RoomMorpheme?
    func postBuild(name: Name, value: String) {
        switch name {
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        }
    }
}

class ConditionEachValue4Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case skillPoint
    }
    func rex() -> String {
        #"每[[:Unit.all:]](?"# + valueName(.skillPoint) + #"[[:SkillPoint:]])"#
    }

    var skillPoint: SkillPointMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .skillPoint:
            if let value = morpheme(of: value, alias: "[[:SkillPoint:]]") as? SkillPointMorpheme {
                self.skillPoint = value
            }
        }
    }
}

class ConditionEachValue5Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"当前订单数与订单上限每差<@cc.vup>1</>笔订单"#
    }
}

class ConditionEachValue7Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case value
    }
    func rex() -> String {
        #"自身(?"# + valueName(.value) + #"[[:EachValue.all:]])"#
    }

    var value: EachValueMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .value:
            if let value = morpheme(of: value, alias: "[[:EachValue.all:]]") as? EachValueMorpheme {
                self.value = value
            }
        }
    }
}

class ConditionEachValue10Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case value
    }
    func rex() -> String {
        #"(?"# + valueName(.value) + #"[[:EachValue.all:]])"#
    }


    var value: EachValueMorpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .value:
            if let value = morpheme(of: value, alias: "[[:EachValue.all:]]") as? EachValueMorpheme {
                self.value = value
            }
        }
    }
}

class ConditionEachValue13Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"基建内"#
    }
}

class ConditionEachValue15Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"每人"#
    }
}

class ConditionEachValue17Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case operators, value, efficient
    }
    func rex() -> String {
        #"(?"# + valueName(.operators) + #"[[:Operator:]])?[[:ProvideAction:]]每[[:Unit.all:]]?(?:(?"# + valueName(.value) + #"[[:Value.all:]])[[:Unit.all:]]?)?(?"# + valueName(.efficient) + #"[[:EfficientOrItem:]])"#
    }
    var operators: OperatorMorpheme?
    var value: ValueMorpheme.Value?
    var efficient: EfficientOrItemMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .operators:
            if let value = morpheme(of: value, alias: "[[:Operator:]]") as? OperatorMorpheme {
                self.operators = value
            }
        case .efficient:
            if let value = morpheme(of: value, alias: "[[:EfficientOrItem:]]") as? EfficientOrItemMorpheme {
                self.efficient = value
            }
        case .value:
            self.value = .string(value)
        }
    }
}

class ConditionEfficient3Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case efficient, valueInRange
    }
    func rex() -> String {
        #"(?"# + valueName(.efficient) + #"[[:EfficientOrItem:]])(?"# + valueName(.valueInRange) + #"[[:ValueInRange:]])"#
    }

    var efficient: EfficientOrItemMorpheme!
    var valueInRange: ValueInRangeMorpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .efficient:
            if let value = morpheme(of: value, alias: "[[:EfficientOrItem:]]") as? EfficientOrItemMorpheme {
                self.efficient = value
            }
        case .valueInRange:
            if let value = morpheme(of: value, alias: "[[:ValueInRange:]]") as? ValueInRangeMorpheme {
                self.valueInRange = value
            }
        }
    }
}

class ConditionFormulaMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case production, typeCount
    }
    func rex() -> String {
        #"(?:生产)?(?:<@cc\.kw>(?"# + valueName(.production) + #"[[:Production:]])</>|(?"# + valueName(.typeCount) + #"[[:Value.all:]]))类配方(?:的生产力)?"#
    }

    var production: String?
    var typeCount: ValueMorpheme.Value?

    func postBuild(name: Name, value: String) {
        switch name {
        case .production:
            self.production = value
        case .typeCount:
            self.typeCount = .string(value)
        }
    }
}

class ConditionGang1Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case gang
    }
    func rex() -> String {
        #"目标是(?"# + valueName(.gang) + #"[[:Gang.all:]])"#
    }

    var gang: GangMorpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .gang:
            if let value = morpheme(of: value, alias: "[[:Gang.all:]]") as? GangMorpheme {
                self.gang = value
            }
        }
    }
}

class ConditionGang2Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case room, gang
    }
    func rex() -> String {
        #"其他(?"# + valueName(.room) + #"[[:Room:]])没有进驻(?"# + valueName(.gang) + #"[[:Gang.all:]])"#
    }

    var room: RoomMorpheme!
    var gang: GangMorpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        case .gang:
            if let value = morpheme(of: value, alias: "[[:Gang.all:]]") as? GangMorpheme {
                self.gang = value
            }
        }
    }
}

class ConditionGang4Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case each, room, gang
    }
    func rex() -> String {
        #"(?"# + valueName(.each) + #"每[[:Unit.all:]])?进驻在(?"# + valueName(.room) + #"[[:Room:]])的(?"# + valueName(.gang) + #"[[:Gang.all:]])"#
    }

    var each: Bool = false
    var room: RoomMorpheme!
    var gang: GangMorpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .each:
            self.each = true
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        case .gang:
            if let value = morpheme(of: value, alias: "[[:Gang.all:]]") as? GangMorpheme {
                self.gang = value
            }
        }
    }
}

class ConditionGang5Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case range
    }
    func rex() -> String {
        #"(?"# + valueName(.range) + #"[[:Range:]])派系干员"#
    }

    var range: RangeMorpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .range:
            if let value = morpheme(of: value, alias: "[[:Range:]]") as? RangeMorpheme {
                self.range = value
            }
        }
    }
}

class ConditionItemMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case item, valueInRange
    }
    func rex() -> String {
        #"当自身(?"# + valueName(.item) + #"[[:EfficientOrItem:]])(?"# + valueName(.valueInRange) + #"[[:ValueInRange:]])"#
    }

    var item: EfficientOrItemMorpheme!
    var valueInRange: ValueInRangeMorpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .item:
            if let value = morpheme(of: value, alias: "[[:EfficientOrItem:]]") as? EfficientOrItemMorpheme {
                self.item = value
            }
        case .valueInRange:
            if let value = morpheme(of: value, alias: "[[:ValueInRange:]]") as? ValueInRangeMorpheme {
                self.valueInRange = value
            }
        }
    }
}

protocol MaximumValue: SkillMorphemeMethod {

}
class ConditionMaximumValue1Morpheme: BuffMorpheme, MaximumValue, BuffMorphemeSubClass {
    enum Name: String {
        case value
    }
    func rex() -> String {
        #"(?:最多|上限)(?:生效)?(?"# + valueName(.value) + #"[[:Value.all:]])[[:Unit.all:]]"#
    }

    var value: ValueMorpheme.Value!

    func postBuild(name: Name, value: String) {
        switch name {
        case .value:
            self.value = .string(value)
        }
    }
}

class ConditionMaximumValue2Morpheme: BuffMorpheme, MaximumValue, BuffMorphemeSubClass {
    enum Name: String {
        case value, efficient
    }
    func rex() -> String {
        #"最多[[:ProvideAction:]]?(?"# + valueName(.value) + #"[[:Value.all:]])((?"# + valueName(.efficient) + #"[[:EfficientOrItem:]])|[[:Unit.all:]])"#
    }

    var value: ValueMorpheme.Value!
    var efficient: EfficientOrItemMorpheme?

    func postBuild(name: Name, value: String) {
        switch name {
        case .value:
            self.value = .string(value)
        case .efficient:
            if let value = morpheme(of: value, alias: "[[:EfficientOrItem:]]") as? EfficientOrItemMorpheme {
                self.efficient = value
            }
        }
    }
}

class ConditionMaximumValue3Morpheme: BuffMorpheme, MaximumValue, BuffMorphemeSubClass {
    enum Name: String {
        case value
    }
    func rex() -> String {
        #"最终达到(?"# + valueName(.value) + #"[[:Value.all:]])"#
    }

    var value: ValueMorpheme.Value?

    func postBuild(name: Name, value: String) {
        switch name {
        case .value:
            self.value = .string(value)
        }
    }
}

class ConditionRoom1Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case with, gang, room
    }
    func rex() -> String {
        #"当?与(?:其他)?(?:(?"# + valueName(.gang) + #"[[:Gang.all:]])|(?"# + valueName(.with) + #".*?))(?:进驻|在)(?:同一[[:Unit.all:]])?(?"# + valueName(.room) + #"[[:Room:]])(?:一起工作)?"#
    }
    var with: String?
    var gang: GangMorpheme?
    var room: RoomMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .with:
            self.with = value
        case .gang:
            if let value = morpheme(of: value, alias: "[[:Gang.all:]]") as? GangMorpheme {
                self.gang = value
            }
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        }
    }
}

class ConditionRoom2Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case person, room
    }
    func rex() -> String {
        #"<@cc\.kw>(?"# + valueName(.person) + #".*?)</>(?:进驻)?在(?"# + valueName(.room) + #"[[:Room:]])"#
    }

    var person: String!
    var room: RoomMorpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .person:
            self.person = value
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        }
    }
}

class ConditionRoom3Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case operators, room
    }

    func rex() -> String {
        #"当(?:、?<@cc\.kw>(?"# + valueName(.operators) + #".*?)</>)+入驻(?"# + valueName(.room) + #"[[:Room:]])"#
    }

    var operators: [String] = []
    var room: RoomMorpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .operators:
            self.operators.append(value)
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        }
    }
}

class ConditionRoom4Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case room, operators
    }
    func rex() -> String {
        #"(?"# + valueName(.room) + #"[[:Room:]])有(?"# + valueName(.operators) + #"[[:Operator:]])"#
    }

    var room: RoomMorpheme!
    var operators: OperatorMorpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        case .operators:
            if let value = morpheme(of: value, alias: "[[:Operator:]]") as? OperatorMorpheme {
                self.operators = value
            }
        }
    }
}

class ConditionRoom5Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case person, room
    }

    func rex() -> String {
        #"<@cc\.kw>(?"# + valueName(.person) + #".*?)</>所在的(?"# + valueName(.room) + #"[[:Room:]])"#
    }

    var person: String!
    var room: RoomMorpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .person:
            self.person = value
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        }
    }
}

class ConditionPositionMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case room
    }
    func rex() -> String {
        #"进驻(?"# + valueName(.room) + #"[[:Room:]])"#
    }
    var room: RoomMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        }
    }
}

class ConditionRoom6Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case value, gang, room
    }

    func rex() -> String {
        #"有(?"# + valueName(.value) + #"[[:Value.all:]])[[:Unit.all:]]?以上(?"# + valueName(.gang) + #"[[:Gang.all:]])进驻在(?"# + valueName(.room) + #"[[:Room:]])"#
    }
    var value: ValueMorpheme.Value!
    var gang: GangMorpheme!
    var room: RoomMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .value:
            self.value = .string(value)
        case .gang:
            if let value = morpheme(of: value, alias: "[[:Gang.all:]]") as? GangMorpheme {
                self.gang = value
            }
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        }
    }
}

class ConditionRoom7Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case room
    }
    func rex() -> String {
        #"进驻在(?"# + valueName(.room) + #"[[:Room:]])以外的设施"#
    }

    var room: RoomMorpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        }
    }
}

class ConditionSamePositionMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case room
    }

    func rex() -> String {
        #"同(?:一|[[:Unit.all:]])?(?"# + valueName(.room) + #"[[:Room:]])中"#
    }
    var room: RoomMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        }
    }
}

class ConditionPeople3Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case range
    }

    func rex() -> String {
        #"心情(?"# + valueName(.range) + #"[[:ValueInRange:]])的干员"#
    }
    var valueRange: ValueInRangeMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .range:
            if let value = morpheme(of: value, alias: "[[:ValueInRange:]]") as? ValueInRangeMorpheme {
                self.valueRange = value
            }
        }
    }
}

class ConditionPeople4Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case range
    }
    func rex() -> String {
        #"当自身心情(?"# + valueName(.range) + #"[[:ValueInRange:]])"#
    }

    var valueRange: ValueInRangeMorpheme?
    func postBuild(name: Name, value: String) {
        switch name {
        case .range:
            if let value = morpheme(of: value, alias: "[[:ValueInRange:]]") as? ValueInRangeMorpheme {
                self.valueRange = value
            }
        }
    }
}

class ConditionTrading1Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case nextOnly, valueRange, staticValue
    }

    func rex() -> String {
        #"(?"# + valueName(.nextOnly) + #"下[[:Unit.all:]])?<@cc\.kw>赤金订单</>(?:的<@cc.kw>赤金</>)?交付数(?:(?"# + valueName(.valueRange) + #"[[:ValueInRange:]])|必定为(?"# + valueName(.staticValue) + #"[[:Value.all:]]))"#
    }
    var nextOnly: Bool = false
    var valueRange: ValueInRangeMorpheme?
    var staticValue: ValueMorpheme.Value?
    func postBuild(name: Name, value: String) {
        switch name {
        case .valueRange:
            if let value = morpheme(of: value, alias: "[[:ValueInRange:]]") as? ValueInRangeMorpheme {
                self.valueRange = value
            }
        case .staticValue:
            self.staticValue = .string(value)
        case .nextOnly:
            self.nextOnly = true
        }
    }
}

class ConditionMood1Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case selfOnly
    }

    func rex() -> String {
        #"(?"# + valueName(.selfOnly) + #"自身)?为(?:<@cc.kw>)?满心情(?:</>)?"#
    }
    var selfOnly: Bool = false

    func postBuild(name: Name, value: String) {
        switch name {
        case .selfOnly:
            self.selfOnly = true
        }
    }
}

class ChangesElementMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case formula, item
    }

    func rex() -> String {
        #"(?:(?"# + valueName(.formula) + #"[[:Condition.Formula:]])|[[:Unit.all:]]?(?"# + valueName(.item) + #"[[:EfficientOrItem:]]))"#
    }
    var formula: ConditionFormulaMorpheme?
    var item: EfficientOrItemMorpheme?
    func postBuild(name: Name, value: String) {
        switch name {
        case .formula:
            if let value = morpheme(of: value, alias: "[[:Condition.Formula:]]") as? ConditionFormulaMorpheme {
                self.formula = value
            }
        case .item:
            if let value = morpheme(of: value, alias: "[[:EfficientOrItem:]]") as? EfficientOrItemMorpheme {
                self.item = value
            }
        }
    }
}

class EventCapacity1Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case valueChanged
    }

    func rex() -> String {
        #"仓库容量(?"# + valueName(.valueChanged) + #"[[:ValueChanged.all:]])"#
    }
    var valueChanged: ValueChangedMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .valueChanged:
            if let value = morpheme(of: value, alias: "[[:ValueChanged.all:]]") as? ValueChangedMorpheme {
                self.valueChanged = value
            }
        }
    }
}

protocol EventChangesStatementMorpheme: SkillMorphemeMethod {

}

class EventChangesStatement1Morpheme: BuffMorpheme, EventChangesStatementMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case valueChanged, room, changesElement
    }

    func rex() -> String {
        #"(?"# + valueName(.valueChanged) + #"[[:ValueChanged.all:]])(?"# + valueName(.room) + #"[[:Room:]])?的?(?"# + valueName(.changesElement) + #"[[:ChangesElement:]])"#
    }
    var valueChanged: ValueChangedMorpheme!
    var room: RoomMorpheme?
    var changesElement: ChangesElementMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .valueChanged:
            if let value = morpheme(of: value, alias: "[[:ValueChanged.all:]]") as? ValueChangedMorpheme {
                self.valueChanged = value
            }
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        case .changesElement:
            if let value = morpheme(of: value, alias: "[[:ChangesElement:]]") as? ChangesElementMorpheme {
                self.changesElement = value
            }
        }
    }
}

class EventChangesStatement2Morpheme: BuffMorpheme, EventChangesStatementMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case valueChanged, changesElement
    }

    func rex() -> String {
        #"(?"# + valueName(.changesElement) + #"[[:ChangesElement:]])(?:分别)?(?"# + valueName(.valueChanged) + #"[[:ValueChanged.all:]])"#
    }
    var valueChanged: ValueChangedMorpheme?
    var changesElement: ChangesElementMorpheme?
    func postBuild(name: Name, value: String) {
        switch name {
        case .valueChanged:
            if let value = morpheme(of: value, alias: "[[:ValueChanged.all:]]") as? ValueChangedMorpheme {
                self.valueChanged = value
            }
        case .changesElement:
            if let value = morpheme(of: value, alias: "[[:ChangesElement:]]") as? ChangesElementMorpheme {
                self.changesElement = value
            }
        }
    }
}

class EventEfficient1Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case forAll, extra, efficient, value
    }
    func rex() -> String {
        #"(?:获取)?(?"# + valueName(.efficient) + #"[[:EfficientOrItem:]])?(?"# + valueName(.forAll) + #"分别)?(?"# + valueName(.extra) + #"额外)?(?"# + valueName(.value) + #"[[:Value.all:]])"#
    }
    var forAll: Bool = false
    var extra: Bool = false
    var efficient: EfficientOrItemMorpheme?
    var value: ValueMorpheme.Value!
    func postBuild(name: Name, value: String) {
        switch name {
        case .forAll:
            self.forAll = true
        case .extra:
            self.extra = true
        case .efficient:
            if let value = morpheme(of: value, alias: "[[:EfficientOrItem:]]") as? EfficientOrItemMorpheme {
                self.efficient = value
            }
        case .value:
            self.value = .string(value)
        }
    }
}

class EventEfficient4Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"[[:Increase.all:]]会客室内(?:另一)?干员<@cc\.kw>所属派系的线索倾向效果(?:</>)+"#
    }
}

class EventEfficient5Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case roomRange
    }

    func rex() -> String {
        #"[[:Increase.all:]](?"# + valueName(.roomRange) + #"[[:Range:]])贸易站<@cc\.kw>高品质贵金属订单</>的出现概率"#
    }
    var roomRange: RangeMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .roomRange:
            if let value = morpheme(of: value, alias: "[[:Range:]]") as? RangeMorpheme {
                self.roomRange = value
            }
        }
    }
}

class EventEfficient6Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case efficient, start
    }

    func rex() -> String {
        #"(?"# + valueName(.efficient) + #"[[:EfficientOrItem:]])首小时(?"# + valueName(.start) + #"[[:ValueChanged.all:]])"#
    }
    var efficient: EfficientOrItemMorpheme!
    var start: ValueChangedMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .efficient:
            if let value = morpheme(of: value, alias: "[[:EfficientOrItem:]]") as? EfficientOrItemMorpheme {
                self.efficient = value
            }
        case .start:
            if let value = morpheme(of: value, alias: "[[:ValueChanged.all:]]") as? ValueChangedMorpheme {
                self.start = value
            }
        }
    }
}

class EventEfficient7Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case efficient, valueChanged
    }

    func rex() -> String {
        #"其(?"# + valueName(.efficient) + #"[[:EfficientOrItem:]])(?"# + valueName(.valueChanged) + #"[[:ValueChanged.all:]])"#
    }
    var efficient: EfficientOrItemMorpheme!
    var valueChanged: ValueChangedMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .efficient:
            if let value = morpheme(of: value, alias: "[[:EfficientOrItem:]]") as? EfficientOrItemMorpheme {
                self.efficient = value
            }
        case .valueChanged:
            if let value = morpheme(of: value, alias: "[[:ValueChanged.all:]]") as? ValueChangedMorpheme {
                self.valueChanged = value
            }
        }
    }
}

class EventEfficient8Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case target, valueChanged, efficient
    }

    func rex() -> String {
        #"(?"# + valueName(.target) + #"[[:Operator:]])(?"# + valueName(.valueChanged) + #"[[:ValueChanged.all:]])(?"# + valueName(.efficient) + #"[[:EfficientOrItem:]])"#
    }

    var operators: OperatorMorpheme!
    var valueChanged: ValueChangedMorpheme!
    var efficient: EfficientOrItemMorpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .target:
            if let value = morpheme(of: value, alias: "[[:Operator:]]") as? OperatorMorpheme {
                self.operators = value
            }
        case .valueChanged:
            if let value = morpheme(of: value, alias: "[[:ValueChanged.all:]]") as? ValueChangedMorpheme {
                self.valueChanged = value
            }
        case .efficient:
            if let value = morpheme(of: value, alias: "[[:EfficientOrItem:]]") as? EfficientOrItemMorpheme {
                efficient = value
            }
        }
    }
}

class EventEfficientStepperMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case valueChanged
    }
    func rex() -> String {
        #"此后每小时(?"# + valueName(.valueChanged) + #"[[:ValueChanged.all:]])"#
    }

    var valueChanged: ValueChangedMorpheme!

    func postBuild(name: Name, value: String) {
        switch name {
        case .valueChanged:
            if let value = morpheme(of: value, alias: "[[:ValueChanged.all:]]") as? ValueChangedMorpheme {
                self.valueChanged = value
            }
        }
    }
}

class EventEfficientMaximumValueMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"[[:Condition.MaximumValue.all:]]"#
    }

    var value: MaximumValue!

    func postBuild(name: Name, value: String) {
        switch name {
        case ._0:
            if let value = morpheme(of: value, alias: "[[:Condition.MaximumValue.all:]]") as? MaximumValue {
                self.value = value
            }
        }
    }
}

class EventGang1Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case gang, tagID, rule
    }

    func rex() -> String {
        #"(?"# + valueName(.gang) + #"[[:Gang.all:]])获得<\$(?"# + valueName(.tagID) + #"cc\.c\.[[:TagName:]])><@cc\.rem>(?"# + valueName(.rule) + #".*?)(?:</>)+"#
    }
    var gang: GangMorpheme!
    var tagID: String!
    var rule: String!
    func postBuild(name: Name, value: String) {
        switch name {
        case .gang:
            if let gang = morpheme(of: value, alias: "[[:Gang.all:]]") as? GangMorpheme {
                self.gang = gang
            }
        case .tagID:
            self.tagID = value
        case .rule:
            self.rule = value
        }
    }
}

class EventGang2Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case people, room, gang
    }

    func rex() -> String {
        #"(?"# + valueName(.people) + #"[[:Gang.all:]])对(?"# + valueName(.room) + #"[[:Room:]])中(?"# + valueName(.gang) + #"[[:Gang.all:]])"#
    }
    var people: GangMorpheme!
    var room: RoomMorpheme!
    var gang: GangMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .people:
            if let value = morpheme(of: value, alias: "[[:Gang.all:]]") as? GangMorpheme {
                self.people = value
            }
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        case .gang:
            if let value = morpheme(of: value, alias: "[[:Gang.all:]]") as? GangMorpheme {
                self.gang = value
            }
        }
    }
}

class EventMeeting1Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case increaseClue
    }

    func rex() -> String {
        #"(?:会客室)?(?"# + valueName(.increaseClue) + #"[[:IncreaseClue:]])"#
    }
    var increaseClue: IncreaseClueMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .increaseClue:
            if let value = morpheme(of: value, alias: "[[:IncreaseClue:]]") as? IncreaseClueMorpheme {
                self.increaseClue = value
            }
        }
    }
}

class EventEfficientMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case selfOnly, valueChanged, efficient
    }

    func rex() -> String {
        #"(?"# + valueName(.selfOnly) + #"自身)?(?"# + valueName(.valueChanged) + #"[[:ValueChanged.all:]])的?(?"# + valueName(.efficient) + #"[[:EfficientOrItem:]])"#
    }
    var valueChanged: ValueChangedMorpheme!
    var efficient: EfficientOrItemMorpheme!
    var selfOnly: Bool = false
    func postBuild(name: Name, value: String) {
        switch name {
        case .valueChanged:
            if let value = morpheme(of: value, alias: "[[:ValueChanged.all:]]") as? ValueChangedMorpheme {
                self.valueChanged = value
            }
        case .efficient:
            if let value = morpheme(of: value, alias: "[[:EfficientOrItem:]]") as? EfficientOrItemMorpheme {
                self.efficient = value
            }
        case .selfOnly:
            selfOnly = true
        }
    }
}

class EventSkillMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case skillPoint, toSkillPoint
    }

    func rex() -> String {
        #"所有(?:、?(?"# + valueName(.skillPoint) + #"[[:SkillPoint:]]))+技能也全都视作<@cc\.kw>(?"# + valueName(.toSkillPoint) + #".*)</>技能"#
    }
    var skillPoint: [SkillPointMorpheme] = []
    var toSkillPoint: String!
    func postBuild(name: Name, value: String) {
        switch name {
        case .skillPoint:
            if let value = morpheme(of: value, alias: "[[:SkillPoint:]]") as? SkillPointMorpheme {
                self.skillPoint.append(value)
            }
        case .toSkillPoint:
            self.toSkillPoint = value
        }
    }
}

class EventTrading1Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case room, value, item
    }

    func rex() -> String {
        #"(?"# + valueName(.room) + #"[[:Room:]])[[:ProvideAction:]](?"# + valueName(.value) + #"[[:Value.all:]])[[:Unit.all:]](?"# + valueName(.item) + #"[[:EfficientOrItem:]])"#
    }
    var room: RoomMorpheme!
    var value: ValueMorpheme.Value!
    var item: EfficientOrItemMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        case .value:
            self.value = .string(value)
        case .item:
            if let item = morpheme(of: value, alias: "[[:EfficientOrItem:]]") as? EfficientOrItemMorpheme {
                self.item = item
            }
        }
    }
}

class EventTrading2Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case room, changesStatement
    }

    func rex() -> String {
        #"(?"# + valueName(.room) + #"[[:Room:]])(?"# + valueName(.changesStatement) + #"[[:Event.ChangesStatement.all:]])"#
    }
    var room: RoomMorpheme!
    var changesStatement: EventChangesStatementMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        case .changesStatement:
            if let value = morpheme(of: value, alias: "[[:Event.ChangesStatement.all:]]") as? EventChangesStatementMorpheme {
                self.changesStatement = value
            }
        }
    }
}

protocol OperatorMethod: SkillMorphemeMethod {

}

class Operator1Morpheme: BuffMorpheme, OperatorMethod, BuffMorphemeSubClass {
    enum Name: String {
        case isAll
    }

    func rex() -> String {
        #"(?"# + valueName(.isAll) + #"每人额外为)?自身"#
    }
    var isAll = false
    func postBuild(name: Name, value: String) {
        switch name {
        case .isAll:
            self.isAll = true
        }
    }
}

// 所有干员
class Operator2Morpheme: BuffMorpheme, OperatorMethod, BuffMorphemeSubClass {
    func rex() -> String {
        #"(?:所有|全体)(?:干员)?"#
    }
}

class Operator3Morpheme: BuffMorpheme, OperatorMethod, BuffMorphemeSubClass {
    func rex() -> String {
        #"(?:每[[:Unit.all:]])?处于工作状态的干员"#
    }
}

class Operator4Morpheme: BuffMorpheme, OperatorMethod, BuffMorphemeSubClass {
    enum Name: String {
        case range
    }

    func rex() -> String {
        #"心情未满的(?"# + valueName(.range) + #"宿舍成员|某[[:Unit.all:]]干员)"#
    }
    enum TargetRange {
        case all, randomOne
    }
    var range: TargetRange = .all
    func postBuild(name: Name, value: String) {
        switch name {
        case .range:
            self.range = value ~= /某.*干员/ ? .randomOne : .all
        }
    }
}

class Operator5Morpheme: BuffMorpheme, OperatorMethod, BuffMorphemeSubClass {
    enum Name: String {
        case otherOperator
    }
    func rex() -> String {
        #"(?"# + valueName(.otherOperator) + #"其他)?干员"#
    }
    var otherOperator = false
    func postBuild(name: Name, value: String) {
        switch name {
        case .otherOperator:
            otherOperator = true
        }
    }
}

class OperatorMorpheme: BuffMorpheme, OperatorMethod, BuffMorphemeSubClass {
    enum Name: String {
        case selfExclusion, target
    }
    func rex() -> String {
        #"(?"# + valueName(.selfExclusion) + #"除自身以外)?(?"# + valueName(.target) + #"[[:Operator.all:]])?"#
    }

    var selfExclusion = false
    var operators: OperatorMethod?
    func postBuild(name: Name, value: String) {
        switch name {
        case .selfExclusion:
            self.selfExclusion = true
        case .target:
            if let value = morpheme(of: value, alias: "[[:Operator.all:]]") as? OperatorMethod {
                self.operators = value
            }
        }
    }
}

class EventMood1Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case extra, target, valueChanged, action
    }

    func rex() -> String {
        #"(?"# + valueName(.extra) + #"额外[[:Defer.For:]])?(?"# + valueName(.target) + #"[[:Operator:]])(?:的?心情)?每小时(?:心情)?(?"# + valueName(.action) + #"恢复|消耗)(?:速度)?(?"# + valueName(.valueChanged) + #"[[:ValueChanged.all:]])"#
    }

    var extra: Bool = false
    var operators: OperatorMorpheme!
    var valueChanged: ValueChangedMorpheme!

    enum Action {
        case recovery
        case consumption
    }
    var action: Action!

    func postBuild(name: Name, value: String) {
        switch name {
        case .extra:
            extra = true
        case .target:
            if let value = morpheme(of: value, alias: "[[:Operator:]]") as? OperatorMorpheme {
                self.operators = value
            }
        case .valueChanged:
            if let value = morpheme(of: value, alias: "[[:ValueChanged.all:]]") as? ValueChangedMorpheme {
                self.valueChanged = value
            }
        case .action:
            self.action = value == "恢复" ? .recovery : .consumption
        }
    }
}

class EventMood2Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case item1, item2
    }

    func rex() -> String {
        #"心情耗尽时清空所有(?"# + valueName(.item1) + #"[[:EfficientOrItem:]])和自身累积的(?"# + valueName(.item2) + #"[[:EfficientOrItem:]])"#
    }
    var item1: EfficientOrItemMorpheme!
    var item2: EfficientOrItemMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .item1:
            if let value = morpheme(of: value, alias: "[[:EfficientOrItem:]]") as? EfficientOrItemMorpheme {
                self.item1 = value
            }
        case .item2:
            if let value = morpheme(of: value, alias: "[[:EfficientOrItem:]]") as? EfficientOrItemMorpheme {
                self.item2 = value
            }
        }
    }
}

class EventMood3Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"<@cc.vdown>无法获得</>其他来源提供的心情恢复效果"#
    }
}

class EventMood4Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case room, gang
    }

    func rex() -> String {
        #"<@cc\.kw>消除</>(?"# + valueName(.room) + #"[[:Room:]])所有(?:(?"# + valueName(.gang) + #"[[:Gang.all:]])|干员)<@cc\.kw>自身</>心情消耗的影响"#
    }

    var room: RoomMorpheme!
    var gang: GangMorpheme?
    func postBuild(name: Name, value: String) {
        switch name {
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        case .gang:
            if let value = morpheme(of: value, alias: "[[:Gang.all:]]") as? GangMorpheme {
                self.gang = value
            }
        }
    }
}

class EventMood6Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case operators, value
    }

    func rex() -> String {
        #"[[:Defer.Make:]](?"# + valueName(.operators) + #"[[:Operator:]])，?平均分配到总计每小时心情恢复(?"# + valueName(.value) + #"[[:Value.all:]])的加成"#
    }

    var value: ValueMorpheme.Value!
    var operators: OperatorMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .value:
            self.value = .string(value)
        case .operators:
            if let value = morpheme(of: value, alias: "[[:Operator:]]") as? OperatorMorpheme {
                self.operators = value
            }
        }
    }
}

class EventMood8Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"<@cc\.kw>额外恢复心情(?:</>)+"#
    }
}

class EventMood9Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case target
    }
    func rex() -> String {
        #"(?"# + valueName(.target) + #"[[:Operator:]])?[[:ProvideAction:]]心情恢复"#
    }
    var operators: OperatorMorpheme?
    func postBuild(name: Name, value: String) {
        switch name {
        case .target:
            if let value = morpheme(of: value, alias: "[[:Operator:]]") as? OperatorMorpheme {
                self.operators = value
            }
        }
    }
}

class EventMood10Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case gang, room, operators, valueChanged
    }
    func rex() -> String {
        #"[[:Defer.Each:]](?"# + valueName(.gang) + #"[[:Gang.all:]])[[:Defer.For:]](?"# + valueName(.room) + #"[[:Room:]])(?"# + valueName(.operators) + #"[[:Operator:]])心情每小时恢复速度(?"# + valueName(.valueChanged) + #"[[:ValueChanged.all:]])"#
    }
    var gang: GangMorpheme!
    var room: RoomMorpheme!
    var operators: OperatorMorpheme!
    var valueChanged: ValueChangedMorpheme!
    func postBuild(name: Name, value: String) {
        switch name {
        case .gang:
            if let value = morpheme(of: value, alias: "[[:Gang.all:]]") as? GangMorpheme {
                self.gang = value
            }
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        case .operators:
            if let value = morpheme(of: value, alias: "[[:Operator:]]") as? OperatorMorpheme {
                self.operators = value
            }
        case .valueChanged:
            if let value = morpheme(of: value, alias: "[[:ValueChanged.all:]]") as? ValueChangedMorpheme {
                self.valueChanged = value
            }
        }
    }
}

class EventMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case event
    }
    func rex() -> String {
        #"(?"# + valueName(.event) + #"[[:Event.all:]])"#
    }

    var event: (BuffMorpheme & SkillMorphemeMethod)!
    func postBuild(name: Name, value: String) {
        switch name {
        case .event:
            if let value = morpheme(of: value, alias: "[[:Event.all:]]") {
                self.event = value
            }
        }
    }

    override var description: String {
        event.description
    }
}

class Note1Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case all
    }
    func rex() -> String {
        #"(?"# + valueName(.all) + #"叠加后的最终值)?同种效果(分别)?取最高"#
    }
    var overlayAll: Bool = false
    func postBuild(name: Name, value: String) {
        switch name {
        case .all:
            self.overlayAll = true
        }
    }
}

class Note2Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case tagID, tagName
    }

    func rex() -> String {
        #"与部分技能有<\$(?"# + valueName(.tagID) + #"cc\.(?:c|t)\.[[:TagName:]])><@cc\.rem>(?"# + valueName(.tagName) + #".*?)(?:</>)+"#
    }
    var tagID: String!
    var tagName: String!
    func postBuild(name: Name, value: String) {
        switch name {
        case .tagID:
            self.tagID = value
        case .tagName:
            self.tagName = value
        }
    }
}

class Note3Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"仅影响设施数量"#
    }
}

class Note4Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case efficient, value
    }
    func rex() -> String {
        #"其中包含基础(?"# + valueName(.efficient) + #"[[:EfficientOrItem:]])(?"# + valueName(.value) + #"[[:Value.all:]])"#
    }

    var efficient: EfficientOrItemMorpheme!
    var value: ValueMorpheme.Value!

    func postBuild(name: Name, value: String) {
        switch name {
        case .efficient:
            if let value = morpheme(of: value, alias: "[[:EfficientOrItem:]]") as? EfficientOrItemMorpheme {
                self.efficient = value
            }
        case .value:
            self.value = .string(value)
        }
    }
}

class Note5Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"该加成全局效果唯一"#
    }
}

class Note6Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"工作时长(和招募位)?影响概率"#
    }
}

class Note7Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"不受其它加成影响"#
    }
}

class Note8Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"不包含初始招募位"#
    }
}

class Note9Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"不包括副手"#
    }
}

class Note10Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"[[:Condition.MaximumValue.all:]]"#
    }

    var maxValue: MaximumValue!
    func postBuild(name: Name, value: String) {
        switch name {
        case ._0:
            if let value = morpheme(of: value, alias: "[[:Condition.MaximumValue.all:]]") as? MaximumValue {
                self.maxValue = value
            }
        }

    }
}

class Note11Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case room, rule
    }
    func rex() -> String {
        #"与(?"# + valueName(.room) + #"[[:Room:]])加成有<\$(?"# + valueName(.rule) + #"cc\.[[:TagName:]]\.[[:TagName:]])><@cc.rem>.*?(?:</>)+"#
    }

    var room: RoomMorpheme!
    var ruleID: String!
    func postBuild(name: Name, value: String) {
        switch name {
        case .room:
            if let value = morpheme(of: value, alias: "[[:Room:]]") as? RoomMorpheme {
                self.room = value
            }
        case .rule:
            self.ruleID = value
        }
    }
}

class Note12Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        "不包含副手"
    }
}

class Note13Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"不包含根据设施数量提供加成的生产力"#
    }
}

class Note14Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    enum Name: String {
        case value
    }
    func rex() -> String {
        #"订单最少为1"#
    }
}

class Note15Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        "(?:违约订单)?不视作(?:.*?)订单"
    }
}

class Note16Morpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        "该技能对单[[:Unit.all:]]干员和多[[:Unit.all:]]干员生效时"
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

class DeferEachValueMorpheme: BuffMorpheme, BuffMorphemeSubClass {
    func rex() -> String {
        #"每[[:Unit.all:]]"#
    }
}

class BuffParser {
    var result: [BuffMorpheme] = []

    func build(in rawString: String) throws {

        var inNote = false
        var startIndex = rawString.startIndex
        while startIndex != rawString.endIndex {
            let separatorIndex = rawString[startIndex...].firstMatch(of: /,|，/)?.range.lowerBound ?? rawString.endIndex
            let bracketStartIndex = rawString[startIndex...].firstMatch(of: /（|\(/)?.range.lowerBound ?? rawString.endIndex
            let bracketEndIndex = rawString[startIndex...].firstMatch(of: /）|\)/)?.range.lowerBound ?? rawString.endIndex


            while [separatorIndex, bracketStartIndex, bracketEndIndex].contains(startIndex) {
                if bracketStartIndex == startIndex {
                    inNote = true
                }

                if bracketEndIndex == startIndex {
                    inNote = false
                }

                startIndex = rawString.index(after: startIndex)
                if startIndex == rawString.endIndex {
                    return
                }
            }

            var endIndex = min(separatorIndex, bracketStartIndex)
            defer {
                startIndex = endIndex
            }
            let substring = rawString[startIndex...]

            if !substring.isEmpty {
                if inNote, let (value, range) = morpheme(of: substring, alias: "[[:Note.all:]]") {
                    assert(!value.rawString.isEmpty)
                    result.last?._notes.append(value)
                    endIndex = range.upperBound
                } else if let (value, range) = morpheme(of: substring, alias: "[[:Event:]]") {
                    assert(!value.rawString.isEmpty)
                    result.append(value)
                    endIndex = range.upperBound
                } else if let (value, range) = morpheme(of: substring, alias: "[[:Condition.all:]]") {
                    assert(!value.rawString.isEmpty)
                    result.append(value)
                    endIndex = range.upperBound
                } else if let (value, range) = morpheme(of: substring, alias: "[[:Defer.all:]]") {
                    assert(!value.rawString.isEmpty)
                    if !inNote {
                        result.append(value)
                    }
                    endIndex = range.upperBound
                } else {
                    print(substring)
                    fatalError("unknown: \(substring)")
                }
            }
        }
    }
}
