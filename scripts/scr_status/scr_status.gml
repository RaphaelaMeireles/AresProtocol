// =====================================================================
// scr_status - status globais do jogo
// =====================================================================
// O código solto no topo de um script roda uma única vez, quando o jogo abre,
// antes da primeira room e de qualquer objeto. Assim estas variáveis já existem
// quando os objetos são criados, sem depender da ordem de criação.
// status_iniciar() também é chamado ao jogar de novo (jogo_reiniciar).

// Um evento da noite nunca tira mais que isto de um mesmo status
#macro STATUS_PERDA_MAX 2
#macro STATUS_INICIAL   3   // vida, energia e comida começam o dia 1 com 3 de 5

/// @function status_iniciar()
function status_iniciar() {
    // --- Raios: ações do jogador no dia (os ícones de raio do HUD) ---
    // Cada ação (máquinas, expedição) gasta raios. Quando acabam, o dia termina.
    // Na troca de dia voltam ao máximo.
    global.raios_max = 5;
    global.raios = global.raios_max;

    // --- Status da base: as barras da camada Status (sVida, sEnergia, sComida) ---
    // Vão de 0 a 5; cada ponto é um segmento da barra. Os eventos da noite gastam esses status
    // e as máquinas recuperam. Eles NÃO voltam sozinhos na troca de dia.
    global.vida_max = 5;              // saúde da tripulação
    global.vida = STATUS_INICIAL;

    global.energia_max = 5;           // eletricidade da base (painéis solares e reatores)
    global.energia = STATUS_INICIAL;

    global.comida_max = 5;            // comida da estufa e do estoque
    global.comida = STATUS_INICIAL;

    global.escudo_max = 5;            // escudo contra radiação (barra sEscudo)
    global.escudo = STATUS_INICIAL;   // protege a vida da tripulação nos eventos de radiação

    global.expedicao_bloqueada_ate = 0;   // dia até quando a porta fica fechada (imprevisto do airlock)
    global.expedicao_enviada_dia = -99;
    global.destinos_dia = -1;             // os lugares da expedição são sorteados de novo
    global.destinos_ontem = [];   // dia em que alguém saiu em expedição (imprevisto no dia seguinte)

    // Dia atual da missão (Sol)
    global.dia = 1;

    // true = o jogador não interage com o posto nem com a câmera
    // (janela aberta ou troca de dia acontecendo). Controlado pelo oDia.
    global.ui_bloqueada = true;

    // Fim da missão: "" = jogando, "vitoria" ou "derrota" (oObjetivos mostra a tela final)
    global.fim_missao = "";

    // Motivo da derrota ("vida", "energia", "comida" ou "escudo"), mostrado na tela final
    global.motivo_derrota = "";

    // Clima de Marte de cada dia, já sorteado (ver clima_do_dia em scr_eventos)
    global.clima_dias = {};
}
status_iniciar();

/// @function status_zerado()
/// @description Nome do primeiro status que chegou a zero ("" se nenhum). Qualquer um em zero é derrota.
function status_zerado() {
    var _nomes = ["vida", "energia", "comida", "escudo"];
    for (var i = 0; i < array_length(_nomes); i++) {
        if (variable_global_get(_nomes[i]) <= 0) return _nomes[i];
    }
    return "";
}

/// @function jogo_reiniciar()
/// @description Jogar de novo: zera status, estoque, colônia e ambiente e recomeça a room
function jogo_reiniciar() {
    status_iniciar();
    estoque_iniciar();
    colonia_iniciar();
    room_restart();
}
