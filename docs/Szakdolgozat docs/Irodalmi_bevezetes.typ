
#import "@preview/scribe:0.2.0": *
#import "@preview/mannot:0.3.2": *
#import "@preview/physica:0.9.8": *
#import "@preview/equate:0.3.2": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/theoretic:0.3.1" as theoretic
#import theoretic.presets.colorbox: *
#import "@preview/simple-plot:0.3.0": *
#import "@preview/simple-plot:0.3.0": plot
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes
#import "@preview/cetz:0.3.4": canvas, draw

// this will automatically load predefined styled environments

#show ref: theoretic.show-ref
#show: equate.with(breakable: false, sub-numbering: false)
#set math.equation(numbering: "(1)")
#show: scribe


#let stmt = counter("stmt")
#let def = counter("def")
#let prop = counter("prop")

#let stmt-number() = {
  stmt.step()
  context {
    let h = counter(heading).get()
    let s = stmt.get().last()

    let prefix = h.map(x => str(x)).join(".")
    [#prefix.#s]
  }
}

#let def-number() = {
  def.step()
  context {
    let h = counter(heading).get()
    let s = def.get().last()

    let prefix = h.map(x => str(x)).join(".")
    [#prefix.#s]
  }
}

#let prop-number() = {
  prop.step()
  context {
    let h = counter(heading).get()
    let s = prop.get().last()
    let prefix = h.map(x => str(x)).join(".")
    [#prefix.#s]
  }
}

#show heading.where(level: 2): it => {
  stmt.update(0)
  def.update(0)
  prop.update(0)
  it
}

#show heading.where(level: 3): it => {
  stmt.update(0)
  def.update(0)
  prop.update(0)
  it
}

#set text(lang: "hu", size: 12pt)
#set text(font: "Latin Modern Roman")

#set page("a4")
#set heading(numbering: "1.1")
#show heading.where(level: 1): set block(
  above: 2em, // Térköz a fejezetcím ELŐTT
  below: 1.5em  // Térköz a fejezetcím UTÁN
)
#show heading.where(level: 1): set text(size: 18pt, weight: "bold")
#show heading.where(level: 2): set block(
  above: 2em, // Térköz a fejezetcím ELŐTT
  below: 2em  // Térköz a fejezetcím UTÁN
)
#show heading.where(level: 2): set text(size: 16pt, weight: "bold")
#show heading.where(level: 3): set block(
  above: 2em, // Térköz a fejezetcím ELŐTT
  below: 2em  // Térköz a fejezetcím UTÁN
)
#show heading.where(level: 3): set text(size: 14pt, weight: "bold")

#show figure.caption: it => context [
  #counter(figure).display(). Ábra: #it.body
]

#show ref: it => {
  let el = it.element
  if el != none and el.func() == figure {
    // Lekéri a hivatkozott ábra sorszámát
    let num = counter(figure).at(el.location()).first()
    link(el.location())[#num. Ábra]
  } else {
    it
  }
}
#set par(justify: true)

#let title-text = "BŰNÖZÉSI GYAKORISÁG MODELLEZÉSE"
#let author-text = "Győrfi Enikő"
#let supervisor-text = "Maga Balázs"
#let year-text = "2026"

#set heading(numbering: "1.1.1")
#let definition = definition.with(breakable: false)
#let theorem = theorem.with(breakable: false)
#let proof = proof.with(breakable: false)
#let proposition = proposition.with(breakable: false)

#let orig-definition = theoretic.presets.colorbox.definition.with(
  supplement: "Definíció",
  number: context(def-number()),
  options: (
    color: rgb("#4169e1"),
    icon: "",
  ),
)
#let definition(..args) = block(
  width: 100%,
  breakable: false,
  above: 3em,
  below: 3em,
)[
  #orig-definition(..args)
]

#let orig-theorem = theoretic.presets.colorbox.theorem.with(
  supplement: "Tétel",
  number: context(def-number()),
  options: (
    icon: "",
  ),
)
#let theorem(..args) = block(
  width: 100%,
  breakable: false,
  above: 3em,
  below: 3em,
)[
  #orig-theorem(..args)
]

#let proof = theoretic.presets.colorbox.proof.with(
  supplement: "Bizonyítás",
)
#let proposition = theoretic.presets.colorbox.proposition.with(
  supplement: "Állítás",
  number: context(def-number()),
 options: (
    color: navy,
    icon: "",
  ),
)


#align(center)[
  #text(size: 15pt, weight: "bold")[EÖTVÖS LORÁND TUDOMÁNYEGYETEM] \
  #text(size: 15pt)[Természettudományi Kar]
]

#v(2.5cm)

#align(center)[
  #text(size: 14pt)[#author-text]
]

#v(1.5cm)

#align(center)[
  #text(size: 18pt, weight: "bold")[#title-text] \
  #v(0.5cm) \
  #text(size: 14pt)[
  Szakdolgozat \
  Matematika alapszak
]]

#v(2cm)

#align(center)[
  Témavezető: \
  #supervisor-text
]
#align(center)[
#image("elte_ttk_logo.png", width: 7cm)
]

#align(center)[Budapest, #year-text]

#pagebreak()
#outline(title: [Tartalomjegyzék])
#pagebreak()
#set page(
  footer: context [
    #align(center, counter(page).display("1"))
  ]
)
#counter(page).update(1)
= Bevezetés

= A Sztochasztikus Folyamatok Elméleti Alapjai

== Definíciók és alapfogalmak

#definition[
  Egy valószínűségi tér $(Omega, cal(F), P)$ hármasa tartalmazza:

  - $Omega$ *(eseménytér)*: a lehetséges kimenetelek halmaza.
  - $cal(F)$ *($sigma$-algebra)*: $Omega$ részhalmazainak olyan rendszere, amely tartalmazza az $emptyset$ üres halmazt; komplementerre zárt; és megszámlálható unióra zárt. Az $(Omega, cal(F))$ párost mérhető térnek nevezzük.
  - $P$ *(valószínűségi mérték)*: egy $P: cal(F) -> RR$ függvény, amely kielégíti a $P(emptyset)=0$ és $P(Omega)=1$ feltételeket, és megszámlálható additivitással rendelkezik diszjunkt halmazok esetén.
] <def_elso>

#definition[
  Legyen $X$ egy $Omega$-n értelmezett függvényekből álló halmaz.
  Az $X$ által generált $sigma$-algebra a legkisebb $sigma$-algebra, amelyre vonatkozóan ezen függvények mind mérhetők. Jelölése: $sigma(X)$.
] <def_masodik>

#definition[
  @shreve2004 Tegyük fel, hogy adott két valószínűségi mérték $cal(P)$ és $cal(Q)$ ugyanazon mérhető téren $(Omega, cal(F))$. Azt mondjuk, hogy a $cal(Q)$ mérték abszolút folytonos a $cal(P)$-re nézve, ha létezik egy integrálható véletlen változó $f: Omega -> RR$, melyre minden $A in cal(F)$ esetén
  $
    cal(Q)(A) = integral_A f(omega) dif cal(P)(omega)
  $
  teljesül.

  Ekkor $f$ a $cal(Q)$ mérték $cal(P)$-re vonatkozó sűrűségfüggvénye.
] <def_harmadik>

#box[
*Megjegyzés.* Ebben az esetben, ha $E^(cal(P))$ és $E^(cal(Q))$ a két mérték szerinti várható értékek, akkor minden $cal(Q)$ szerint integrálható véletlen változóra $X$:
$
  E^(cal(Q))[X] = integral_Omega X dif cal(Q) = integral_Omega X f dif cal(P) = E^(cal(P))[X f].
$
]

#definition[
 @shreve2004 Legyen $Omega$ egy nemüres halmaz. Legyen $T$ egy rögzített pozitív szám, és tegyük fel, hogy minden $t in [0,T]$ esetén adott egy $cal(F)(t)$ $sigma$-algebra. Tegyük fel továbbá, hogy ha $s <= t$, akkor minden halmaz, amely eleme $cal(F)(s)$-nek, eleme $cal(F)(t)$-nek is. Ekkor a $0 <= t <= T$ paraméterű $cal(F)(t)$ $sigma$-algebrák gyűjteményét filtrációnak nevezzük.
] <def_negyedik>

#definition[
  @shreve2004 Legyen $X$ egy nem üres $Omega$ mintatéren értelmezett valószínűségi változó. Legyen $cal(G)$ az $Omega$ részhalmazainak egy $sigma$-algebrája. Ha a $sigma(X)$ minden halmaza eleme $cal(G)$-nek is, akkor azt mondjuk, hogy $X$ $cal(G)$-mérhető.
] <def_otodik>

#definition[
  @shreve2004 Legyen $f(t)$ egy $[0,T]$ intervallumon értelmezett függvény. Az $f$ kvadratikus variációját a $[0,T$ intervallumon a következő határértékkel definiáljuk:
$
    [f,f](T) = lim_(||Pi|| -> infinity) sum_(i=0)^(n-1) (f(t_(i+1)) - f(t_i))^2,
$
ahol $Pi = {0 = t_0 < t_1 < dots < t_n = T}$ egy partíciója a $[0,T]$ intervallumnak, és $||Pi|| = max_(0 <= i <= n-1) (t_(i+1) - t_i)$.
]

== Sztochasztikus folyamatok

#definition[
  @shreve2004 Legyen $(Omega, cal(F), P)$ egy valószínűségi tér és $T$ egy rögzített pozitív szám. Ekkor az
  #box($X = (X_t)_(t in [0,T])$)
  családot sztochasztikus folyamatnak nevezzük, ha minden $t in [0,T]$ esetén $X_t$ egy valószínűségi változó.
] <def_hatodik>

#definition[
  @shreve2004 Legyen $(Omega, cal(F), P)$ egy valószínűségi tér és $(cal(F)(t))_(0 <= t <= T)$ filtráció. Legyen $X(t)$ egy valószínűségi változókból álló család, amelyet $t in [0,T]$ paraméter indexel. Azt mondjuk, hogy $X(t)$ egy adaptált sztochasztikus folyamat az $cal(F(t))$-re nézve, ha minden $t$-re az $X(t)$ valószínűségi változó $cal(F)(t)$-mérhető.
] <def_hetedik>

#definition[
  @shreve2004 Legyen $(Omega, cal(F), P)$ egy valószínűségi mező, legyen $T$ egy rögzített pozitív szám, és legyen $(cal(F)(t))_(0 <= t <= T)$ a $cal(F)$ $sigma$-algebráinak egy filtrációja. Tekintsünk egy adaptált sztochasztikus folyamatot $M(t)$-t, $0 <= t <= T$.

  (i) Ha $E[M(t) | cal(F)(s)] = M(s)$ minden $0 <= s <= t <= T$ esetén, akkor a folyamatot *martingálnak* nevezzük.

  (ii) Ha $E[M(t) | cal(F)(s)] >= M(s)$ minden $0 <= s <= t <= T$ esetén, akkor a folyamat *szubmartingál*.

  (iii) Ha $E[M(t) | cal(F)(s)] <= M(s)$ minden $0 <= s <= t <= T$ esetén, akkor a folyamat *szupermartingál*.
] <def_nyolcadik>

#definition[
@shreve2004 Legyen $(Omega, cal(F), P)$ egy valószínűségi mező, legyen $T$ egy rögzített pozitív szám és legyen $(cal(F)(t))_(0 <= t <= T)$ a $cal(F)$ $sigma$-algebráinak egy filtrációja. Az $X(t)_(0 <= t <= T)$ adaptált sztochasztikus folyamatot Markov-folyamatnak nevezzük, ha minden $0 <= s < t <= T$ és minden nemnegatív, Borel-mérhető $f$ függvény esetén létezik egy $g$ Borel-mérhető függvény, amelyre teljesül:
$
E[f(X(t)) | cal(F)(s)] = g(X(s))
$

] <def_kilencedik>

*Megjegyzés.* Tehát a Markov-folyamat jövőbeli állapota csak a jelenlegi állapottól függ, és független a múltbeli állapotoktól. Ebből következik, hogy az együttes valószínűségi sűrűség feltételes formája felírható átmeneti sűrűségek szorzataként:
$
  p(x_n, t_n dots x_2, t_2 | x_1, t_1) = p(x_n, t_n | x_(n-1), t_(n-1)) dots p(x_2, t_2 | x_1, t_1).
$

#definition[
  Egy folytonos Markov-folyamat időben homogén, ha az átmeneti sűrűsége csak az időbeli különbségektől függ:
  $
    p(x,t | y,s) = p(x, t-s | y, 0).
  $
] <def_tizedik>

== Brown-mozgás

#definition[
  @pitera2020 Egy $B = (B_t)_(t >= 0)$ sztochasztikus folyamatot Brown-mozgásnak (vagy Wiener-folyamatnak) nevezünk, ha az alábbi négy tulajdonságnak tesz eleget:

  - A folyamat a $t=0$ időpontban a nullából indul, 1 valószínűséggel, azaz $B_0 = 0$.
  - A folyamat pályái, azaz a $t mapsto B_t (omega)$ leképezések minden egyes $omega$ elemi eseményre, majdnem biztosan folytonosak.
  - Bármely $0 <= s_1 < t_1 <= s_2 < t_2$ időpontsorozatra a $B_(t_1) - B_(s_1)$ és $B_(t_2) - B_(s_2)$ valószínűségi változók függetlenek egymástól.
  - Bármely $s < t$ időpontpárra a $B_t - B_s$ növekmény normális eloszlású, 0 várható értékkel és $t-s$ szórásnégyzettel. Formálisan: $B_t - B_s ~ N(0, t-s)$.
] <def_tizenegyedik>

*Megjegyzés.* A független növekmények tulajdonságából adódóan a Brown-mozgás egy Gauss–Markov-folyamat. Továbbá, mivel az átmeneti sűrűsége csak az időbeli különbségtől függ, egyben időben homogén Markov-folyamat is.

#definition[
  @shreve2004 Legyen $(Omega, cal(A), P)$ egy valószínűségi mező, amelyen a $B(t)$, $t >= 0$ Brown-mozgás definiálva van. A $B(t)$-hez tartozó filtráció egy $cal(F)(t)$ szigma-algebrákból álló család, amelyre a következő feltételek teljesülnek:

  - Az információ halmozódik: $cal(F)(s) subset cal(F)(u)$ minden $0 <= s < u$ esetén, vagyis az idő előrehaladtával az elérhető információ mennyisége nem csökken.
  - Adaptivitás: minden $t >= 0$ esetén a $B(t)$ $cal(F)(t)$-mérhető.
  - A jövőbeli növekmények függetlensége: minden $0 <= s < u$ esetén a $B(u)-B(s)$ növekmény független $cal(F)(s)$-től.
]


#theorem[
  @shreve2004 Legyen $(Omega, cal(A), P)$ egy valószínűségi mező, amelyen a $B(t)$, $t >= 0$ Brown-mozgás definiálva van. Ekkor a következő állítások teljesülnek:

  - $B(t)$ martingál a fenti definícióban definiált filtrációval.
  ]

#proof[
  Elég azt bizonyítani, hogy a $B(t)$ folyamat martingál. Legyen $0 <= s < t$ adott, és tekintsük a következő várható értéket:
  $
    E[B(t) | cal(F)(s)] = E[B(t) - B(s) + B(s) | cal(F)(s)].
  $
  Mivel a Brown-mozgás növekményei függetlenek a múltbeli információtól, ezért
  $
    E[B(t) - B(s) | cal(F)(s)] = E[B(t) - B(s)] = 0.
  $
  Ezenkívül, mivel $B(s)$ már ismert a $cal(F)(s)$-ben, ezért
  $
    E[B(s) | cal(F)(s)] = B(s).
  $
  Ezeket az eredményeket összevonva kapjuk, hogy
  $
    E[B(t) | cal(F)(s)] = 0 + B(s) = B(s).
  $
  Ez pontosan a martingál feltétel, így a $B(t)$ folyamat martingál.
]
#pagebreak()

= Sztochasztikus differenciálegyenletek

== Bevezetés

Egy közönséges differenciálegyenlet az alábbi formában írható fel:
$
  (d x(t))  / (d t)  = f(t, x(t)).
$
ahol $x(t)$ a vizsgált mennyiség időbeli változása, és $f(t, x(t))$ egy determinisztikus függvény, amely meghatározza a rendszer dinamikáját.

Integrál formában és $x(0) = x_0$ kezdeti értékkel ez az egyenlet a következőképpen néz ki:
$
  x(t) = x_0 + integral_0^t f(s, x(s)) dif s.
$

Egy SDE akkor jön létre, ha a differenciálegyenlet egy együtthatója determinisztikus paraméter helyett sztochasztikus paraméterré válik. Például tekintsük a következő KDE-t:
$
  (d x(t)) / (d t) = a(t)x(t).
$
Amennyiben feltesszük, hogy $a(t)$ egy sztochasztikus folyamat, akkor az egyenlet sztochasztikus differenciálegyenletté alakul. Ekkor az $a(t)$ a következő formában írható fel:
$
  a(t) = f(t) + h(t)xi(t),
$
ahol $xi(t)$ egy fehér zaj folyamat.

Ekkor az SDE a következőképpen néz ki:
$
  (d x(t)) / (d t) = (f(t) + h(t)xi(t)) x(t)
$

Legyen $dif B(t) = xi(t) dif t$, ahol $dif B(t)$ a Brown-mozgás differenciálját jelöli, ekkor az SDE differenciál formában a következőképpen írható fel:
$
  dif x(t) = f(t)x(t) dif t + h(t)x(t) dif B(t).
$
Általánosabban egy Itô-típusú sztochasztikus differenciálegyenlet a következő formában írható fel:
$
  dif x(t, omega) = f(t, x(t, omega)) dif t + g(t, x(t, omega)) dif B(t).
$

Egy általános, Itô-típusú SDE a következő szimbolikus formában írható fel:
$
  dif X(t) = mu(t, X(t)) dif t + sigma(t, X(t)) dif B(t).
$
Ez az egyenlet valójában egy integrálegyenlet rövidítése, és két fő részből áll:

- *Drift tag*: a folyamat változásának determinisztikus, előre jelezhető komponense egy infinitezimális $dif t$ időlépés alatt.
- *Diffúziós tag* ($sigma(X_t, t) dif B_t$): ez a sztochasztikus, előre nem látható komponenst képviseli. A hatásának nagyságát a $sigma(X_t, t)$ volatilitás- vagy diffúziós függvény skálázza, amely függhet a rendszer aktuális állapotától és az időtől is. Ez a tag visz véletlenszerűséget a rendszer leírásába.

== Itô-integrál

Amikor a modellezett rendszerben véletlen hatások jelennek meg, a klasszikus integrálfogalom már nem elegendő. Számos alkalmazási területen, például pénzügyi matematikában, fizikai rendszerek leírásában vagy biológiai folyamatok vizsgálatában, a modellek természetes módon vezetnek sztochasztikus folyamatokhoz. A Brown-mozgás pályái 1 valószínűséggel folytonosak, de sehol sem differenciálhatók, így nem rendelkeznek jól definiált deriváltakkal. Emiatt a hagyományos Riemann- vagy Lebesgue-integrál közvetlenül nem alkalmazható olyan kifejezésekre, mint például
$
  integral_0^t X(s) dif B(s).
$

Az ilyen típusú integrálok értelmezéséhez egy új integrálfogalom bevezetése szükséges. Az Itô-integrál lehetővé teszi, hogy Brown-mozgásra vonatkozóan értelmezzük a sztochasztikus integrálokat.

Az előbbi kifejezésben az integrál egyik összetevője egy $B(t)$, $t >= 0$ Brown-mozgás, valamint az ehhez tartozó $cal(F)(t)$, $t >= 0$ filtráció. Az integrandus $X(t)$ egy adaptált sztochasztikus folyamat, amely azt jelenti, hogy minden $t >= 0$ esetén $X(t)$ $cal(F)(t)$-mérhető. Az adaptáltság biztosítja, hogy $X(t)$ értéke csak a $t$ időpontig ismert információtól függ.

#definition[
  @shreve2004 Legyen a $0 = t_0 < t_1 < dots < t_n = T$ egy partíciója a $[0, T]$ intervallumnak, és legyen $Delta(t)$ konstans minden $t in [t_i, t_(i+1))$ intervallumon. Ekkor $Delta(t)$-t elemi folyamatnak nevezzük.
] <def_tizenharmadik>

Ez analóg a Lebesgue-integrál lépcsős függvényeivel, ahol a függvény értéke egy adott intervallumon állandó.

#definition[
  @shreve2004 Egy elemi folyamat Itô-integrálja a következőképpen definiálható:
  $
    I(t) = integral_0^T Delta(s) dif B(s)
      = \
      sum_(j=0)^(n) Delta(t_j) (B(t_(j)) - B(t_(j-1))) + Delta(t_n) (B(T)- B(t_n)). #<equate:revoke>
  $
] <def_tizennegyedik>

#theorem[
  @shreve2004 Legyen $Delta(t)$ egy elemi folyamat, ekkor az Itô-izometria a következőképpen írható fel:
  $
    E[(integral^t Delta(s) dif B(s))^2] = E[integral^t Delta^2(s) dif s].
  $
] <thm_ito_isometry>

Az elemi folyamatok integráljának felhasználásával az Itô-integrál kiterjeszthető általános adaptált sztochasztikus folyamatokra, amelyek kielégítik a megfelelő feltételeket:

- $X(t)$ adaptált a $cal(F)(t)$ filtrációhoz.
- $X(t)$ kvadratikusan integrálható, azaz $integral_0^t E[X^2(s)] dif s < infinity$ minden $t >= 0$ esetén.

Az integrál definiálásához az $X(t)$ folyamatot elemi folyamatokkal közelítjük. Vesszük a $[0,T]$ intervallum egy partícióját: $0 = t_0 < t_1 < dots < t_n = T$, és a $[t_j, t_(j+1)]$ intervallumon a közelítő $Delta(t)$ elemi folyamat értékét az $X(t_j)$ értékére állítjuk. Így a felosztás finomításával az elemi folyamat egyre jobb közelítést ad az $X(t)$ folyamatnak. Választható tehát elemi folyamatok sorozata $Delta_n (t)$ úgy, hogy a következő konvergencia teljesüljön, ha $n -> infinity$:
$
  E integral_0^t abs(X(s) - Delta_n (s))^2 dif s -> 0.
$
Ekkor az Itô-integrál a következőképpen definiálható:
$
  integral_0^t X(s) dif B(s) = lim_(n -> infinity) integral_0^t Delta_n (s) dif B(s), quad 0 <= t <= T.
$
Az integrál tulajdonságait a következő tétel foglalja össze:

#theorem[
  @shreve2004 Legyen $T$ egy pozitív konstans, és legyen $X(t)$, $0 <= t <= T$ egy adaptált sztochasztikus folyamat, amely kielégíti a fentebb írt feltételeket. Ekkor az
  $
    I(t) = integral_0^t X(s) dif B(s)
  $
  folyamat a következő tulajdonságokkal rendelkezik:

  - *Folytonosság:* $I(t)$ pályái folytonosak.
  - *Adaptáltság:* minden $t$-re az $I(t)$ folyamat $cal(F)(t)$-mérhető.
  - *Linearitás:* ha $I(t)=integral_0^t X(s) dif B(s)$ és $J(t)=integral_0^t Y(s) dif B(s)$, akkor #box($I(t)+J(t)=integral_0^t (X(s)+Y(s)) dif B(s)$). Továbbá minden $c$ konstansra #box($I(t)=integral_0^t X(s) dif B(s)$).
  - *Martingál tulajdonság:* az $I(t)$ folyamat martingál.
  - *Itô-izometria:* $E[I^2(t)] = E[integral_0^t X^2(u) dif u]$.
  - *Kvadratikus variáció:* $[I,I](t)=integral_0^t X^2(u) dif u$.
] <thm_ito_integral_properties>

Eddig azt vizsgáltuk, hogyan lehet értelmezni egy Brown-mozgásra vonatkozó integrált, és milyen tulajdonságokkal rendelkezik ez az integrál. Most vizsgáljuk meg, hogyan lehet értelmezni egy Brown-mozgás által meghatározott folyamat megváltozását. Tekintsük a következő kifejezést:
$
  dif / (dif t) f(B(t)).
$
Ez a kifejezés nem értelmezhető a klasszikus analízisben használt láncszabály szerint, mivel a Brown-mozgás pályái sehol sem differenciálhatók. Ennek értelmezéséhez az Itô–Doeblin-formula alkalmazására van szükség, amely egy sztochasztikus változókra vonatkozó általánosított láncszabály.

#theorem[
   @shreve2004 Legyen $f(t,x)$ függvény, melynek parciális deriváltjai $f_t$, $f_x$ és $f_(x x)$ léteznek és folytonosak. Legyen továbbá $B(t)$ egy Brown-mozgás. Ekkor minden $T >= 0$ esetén teljesül a következő egyenlőség:
  $
    f(T, B(T)) = f(0, B(0)) + integral_0^T f_t (t, B(t)) dif t \
    + integral_0^T f_x (t, B(t)) dif B(t) + 1/2 integral_0^T f_(x x)(t, B(t)) dif t.
  #<equate:revoke>
  $
] <thm_ito_doeblin>

Ahhoz, hogy megértsük az Itô–Doeblin-formula jelentőségét, tekintsük a következő példát. Legyen $f(x) = 1/2 x^2$, ekkor $f$ nem függ az időtől, így $f_t = 0$, és a parciális deriváltakak $f_(x) = x$ és $f_(x x) = 1$. Legyen $x_(j-1)$ és $x_j$ két szomszédos pont egy partícióban, és tekintsük a Taylor-sor első két tagját:
$
  f(x_j) - f(x_(j-1)) = f_x (x_(j-1))(x_j - x_(j-1)) + 1/2 f_(x x)(x_(j-1))(x_j - x_(j-1))^2.
$
Továbbá legyen $T > 0$ egy rögzített pozitív szám, és legyen a $[0,T]$ intervallum egy partíciója $cal(P)= {t_0, t_1, dots, t_n}$. Az $f(B(t))$ folyamat változását $0$ és $T$ között a következőképpen írhatjuk fel:
$
  f(B(T)) - f(B(0)) = sum_(j=1)^n f_x(B(t_(j-1)))(B(t_j) - B(t_(j-1))) + \
  1/2 sum_(j=1)^n f_(x x)(B(t_(j-1)))(B(t_j) - B(t_(j-1)))^2.  #<equate:revoke>
$
Ha ebbe behelyettesítjük a parciális deriváltakak értékét, akkor a következő egyenlőséget kapjuk:
$
  f(B(T)) - f(B(0)) = sum_(j=1)^n B(t_(j-1))(B(t_j) - B(t_(j-1))) + \
  1/2 sum_(j=1)^n (B(t_j) - B(t_(j-1)))^2. #<equate:revoke>
$
A partíció finomításával, azaz ha $norm(cal(P)) -> 0$, akkor a következő konvergencia teljesül:
$
  sum_(j=1)^n B(t_(j-1))(B(t_j) - B(t_(j-1))) -> integral_0^T B(t) dif B(t)
$
és
$
  sum_(j=1)^n (B(t_j) - B(t_(j-1)))^2 -> [B,B](T) = T.
$
Ezeket az eredményeket összevonva kapjuk, hogy
$
  f(B(T)) - f(B(0)) = integral_0^T B(t) dif B(t) + 1/2 T.
$
Ez pontosan az Itô–Doeblin-formula egy speciális esete, amelyben a függvény csak a Brown-mozgás értékétől függ, és nem függ az időtől.
\

Eddig az Itô–Doeblin-formulát egy speciális esetre vizsgáltuk, nevezetesen a Brown-mozgásra.Azonban ez a formula általánosítható tetszőleges Itô- folyamatokre is.

#definition[
    @shreve2004 Legyen $B(t)$ egy Brown mozgás és $cal(F)$ a $B(t)$-hez tartozó filtráció. Az $X(t)$ folyamatot Itô-folyamatnak nevezzük, ha felírható a következő alapkban:
$  X(t) = X(0) + integral_0^t mu(s) dif s + integral_0^t sigma(s) dif B(s), $
ahol $mu(s)$ és $sigma(s)$ adaptált sztochasztikus folyamatok, amelyek kielégítik a megfelelő integrálhatósági feltételeket, és $X(0)$ egy adott kezdeti érték.
] <def_tizenotodik>

Tekintsünk egy általános Itô-folyamatot $X(t)$-t, amely kielégíti a következő SDE-t:
$
dif X(t) = mu(t) dif t + sigma(t) dif B(t).
$
Ekkor az Itô–Doeblin-formula kiterjeszthető az $X(t)$ folyamatra is, és a következőképpen írható fel:
#theorem[
  @shreve2004 Legyen $X(t)$ egy Itô-folyamat, amely kielégíti a következő SDE-t:
  $
    dif X(t) = mu(t, X(t)) dif t + sigma(t, X(t)) dif B(t),
  $
 és legyen $f(t,x) in C^2([0,infinity) times RR) $. Ekkor az $Y(t) = f(t, X(t))$ folyamatra teljesül a következő egyenlőség:
$
dif Y(t) = (diff f(t,X(t))) / (diff t) dif t + (diff f(t,X(t))) / (diff x) dif X(t) + 1/2 (diff^2 f(t,X(t))) / (diff x^2) (dif X(t))^2.
$

] <thm_ito_doeblin_general>

A fenti tételben a $(dif X(t))^2$ kifejezés a következőképpen értelmezendő:
$  (dif X(t))^2 = (mu(t, X(t)) dif t + sigma(t, X(t)) dif B(t))^2. $
A következő egyenlőségek teljesülnek:
- $(dif t)^2 = 0$,
- $dif t dif B(t) = 0$,
- $(dif B(t))^2 = dif t$.
Ezeket az eredményeket összevonva kapjuk, hogy
$  (dif X(t))^2 = sigma^2(t, X(t)) dif t. $
Ezt az eredményt visszahelyettesítve a tétel állításába kapjuk, hogy
$  dif Y(t) = (diff f(t,X(t))) / (diff t) dif t + (diff f(t,X(t))) / (diff x) dif X(t) + 1/2 (diff^2 f(t,X(t))) / (diff x^2) sigma^2(t, X(t)) dif t. $

#pagebreak()

== Geometriai Brown-mozgás

A pénzügyi modellezésben és más területeken, ahol a vizsgált mennyiségek (például árak vagy populációk mérete) nem vehetnek fel negatív értéket, és a növekedésük arányos a jelenlegi méretükkel, a leggyakrabban használt modell a geometriai Brown-mozgás (GBM).

#definition[
   @shreve2004 Legyen $B(t)$ Brown-mozgás. Az $S(t)$ folyamatot geometriai Brown-mozgásnak nevezzük, ha kielégíti a következő sztochasztikus differenciálegyenletet:
  $
    dif S(t) = mu S(t) dif t + sigma S(t) dif B(t),
  $
  ahol $mu$ és $sigma$ konstansok. 
] <def_tizenotodik>

A következő tétel megmutatja, hogy a geometriai Brown-mozgás explicit megoldással rendelkezik, amely egy exponenciális függvény formájában írható fel.
#theorem[
  @herzog2013 Legyen $S(t)$ egy geometriai Brown-mozgás, amely kielégíti a következő SDE-t:
  $
    dif S(t) = mu S(t) dif t + sigma S(t) dif B(t),
  $
  ahol $mu$ és $sigma$ konstansok. Ekkor az $S(t)$ folyamat explicit megoldása a következőképpen írható fel:
  $
    S(t) = S(0) exp((mu - 1/2 sigma^2)t + sigma B(t)).
  $ <exp_megoldas>
] <thm_gbm_solution>

#proof[
  Legyen $Y(t) = Phi(t,S(t)) = ln(S(t))$. A parciális deriváltak a következők:
$
(diff Phi(t.S)) / (diff S) = 1/S, quad (diff^2 Phi(t.S)) / (diff S^2) = -1/S^2, quad (diff Phi(t.S)) / (diff t) = 0.
$
Ekkor az Itô–Doeblin-formula alkalmazásával kapjuk, hogy:
$
  dif Y(t) = ((diff Phi(t,S)) / (diff t) + mu S(t) (diff Phi(t,S)) / (diff S) + 1/2 sigma^2 S^2(t) (diff^2 Phi(t,S)) / (diff S^2)) dif t \
  + sigma S(t) (diff Phi(t,S)) / (diff S) dif B(t). #<equate:revoke>
$
\
Ebbe a parciális deriváltak értékét behelyettesítve kapjuk, hogy
$  dif Y(t) = (mu - 1/2 sigma^2) dif t + sigma dif B(t).
$
Integrálva ezt az egyenletet $0$ és $t$ között kapjuk, hogy:
$
  Y(t) = Y_(0) + integral_0^t (mu - 1/2 sigma^2) dif s + integral_0^t sigma dif B ,\
  
  Y(t) = Y_(0) + (mu - 1/2 sigma^2)t + sigma B(t).
$
Visszahelyettesítve $Y(t) = ln(S(t))$, kapjuk az $S(t)$ folyamat explicit megoldását:
$
  ln(S(t)) = ln(S(0)) + (mu - 1/2 sigma^2)t + sigma B(t), \
  
  S(t) = S(0) exp((mu - 1/2 sigma^2)t + sigma B(t)).
$
]
Mivel $ln S(t)$ normális eloszlású, ezért a geometriai Brown.mozgás eloszlásáról a következő állítás tehető:

#proposition[
@herzog2013 A geometriai Brown-mozgás $S(t)$ minden $t > 0$ esetén
lognormális eloszlású.]

#proposition()[
  @herzog2013 Legyen $S(t)$ egy geometriai Brown-mozgás, amely kielégíti a következő SDE-t:
  $
    dif S(t) = mu S(t) dif t + sigma S(t) dif B(t),
  $
  ahol $mu$ és $sigma$ konstansok. Ekkor az $S(t)$ folyamat várható értéke a következőképpen írható fel:
  $
    E[S(t)] = S(0) exp(mu t).
  $
] <lemma_gbm_expectation>

#proof[
  Az $S(t)$ folyamat explicit megoldása a következőképpen írható fel:
  $
    S(t) = S(0) exp((mu - 1/2 sigma^2)t + sigma B(t)).
  $
  Mivel $B(t)$ normális eloszlású, ezért $sigma B(t)$ is normális eloszlású, 0 várható értékkel és $sigma^2 t$ szórásnégyzettel. Ezért a következő egyenlőség teljesül:
  $
    E[exp(sigma B(t))] = exp(1/2 sigma^2 t).
  $
  Ezt az eredményt felhasználva kapjuk, hogy
  $
    E[S(t)] = S(0) exp((mu - 1/2 sigma^2)t) E[exp(sigma B(t))] = S(0) exp(mu t).
  $
]

#proposition[
   @herzog2013 Legyen $S(t)$ egy geometriai Brown-mozgás, amely kielégíti a következő SDE-t:
  $
    dif S(t) = mu S(t) dif t + sigma S(t) dif B(t),
  $
  ahol $mu$ és $sigma$ konstansok. Ekkor az $S(t)$ folyamat varianciája a következőképpen írható fel:
  $
    op("Var")[S(t)] = S^2(0) exp(2 mu t)(exp(sigma^2 t) - 1).
  $
] <prop_gbm_variance>

#proof[
A második momentum kiszámításához felhasználjuk a @exp_megoldas[]. egyenlet szerinti $S(t)$ explicit megoldást:
$  S^2(t) = S^2(0) exp(2(mu - 1/2 sigma^2)t + 2 sigma B(t)).
$
Ekkor:
$
    E[S^2(t)] = S^2(0) exp(2(mu - 1/2 sigma^2)t) E[exp(2 sigma B(t))].
$
Mivel $2 sigma B(t)$ normális eloszlású, 0 várható értékkel és $4 sigma^2 t$ szórásnégyzettel, ezért
$  E[exp(2 sigma B(t))] = exp(2 sigma^2 t).
$
Ezt felhasználva kapjuk, hogy
$  E[S^2(t)] = S^2(0) exp(2(mu - 1/2 sigma^2)t) E[exp(2 sigma B(t))] =
 \
 S^2(0) exp(2 mu t + sigma^2 t). #<equate:revoke>
$
A variancia definíciója szerint:
$
op("Var")[S(t)] = E[S^2(t)] - (E[S(t)])^2 = \
 S^2(0) exp(2 mu t + sigma^2 t) - (S(0) exp(mu t))^2 = #<equate:revoke>
 \  
 S^2(0) exp(2 mu t)(exp(sigma^2 t) - 1).
 #<equate:revoke>
$
]


#pagebreak()
= A gépi tanulás elméleti háttere

A gépi tanulás fontos szerepet játszik a tudomány, a gazdaság és a technológia számos területén. Például az orvostudományban a gépi tanulás segíthet a betegségek korai felismerésében és betegségekkel járó kockázatok azonosításában. A pénzügyi szektorban a gépi tanulás alkalmazható a kockázatkezelésben, a csalásfelderítésben és a kereskedési stratégiák optimalizálásában.
\
A gépi tanulás lehetővé teszi a nagy adathalmazok elemzését és a mintázatok felismerését ezért bűnügyi adatok elemzésére is használható, például a bűnözési mintázatik felismerésére és  bűnügyi előrejelzések készítésére.

== A gépi tanulás alapjai

A gépi tanulás algoritmusait három fő csoportba sorolhatjuk:
- Felügyelt tanulás: ahol a modell egy címkézett adathalmazon tanul, azaz minden bemeneti adathoz (X) tartozik egy kimeneti címke (y). A modell célja, egy olyan függvény megtanulása. amely képes egy új, ismeretlen bemeneti adat (X) alapján helyesen megjósolni a hozzá tartozó kimeneti címkét (y).
- Felügyelet nélküli tanulás: ahol a modell egy címkézetlen adathalmazon tanul, azaz csak bemeneti adatok (X) állnak rendelkezésre, de nincs hozzájuk tartozó kimeneti címke (y). A modell célja, hogy feltárja az adat szerkezetét, megtalálja a rejtett mintázatokat.
- Megerősítéses tanulás: ahol a modell egy környezetben tanul, és a tanulási folyamat során visszajelzést kap a környezettől, amely alapján maximalizálni igyekszik egy célfüggvényt.

A szakdolgozat keretein belül elsősorban a felügyelt tanulás alapjaival foglalkozunk, különös tekintettel a regressziós problémákra, ahol a cél egy folytonos kimeneti érték előrejelzése.
\
A felügyelt tanulás esetén formálisan a következőképpen tekinthetünk az adatra:
$
D = {(x_1, y_1), (x_2, y_2), dots, (x_n, y_n)}.
$
ahol $x_i in RR$ a bemeneti változókat tartalmazó vektor és $y_i in RR$ a hozzá tartozó célváltozó értéke.
A statisztikai tanulási modell áltanos alakja a következőképpen írható fel:
$
Y = f(X) + epsilon,
$
ahol $f$ az ismeretlen függvény, amit becsülni szeretnénk, míg $epsilon$ egy véletlen zaj, amely a modell hibáját reprezentálja és függelen a bemeneti változóktól. Továbbá feltételezzük, hogy $E[epsilon] = 0$.

#box([
Két fő kérdésre keresünk választ a gépi tanulás során:
- Egy új bemeneti adat (x) esetén mennyi lesz a célváltozó (y) értéke?\
  Ez a predikciós kérdés. Ebben az esetben a függvény úgynevezett "fekete doboz" modellként működik, ahol nem a függvény pontos alakja a lényeg, hanem a predikciós teljesítménye. Az előrejelzés pontossága két hibatényezőtől függ, egy csökkenthető hibától, amely a függvény becslésének pontosságából adódik, és egy nem csökkenthető hibától, amely egy felső korlátot szab az előrejelzés pontosságának.
- Hogyan befolyásolja a bemeneti változó (X) értéke a célváltozó (Y) értékét?\
  Ez a magyarázó kérdés.Vizsgálhatjuk, hogy a bemeneti változók közül melyik az néhány legfontosabb, amely a legnagyobb hatással van a célváltozó értékére.
  Ilyenkor a függvény pontos alakja is fontos, nem viselkedhet "fekete doboz" modellként. 

])

#v(0.3cm)
A változóknak két fő típusát különböztetjük meg, lehetnek kvalitatív (minőségi) vagy kvantitatív (mennyiségi) változók. A kvalitatív változók kategóriákba, osztályokba sorolhatóak, például a nem, a szín vagy a márka. Ezzel szemben a kvantitatív változók számszerű értékeket vesznek fel, ilyen például a magasság, a súly vagy az ár. A célváltozó típusa alapján a gépi tanulási problémák lehetnek klasszifikációs vagy regressziós problémák.  Klasszifikáció esetén a célváltozó kvalitatív, és a modell célja, hogy egy adott bemeneti adat alapján megállapítsa a hozzá tartozó kategóriát. Regresszió esetén a célváltozó kvantitatív, és a modell célja, hogy egy adott bemeneti adat alapján megjósolja a hozzá tartozó számértéket.
A határvonal a klasszifikációs és regressziós módszerek között azonaban nem mindig éles. A legkisebb négyzetek módszerét mennyiségi meghatározásra használjuk, a logisztikus regressziót pedig kvalitatív meghatározásra, de a KNN (K-Nearest Neighbors) algoritmust, a döntési fákat mind a két probléma esetén használhatjuk.

Mindkét probléma esetén fontos vizsgálni a modell teljesítményét, hibáját. A várható hiba egy $x_0$ pontban a következőképpen írható fel:
$
E[(y_0 - hat(f)(x_0))^2] = E[(f(x_0) + epsilon - hat(f)(x_0))^2] = #<equate:revoke>
\
E[(f(x_0) - hat(f)(x_0))^2 + epsilon^2 + 2 (f(x_0) - hat(f)(x_0)) epsilon]=
#<equate:revoke>\
E[(f(x_0) - hat(f)(x_0))^2] + E[epsilon^2] + 2 E[(f(x_0) - hat(f)(x_0)) epsilon]= 
\
E[(f(x_0) - hat(f)(x_0))^2] + op("Var")[epsilon] + 2 E[epsilon] E[f(x_0)-hat(f)(x_0)]= #<equate:revoke> \
E[(f(x_0)- E[hat(f)(x_0)] + E[hat(f)(x_0)] - hat(f)(x_0))^2] + op("Var")[epsilon] = #<equate:revoke>\
E[(f(x_0) - E[hat(f)(x_0)])^2] + E[(E[hat(f)(x_0)] - hat(f)(x_0))^2] + op("Var")[epsilon] = #<equate:revoke> \
 (E[hat(f)(x_0)] - f(x_0))^2 +op("Var")[hat(f)(x_0)]+ op("Var")[epsilon]
  #<equate:revoke> \
$
ahol $hat(f)(x_0)$ a modell által adott előrejelzés, $f(x_0)$ a valódi értéke, és $epsilon$ a nem csökkenthető hiba. Tehát a várható hiba három összetevőből épül fel: a becslés varianciájából ($op("Var")[hat(f)(x_0)]$), a becslés torzításának négyzetéből ($(E[hat(f)(x_0)] - f(x_0))^2$) és a hibatag varianciájából ($op("Var")[epsilon]$).

Ahhoz, hogy a várható hiba értékét minimalizáljuk, olyan módszert kell választanunk, amely egyszerre biztosít alacsonmy varianciát és alacsony torzítást.
 A variancia azt mutatja meg, hogy a modell előrejelzése mennyire érzékeny a tanító adathalmaz változásaira. Általánosságban elmondható, hogy a komplexebb modellek nagyobb varianciával rendelkeznek. A torzítás pedig abból fakad, hogy a modell nem képes pontosan megragadni a valódi függvény alakját, ez akkor fordulhat elő ha egy bonyolult problémát egy egyszerűbb modellel közelítünk. Például ha a változók közötti kapcsolat erősen nemlineáris, de egy lineáris modellt használunk, akkor a modell torzított lesz.
  Általában a kevésbé komplex modellek nagyobb torzítással rendelkeznek.
  Tehát láthatjuk, hogy a modell komplexitásának növelése csökkenti a torzítást, de növeli a varianciát. Ez az úgynevezett torzítás-variancia kompromisszum (bias-variance tradeoff).
  

#show: lq.set-diagram(width: 12cm, height: 8cm)
#show lq.selector(lq.title): set align(center)
#let x = lq.linspace(0, 10)
#show: lq.set-diagram(
  xaxis: (format-ticks: none),
  yaxis: (format-ticks: none)
)
#show: lq.set-diagram(
  xaxis: (mirror: false),
  yaxis: (mirror: false),
)


#figure(
  lq.diagram(
    xlabel: "Model komplexitása",
    xaxis: (ticks: none),
    yaxis: (ticks: none),
    legend: (position: right, dy: 4em),
    lq.plot(x, x => 8 * calc.exp(-0.4 * x) + 0.5,label: "Torzítás", stroke:(thickness: 2pt), mark:none),
    lq.plot(x, x => 0.12 * calc.pow(x - 1, 2) + 0.3, label: "Variancia", stroke:(thickness: 2pt), mark:none),
    lq.plot(x, x => 8 * calc.exp(-0.4 * x) + 0.5 + 0.12 * calc.pow(x - 1, 2) + 0.3, label: "Hiba", stroke:(thickness: 2pt), mark:none),
    lq.plot((3.86, 3.86), (0, 10), stroke: (dash: "dashed", paint: green, thickness: 1pt), mark:none),
    lq.scatter((3.86,), (3.49,), mark: "o", label: "Optimum pont"),
),
caption: [Torzítás-variancia kompromisszum illusztrációja],

gap: 0.5cm,
) <bias_variance_tradeoff>

Az @bias_variance_tradeoff alapján látható, hogy a modell komplexitásának növelésével a torzítás csökken, de a variancia nő. Az ábrán is látható, hogy kezdetben a modell komplexitásának növelésével a torzítás gyorsabban csökken, mint ahogy a variancia nő, így a teljes hiba csökken. Azonban egy bizonyos pont után a variancia növekedése gyorsabb lesz, mint a torzítás csökkenése, így a teljes hiba növekedni kezd.
 Az optimális pont ott van, ahol a teljes hiba minimális. Valós helyzetben, mivel a valódi függvény nem ismert, nem tudjuk explicit módon kiszámolni a torzítást és a varianciát, ezért gyakran keresztvalidációs módszereket alkalmazunk a modell teljesítményének értékelésére.
#v(0.3cm)
Ahhoz, hogy kiértékeljük egy modell teljesítményét, szükségünk van egy mérőszámra, amely megmutatja, hogy a modell mennyire jól teljesít a tanító adathalmazon vagy egy új, ismeretlen adathalmazon. A regressziós problémák esetén a leggyakrabban használt mérőszámok közé tartozik az átlagos négyzetes hiba (MSE):
$
op("MSE") = sum_(i=1)^n (y_i - hat(f)(x_i))^2 / n
$

ahol $y_i$ a valódi érték, $hat(f)(x_i)$ a modell által adott előrejelzés, és $n$ a minta mérete. Minél kisebb az MSE értéke, annál jobb a modell teljesítménye. Ezt az értéket a tanító adatra tudjuk kiszámolni, de a modell választásánál az új, ismeretlen adatokon való teljesítmény a fontosabb. Mivel a tanító adaton való teljesítmény nem feltétlenül tükrözi az új adatokon való teljesítményt, nem választhatjuk a legkisebb MSE-vel rendelkező módszert. Sőt, ha a tanító adaton túl jól teljesít egy módszer, akkor fennáll a veszélye annak, hogy a modell túltanult (overfitting), vagyis a modell nemcsak a valódi mintázatot tanulta meg, hanem a tanító adathalmaz zaját is, így az új adatokon való teljesítménye gyenge lesz.
\

Tehát ebben az esetben is fennáll a torzítás-variancia kompromisszum esetéhez hasonló összefüggés: a modell komplexitásának növelésével a tanító adaton az MSE monoton csökken, azonban a teszt adaton az MSE egy bizonyos pont után növekedni kezd, mivel a modell túltanul. (@overfitting)

#show: lq.set-diagram(width: 12cm, height: 8cm)
#show: lq.set-diagram(
  xaxis: (format-ticks: none),
  yaxis: (format-ticks: none)
)
#show: lq.set-diagram(
  xaxis: (mirror: false),
  yaxis: (mirror: false),
)


#figure(
  lq.diagram(
    xlabel: "Model komplexitása",
    ylabel: "Hiba",
    xaxis: (ticks: none),
    yaxis: (ticks: none),
    legend: (position: right, dy: 4em),
    lq.plot(x, x => 8 * calc.exp(-0.4 * x) + 0.5, label: "Tanító adat MSE", stroke:(thickness: 2pt), mark:none),
    lq.plot(x, x => 8 * calc.exp(-0.4 * x) + 0.5 + 0.12 * calc.pow(x - 1, 2) + 0.3, label: "Teszt adat MSE", stroke:(thickness: 2pt), mark:none),
    lq.plot((3.86, 3.86), (0, 10), stroke: (dash: "dashed", paint: green, thickness: 1pt), mark:none),
    lq.scatter((3.86,), (3.49,), mark: "o", label: "Optimum pont"),
),
caption: [\Túlillesztés illusztrációja],
gap: 0.5cm,
) <overfitting>

A gyakorlatban a tanító adaton az MSE értékét meg tudjuk határozni, de a teszt adaton az MSE értékét nem, mivel a teszt adaton a valódi értékek nem ismertek. A minimumpont meghatározására a gyakorlatban az egyik legelterjedtebb módszer a keresztvalidáció, amely során a tanító adatot több részre osztjuk, és a modell teljesítményét ezekre a részekre értékeljük. Ez lehetővé teszi, hogy becslést kapjunk a modell új adatokon való teljesítményére, és segítséget nyújt a megfelelő modell komplexitásának kiválasztásában.

#pagebreak()

== Döntési fák

A fa-alapú módszerek egy jelentős és széles körben használt osztálya a gépi tanulási algoritmusoknak. Ezek a módszerek könnyen értelmezhető modelleket hoznak létre, amelyek jól teljesítenek mind klasszifikációs, mind regressziós problémák esetén.
 Ezek a módszerek a bementeti változók terét egyszerű, jellemzően tégla alakú régókra osztják fel, rétegzik azokat. Ha egy új megfigyelést szeretnénk osztályozni vagy a hozzá tartozó értéket előrejelezni, akkor a modell megvizsgálja, hogy a megfigyelés melyik régióba esik, és a régióba eső tanuló adatok között előforduló leggyakoribb osztályt vagy a régióba eső tanuló adatok átlagát használja a predikcióhoz.
A modell struktúrája:
- Gyökércsomópont: A legfelső szint, ami a teljes adatot reprezentálja.
- Belső csomópontok: Egy-egy bemeneti változó (feature) alapján végzett döntést reprezentálnak, amelyek az adatot két vagy több részre osztják.
- Élek: A tesztek eredményét reprezentálják, amelyek a bemeneti változó értékétől függően vezetnek a következő csomóponthoz.
- Levélcsomópontok: Az osztályokat vagy a regressziós értékeket reprezentálják, amelyek a modell végső döntését adják meg.
 
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes
#figure(
  diagram(
    node-stroke: 1pt + black,
    edge-stroke: 1pt + black,

    node((0, 0), [Elhelyezkedés], shape: shapes.diamond, fill: blue.lighten(80%), name: <outlook>, inset: 1em),

    node((-1.5, 1), [Méret], shape: shapes.diamond, fill: blue.lighten(80%), name: <humidity>, inset: 1em),
    node((0, 1.5), [58], shape: shapes.pill, fill: rgb("#fff2cc"), name: <yes_overcast>, inset: 1em),
    node((1.5, 1.3), [Állapot], shape: shapes.diamond,fill: blue.lighten(80%), name: <wind>, inset: 1em),

    node((-2.5, 2.3), [65], shape: shapes.pill, fill: green.lighten(80%), name: <no_high>, inset: 1em),
    node((-1, 2.3), [95], shape: shapes.pill, fill: blue.lighten(80%), name: <yes_normal>, inset: 1em),
    node((1, 2.3), [40], shape: shapes.pill, fill: red.lighten(80%), name: <no_strong>, inset: 1em),
    node((2.6, 2.3), [70], shape: shapes.pill, fill: rgb("#d9d2e9"), name: <yes_weak>, inset: 1em),


    edge(<outlook>, <humidity>,  [Belváros], label-pos: 0.5, "-|>"),
    edge(<outlook>, <yes_overcast>,  [Külváros], label-pos: 0.5, "-|>"),
    edge(<outlook>, <wind>,  [Vidék], label-pos: 0.5, "-|>"),

    edge(<humidity>, <no_high>,  [Kicsi], label-pos: 0.5, "-|>"),
    edge(<humidity>, <yes_normal>,  [Nagy], label-pos: 0.5, "-|>"),

    edge(<wind>, <no_strong>,  [Rossz], label-pos: 0.5, "-|>"),
    edge(<wind>, <yes_weak>,  [Jó], label-pos: 0.5, "-|>"),
   

  ),
    caption: [Döntési fa példa],
    gap: 0.5cm,
    )<decision_tree_example>
A @decision_tree_example egy döntési fa példáját mutatja be: lakások árát becsüli meg különböző jellemzők alapján. A döntési fa struktúrája a következő:
 - A gyökércsomópontban az elhelyezkedés szerepel, ez a döntési folyamat kiindulópontja. A modell a tanítás során ezt a változót találta a legfontosabbnak, ez bontja fel legjobban az adatokat.
 - Élek: A lehetséges állapotokat jelölik.
- Belső csomópontok: Ha az "elhelyezkedés" értéke alapján nem tudunk dönteni, további változókat kell vizsgálnunk. Például, ha a lakás a belvárosban helyezkedik el, akkor a következő változó, amit megvizsgálunk, a "Méret".
- Levélcsomópontok: Ezek a végső döntéseket jelölik, például ha a lakás a belvárosban helyezkedi el és a mérete "Nagy", akkor a modell szerint a lakás ára 95 millió forint.

#figure(
  canvas({
    import draw: *

    let x0 = 0
    let x1 = 4
    let x2 = 8
    let x3 = 12

    let y0 = 0
    let y1 = 3
    let y2 = 6
    let y3 = 9

    // Külső keret
    rect((x0, y0), (x3, y3), stroke: 1pt + black)

    // Régiók
    // Belváros + kicsi -> 65
    rect((x0, y0), (x1, y1), fill: rgb("#d9ead3"), stroke: 0.8pt + black)

    // Belváros + nagy -> 95
    rect((x1, y0), (x3, y1), fill: rgb("#cfe2f3"), stroke: 0.8pt + black)

    // Külváros -> 58
    rect((x0, y1), (x3, y2), fill: rgb("#fff2cc"), stroke: 0.8pt + black)

    // Vidék + rossz -> 40
    rect((x0, y2), (x2, y3), fill: rgb("#f4cccc"), stroke: 0.8pt + black)

    // Vidék + jó -> 70
    rect((x2, y2), (x3, y3), fill: rgb("#d9d2e9"), stroke: 0.8pt + black)

    // Osztóvonalak
    line((x0, y1), (x3, y1), stroke: 1pt + black)
    line((x0, y2), (x3, y2), stroke: 1pt + black)

    // Belváros sávon belüli vágás: Méret
    line((x1, y0), (x1, y1), stroke: 1pt + black)

    // Vidék sávon belüli vágás: Állapot
    line((x2, y2), (x2, y3), stroke: 1pt + black)

    // Tengelyek
    line((x0, y0), (x3 + 1, y0), mark: (end: ">"), stroke: 1pt + black)
    line((x0, y0), (x0, y3 + 1), mark: (end: ">"), stroke: 1pt + black)

    // Tengelyfeliratok
    content((x3 + 1.1, y0 - 0.5), [Másodlagos változó])
    content((x0 - 0.2, y3 + 1.1), [Elhelyezkedés])

    // Y-tengely kategóriacímkék
    content((x0 - 1.2, 1.5), [Belváros])
    content((x0 - 1.1, 4.5), [Külváros])
    content((x0 - 0.7, 7.5), [Vidék])

    // X-tengely szakaszcímkék
    content((2, y0 - 0.6), [kicsi / rossz])
    content((8, y0 - 0.6), [nagy / jó])

    // Csomópont-logika jelzése
    content((4.48, y1 - 0.2), [Méret szerinti bontás Belvárosban])
    content((8, y2 + 0.25), [Állapot szerinti bontás Vidéken])

    // Régióértékek
    content((2, 1.5), [*65*])
    content((8, 1.5), [*95*])
    content((6, 4.5), [*58*])
    content((4, 7.5), [*40*])
    content((10, 7.5), [*70*])

  }),
  caption: [A bemeneti tér régiókra bontása a regressziós döntési fa szerint.],
  gap: 0.5cm
) <dontesi_fa_regio>

A @dontesi_fa_regio a regressziós döntési fa által létrehozott régiókat szemlélteti. Minden színezett tartomány egy levélcsomópontnak felel meg, és az ott szereplő szám az adott régióhoz rendelt becsült célérték. 
#pagebreak()

=== A döntési fák tanítása

A fák építése mind a klasszifikációs, mind a regressziós problémák esetében rekurzív módon történik. A fák építése "mohó" módon történik, felülről lefelé haladva választjuk ki a legjobb vágást, amely az adott pillanatban a legjobban szétválasztja az adatokat. A legjobb vágás kiválasztásához különböző mérőszámokat használunk, ezek a következők lehetnek:
- _Gini-index_: Klasszifikációs problémák esetén használju. Azt méri, hogy mekkora eséllyel osztályoznánk félre egy véletlenszerűen kiválasztott elemet, ha a részhalmaz eloszlása alapján osztályoznánk. Minél kisebb a Gini-index, annál tisztább a részhalmaz.
$
G(m) = sum_(k=1)^K p_(m k) (1 - p_(m k)) = 1 - sum_(k=1)^K p_(m k)^2,
$
ahol $p_(m k)$ a $k$-adik osztályba tartozó elemek aránya a $m$-edik részhalmazban.
- _Entrópia_: Szintén klasszifikációs problémák esetén használjuk. Azt méri, hogy mekkora információt nyerünk egy adott vágással. Minél nagyobb az entrópia csökkenése, annál jobb a vágás.
$
H(m) = - sum_(k=1)^K p_(m k) log(p_(m k)),
$
ahol $p_(m k)$ a $k$-adik osztályba tartozó elemek aránya a $m$-edik részhalmazban.
- _Négyzetes hiba_: Regressziós problémák esetén használjuk. Azt mérjük, hogy a vágás utáni részhalmazban mekkora az a tényleges válaszértékek és a részhalmaz átlaga közötti eltérések negyzetösszege. Minél kisebb ez az érték, annál jobb a vágás.
$
op("MSE(m)") = 1/n_m sum_(i=1)^m (y_i - hat(y)_m)^2,
$
ahol $n_m$ a $m$-edik részhalmazban lévő elemek száma, $y_i$ a tényleges válaszérték, és $hat(y)_m$ a részhalmaz átlaga.

A döntési fák esetén ügyelni kell arra, hogy a fa ne nőjön túl mélyre, mert ez túltanuláshoz vezethet. Erre megoldás lehet a fa vágása (pruning). Kétfő vágási módszert alkalmaznak a gyakorlatban:
- _Előmetszés (prepruning)_: A fa építése során már a vágás kiválasztásánál figyelembe vesszük a vágás utáni részhalmazok méretét, és csak akkor hajtjuk végre a vágást, ha a részhalmazok mérete egy bizonyos küszöbérték fölött van.
- _Utólagos metszés (postpruning)_: Először egy teljes fát építünk, majd utólagosan, alulról felfelé haladva metszük vissza a fát.

== Ensemble módszerek

Az ensemble módszerek használata során több gyenge modellt kombinálunk egy erősebb modell lérehozásához. Két fő típusát különböztetjük meg:
- _Bagging_: A bagging során a tanító adatból bootstrap (visszatevéses mintavétellel) több új adathalmazt hounk létre, majd mindegyiket tanítunk egy gyenge modellt (példáil egy metszés nélküli döntési fát). Majd egyesítjük a modellek előrejelzéseit, klasszifikáció esetén többségi szavazással, regresszió esetén pedig átlagolással. Mivel egy mély fának alacsony a torzítása, de magas a varianciája, ezért a bagging segítségével csökkenthetjük a varianciát anélkül, hogy a torzítást növelnénk.
- _Boosting_: Míg a bagging egymástól függetlenül, párhuzamosan épít fákat, addig a boosting során szekvenciálisan építjük a fákat. Minden új fa a korábbi fák információit használja fel és a a korábbi fák által helytelenül osztályzott vagy előrejelzett megfigyelésekre helyezi a hangsúlyt, azaz ezeket a megfigyeléseket nagyobb súllyal veszi figyelembe a tanítás során. 


=== Random Forest

Ensemble módszer, amely a bagging elvén alapul és nagyszámú, egymástól független döntési fát épít. A módszer regressziós és klasszifikációs problémák esetén is használható. A Random Forest során minden egyes fa építésekor a változók egy véletlenszerű részhalmazát választjuk ki, és csak ezek közül választjuk ki a legjobb vágást. (@random_forest)

#let dt-icon(label) = align(center, {
  diagram(
    spacing: 0.65em,
    node-stroke: none,
    edge-stroke: 0.8pt + black,

    node((0, 0), [], shape: shapes.circle, fill: black, name: <r>, width: 3.5pt, height: 3.5pt),
    node((-0.7, 0.7), [], shape: shapes.circle, fill: black, name: <l1>, width: 3.5pt, height: 3.5pt),
    node((0.7, 0.7), [], shape: shapes.circle, fill: black, name: <r1>, width: 3.5pt, height: 3.5pt),

    node((-1, 1.4), [], shape: shapes.circle, fill: black, name: <l2>, width: 3pt, height: 3.5pt),
    node((-0.4, 1.4), [], shape: shapes.circle, fill: black, name: <r2>, width: 3pt, height: 3.5pt),
    node((1, 1.4), [], shape: shapes.circle, fill: black, name: <r3>, width: 3pt, height: 3.5pt),

    edge(<r>, <l1>, "-"),
    edge(<r>, <r1>, "-"),
    edge(<l1>, <l2>, "-"),
    edge(<l1>, <r2>, "-"),
    edge(<r1>, <r3>, "-"),
  )
  text(size: 10pt, weight: "bold")[#label]
})

#figure(
diagram(
  spacing: 2em,
  node-stroke: 0.7pt + black,
  edge-stroke: 0.7pt + black,


  node((-2, 0), text(size: 12pt, style: "italic")[Tanító\ Adat], stroke: none),
  node((-1, 0), [D], shape: shapes.cylinder, fill: blue.lighten(90%), name: <D>),
  node((0, 0), text(size:12pt)[Bagging /\ Randomizáció], shape: shapes.hexagon, fill: yellow.lighten(90%), name: <random>),

  edge(<D>, <random>, "->"),

  // A szétágazási pont
  node((0, 0.6), [], stroke: none, fill: none, name: <split>),
  edge(<random>, <split>, "-"),

  // Dataset nodes
  node((-3.5, 1), text(size: 12pt, style: "italic")[Bootstrap\ Minták], stroke: none),
  node((-2.2, 1), [$D_1$], shape: shapes.cylinder, fill: blue.lighten(90%), name: <D1>),
  node((-0.7, 1), [$D_2$], shape: shapes.cylinder, fill: blue.lighten(90%), name: <D2>),
  node((0.4,1 ), text(size:18pt)[...], stroke: none, name: <dots-d>),
  node((2.3, 1), [$D_t$], shape: shapes.cylinder, fill: blue.lighten(90%), name: <D3>),

  // Élek a szétágazástól a Dataset-ekig
  edge(<split>, <D1>, "->", corner-radius: 0.4em),
  edge(<split>, <D2>, "->", corner-radius: 0.4em),
  edge(<split>, <D3>, "->", corner-radius: 0.4em),

  // Modell (fa) nodes
  node((-3.5, 2.4), text(size: 12pt, style: "italic")[Modellek], stroke: none),
  node((-2.2, 2.4), dt-icon($T_1$), shape: shapes.hexagon, fill: green.lighten(90%), name: <T1>, width: 4em, height: 3.6em),
  node((-0.7, 2.4), dt-icon($T_2$), shape: shapes.hexagon, fill: green.lighten(90%), name: <T2> , width: 4em, height: 3.6em),
  node((0.4, 2.4), text(size:18pt)[...], stroke: none, name: <dots-t>),
  node((2.3, 2.4), dt-icon($T_t$), shape: shapes.hexagon, fill: green.lighten(90%), name: <T3> , width: 3.8em, height: 3.6em),

  // Dataset -> Modell élek
  edge(<D1>, <T1>, "->"),
  edge(<D2>, <T2>, "->"),
  edge(<D3>, <T3>, "->"),

  // Aggregation/Majority vote rész
  node((-3.5, 4), text(size: 12pt, style: "italic")[Aggregáció], stroke: none),
  node((0.1, 4), text(size: 12pt)[Többségi szavazás /\ Átlag], shape: shapes.hexagon, fill: orange.lighten(90%), name: <vote>, width: 10em, height: 2.4em),

  edge(<T1>, <vote>, "->", corner-radius: 0.4em),
  edge(<T2>, <vote>, "->", corner-radius: 0.4em),
  edge(<T3>, <vote>, "->", corner-radius: 0.4em),

  node((0.1, 5), text(size: 12pt)[Osztályozás /\ Előrejelzés], shape: shapes.hexagon, fill: orange.lighten(90%),  name: <pred>, width: 7em, height: 2.8em),
  edge(<vote>, <pred>, "->"),
),
caption: [Random Forest módszer vázlatos ábrája],
gap: 0.5cm,
)<random_forest>

Minden fát a lehető legnagyobbra növesztünk, azaz metszés nélkül építjük. A bagging esetében előfordulhat, hogyha van egy nagyon erős változó, akkor a tanított fák közül sok ezt az erős változót fogja választani a legelső vágáshoz, így a fák hasonlóak lesznek egymáshoz, nem lesznek függetlenek, így a variancia csökkentése sem lesz olyan hatékony. A Random Forest esetében viszon csak csak egy véletlen $m$ elemű részhalmazt választunk a $p$ változoból, így a vágások $(p-m)/(p)$ arányában a legerősebb változó nem lesz kiválasztva, így a fák nagyobb mértékben lesznek különbözőekés és függetlenek, így a variancia csökkentése is hatékonyabb lesz.
A modell hiperparaméterei közé tartozik a minimális csomópontok száma és a változókból kiválasztott részhalmaz mérete. Az m paraméter értékét gyakran a gyakorlatban $sqrt(p)$-re (klasszifikációs problémák esetén) vagy $p/3$-ra (regressziós problémák esetén) állítják be, de ez a probléma jellegétől függően változhat. A minimális csomópontok számát klasszifikációs problémák esetén gyakran 1-re, regressziós problémák esetén pedig 5-re állítják be, de ez is a probléma jellegétől függően változhat. A Random Forest módszer nagy előnye, hogy nem érzékeny a fák számára, így általában a nagy számú fa építése nem vezet túltanuláshoz, ahogy egyre több fát adunk a modellhez, a hibaartás csökken, és egy bizonyos pont után stabilizálódik.
\
Random Forest esetén, mivel minden fa egy bootstrap mintán tanul, a tanító adathalmaz körülbelül egyharmada minden fa esetében kimarad a tanításból, ezeket a kimaradt pontokat nevezzük out-of-bag (OOB) pontoknak. Ezt felhasználva a modell teljesítményét is értékelhetjük, anélkül, hogy külön teszt adathalmazt kellene fenntartanunk. A hibabecsléshez minden egyes megfigyelés esetén kiszámoljuk a fák előrejelzését, amelyek nem tanultak az adott megfigyelésen (azaz azok a fák, amelyeknél az adott megfigyelés OOB pont), majd ezeket az előrejelzéseket átlagoljuk (regresszió esetén) vagy többségi szavazással egyesítjük (klasszifikáció esetén), és összehasonlítjuk a valódi értékekkel.
A hagyományos döntési fákkal szemben a Random Forest kevésbé átlátható, de többféle mutatóval is értékelhetjük a változók fontosságát, például a csomópontok tisztaságának növekedése alapján, vagy az OOB hibabecslés alapján, amely megmutatja, hogy egy adott változó kizárása hogyan befolyásolja a modell teljesítményét.

 
== Idősorok elemzése

Idősornak tekinthetünk minden olyan adatot, amelyet időpontokhoz renelünk és a megfigyelések között időbeli függés van, például a bűnügyi statisztikák is jellemzően idősorok.
Az idősorok elemzése olyan módszereket foglal magában, amelyekkel az adatokból mintázatokat, trendeket lehet felismerni, valamint előrejelzéseket kézíthetünk.
 Az idősorok elemzésének két fő célja van: a múltbeli adatok megértése és a jövőbeli értékek előrejelzése.
Az idősorok egyik legfontosabb jellemzője, hogy az egymást követő megfigelések nem függetlenek. Ez a függőség lehet rövid távú, amikor a közelmúlt megfigyelései befolyásolják a jövőbeli értékeket, vagy hosszútávú, amikor trendek vagy szezonális mintázatok figyelhetők meg az adatokban. Akkor beszélhetünk trendről, ha az adatokban hosszú távú növekedés vagy csökkenés figyelhető meg, míg szezonális mintázat esetében az adatsort valamilyen ismétlődő ciklus jellemzi, például éves, havi vagy heti szinten.
Ezek alapján az idősorok több, egymástól független komponensből állhatnak, tehát egy $Y_t$ idősor felírható a következőképpen:

$
Y_t = f(S_t, T_t, epsilon_t)
$
ahol $S_t$ a szezonális komponens, $T_t$ a trendkomponens, és $epsilon_t$ a maradéktag.
\
=== Alapfogalmak

#definition[
Egy idősor kovarianciája a következőképpen definiálható:
$
op("Cov")(X_t, X_(t+k)) = E[(X_t - E[X_t])(X_(t+k) - E[X_(t+k)])],
$
ahol $X_t$ az idősor $t$-edik megfigyelése, $E[X_t]$ az idősor $t$-edik megfigyelésének várható értéke, és $k$ a késleltetés (lag) értéke.
]

#definition[
Egy idősor autokovarianciája a következőképpen definiálható:
$gamma(h) = op("Cov")(X_t, X_(t+h)),
$
ahol $X_t$ az idősor $t$-edik megfigyelése, és $h$ a késleltetés (lag) értéke.
]

#definition[
Egy idősor autokorrelációja a következőképpen definiálható:
$rho(h) = gamma(h) / gamma(0),
$
]

#definition[
Egy idősor gyengén stacionáris, ha teljesül az alábbi három feltétel:
1. Az idősor várható értéke időben állandó, azaz $E[X_t] = \mu$ minden $t$-re.
2. $E[X_t^2] < infinity$ minden $t$-re.
3. Két megfigyelés közötti kovariancia csak a köztük lévő időkülönbségtől ($h$) függ és nem a konkrét $t$ időponttól, azaz $op("Cov")(X_t, X_(t+h)) = gamma(h)$.]

#definition[
Egy idősor erősen stacionáris, ha minden $h$ és minden $t_1, t_2,...,t_n$ esetén teljesül, hogy $(X_t_1, X_t_2, ..., X_t_n)$ és $(X_(t_1+h), X_(t_2+h), ..., X_(t_n+h))$ azonos eloszlásúak.
]
A (gyenge) stacionaritás fonto sfogalom az idősorelemzésben, mivel a legtöbb klasszikus idősorelemzési módszer feltételezi, hogy az idősor (gyengén)stacionáris. A stacionaritás azt jelenti, hogy az idősor statisztikai tulajdonságai időben állandóak, így a múltbeli adatok alapján megbízhatóan előrejelezhetjük a jövőbeli értékeket.

=== Klasszikus idősorelemzési módszerek

A klasszikus idősorelemzési módszereket két nagy csoportra oszhatjuk: determinisztikus és sztochasztikus módszerekre. A determinisztikus módszerek a trendek és szezonális mintázatok modellezésére fókuszálnak, míg a sztochasztikus módszerek a véletlenszerű komponensek modellezésére helyezik a hangsúlyt.

==== Determinisztikus és simításos módszerek

==== Sztochasztikus módszerek

=== ML és DL módszerek idősorok elemzésére

== Metrikák és értékelési módszerek


#pagebreak()
= Irodalomjegyzék

#bibliography("reference.bib", full: true, title:none)
