// =====================================================================
// scr_objetivos - a missão de 10 dias (Sols) e seus objetivos
// =====================================================================
// O motivo da expedição: a NASA quer saber se pessoas podem viver em Marte.
// A tripulação precisa sobreviver 10 Sols, coletar amostras do solo para os cientistas
// e encontrar os elementos que uma colônia precisaria para construir e consertar coisas.
//   tipo "dia"       chegar ao dia alvo
//   tipo "coletado"  total coletado na missão de um material (global.coletado)
//   tipo "maquinas"  todas as máquinas funcionando
// Textos em scr_idioma: obj_<id>.

#macro MISSAO_DIAS 10

global.objetivos = [
    { id: "sobreviver", tipo: "dia",      alvo: MISSAO_DIAS },
    { id: "amostras",   tipo: "coletado", material: "regolito", alvo: 5 },
    { id: "ferro",      tipo: "coletado", material: "ferro",    alvo: 3 },
    { id: "silicio",    tipo: "coletado", material: "silicio",  alvo: 3 },
    { id: "magnesio",   tipo: "coletado", material: "magnesio", alvo: 2 },
    { id: "maquinas",   tipo: "maquinas", alvo: 1 }
];

/// @function objetivo_progresso(objetivo)
/// @description [valor atual, alvo] do objetivo
function objetivo_progresso(_obj) {
    switch (_obj.tipo) {
        case "dia":      return [min(global.dia, _obj.alvo), _obj.alvo];
        case "coletado": return [min(global.coletado[$ _obj.material], _obj.alvo), _obj.alvo];
        case "maquinas":
            var _total = 0, _ok = 0;
            for (var i = 0; i < array_length(global.maquinas); i++) {
                if (!global.maquinas[i].quebravel) continue;
                _total += 1;
                if (!global.maquinas[i].quebrada) _ok += 1;
            }
            return [_ok, max(1, _total)];
    }
    return [0, 1];
}

/// @function objetivo_cumprido(objetivo)
function objetivo_cumprido(_obj) {
    var _p = objetivo_progresso(_obj);
    return _p[0] >= _p[1];
}

/// @function missao_estrelas()
/// @description 0 a 3 estrelas no fim: sobreviver é obrigatório; o resto conta pontos
function missao_estrelas() {
    if (status_zerado() != "") return 0;
    var _ok = 0, _total = 0;
    for (var i = 0; i < array_length(global.objetivos); i++) {
        if (global.objetivos[i].id == "sobreviver") continue;
        _total += 1;
        if (objetivo_cumprido(global.objetivos[i])) _ok += 1;
    }
    if (_ok >= _total) return 3;
    if (_ok >= _total / 2) return 2;
    return 1;
}
