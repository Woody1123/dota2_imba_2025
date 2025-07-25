"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (g && (g = 0, op[0] && (_ = 0)), _) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var __spreadArray = (this && this.__spreadArray) || function (to, from, pack) {
    if (pack || arguments.length === 2) for (var i = 0, l = from.length, ar; i < l; i++) {
        if (ar || !(i in from)) {
            if (!ar) ar = Array.prototype.slice.call(from, 0, i);
            ar[i] = from[i];
        }
    }
    return to.concat(ar || Array.prototype.slice.call(from));
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.Start = Start;
var easy_keyvalues_1 = require("./node_modules/easy-keyvalues");
function Start() {
    return __awaiter(this, void 0, void 0, function () {
        var abilities, DOTAAbilities, _i, DOTAAbilities_1, _DOTAAbilities, _a, _b, ability, AbilitySpecial, AbilityValues, _c, _d, speical, _e, _f, kv, items, DOTAItems, _g, DOTAItems_1, _DOTAAbilities, _h, _j, ability, AbilitySpecial, AbilityValues, _k, _l, speical, _m, _o, kv;
        return __generator(this, function (_p) {
            switch (_p.label) {
                case 0: return [4 /*yield*/, easy_keyvalues_1.KeyValues.Load(join(HostProjectInfo.ScriptsPath, 'npc/npc_abilities_custom.txt'))];
                case 1:
                    abilities = _p.sent();
                    DOTAAbilities = __spreadArray([
                        abilities.FindKey('DOTAAbilities')
                    ], abilities.GetBaseList().map(function (k) { return k.FindKey('DOTAAbilities'); }), true);
                    for (_i = 0, DOTAAbilities_1 = DOTAAbilities; _i < DOTAAbilities_1.length; _i++) {
                        _DOTAAbilities = DOTAAbilities_1[_i];
                        for (_a = 0, _b = _DOTAAbilities.GetChildren(); _a < _b.length; _a++) {
                            ability = _b[_a];
                            if (!ability.HasChildren()) {
                                continue;
                            }
                            AbilitySpecial = ability.FindKey('AbilitySpecial');
                            if (!AbilitySpecial) {
                                continue;
                            }
                            AbilityValues = ability.CreateChild('AbilityValues', []);
                            for (_c = 0, _d = AbilitySpecial.GetChildren(); _c < _d.length; _c++) {
                                speical = _d[_c];
                                for (_e = 0, _f = speical.GetChildren(); _e < _f.length; _e++) {
                                    kv = _f[_e];
                                    if (kv.Key !== 'var_type') {
                                        AbilityValues.CreateChild(kv.Key, kv.GetValue());
                                    }
                                }
                            }
                            ability.Delete('AbilitySpecial');
                        }
                    }
                    return [4 /*yield*/, abilities.Save()];
                case 2:
                    _p.sent();
                    return [4 /*yield*/, easy_keyvalues_1.KeyValues.Load(join(HostProjectInfo.ScriptsPath, 'npc/npc_items_custom.txt'))];
                case 3:
                    items = _p.sent();
                    DOTAItems = __spreadArray([
                        abilities.FindKey('DOTAAbilities')
                    ], items.GetBaseList().map(function (k) { return k.FindKey('DOTAAbilities'); }), true);
                    for (_g = 0, DOTAItems_1 = DOTAItems; _g < DOTAItems_1.length; _g++) {
                        _DOTAAbilities = DOTAItems_1[_g];
                        for (_h = 0, _j = _DOTAAbilities.GetChildren(); _h < _j.length; _h++) {
                            ability = _j[_h];
                            if (!ability.HasChildren()) {
                                continue;
                            }
                            AbilitySpecial = ability.FindKey('AbilitySpecial');
                            if (!AbilitySpecial) {
                                continue;
                            }
                            AbilityValues = ability.CreateChild('AbilityValues', []);
                            for (_k = 0, _l = AbilitySpecial.GetChildren(); _k < _l.length; _k++) {
                                speical = _l[_k];
                                for (_m = 0, _o = speical.GetChildren(); _m < _o.length; _m++) {
                                    kv = _o[_m];
                                    if (kv.Key !== 'var_type') {
                                        AbilityValues.CreateChild(kv.Key, kv.GetValue());
                                    }
                                }
                            }
                            ability.Delete('AbilitySpecial');
                        }
                    }
                    return [4 /*yield*/, items.Save()];
                case 4:
                    _p.sent();
                    return [2 /*return*/];
            }
        });
    });
}
