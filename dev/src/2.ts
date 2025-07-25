import { KeyValues } from 'easy-keyvalues';
import { join } from 'path';
export async function Start(): Promise<void> {
    const abilities = await KeyValues.Load(
        join("d:/dev/" ,'npc_abilities_custom.txt')
       
    );
    const DOTAAbilities: KeyValues[] = [
        abilities.FindKey('DOTAAbilities')!,
        ...abilities.GetBaseList().map((k) => k.FindKey('DOTAAbilities')!),
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

    const items = await KeyValues.Load(
        join("d:/dev/", 'npc_items_custom.txt')
    );
    const DOTAItems: KeyValues[] = [
        abilities.FindKey('DOTAAbilities')!,
        ...items.GetBaseList().map((k) => k.FindKey('DOTAAbilities')!),
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
