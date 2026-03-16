#import "@preview/scribe:0.2.0": *
#import "@preview/mannot:0.3.2": *
#import "@preview/physica:0.9.8": *
#import "@preview/equate:0.3.2": *
#import "@preview/rich-counters:0.2.1": *
#import "@preview/theoretic:0.3.1" as theoretic
#import theoretic.presets.colorbox: *
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
  number: context(stmt-number()),
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
  number: context(prop-number()),
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

#v(4cm)

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
  Egy $B = (B_t)_(t >= 0)$ sztochasztikus folyamatot Brown-mozgásnak (vagy Wiener-folyamatnak) nevezünk, ha az alábbi négy tulajdonságnak tesz eleget:

  - A folyamat a $t=0$ időpontban a nullából indul, 1 valószínűséggel, azaz $B_0 = 0$.
  - A folyamat pályái, azaz a $t mapsto B_t (omega)$ leképezések minden egyes $omega$ elemi eseményre, majdnem biztosan folytonosak.
  - Bármely $0 <= s_1 < t_1 <= s_2 < t_2$ időpontsorozatra a $B_(t_1) - B_(s_1)$ és $B_(t_2) - B_(s_2)$ valószínűségi változók függetlenek egymástól.
  - Bármely $s < t$ időpontpárra a $B_t - B_s$ növekmény normális eloszlású, 0 várható értékkel és $t-s$ szórásnégyzettel. Formálisan: $B_t - B_s ~ N(0, t-s)$.
] <def_tizenegyedik>

*Megjegyzés.* A független növekmények tulajdonságából adódóan a Brown-mozgás egy Gauss–Markov-folyamat. Továbbá, mivel az átmeneti sűrűsége csak az időbeli különbségtől függ, egyben időben homogén Markov-folyamat is.

#definition[
  Legyen $(Omega, cal(A), P)$ egy valószínűségi mező, amelyen a $B(t)$, $t >= 0$ Brown-mozgás definiálva van. A $B(t)$-hez tartozó filtráció egy $cal(F)(t)$ szigma-algebrákból álló család, amelyre a következő feltételek teljesülnek:

  - Az információ halmozódik: $cal(F)(s) subset cal(F)(u)$ minden $0 <= s < u$ esetén, vagyis az idő előrehaladtával az elérhető információ mennyisége nem csökken.
  - Adaptivitás: minden $t >= 0$ esetén a $B(t)$ $cal(F)(t)$-mérhető.
  - A jövőbeli növekmények függetlensége: minden $0 <= s < u$ esetén a $B(u)-B(s)$ növekmény független $cal(F)(s)$-től.
]


#theorem[
  Legyen $(Omega, cal(A), P)$ egy valószínűségi mező, amelyen a $B(t)$, $t >= 0$ Brown-mozgás definiálva van. Ekkor a következő állítások teljesülnek:

  - $B(t)$ martingál.
  - $B(t)$ filtrációja a definiált filtráció.
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
  Legyen a $0 = t_0 < t_1 < dots < t_n = T$ egy partíciója a $[0, T]$ intervallumnak, és legyen $Delta(t)$ konstans minden $t in [t_i, t_(i+1))$ intervallumon. Ekkor $Delta(t)$-t elemi folyamatnak nevezzük.
] <def_tizenharmadik>

Ez analóg a Lebesgue-integrál lépcsős függvényeivel, ahol a függvény értéke egy adott intervallumon állandó.

#definition[
  Egy elemi folyamat Itô-integrálja a következőképpen definiálható:
  $
    I(t) = integral_0^T Delta(s) dif B(s)
      = \
      sum_(j=0)^(n) Delta(t_j) (B(t_(j)) - B(t_(j-1))) + Delta(t_n) (B(T)- B(t_n)). #<equate:revoke>
  $
] <def_tizennegyedik>

#theorem[
  Legyen $Delta(t)$ egy elemi folyamat, ekkor az Itô-izometria a következőképpen írható fel:
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
  Legyen $T$ egy pozitív konstans, és legyen $X(t)$, $0 <= t <= T$ egy adaptált sztochasztikus folyamat, amely kielégíti a fentebb írt feltételeket. Ekkor az
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
  Legyen $f(t,x)$ függvény, melynek parciális deriváltjai $f_t$, $f_x$ és $f_(x x)$ léteznek és folytonosak. Legyen továbbá $B(t)$ egy Brown-mozgás. Ekkor minden $T >= 0$ esetén teljesül a következő egyenlőség:
  $
    f(T, B(T)) = f(0, B(0)) + integral_0^T f_t(t, B(t)) dif t \
    + integral_0^T f_x(t, B(t)) dif B(t) + 1/2 integral_0^T f_(x x)(t, B(t)) dif t.
  #<equate:revoke>
  $
] <thm_ito_doeblin>

Ahhoz, hogy megértsük az Itô–Doeblin-formula jelentőségét, tekintsük a következő példát. Legyen $f(x) = 1/2 x^2$, ekkor $f$ nem függ az időtől, így $f_t = 0$, és a parciális derivátak $f_(x) = x$ és $f_(x x) = 1$. Legyen $x_(j-1)$ és $x_j$ két szomszédos pont egy partícióban, és tekintsük a Taylor-sor első két tagját:
$
  f(x_j) - f(x_(j-1)) = f_x (x_(j-1))(x_j - x_(j-1)) + 1/2 f_(x x)(x_(j-1))(x_j - x_(j-1))^2.
$
Továbbá legyen $T > 0$ egy rögzített pozitív szám, és legyen a $[0,T]$ intervallum egy partíciója $cal(P)= {t_0, t_1, dots, t_n}$. Az $f(B(t))$ folyamat változását $0$ és $T$ között a következőképpen írhatjuk fel:
$
  f(B(T)) - f(B(0)) = sum_(j=1)^n f_x(B(t_(j-1)))(B(t_j) - B(t_(j-1))) + \
  1/2 sum_(j=1)^n f_(x x)(B(t_(j-1)))(B(t_j) - B(t_(j-1)))^2.  #<equate:revoke>
$
Ha ebbe behelyettesítjük a parciális derivátak értékét, akkor a következő egyenlőséget kapjuk:
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

#proposition[A geometriai Brown-mozgás $S(t)$ minden $t > 0$ esetén
lognormális eloszlású.]

#proposition()[
  Legyen $S(t)$ egy geometriai Brown-mozgás, amely kielégíti a következő SDE-t:
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
  Legyen $S(t)$ egy geometriai Brown-mozgás, amely kielégíti a következő SDE-t:
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
== A gépi tanulás alapjai

#pagebreak()
= Irodalomjegyzék

#bibliography("reference.bib", full: true, title:none)
