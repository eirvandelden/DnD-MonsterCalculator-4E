//
//  DnDNPC.swift
//  MonsterCalculator
//
//  Created by Etienne van Delden on 09-02-2013.
//  Modernised to Swift 2025.
//

import Foundation

enum MonsterType: String {
    case brute      = "Brute"
    case skirmisher = "Skirmisher"
    case soldier    = "Soldier"
    case lurker     = "Lurker"
    case artillery  = "Artillery"
    case controller = "Controller"
}

enum MonsterRole: String {
    case normal = "Normal"
    case elite  = "Elite"
    case solo   = "Solo"
    case minion = "Minion"
}

enum MonsterAttackRange {
    case melee, ranged
}

enum MonsterAttackVsDefense {
    case ac, other
}

enum MonsterDamageScale {
    case atWill, encounter
}

struct DnDNPC {
    var level: Int
    var type: MonsterType
    var role: MonsterRole
    var attackVsDefense: MonsterAttackVsDefense
    var attackRange: MonsterAttackRange
    var damageScale: MonsterDamageScale

    // Brutes are tankier — higher constitution
    private var constitution: Int {
        type == .brute ? 16 : 14
    }

    // MARK: - Initiative

    var initiative: Int {
        var result = (level / 2) + 2
        switch type {
        case .skirmisher, .soldier: result += 2
        case .lurker:               result += 4
        default:                    break
        }
        return result
    }

    // MARK: - Hit Points

    var hp: Int {
        switch role {
        case .normal: return hpNormal
        case .elite:  return hpElite
        case .solo:   return hpSolo
        case .minion: return 1
        }
    }

    private var hpNormal: Int {
        var result = 8 + constitution + (level * 8)
        switch type {
        case .brute:                result += 2 + (level * 2)
        case .lurker, .artillery:   result -= 2 + (level * 2)
        default:                    break
        }
        return result
    }

    private var hpElite: Int {
        2 * hpNormal + 2 * constitution
    }

    private var hpSolo: Int {
        let base = 8 * (level + 1) + constitution
        return base * (level <= 10 ? 4 : 5)
    }

    // MARK: - Defenses

    var ac: Int {
        var result = level + 14
        switch type {
        case .brute, .artillery: result -= 2
        case .soldier:           result += 2
        default:                 break
        }
        if role == .solo || role == .elite { result += 2 }
        return result
    }

    var fortitude: Int { level + 12 }
    var reflex: Int    { level + 12 }
    var will: Int      { level + 12 }

    // MARK: - Offensive

    var attackBonus: Int {
        switch attackVsDefense {
        case .ac:
            var result = level + 4
            if attackRange == .ranged && type == .artillery { result += 2 }
            return result
        case .other:
            return level + 2
        }
    }

    var damageBonus: Int {
        var result = 8 + level
        if role == .minion {
            result = Int((Double(level) * 0.5).rounded()) + 4
        }
        if type == .brute {
            result += Int(Double(result) * 0.25)
        }
        if damageScale == .encounter {
            result += Int(Double(result) * 0.25)
        }
        return result
    }
}
