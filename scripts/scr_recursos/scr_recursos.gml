// =====================================================================
// scr_recursos - estoque de materiais de Marte e análise no laboratório
// =====================================================================
// As expedições trazem materiais de Marte para o estoque da base:
//   poeira    poeira marciana (fininha, entra em tudo)
//   regolito  solo solto de Marte, com pedrinhas: são as amostras que a NASA quer estudar
//   ferro     Fe  - metal (Marte é vermelho por causa da ferrugem!)
//   silicio   Si  - usado em vidro, painéis solares e eletrônicos
//   magnesio  Mg  - metal leve, vem de rochas como a olivina
// Os materiais servem para consertar máquinas quebradas e cumprir os objetivos da missão.
// O laboratório transforma regolito em elementos, com a mesma proporção que o robô
// Curiosity da NASA mediu no solo de Marte (amostra "Rocknest", cratera Gale):
// cerca de 43% sílica (SiO2), 19% óxido de ferro (FeO) e 9% óxido de magnésio (MgO).

global.materiais = ["poeira", "regolito", "ferro", "silicio", "magnesio"];

// Ícone (scr_emocoes) de cada material
global.materiais_icone = {
    poeira: "mat_poeira", regolito: "mat_regolito",
    ferro: "mat_ferro", silicio: "mat_silicio", magnesio: "mat_magnesio"
};

// Composição do solo de Marte medida pelo Curiosity (NASA), em % de óxido
global.solo_marte = { silicio: 43, ferro: 19, magnesio: 9 };
#macro LAB_CUSTO_REGOLITO 1   // regolito gasto no laboratório para dar +1 de escudo

/// @function estoque_iniciar()
/// @description Zera o estoque e os totais coletados na missão (início ou reinício do jogo)
function estoque_iniciar() {
    global.estoque  = { poeira: 0, regolito: 0, ferro: 0, silicio: 0, magnesio: 0 };
    global.coletado = { poeira: 0, regolito: 0, ferro: 0, silicio: 0, magnesio: 0 };  // total da missão
}
estoque_iniciar();

/// @function estoque_adicionar(material, quantidade)
function estoque_adicionar(_mat, _q) {
    if (_q <= 0) return;
    global.estoque[$ _mat]  += _q;
    global.coletado[$ _mat] += _q;
}

/// @function estoque_tem(custo)
/// @description true se o estoque tem tudo do custo, ex.: { ferro: 1, silicio: 1 }
function estoque_tem(_custo) {
    var _nomes = variable_struct_get_names(_custo);
    for (var i = 0; i < array_length(_nomes); i++) {
        if (global.estoque[$ _nomes[i]] < _custo[$ _nomes[i]]) return false;
    }
    return true;
}

/// @function estoque_gastar(custo)
function estoque_gastar(_custo) {
    var _nomes = variable_struct_get_names(_custo);
    for (var i = 0; i < array_length(_nomes); i++) {
        global.estoque[$ _nomes[i]] -= _custo[$ _nomes[i]];
    }
}

/// @function materiais_texto(quantidades)
/// @description "1 Iron  2 Silicon" (só os que têm quantidade)
function materiais_texto(_q) {
    var _txt = "";
    for (var i = 0; i < array_length(global.materiais); i++) {
        var _m = global.materiais[i];
        var _v = _q[$ _m];
        if (!is_numeric(_v) || _v <= 0) continue;
        if (_txt != "") _txt += "  ";
        _txt += string(_v) + " " + tr("mat_" + _m);
    }
    return _txt;
}

/// @function laboratorio_analisar()
/// @description Gasta regolito e devolve o elemento encontrado ("silicio", "ferro" ou "magnesio"),
///   sorteado na proporção real do solo marciano. Devolve "" se não houver regolito suficiente.
function laboratorio_analisar() {
    if (global.estoque.regolito < LAB_CUSTO_REGOLITO) return "";
    global.estoque.regolito -= LAB_CUSTO_REGOLITO;

    var _s = global.solo_marte;
    var _sorteio = random(_s.silicio + _s.ferro + _s.magnesio);
    var _elem = "magnesio";
    if (_sorteio < _s.silicio) _elem = "silicio";
    else if (_sorteio < _s.silicio + _s.ferro) _elem = "ferro";

    estoque_adicionar(_elem, 1);
    // Regolito analisado ainda conta como amostra coletada (global.coletado não diminui)
    return _elem;
}
