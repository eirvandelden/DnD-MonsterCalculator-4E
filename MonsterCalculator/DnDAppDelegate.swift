//
//  DnDAppDelegate.swift
//  MonsterCalculator
//
//  Created by Etienne van Delden on 09-02-2013.
//  Modernised to Swift 2025.
//

import Cocoa

class DnDAppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - IBOutlets (window)
    @IBOutlet weak var window: NSWindow!

    // MARK: - IBOutlets (inputs)
    @IBOutlet weak var monsterLevel: NSTextField!
    @IBOutlet weak var monsterType: NSPopUpButton!
    @IBOutlet weak var monsterSecondaryRole: NSPopUpButton!
    @IBOutlet weak var AttackRange: NSPopUpButton!
    @IBOutlet weak var AttackVsDefense: NSPopUpButton!
    @IBOutlet weak var damageScale: NSPopUpButton!

    // Legacy duplicate outlet wired in the XIB to the same button as monsterType;
    // must be declared to prevent a crash on launch.
    @IBOutlet weak var TypeList: NSPopUpButton?

    // MARK: - IBOutlets (outputs)
    @IBOutlet weak var viewInitiative: NSTextField!
    @IBOutlet weak var viewHP: NSTextField!
    @IBOutlet weak var viewAC: NSTextField!
    @IBOutlet weak var viewFortitude: NSTextField!
    @IBOutlet weak var viewReflex: NSTextField!
    @IBOutlet weak var viewWill: NSTextField!
    @IBOutlet weak var viewAttackBonus: NSTextField!
    @IBOutlet weak var viewDamage: NSTextField!

    // MARK: - State
    private var npc = DnDNPC(
        level: 1,
        type: .brute,
        role: .normal,
        attackVsDefense: .ac,
        attackRange: .melee,
        damageScale: .atWill
    )

    // MARK: - NSApplicationDelegate
    func applicationDidFinishLaunching(_ notification: Notification) {}

    // MARK: - IBActions
    @IBAction func Calculate(_ sender: Any) {
        updateNPC()
    }

    @IBAction func UpdateAttack(_ sender: Any) {
        updateNPC()
    }

    // MARK: - Private
    private func updateNPC() {
        let type = MonsterType(rawValue: monsterType.titleOfSelectedItem ?? "") ?? .brute
        let role = MonsterRole(rawValue: monsterSecondaryRole.titleOfSelectedItem ?? "") ?? .normal
        let range: MonsterAttackRange = AttackRange.titleOfSelectedItem == "Ranged" ? .ranged : .melee
        let defense: MonsterAttackVsDefense = AttackVsDefense.titleOfSelectedItem == "AC" ? .ac : .other
        let scale: MonsterDamageScale = damageScale.titleOfSelectedItem == "Encounter" ? .encounter : .atWill

        npc = DnDNPC(
            level: monsterLevel.integerValue,
            type: type,
            role: role,
            attackVsDefense: defense,
            attackRange: range,
            damageScale: scale
        )
        updateView()
    }

    private func updateView() {
        viewInitiative.stringValue  = "\(npc.initiative)"
        viewHP.stringValue          = "\(npc.hp)"
        viewAC.stringValue          = "\(npc.ac)"
        viewFortitude.stringValue   = "\(npc.fortitude)"
        viewReflex.stringValue      = "\(npc.reflex)"
        viewWill.stringValue        = "\(npc.will)"
        viewAttackBonus.stringValue = "\(npc.attackBonus)"
        viewDamage.stringValue      = "\(npc.damageBonus)"
    }
}
