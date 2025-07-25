import {
    KeyValues
} from 'easy-keyvalues';
import fs from 'fs';
import readline from 'readline';



// // const rl = readline.createInterface({
// //   input: fs.createReadStream('npc_abilities_custom.txt'),
// //   crlfDelay: Infinity
// // });

// // rl.on('line', async (line) => {  
// //     if (line.startsWith("#base ")) {
// //         const lineWithoutBase = line.substring(6); // 去掉 #base 部分
// //         console.log(`Line from file: ${lineWithoutBase.trim()}`);        
// //         const kv = await KeyValues.Load(lineWithoutBase, 'utf8')
// //         let dac_number = kv.FindKey("DOTAAbilities").GetChildCount();
// //         for (let index = 0; index < dac_number; index++) {
// //             let AbilityValues_p
// //             if( kv.FindKey("DOTAAbilities").GetChildren()[index].FindKey("AbilityValues") != undefined){
// //                 AbilityValues_p= kv.FindKey("DOTAAbilities").GetChildren()[index].FindKey("AbilityValues") 
// //             }else{
// //                 try {
// //                     AbilityValues_p = kv.FindKey("DOTAAbilities").GetChildren()[index].CreateChild("AbilityValues", [])

// //                 }catch(error){
// //                     console.log(error)
// //                 }
// //             }
            
// //             if (kv.FindKey("DOTAAbilities").GetChildren()[index].FindKey("AbilitySpecial") != undefined) {
// //                 let number2 = kv.FindKey("DOTAAbilities").GetChildren()[index].FindKey("AbilitySpecial").GetChildCount();
// //                 for (let index2 = 1; index2 <= number2; index2++) {
// //                     if (kv.FindKey("DOTAAbilities").GetChildren()[index].FindKey("AbilitySpecial").FindKey("0" + index2) != undefined) {
// //                         let dac_key = kv.FindKey("DOTAAbilities").GetChildren()[index].FindKey("AbilitySpecial").FindKey("0" + index2).GetLastChild().Key
// //                         let dac_value = kv.FindKey("DOTAAbilities").GetChildren()[index].FindKey("AbilitySpecial").FindKey("0" + index2).GetLastChild().value
// //                         AbilityValues_p.Append(new KeyValues(dac_key, dac_value))
// //                     }

// //                 }
// //                 kv.FindKey("DOTAAbilities").GetChildren()[index].Delete("AbilitySpecial")
// //             }

// //         }

// //         kv.Save(lineWithoutBase);

// //         // var kv2=kv.FindTraverse(SetValue("AbilityCastPoint"))
// //       }
    
// // });

const kv = await KeyValues.Load("npc_items_custom.txt", 'utf8')
let dac_number = kv.FindKey("DOTAAbilities").GetChildCount();
for (let index = 0; index < dac_number; index++) {
    let AbilityValues_p
    if( kv.FindKey("DOTAAbilities").GetChildren()[index].FindKey("AbilityValues") != undefined){
        AbilityValues_p= kv.FindKey("DOTAAbilities").GetChildren()[index].FindKey("AbilityValues") 
    }else{
        try {
            AbilityValues_p = kv.FindKey("DOTAAbilities").GetChildren()[index].CreateChild("AbilityValues", [])
        }catch(error){
            console.log(error)
        }
    }
    
    if (kv.FindKey("DOTAAbilities").GetChildren()[index].FindKey("AbilitySpecial") != undefined) {
        let number2 = kv.FindKey("DOTAAbilities").GetChildren()[index].FindKey("AbilitySpecial").GetChildCount();
        for (let index2 = 1; index2 <= number2; index2++) {
            if (kv.FindKey("DOTAAbilities").GetChildren()[index].FindKey("AbilitySpecial").FindKey("0" + index2) != undefined) {
                let dac_key = kv.FindKey("DOTAAbilities").GetChildren()[index].FindKey("AbilitySpecial").FindKey("0" + index2).GetLastChild().Key
                let dac_value = kv.FindKey("DOTAAbilities").GetChildren()[index].FindKey("AbilitySpecial").FindKey("0" + index2).GetLastChild().value
                AbilityValues_p.Append(new KeyValues(dac_key, dac_value))
            }

        }
        kv.FindKey("DOTAAbilities").GetChildren()[index].Delete("AbilitySpecial")
    }

}

kv.Save("npc_items_custom.txt")
