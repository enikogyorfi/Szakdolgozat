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
#set page(numbering: "1")
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
  A függvények egy halmaza által generált $sigma$-algebra a legkisebb $sigma$-algebra, amelyre vonatkozóan ezen függvények mind mérhetők.
] <def_masodik>

#definition[
  @shreve2004 Tegyük fel, hogy adott két valószínűségi mérték $cal(P)$ és $cal(Q)$ ugyanazon mérhető téren $(Omega, cal(F))$. Azt mondjuk, hogy a $cal(Q)$ mérték abszolút folytonos a $cal(P)$-re nézve, ha létezik egy integrálható véletlen változó $f: Omega -> RR$, melyre minden $A in cal(F)$ esetén
  $
    cal(Q)(A) = integral_A f(omega) dif cal(P)(omega)
  $
  teljesül.

  Ekkor $f$ a $cal(Q)$ mérték $cal(P)$-re vonatkozó sűrűségfüggvénye.
] <def_harmadik>

*Megjegyzés.* Ebben az esetben, ha $E^(cal(P))$ és $E^(cal(Q))$ a két mérték szerinti várható értékek, akkor minden $cal(Q)$ szerint integrálható véletlen változóra $X$:
$
  E^(cal(Q))[X] = integral_Omega X dif cal(Q) = integral_Omega X f dif cal(P) = E^(cal(P))[X f].
$

#definition[
 @shreve2004 Legyen $Omega$ egy nemüres halmaz. Legyen $T$ egy rögzített pozitív szám, és tegyük fel, hogy minden $t in [0,T]$ esetén adott egy $cal(F)(t)$ $sigma$-algebra. Tegyük fel továbbá, hogy ha $s <= t$, akkor minden halmaz, amely eleme $cal(F)(s)$-nek, eleme $cal(F)(t)$-nek is. Ekkor a $0 <= t <= T$ paraméterű $cal(F)(t)$ $sigma$-algebrák gyűjteményét filtrációnak nevezzük.
] <def_negyedik>

#definition[
  @shreve2004 Legyen $X$ egy nem üres $Omega$ mintatéren értelmezett valószínűségi változó. Legyen $cal(G)$ az $Omega$ részhalmazainak egy $sigma$-algebrája. Ha a $sigma(X)$ minden halmaza eleme $cal(G)$-nek is, akkor azt mondjuk, hogy $X$ $cal(G)$-mérhető.
] <def_otodik>

== Sztochasztikus folyamatok

#definition[
  @shreve2004 Legyen $(Omega, cal(F), P)$ egy valószínűségi tér és $T$ egy rögzített pozitív szám. Ekkor az
  #box($X = (X_t)_(t in [0,T])$)
  családot sztochasztikus folyamatnak nevezzük, ha minden $t in [0,T]$ esetén $X_t$ egy valószínűségi változó.
] <def_hatodik>

#definition[
  @shreve2004 Legyen $(Omega, cal(F), P)$ egy valószínűségi tér és $(cal(F)(t))_(0 <= t <= T)$ filtráció. Legyen $X(t)$ egy valószínűségi változókból álló család, amelyet $t in [0,T]$ paraméter indexel. Azt mondjuk, hogy ez egy adaptált sztochasztikus folyamat, ha minden $t$-re az $X(t)$ valószínűségi változó $cal(F)(t)$-mérhető.
] <def_hetedik>

#definition[
  @shreve2004 Legyen $(Omega, cal(F), P)$ egy valószínűségi mező, legyen $T$ egy rögzített pozitív szám, és legyen $(cal(F)(t))_(0 <= t <= T)$ a $cal(F)$ $sigma$-algebráinak egy filtrációja. Tekintsünk egy adaptált sztochasztikus folyamatot $M(t)$-t, $0 <= t <= T$.

  (i) Ha $E[M(t) | cal(F)(s)] = M(s)$ minden $0 <= s <= t <= T$ esetén, akkor a folyamatot *martingálnak* nevezzük.

  (ii) Ha $E[M(t) | cal(F)(s)] >= M(s)$ minden $0 <= s <= t <= T$ esetén, akkor a folyamat *szubmartingál*.

  (iii) Ha $E[M(t) | cal(F)(s)] <= M(s)$ minden $0 <= s <= t <= T$ esetén, akkor a folyamat *szupermartingál*.
] <def_nyolcadik>

#definition[
  Egy sztochasztikus folyamat $X = (X_t)_(t >= 0)$ Markov-folyamat, ha minden $0 <= s < t$ és minden Borel-mérhető $f: RR -> RR$ függvény esetén, ahol $E |f(X_t)| < infinity$, teljesül a következő feltétel:
  $
    E[f(X_t) | cal(F)_s] = E[f(X_t) | X_s].
  $
  Ahol $cal(F)_s$ az $X$-folyamat $s$ időpontig ismert információit tartalmazó $sigma$-algebra.
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

Eddig azt vizsgáltuk, hogyan lehet értelmezni egy Brown-mozgásra vonatkozó integrált, és milyen tulajdonságokkal rendelkezik ez az integrál. Most vizsgáljuk meg, hogyan lehet értelmezni egy Brown-mozgás deriváltját. Tekintsük a következő kifejezést:
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
  $
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
A második momentum kiszámításához felhasználjuk:
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
A határvonal a klasszifikációs és regressziós módszerek között azonaban nem mindig éles. A legkisebb négyzetek módszerét mennyiségi meghatározásra használjuk, a logisztikus regressziót pedig kvalitatív meghatározásra, de a KNN algoritmust, a döntési fákat mind a két probléma esetén használhatjuk.

Mindkét probléma esetén fontos vizsgálni a modell teljesítményét, hibáját. A várható hiba egy $x_0$ pontban a következőképpen írható fel:
$
E[(y_0 - hat(f)(x_0))^2] = op("Var")[hat(f)(x_0)] + (E[hat(f)(x_0)] - f(x_0))^2 + op("Var")[epsilon].
$,
ahol $hat(f)(x_0)$ a modell által adott előrejelzés, $f(x_0)$ a valódi értéke, és $epsilon$ a nem csökkenthető hiba. Tehát a várható hiba három összetevőből épül fel: a becslés varianciájából ($op("Var")[hat(f)(x_0)]$), a becslés torzításának négyzetéből ($(E[hat(f)(x_0)] - f(x_0))^2$) és a hibatag varianciájából ($op("Var")[epsilon]$).
Ahhoz, hogy a várható hiba értékét minimalizáljuk, olyan módszert kell választanunk, amely egyszerre biztosít alacsonmy varianciát és alacsony torzítást.
 A variancia azt mutatja meg, hogy a modell előrejelzése mennyire érzékeny a tanító adathalmaz változásaira. Általánosságban elmondható, hogy a komplexebb modellek nagyobb varianciával rendelkeznek. A torzítás pedig abból fakad, hogy a modell nem képes pontosan megragadni a valódi függvény alakját, ez akkor fordulhat elő ha egy bonyolult problémát egy egyszerűbb modellel közelítünk. Például ha a változók közötti kapcsolat erősen nemlineáris, de egy lineáris modellt használunk, akkor a modell torzított lesz.
  Általában a kevésbé komplex modellek nagyobb torzítással rendelkeznek.
  Tehát láthatjuk, hogy a modell komplexitásának növelése csökkenti a torzítást, de növeli a varianciát. Ez az úgynevezett torzítás-variancia kompromisszum.
  

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
placement: top,
gap: 0.5cm,
) <bias_variance_tradeoff>

Az @bias_variance_tradeoff alapján látható, hogy a modell komplexitásának növelésével a torzítás csökken, de a variancia nő. Az ábrán is látható, hogy kezdetben a modell komplexitásának növelésével a torzítás gyorsabban csökken, mint ahogy a variancia nő, így a teljes hiba csökken. Azonban egy bizonyos pont után a variancia növekedése gyorsabb lesz, mint a torzítás csökkenése, így a teljes hiba növekedni kezd.
 Az optimális pont ott van, ahol a teljes hiba minimális. Valós helyzetben, mivel a valódi függvény nem ismert, nem tudjuk explicit módon kiszámolni a torzítást és a varianciát, ezért gyakran keresztvalidációs módszereket alkalmazunk a modell teljesítményének értékelésére.
#v(0.3cm)
Ahhoz, hogy kiértékeljük egy modell teljesítményét, szükségünk van egy mérőszámra, amely megmutatja, hogy a modell mennyire jól teljesít a tanító adathalmazon vagy egy új, ismeretlen adathalmazon. A regressziós problémák esetén a leggyakrabban használt mérőszámok közé tartozik a négyzetes hiba (MSE):
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
 Ezek a módszerek a bementeti változók terét egyszerű, jellemzően téglalap alakú régókra osztják fel, rétegzik azokat. Ha egy új megfigyelést szeretnénk osztályozni vagy a hozzá tartozó értéket előrejelezni, akkor a modell megvizsgálja, hogy a megfigyelés melyik régióba esik, és a régióba eső tanuló adatok között előforduló leggyakoribb osztályt vagy a régióba eső tanuló adatok átlagát használja a predikcióhoz.
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

    node((0, 0), [Időjárás], shape: shapes.diamond, fill: blue.lighten(80%), name: <outlook>, inset: 1em),

    node((-1.5, 1), [Páratartalom], shape: shapes.diamond, fill: blue.lighten(80%), name: <humidity>, inset: 1em),
    node((0, 1.5), [Igen], shape: shapes.pill, fill: green.lighten(80%), name: <yes_overcast>, inset: 1em),
    node((1.5, 1.3), [Szél], shape: shapes.diamond,fill: blue.lighten(80%), name: <wind>, inset: 1em),

    node((-2.5, 2.3), [Nem], shape: shapes.pill, fill: red.lighten(80%), name: <no_high>, inset: 1em),
    node((-1, 2.3), [Igen], shape: shapes.pill, fill: green.lighten(80%), name: <yes_normal>, inset: 1em),
    node((1, 2.3), [Nem], shape: shapes.pill, fill: red.lighten(80%), name: <no_strong>, inset: 1em),
    node((2.6, 2.3), [Igen], shape: shapes.pill, fill: green.lighten(80%), name: <yes_weak>, inset: 1em),


    edge(<outlook>, <humidity>,  [Napos], label-pos: 0.5, "-|>"),
    edge(<outlook>, <yes_overcast>,  [Borult], label-pos: 0.5, "-|>"),
    edge(<outlook>, <wind>,  [Eső], label-pos: 0.5, "-|>"),

    edge(<humidity>, <no_high>,  [Magas], label-pos: 0.5, "-|>"),
    edge(<humidity>, <yes_normal>,  [Normál], label-pos: 0.5, "-|>"),

    edge(<wind>, <no_strong>,  [Erős], label-pos: 0.5, "-|>"),
    edge(<wind>, <yes_weak>,  [Gyenge], label-pos: 0.5, "-|>"),
   

  ),
    caption: [Döntési fa példa],
    gap: 0.5cm,
    )<decision_tree_example>
A @decision_tree_example egy döntési fa példát mutata be: el kell dönteni, hogy egy adott napon játszunk-e a szabadban az időjárás alapján. A döntési fa struktúrája a következő:
 - A gyökércsomópontban az időjárás szerepel, ez a döntési folyamat kiindulópontja. A modell a tanítás során ezt a változót találta a legfontosabbnak, ez bontja fel legjobban az adatokat.
 - Élek: A lehetséges állapotokat jelölik.
- Belső csomópontok: Ha az "időjárás" értéke alapján nem tudunk dönteni, további változókat kell vizsgálnunk. Például, ha az időjárás "Napos", akkor a következő változó, amit megvizsgálunk, a "Páratartalom".
- Levélcsomópontok: Ezek a végső döntéseket jelölik, például ha az időjárás "Napos" és a páratartalom "Magas", akkor a modell azt javasolja, hogy ne játsszunk a szabadban ("Nem").

=== A döntési fák tanítása

A fák építése mind a klasszifikációs, mind a regressziós problémák esetében rekurzív módon történik. A fák építése "mohó" módon történik, felülről lefelé haladva választjuk ki a legjobb vágást, amely az adott pillanatban a legjobban szétválasztja az adatokat. A legjobb vágás kiválasztásához különböző mérőszámokat használunk, ezek a következők lehetnek:
- _Gini-index_: Klasszifikációs problémák esetén használju. Azt méri, hogy mekkora eséllyel osztályoznánk félre egy véletlenszerűen kiválasztott elemet, ha a részhalmaz eloszlása alapján osztályoznánk. Minél kisebb a Gini-index, annál tisztább a részhalmaz.
$
G(m) = sum_(k=1)^K p_(m k) (1 - p_(m k)) = 1 - sum_(k=1)^K p_(m k)^2,
$
ahol $p_(m k)$ a $k$-adik osztályba tartozó elemek aránya a $m$-edik részhalmazban.
- _Entrópia_: Szintén klasszifikációs problémák esetén használjuk.

#pagebreak()
= Irodalomjegyzék

#bibliography("reference.bib", full: true, title:none)
