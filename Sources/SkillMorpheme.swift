//
//  SkillMorpheme.swift
//  
//
//  Created by mi on 2024/4/6.
//

import Foundation

enum SkillMorphemeMethodTarget: Equatable, Encodable {
    case from, increase, to
}

@dynamicMemberLookup
class SkillMorpheme: Equatable, Encodable {
    static func == (lhs: SkillMorpheme, rhs: SkillMorpheme) -> Bool {
        lhs.content == rhs.content
    }
    func encode(to encoder: any Encoder) throws {
        try content.encode(to: encoder)
    }

    enum State: Equatable, Encodable {
        case initial
        case end
        case reverse
    }

    enum EffectiveType: Equatable, Encodable {
        case simultaneous
        case exclusive
        case exclusiveAll
    }

    enum Operator: Equatable, Encodable {
        case myself, others, atWork, unfulfilledMood, randomOne, evenly
    }

    enum RoomType: String, Equatable, Codable, CodingKeyRepresentable {
        case control = "CONTROL"
        case corridor = "CORRIDOR"
        case dormitory = "DORMITORY"
        case elevator = "ELEVATOR"
        case functional = "FUNCTIONAL"
        case hire = "HIRE"
        case manufacture = "MANUFACTURE"
        case meeting = "MEETING"
        case power = "POWER"
        case trading = "TRADING"
        case training = "TRAINING"
        case workshop = "WORKSHOP"
        case others
        init(localizedString: String) {
            switch localizedString {
            case "人力办公室":
                self = .hire
            case "会客室":
                self = .meeting
            case "制造站":
                self = .manufacture
            case "加工站":
                self = .workshop
            case "发电站":
                self = .power
            case "宿舍":
                self = .dormitory
            case "控制中枢":
                self = .control
            case "训练室":
                self = .trading
            case "贸易站":
                self = .trading
            case "其他设施":
                self = .others
            default:
                fatalError("unknown \(localizedString)")
            }
        }
    }

    @dynamicMemberLookup
    class Target: Equatable, Encodable {
        static func == (lhs: Target, rhs: Target) -> Bool {
            lhs.content == rhs.content
        }
        func encode(to encoder: any Encoder) throws {
            try content.encode(to: encoder)
        }

        struct Content: Equatable, Encodable {
            var isReverse: Bool = false

            var roomRange: RangeMorpheme.Range?

            enum ValueType: Equatable, Encodable {
                case once
                case each
                case perHour
            }
            // Not for to
            var valueType: ValueType = .once
            var value: ValueMorpheme.Value?
            var maxSourceValue: ValueMorpheme.Value?
            // for to only, when it is simultaneous, need to make sure that there are more than one object in the from.eachItem
            enum EffectiveType: Equatable, Encodable {
                case simultaneous
                case exclusive
            }
            var effectiveFrom: EffectiveType = .exclusive
            enum Item: Equatable, Encodable {
                case mood
                case `operator`(Set<Operator>)
                case recruitingPosition
                case contactSpeed
                case gangOrPeople(String)
                case clue(gang: String)
                case clueFromOther
                case allPeople
                case room(RoomType)
                case unknown(String)
                case orderLimit
                case formulaType
                case efficient
                case skillPoint(String)
                case roomLevel(Set<RoomType>)
            }

            var items: [Item] = []
            var ids: [String] = []

            var itemFromOperator: Set<Operator>?


            var itemInRooms: Set<RoomType> = []
            var itemNotInRooms: Set<RoomType> = []
            var gangExceptSelf = false

            struct ValueComparison: Equatable, Encodable {
                let value: (Double, Double) -> Bool

                static func == (lhs: ValueComparison, rhs: ValueComparison) -> Bool {
                    unsafeBitCast(lhs.value, to: AnyObject.self) === unsafeBitCast(rhs.value, to: AnyObject.self)
                }
                func encode(to encoder: any Encoder) throws {
                    var container = encoder.singleValueContainer()

                    var valueObject = unsafeBitCast(value, to: AnyObject.self)
                    try withUnsafePointer(to: &valueObject) {
                        try container.encode(Int(bitPattern: UnsafePointer($0)))
                    }
                }
            }
            var valueComparison: ValueComparison?

            var kaibaSpecialRuleID: String?
            enum KaibaSpecialRule: Equatable, Encodable {
                case removeMoodEffect
            }
            var kaibaSpecialRule: KaibaSpecialRule?
        }
        private var content = Content()

        func copyFrom(_ source: Target) {
            content = source.content
        }

        subscript<P>(dynamicMember keyPath: WritableKeyPath<Content, P>) -> P {
            get {
                content[keyPath: keyPath]
            }
            set {
                content[keyPath: keyPath] = newValue
            }
        }
    }

    struct Content: Equatable, Encodable {
        fileprivate var state: State = .initial

        fileprivate var target: SkillMorphemeMethodTarget?

        var effectiveType: EffectiveType = .simultaneous

        var effectiveRoom: RoomType?

        var from: Target?
        var increase: Target?
        var to: Target?
    }
    private var content = Content()
    var hasFrom: Bool {
        content.from != nil
    }
    var from: Target {
        let target = content.from ?? Target()
        content.from = target
        return target
    }

    var hasIncrease: Bool {
        content.increase != nil
    }
    var increase: Target {
        let target = content.increase ?? Target()
        content.increase = target
        return target
    }

    var hasTo: Bool {
        content.to != nil
    }
    var to: Target {
        let target = content.to ?? Target()
        content.to = target
        return target
    }

    subscript<P>(dynamicMember keyPath: WritableKeyPath<Content, P>) -> P {
        get {
            content[keyPath: keyPath]
        }
        set {
            content[keyPath: keyPath] = newValue
        }
    }

    func getTarget(updateTarget newTarget: SkillMorphemeMethodTarget? = nil) -> Target {
        if let newTarget {
            self.target = newTarget
        }
        if let target = content.target {
            if target == .from {
                return from
            } else {
                return to
            }
        } else {
            return from.items.isEmpty ? from : to
        }
    }
}
