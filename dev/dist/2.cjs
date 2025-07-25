"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Start = Start;
const easy_keyvalues_1 = require("easy-keyvalues");
const path_1 = require("path");
console.log((0, path_1.join)("d:/dev/", 'npc_abilities_custom.txt'));
async function Start() {
    const abilities = await easy_keyvalues_1.KeyValues.Load((0, path_1.join)("d:/dev/", 'npc_abilities_custom.txt'));
    const DOTAAbilities = [
        abilities.FindKey('DOTAAbilities'),
        ...abilities.GetBaseList().map((k) => k.FindKey('DOTAAbilities')),
    ];
    for (const _DOTAAbilities of DOTAAbilities) {
        for (const ability of _DOTAAbilities.GetChildren()) {
            if (!ability.HasChildren()) {
                continue;
            }
            const AbilitySpecial = ability.FindKey('AbilitySpecial');
            if (!AbilitySpecial) {
                continue;
            }
            const AbilityValues = ability.CreateChild('AbilityValues', []);
            for (const speical of AbilitySpecial.GetChildren()) {
                for (const kv of speical.GetChildren()) {
                    if (kv.Key !== 'var_type') {
                        AbilityValues.CreateChild(kv.Key, kv.GetValue());
                    }
                }
            }
            ability.Delete('AbilitySpecial');
        }
    }
    await abilities.Save();
    const items = await easy_keyvalues_1.KeyValues.Load((0, path_1.join)("d:/dev/", 'npc_items_custom.txt'));
    const DOTAItems = [
        abilities.FindKey('DOTAAbilities'),
        ...items.GetBaseList().map((k) => k.FindKey('DOTAAbilities')),
    ];
    for (const _DOTAAbilities of DOTAItems) {
        for (const ability of _DOTAAbilities.GetChildren()) {
            if (!ability.HasChildren()) {
                continue;
            }
            const AbilitySpecial = ability.FindKey('AbilitySpecial');
            if (!AbilitySpecial) {
                continue;
            }
            const AbilityValues = ability.CreateChild('AbilityValues', []);
            for (const speical of AbilitySpecial.GetChildren()) {
                for (const kv of speical.GetChildren()) {
                    if (kv.Key !== 'var_type') {
                        AbilityValues.CreateChild(kv.Key, kv.GetValue());
                    }
                }
            }
            ability.Delete('AbilitySpecial');
        }
    }
    await items.Save();
}
