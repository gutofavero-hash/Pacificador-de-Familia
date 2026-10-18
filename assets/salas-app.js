/* Salas de debate · código compartilhado entre salas.html, sala.html e curadoria.html.
   Depende de config.js e da biblioteca supabase-js (carregada antes deste arquivo). */
(function () {
  "use strict";

  var CFG = window.PACIFICADOR_CONFIG || {};
  var configurado = !!(CFG.supabaseUrl && CFG.supabaseAnonKey && window.supabase);

  // Fluxo "implicit": o link mágico funciona mesmo se o e-mail for aberto em outro navegador ou app.
  var sb = configurado ? window.supabase.createClient(CFG.supabaseUrl, CFG.supabaseAnonKey, {
    auth: { flowType: "implicit", persistSession: true, detectSessionInUrl: true }
  }) : null;

  var ESTADOS = {
    proposta: "Proposta", em_validacao: "Em validação", aberta: "Aberta", no_conselho: "No Conselho",
    em_revisao: "Em revisão", publicada: "Sentença publicada", em_debate: "Em debate",
    arquivada: "Arquivada", recusada: "Não cabe no Conselho"
  };
  var ETAPAS = ["aberta", "no_conselho", "em_revisao", "publicada", "em_debate", "arquivada"];
  var ESFERAS = {
    municipal: "Municipal", estadual: "Estadual", federal: "Federal",
    internacional: "Internacional", varias: "Várias esferas", nao_sei: "Esfera a definir"
  };
  var REACOES = [
    { k: "aprendi", e: "💡", t: "Aprendi algo" },
    { k: "mudei", e: "🔄", t: "Mudei de ideia em algo" },
    { k: "reconheco", e: "🤝", t: "Reconheço um acerto do outro lado" },
    { k: "mais_dados", e: "🔍", t: "Quero mais dados" },
    { k: "discordo", e: "⚖️", t: "Discordo, e sei explicar por quê" }
  ];
  // Regra 1 das Regras da Mesa: rótulos desqualificadores, de qualquer lado.
  var ROTULOS = ["genocida", "fascista", "nazista", "comunista", "gado", "petralha", "bolsominion", "esquerdopata",
    "isentão", "isentao", "mortadela", "coxinha", "golpista", "terrorista", "vagabundo", "ladrão", "ladrao",
    "lacrador", "minion", "esquerdalha", "direitalha", "comuna", "bolsonarista burro", "petista burro"];

  /* ---------- utilidades de DOM ---------- */
  function el(tag, attrs, kids) {
    var n = document.createElement(tag);
    if (attrs) Object.keys(attrs).forEach(function (k) {
      var v = attrs[k];
      if (v == null || v === false) return;
      if (k === "text") n.textContent = v;
      else if (k === "class") n.className = v;
      else if (k.slice(0, 2) === "on") n.addEventListener(k.slice(2), v);
      else n.setAttribute(k, v === true ? "" : v);
    });
    (kids || []).forEach(function (c) { if (c != null) n.appendChild(typeof c === "string" ? document.createTextNode(c) : c); });
    return n;
  }
  function limpar(n) { while (n.firstChild) n.removeChild(n.firstChild); return n; }
  function toast(msg) {
    var t = el("div", { class: "toast", role: "status", text: msg });
    document.body.appendChild(t);
    setTimeout(function () { t.remove(); }, 3800);
  }
  function copiar(txt, okMsg) {
    try {
      navigator.clipboard.writeText(txt).then(function () { toast(okMsg || "Copiado."); },
        function () { prompt2(txt); });
    } catch (e) { prompt2(txt); }
  }
  function prompt2(txt) {
    var ta = el("textarea", { readonly: true }); ta.value = txt;
    modal("Copie o texto", [ta, el("p", { class: "small", text: "Selecione e use a opção Copiar do seu aparelho." })]);
    ta.select();
  }
  function modal(titulo, corpo, acoes) {
    var ov = el("div", { class: "overlay", role: "dialog", "aria-modal": "true", "aria-label": titulo });
    var fechar = function () { ov.remove(); document.removeEventListener("keydown", esc); };
    var esc = function (e) { if (e.key === "Escape") fechar(); };
    var box = el("div", { class: "modal" }, [el("h2", { text: titulo })].concat(corpo));
    var row = el("div", { class: "row" });
    (acoes || [{ t: "Fechar" }]).forEach(function (a) {
      row.appendChild(el("button", { type: "button", class: "btn" + (a.primary ? " primary" : "") + (a.danger ? " danger" : ""), text: a.t,
        onclick: function () { if (!a.fn || a.fn() !== false) fechar(); } }));
    });
    box.appendChild(row);
    ov.appendChild(box);
    ov.addEventListener("click", function (e) { if (e.target === ov) fechar(); });
    document.addEventListener("keydown", esc);
    document.body.appendChild(ov);
    var foco = box.querySelector("input,textarea,select,button");
    if (foco) foco.focus();
    return { fechar: fechar, box: box };
  }
  function dataBR(iso) { try { return new Date(iso).toLocaleDateString("pt-BR"); } catch (e) { return ""; } }
  function chipEstado(e) { return el("span", { class: "chip " + e, text: ESTADOS[e] || e }); }
  function rotulosEm(txt) {
    var t = " " + (txt || "").toLowerCase() + " ";
    return ROTULOS.filter(function (r) { return t.indexOf(r) > -1; });
  }
  function param(nome) { return new URLSearchParams(location.search).get(nome); }
  function urlAtual() { return location.href.split("#")[0]; }

  /* ---------- sessão e perfil ---------- */
  var estado = { sessao: null, perfil: null, curador: false, ouvintes: [] };

  function aoMudar(fn) { estado.ouvintes.push(fn); }
  function avisar() { estado.ouvintes.forEach(function (fn) { try { fn(estado); } catch (e) { console.error(e); } }); }

  async function carregarPerfil() {
    estado.perfil = null; estado.curador = false;
    if (!estado.sessao) return;
    var r = await sb.from("perfis").select("id, apelido, papel, criado_em").eq("id", estado.sessao.user.id).maybeSingle();
    estado.perfil = r.data || null;
    estado.curador = !!(estado.perfil && (estado.perfil.papel === "curador" || estado.perfil.papel === "admin"));
  }

  async function iniciar() {
    if (!configurado) { avisar(); return; }
    var s = await sb.auth.getSession();
    estado.sessao = s.data.session;
    await carregarPerfil();
    if (estado.sessao && !estado.perfil) pedirConsentimento();
    avisar();
    sb.auth.onAuthStateChange(async function (ev, sessao) {
      if (ev === "TOKEN_REFRESHED") return;
      estado.sessao = sessao;
      await carregarPerfil();
      if (sessao && !estado.perfil) pedirConsentimento();
      avisar();
    });
  }

  function entrar() {
    var email = el("input", { type: "email", id: "loginEmail", autocomplete: "email", placeholder: "seu@email.com" });
    var msg = el("p", { class: "small", "aria-live": "polite" });
    var m = modal("Entrar nas salas", [
      el("p", { text: "Sem senha: escolha entrar com a conta Google ou receber um link de acesso no seu e-mail." }),
      el("button", { type: "button", class: "btn google", onclick: function () {
        sb.auth.signInWithOAuth({ provider: "google", options: { redirectTo: urlAtual() } });
      } }, [el("span", { "aria-hidden": "true", text: "G" }), "Entrar com Google"]),
      el("label", { class: "f" }, ["Ou receba um link no e-mail", email]),
      el("button", { type: "button", class: "btn primary", onclick: async function (ev) {
        var v = (email.value || "").trim();
        if (!/^\S+@\S+\.\S+$/.test(v)) { msg.textContent = "Digite um e-mail válido."; return; }
        ev.target.disabled = true; msg.textContent = "Enviando…";
        var r = await sb.auth.signInWithOtp({ email: v, options: { emailRedirectTo: urlAtual() } });
        ev.target.disabled = false;
        msg.textContent = r.error ? "Não foi possível enviar agora: " + r.error.message + ". Tente de novo em alguns minutos."
          : "Pronto. Abra o e-mail que enviamos para " + v + " e toque no link. Confira também a caixa de spam.";
      } }, ["Enviar link de acesso"]),
      msg,
      el("p", { class: "small" }, ["Ao entrar, você verá a ", el("a", { href: "privacidade.html", text: "Política de Privacidade" }), " e as Regras da Mesa antes de participar."])
    ], [{ t: "Cancelar" }]);
    return m;
  }

  function pedirConsentimento() {
    if (document.getElementById("consentApelido")) return;
    var ap = el("input", { type: "text", id: "consentApelido", maxlength: "40", placeholder: "Ex.: Tia Marta, Rafa, Leitor do Sul" });
    var c1 = el("input", { type: "checkbox", id: "consentLgpd" });
    var c2 = el("input", { type: "checkbox", id: "consentRegras" });
    var msg = el("p", { class: "warnline", "aria-live": "polite" });
    modal("Antes de sentar à mesa", [
      el("label", { class: "f" }, ["Como quer ser chamado nas salas?",
        el("span", { class: "hint", text: "Use um apelido. Não precisa ser seu nome completo." }), ap]),
      el("label", { class: "check" }, [c1, el("span", {}, ["Li a ", el("a", { href: "privacidade.html", target: "_blank", rel: "noopener", text: "Política de Privacidade" }),
        " e autorizo o tratamento dos meus dados, inclusive o registro das salas em que me inscrevo e das minhas reações, que podem revelar opinião política (dado sensível, LGPD art. 11)."])]),
      el("label", { class: "check" }, [c2, el("span", {}, ["Li as ", el("a", { href: "DECLARACAO_UNIVERSAL_DO_PACIFICADOR.html#regras", target: "_blank", rel: "noopener", text: "Regras da Mesa" }),
        " e assumo o compromisso: começar pelo entendimento, sem rótulos, sem \"o outro lado também\", e com abertura para reconhecer acertos do outro lado."])]),
      msg
    ], [
      { t: "Agora não", fn: function () { sb.auth.signOut(); } },
      { t: "Entrar na mesa", primary: true, fn: function () {
        var a = (ap.value || "").trim();
        if (a.length < 2) { msg.textContent = "Escolha um apelido com pelo menos 2 letras."; return false; }
        if (rotulosEm(a).length) { msg.textContent = "Escolha um apelido sem rótulos."; return false; }
        if (!c1.checked || !c2.checked) { msg.textContent = "Para participar, é preciso aceitar os dois itens."; return false; }
        var agora = new Date().toISOString();
        sb.from("perfis").insert({ id: estado.sessao.user.id, apelido: a, consentimento_em: agora, regras_aceitas_em: agora })
          .then(async function (r) {
            if (r.error) { toast("Não foi possível salvar: " + r.error.message); return; }
            await carregarPerfil(); avisar(); toast("Bem-vindo à mesa, " + a + ".");
          });
      } }
    ]);
  }

  function minhaConta() {
    var ap = el("input", { type: "text", id: "contaApelido", maxlength: "40" }); ap.value = estado.perfil ? estado.perfil.apelido : "";
    var mot = el("textarea", { id: "contaMotivacao", placeholder: "Por que você quer ajudar como curador? (mínimo 20 caracteres)" });
    var cand = el("div", { class: "small", text: "Carregando…" });
    var m = modal("Minha conta", [
      el("label", { class: "f" }, ["Apelido", ap]),
      el("button", { type: "button", class: "btn small", onclick: async function () {
        var a = (ap.value || "").trim();
        if (a.length < 2 || rotulosEm(a).length) { toast("Apelido inválido."); return; }
        var r = await sb.from("perfis").update({ apelido: a }).eq("id", estado.sessao.user.id);
        if (r.error) toast(r.error.message); else { await carregarPerfil(); avisar(); toast("Apelido atualizado."); }
      } }, ["Salvar apelido"]),
      el("h3", { text: "Quero ser curador" }),
      cand,
      el("h3", { text: "Seus dados" }),
      el("p", { class: "small" }, ["Apagar a conta remove seu login, apelido, inscrições, reações e candidatura. Temas que você propôs continuam, sem autor. Veja a ",
        el("a", { href: "privacidade.html", text: "Política de Privacidade" }), "."]),
      el("button", { type: "button", class: "btn small danger", onclick: function () {
        modal("Apagar sua conta?", [el("p", { text: "Isso não pode ser desfeito." })], [
          { t: "Cancelar" },
          { t: "Apagar definitivamente", danger: true, fn: function () {
            sb.rpc("apagar_minha_conta").then(function (r) {
              if (r.error) { toast(r.error.message); return; }
              sb.auth.signOut(); toast("Conta apagada."); m.fechar();
            });
          } }
        ]);
      } }, ["Apagar minha conta"])
    ], [{ t: "Sair da conta", fn: function () { sb.auth.signOut(); } }, { t: "Fechar", primary: true }]);
    if (estado.curador) { cand.textContent = "Você já faz parte da curadoria."; return; }
    sb.from("candidaturas_curador").select("estado, criado_em").maybeSingle().then(function (r) {
      limpar(cand);
      if (r.data) { cand.textContent = "Sua candidatura está: " + r.data.estado + " (enviada em " + dataBR(r.data.criado_em) + ")."; return; }
      cand.appendChild(el("div", { class: "form" }, [mot, el("button", { type: "button", class: "btn small", onclick: async function () {
        var t = (mot.value || "").trim();
        if (t.length < 20) { toast("Escreva pelo menos 20 caracteres."); return; }
        var r2 = await sb.from("candidaturas_curador").insert({ user_id: estado.sessao.user.id, motivacao: t });
        if (r2.error) toast(r2.error.message); else { toast("Candidatura enviada."); limpar(cand).textContent = "Candidatura enviada. Um administrador vai avaliar."; }
      } }, ["Enviar candidatura"])]));
    });
  }

  /* ---------- cabeçalho comum ---------- */
  function cabecalho(paginaAtual) {
    var slot = el("div", { class: "auth-slot" });
    var links = [["salas.html", "Salas"], ["DECLARACAO_UNIVERSAL_DO_PACIFICADOR.html", "Declaração"], ["MOTOR_DO_CONSELHO.html", "Motor do Conselho"]];
    var nav = el("nav", { class: "nav", "aria-label": "Navegação" }, links.map(function (l) {
      return el("a", { href: l[0], text: l[1], "aria-current": l[0] === paginaAtual ? "page" : null });
    }));
    var curLink = el("a", { href: "curadoria.html", text: "Curadoria", hidden: true, "aria-current": paginaAtual === "curadoria.html" ? "page" : null });
    nav.appendChild(curLink);
    var top = el("header", { class: "topbar" }, [el("a", { class: "brand", href: "salas.html", text: "O Pacificador de Famílias" }), nav, slot]);
    aoMudar(function (s) {
      limpar(slot);
      curLink.hidden = !s.curador;
      if (!configurado) return;
      if (!s.sessao) slot.appendChild(el("button", { type: "button", class: "btn small primary", onclick: entrar, text: "Entrar" }));
      else slot.appendChild(el("button", { type: "button", class: "btn small", onclick: s.perfil ? minhaConta : pedirConsentimento,
        text: s.perfil ? s.perfil.apelido : "Completar cadastro" }));
    });
    return top;
  }

  function avisoConfiguracao() {
    return el("div", { class: "notice", role: "note", hidden: configurado }, [
      el("strong", { text: "As salas estão sendo preparadas. " }),
      "Em breve você poderá propor temas, se inscrever e reagir às Sentenças por aqui."
    ]);
  }

  /* ---------- Sentenças publicadas (índice gerado pelo modelos/gerar_sentenca.py) ---------- */
  var _indice = null;
  function indiceSentencas() {
    if (_indice) return _indice;
    _indice = fetch("sentencas/indice.json", { cache: "no-cache" }).then(function (r) { return r.ok ? r.json() : []; })
      .then(function (j) { return Array.isArray(j) ? j : (j.sentencas || []); }).catch(function () { return []; });
    return _indice;
  }
  function sentencaDaSala(lista, sala) {
    return lista.filter(function (s) { return (sala.sentenca_base && s.base === sala.sentenca_base) || (s.sala && s.sala === sala.slug); })[0] || null;
  }

  window.Pacificador = {
    sb: sb, configurado: configurado, estado: estado, iniciar: iniciar, aoMudar: aoMudar, entrar: entrar,
    pedirConsentimento: pedirConsentimento, cabecalho: cabecalho, avisoConfiguracao: avisoConfiguracao,
    el: el, limpar: limpar, toast: toast, copiar: copiar, modal: modal, dataBR: dataBR, chipEstado: chipEstado,
    rotulosEm: rotulosEm, param: param, ESTADOS: ESTADOS, ETAPAS: ETAPAS, ESFERAS: ESFERAS, REACOES: REACOES,
    indiceSentencas: indiceSentencas, sentencaDaSala: sentencaDaSala,
    SITE: "https://gutofavero-hash.github.io/Pacificador-de-Familia/"
  };
})();
