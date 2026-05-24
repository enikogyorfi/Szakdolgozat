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
#import "citer.typ": handleref
#show ref: handleref
#import "@preview/codly:1.3.0": *


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

#show figure.caption: it => context {
  // 1. Lekérjük a sorszámot. Az 'it.counter' automatikusan tudja,
  // hogy a táblázatok vagy a képek számlálóját kell-e néznie!
  let num = it.counter.display()

  // 2. Lekérjük a megnevezést (pl. "Ábra" vagy "Táblázat").
  // Biztonsági másolatként, ha nincs megadva, "ábra" lesz.
  let nev = if it.supplement != none { it.supplement } else { "ábra" }

  // 3. Összerakjuk a végső feliratot
  [#num. #nev: #it.body]
}

#show ref: it => {
  let el = it.element
  if el != none and el.func() == figure and not el.kind == table {
    // Lekéri a hivatkozott ábra sorszámát
    let num = counter(figure).at(el.location()).first()
    link(el.location())[#num. Ábra]
  } else {
    it
  }
}
#set par(justify: true)

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

#let pandas-table(path) = {
  let adatok = csv(path)
  let fejlec = adatok.first()
  let torzs = adatok.slice(1)

  align(center)[
    #table(
      columns: fejlec.len(),

      // Profi kinézet: Felső és alsó vastag vonal (mint a tudományos cikkekben a 'booktabs')
      stroke: (x, y) => (
        left: 0.5pt,
        right: 0.5pt,
        top: if y == 0 or y == 1 { 1pt } else { 0.5pt },
        bottom: if y == 0 { 1pt } else if y == torzs.len() { 1pt } else { 0.5pt }
      ),
      fill: (x, y) => if y == 0 { gray.lighten(80%) } else { none },

      // Fejléc kiemelése
      ..fejlec.map(cella => strong(cella)),

      // Adatok betöltése
      ..torzs.flatten()
    )
  ]
}
#show: codly-init.with()

#codly(
  number-format: numbering.with("1"),
  stroke: 0.5pt + luma(200),
  inset: 0.8em,

  // Így a helyes:
  zebra-fill: luma(250),

  languages: (
    python: (name: "Python", icon: none, color: rgb("#4C72B0")),
  )
)

= Gyakorlati alkalmazások

Az előző fejezetekben bemutatott eszkozök, mint a sztochasztikus differenciálegyenletek, a különböző ML és DL modellek lehetőséget adnak arra, hogy elemezzünk összetett, időben változó rendszereket és előrejelzéseket készítsünk. Ebben a fejezetben ezen módszerek gyakorlati alkalmazását vizsgálom meg bűnözési adatokon,
 elemezem a bűnözés időbeli mintázatát, a bűnözést befolyásoló demográfiai tényezőket, valamint a bűnözés előrejelzésére szolgáló modellek teljesítményét.

A bűnügyi statisztikák elemzése társadalmi és gazdasági szempontból is fontos, segíthet megérteni a bűnőzést kiváltó okokat, és hozzájárulhat a hatékonyabb bűnmegelőzési stratégiák kidolgozásához. A bűncselekmények időbeli alakulásának vizsgálata lehetőséget ad a trendek, a szezonalitás és a hirtelen változások azonosítására, míg a demográfiai tényezők elemzése segíthet megérteni, hogy mely csoportok vannak nagyobb kockázatnak kitéve.


Elsőként korábban bemutatott geometriai Brown-mozgás segítségével modellezem a bűnözés időbeli alakulását, majd Random Forest modellt fogok alkalmazni a bűnözés előrejelzésére és a legfontosabb tényezők azonosítására.

 == Adatok bemutatása

A vizsgálathoz a Chicago városában elkövetett bűncselekmények adatait használom, amelyeket a Chicago Police Department tett közzé. Az adatbázis tartalmazza a bűncselekmények típusát, helyét, időpontját és egyéb jellemzőit. Az adatok a 2001-től 2025-ig terjedő időszakot ölelik fel, és több mint 6 millió bűncselekményt tartalmaznak. Minden egyes rekord egy bűncselekményt reprezentál ée a legfontosabb jellemzői a következők:
- _ID_: Egyedi azonosító minden bűncselekményhez.
- _Dátum_: A bűncselekmény elkövetésének időpontja.
- _Primary Type_: A bűncselekmény típusa (pl. lopás, testi sértés, stb.).
- _Description_: Részletes leírás a bűncselekményről.
- _Arrest_: Jelzi, hogy történt-e letartóztatás a bűncselekmény kapcsán.
- _District_: A város melyik rendőri körzetében történt a bűncselekmény.
- _Community Area_: A város melyik területén történt a bűncselekmény.
- _Latitude_ és _Longitude_: A bűncselekmény helyének földrajzi koordinátái.

#figure(
    table(
      columns: (auto, auto, 1.2fr, 1.2fr, 1fr, auto),
      align: left + horizon,
      stroke: 0.5pt,
      inset: 4pt,
      fill: (x, y) => if y == 0 { gray.lighten(60%) },
      [*ID*], [*Date*], [*Primary Type*], [*Description*], [*Location*], [*Arrest*],

      [13974502], [09/21/2025], [CRIMINAL\ DAMAGE], [TO PROPERTY], [RESIDENCE -\ GARAGE], [False],
      [13975969], [09/21/2025], [THEFT], [FROM MOTOR\ VEHICLE], [RESIDENCE], [False],
      [13974043], [09/21/2025], [THEFT], [OVER \$500], [SIDEWALK], [False],
      [13976000], [09/21/2025], [DECEPTIVE\ PRACTICE], [FINANCIAL\ IDENTITY THEFT], [RESIDENCE], [False],
      [13976430], [09/21/2025], [CRIMINAL\ DAMAGE], [TO VEHICLE], [HOTEL / MOTEL], [False],
    ),

  caption: [Chicago bűnügyi adatok (minta)],
  kind: table,

)

#figure(
  image("Images/EDA/major_crimes_chicago.svg", width: 80%),
  caption: [Chicago bűnesemények típusai és gyakorisága]
)<buneset_tipusok_chicago>

A @buneset_tipusok_chicago a Chicagoban elkövetett bűnesetek típusait és azok gyakoriságát mutatja be 2001 és 2025 között. A leggyakoribb bűncselekménytípusok közé tartozik a lopás (THEFT, több mint 1,7 millió eset), a testi sértés (BATTERY, több mint 1,5 millió eset)  illetve fontos lehet még kiemelni a kábítószerrek kapcsolatos bűncselekmények magasabb számát is (NARCOTICS, több mint 700 ezer eset). Ezek az adatok fontosak lehetnek a bűnmegelőzési stratégiák kialakításához és a későbbi elemzések során vizsgálhatjuk azt is, hogy ezek a bűncselekménytípusok hogyan változnak időben és térben, valamint milyen demográfiai tényezők befolyásolják előfordulásukat.

#figure(
  image("Images/EDA/buneset_suruseg_terkep.png", width: 60%),
  caption: [Chicago bűnözési sűrűségének térképe])<buneset_suruseg_terkep>
A @buneset_suruseg_terkep a rendőri körzeteket mutatja Chicagoban a bűnözési sűrűség alapján színezve. Azonosíthatóak azok a körzetek, amik a leginkább érintettek, ezek a térképen a sötétebb színnel vannak jelölve.

#figure(
  image("Images/EDA/buneset_heti_nap_eloszlása.png", width: 85%),
  caption: [Chicago bűnözési sűrűségének térképe])<buneset_heti_nap_eloszlasa>
A @buneset_heti_nap_eloszlasa a bűncselekmények eloszlását mutatja a hét napjaira lebontva. Az ábráról kivehető a napszaki és heti mintázat, például, hogy a legtöbb bűncselekményt a hét végén éjfél körül követik el, illetve a hétköznapokon is megfigyelhető egy kisebb csúcs a délutáni órákban. Ezek az információk fontosak lehetnek a rendőri erőforrások hatékonyabb elosztásához.
#figure(
  image("Images/EDA/arrest_stats_top10.svg", width: 85%),
  caption: [Leggyakoribb bűncselekménytípusok és letartóztatási arányuk])<arrest_stats_top10>
A @arrest_stats_top10 a leggyakoribb bűncselekménytípusokat mutatja be a letartóztatási arányukkal együtt. Az ábra alapján látható, hogy a leggyakoribb bűncselekménytípusok közül a lopás (THEFT) és a testi sértés (BATTERY) esetében a letartóztatási arány viszonylag alacsony, míg a kábítószerrel kapcsolatos bűncselekmények (NARCOTICS) esetében kiugróan magas.
 #figure(
  image("Images/EDA/buneset_havi_alakulasa.svg", width: 85%),
  caption: [Bűncselekmények havi alakulása])<buneset_havi_alakulasa>
#figure(
  image("Images/EDA/buneset_havi_alakulasa_osszesitett.svg", width: 85%),
  caption: [Bűncselekmények havi alakulása (összesítve)])<buneset_havi_alakulasa_osszesitett>
A @buneset_havi_alakulasa és a @buneset_havi_alakulasa_osszesitett a bűncselekmények havi alakulását mutatja be. A @buneset_havi_alakulasa alapján látható a bűnözés éven belüli szezonális mintázata, jellemzően a nyári hónapokban a legmagasabb a bűncselekmények száma, míg a téli hónapokban egy jelentős csökkenés figyelhető meg. Bár a bűnözés csökkenő trndet mutata a 2001 és 2025 közötti időszakban, a szezonalitás továbbra is megfigyelhető. Ezeket a megfigyeléseket számszerűsíti a @buneset_havi_alakulasa_osszesitett, itt is megfigyelhető, hogy valóban a nyári hónapokban a legmagasabb a bűncselekmények száma, míg ez a szám a téli hónapokra csökken.



== Bűnözés időbeli modellezése geometriai Brown-mozgással (Korrelált Brown-mozgás)

Ebben a fejezetben a bűnözés időbeli alakulását modellezem geometriai Brown-mozgással. A felépített modell alapját Julia Calatayud és tárasi (@calatayud2023) 2023-ban megjelent tanulmánya adja, amelyben a bűnözés időbeli alakulását sztochasztikus differenciálegyenletekkel modellezték. A módszer lényege, hogy a különböző területekhez tartozó Brown-mozgások nem függetlenek, hanem korreláltak, így a modell képes figyelembe venni a térségek közötti együttmozgást is.
 A szerzők a spanyolországi Valencia város bűnözési adatait vizsgálták geometriai Brown-mozgás segítségével, de az általuk javasolt módszertan alkalmazható más városok, így Chicago bűnözési adatainak modellezésére is. A következőkben bemutatom hogyan készítettem elő az adatokat és hogyan határoztam meg a geometriai Brown-mozgás paramétereit, majd a modell segítségével előrejelzéseket készítek a bűnözés alakulására vonatkozóan.

=== Adatok előkészítése

Elsőként, hogy a modellt alkalmazni tudjam, a nyers adatokat megfelelő térbeli és időbeli felbontásra kellett hozni. Ahogy az @buneset_suruseg_terkep is mutatja, a bűnözési mintázat jelentős eltéréseket mutat a városon belül, ezért az előrejelzéseket kerültenként készítem el (a 21-es és 31-es körzetre nem állt rendelkezésre elég információ, így azokat az elemzés során nem vettem figyelembe). Az időbeli felbontáshoz először minden körzetre és évre kiszámoltam a havi bűncselekmények számát, majd ebből az adatból kiszámoltam a bűncselekmények napi átlagos számát, így figyelembe tudtam venni, hogy az egyes hónapok különböző hosszúságúak. Tanító adathalmazatként a 2001 és 2024 közötti időszakot, míg teszt adatként 2025 január és augusztus közötti időszakot használtam. Illetve még az adatelőkészítés során eltávolítottam azokat az oszlopokat amelykre nem lesz szükség a modellépítés során, például a bűncselekmények pontos helyét jelző földrajzi koordinátákat, illetve a bűncselekmények típusát jelző oszlopokat is, mivel ezek nem relevánsak a bűnözés időbeli alakulásának modellezése szempontjából.


=== Paraméterek meghatározása

Elsőként a szimuláció alapparamétereit határoztam meg, ezek a következők voltak:
- _dt_: A szimuláció időlépése, amelyet 1 hónapra állítottam be, mivel a bűnözési adatokat havi szinten aggregáltam.
- _T_: A szimuláció teljes időtartama, amely az én esetemben 8 hónap volt, mivel a teszt adatok 2025 január és augusztus közötti időszakot ölelik fel.
- _N_: A szimuláció lépéseinek száma, amelyet a teljes időtartam és az időlépés alapján számoltam ki, így $N =T/("dt")$
- _$S_0$_: A szimuláció kezdeti értéke, amely minden körzetre a 2024 decemberében elkövetett bűncselekmények napi átlagos számát jelenti, mivel ez az utolsó ismert adatpont a tanító adathalmazatban.
- _t_: A szimuláció időtengelye, amely tartalmazza a szimuláció minden időpontját a kezdeti időponttól a teljes időtartam végéig, az időlépésnek megfelelően.

A körzetek idősorait geometriai Brown-mozgással modelleztem. Jelölje $S_(i,t)$ az i-edik körzetben a bűncselekmények napi átlagos számát a t-edik időpontban. Ekkor az i-edik körzet idősora a következő sztochasztikus differenciálegyenlettel írható le:
$
d S_(i,t) = S_(i,t) μ_i d t + σ_i S_(i,t) d W_(i.t))
$
ahol $mu_i$ az i-edik körzet drift paramétere, $sigma_i$ a volatilitás paramétere, és $W_(i,t)$ az i-edik körzethez tartozó Brown-mozgás. A megoldás az alábbi alakban adható meg:
 $
 S_(i,t)=S_(i,0)*exp((μ_i-σ_i^2/2)*"t"+σ_i*W_(i,t))
 $
A modell minden körzetre külön-külön határozza meg a drift és volatilitás paramétereket, de a körzetek közötti Brown-mozgások között korrelációt feltételez:
$
"Corr"( W_(i,t), W_(j,t))=ρ_(i,j)
 $
 ahol $ρ_(i,j)$ a körzetek közötti korrelációs együttható. Ez azt fejezi ki, hogy a különböző körzetek bűnözési mintázatai nem függetlenek, tehát ha két körzet bűnözése hasonlóan változott az elmúlt években, akkor a modell a jövőben is figyelembe fogja ezt venni.
 A drift és volatilitás paraméterek számítását az alábbi módon végeztem:
- _μ_: A drift paraméter, amely a bűnözés hosszú távú trendjét jelenti. Ezt a paramétert minden körzetre külön-külön határoztam meg. Ehhez először kiszámoltam az i-edik körzetben minden egymást követő hónap közötti loghozamot:
$
mu_(i,t) = log(S_(i,t+1)/S_(i,t))
$
majd kiszámoltam a loghozamok átlagát és szórását és a drift paramétert a következő képlettel számoltam ki:
$
μ_i = overline(mu_(i,t)) + 0.5*"sd" (mu_(i,t))^2
$
- _σ_: A volatilitás paraméter, amely a bűnözés rövid távú ingadozásait jelenti. Ezt a paramétert szintén minden körzetre külön-külön határoztam meg. A $sigma$ kiszámolásához is a loghozamokat használtam, kiszámoltam minden körzetre a szórásukat, és ezt az értéket használtam a volatilitás paraméterként:
$
σ_i = "sd"(mu_(i,t))
$

==== A korrelációs mátrix meghatározása és szcenáriók generálása

A loghozamok alapján kiszámoltam a körzetek közötti korrelációs mátrixot, amely megmutatja, hogy a különböző körzetek bűnözési mintázatai mennyire mozognak együtt. Ha $i,j$ jelöl két körzetet, akkor a korrelációs együttható a következő képlettel számolható ki:
$
ρ_(i,j) = "Cov"(mu_(i,t), mu_(j,t))/sigma_i*sigma_j
$
ahol $"cov"(mu_(i,t), mu_(j,t))$ az i-edik és j-edik körzet loghozamainak kovarianciája, $sigma_i$ és $sigma_j$ pedig a volatilitás paraméterek. Így a korrelációs mátrix a következő alakú lesz:
$
R = (ρ_(i,j))
$

A korrelált Brown-mozgások előállításához a körzetek korrelációs mátrixának Cholesky-felbontását használtam:
$
R = L L^T
$
ahol R a korrelációs mátrix, L pedig egy alsó háromszögmátrix. Ekkor a független standard normál eloszlású változókból előállíthatók a korrelált valószínűségi változók a következő módon:
$
Delta W_t = sqrt(d t) L Z_t
$
ahol $Z_t$ egy független standard normál eloszlású vektor, és $Delta W$ a korrelált Brown-mozgások vektora. Ezután a Brown-pályákat a következő módon állítottam elő:
$
W_(t_k) = sum_(l=1)^(k) Delta W_t_l
$
Tehát így minden körzethez és szcenárióhoz egy összefüggő Brown-pálya tartozik, amely figyelembe veszi a körzetek közötti korrelációt is. Majd az így kapott paramétereket és pályákat behelyettesítettem a geometriai Brown-mozgás megoldásába és így kaptam meg a bűnözés előrejelzéseit minden körzetre és minden időpontra vonatkozóan.

Tehát például három szcenárió generálása esetén a következő eredményt kaptam az első körzetre vonatkozóan:

#figure(
    caption: [Az első körzetre kapott előrejelzések a három szcenárióban],
    [
        #set text(size: 9pt)
        #pandas-table("Results/gbm_pred_1korzet_2.csv")

    ]
) <geom_brown_simulation_results_1_kerulet>
A táblázat alapján látható, hogy a három szcenárióban kapott előrejelzések jelentős eltéréseket mutatnak, ami a sztochasztikus paraméter véletlenszerűségéből adódik. Ez azt jelzi, hogy a geometriai Brown-mozgás érzékeny a sztochasztikus paraméter értékére, ezért fontos lehet több szcenáriót is szimulálni, hogy jobban megértsük a bűnözés időbeli alakulásának bizonytalanságát. A szcenáriók eredményeit a valós adatokkal is összehasonlítottam:

#figure(
    image("Images/Results_img/predictions_vs_actuals_district_1.png", width: 85%),
    caption: [Tényleges bűncselekmények napi átlagos száma a teszt időszakban és a három szcenárióban kapott előrejelzések],
) <geom_brown_simulation_results_1_kerulet_actual_vs_predicted>
A különbségek számszerűsítéséhez kiszámoltam az RMSE értékeket is:
 $
"RMSE" = sqrt(sum_(i=1)^(n)(y_i - (hat(y))_i)^2)
$
és ábrázoltam a három szcenárióra:

#figure(
    image("Images/Results_img/rmse_by_scenario_district_1.png", width: 75%),
    caption: [Az első körzet esetén a három szcenárió RMSE értékei],
   ) <geom_brown_simulation_results_1_kerulet_rmse>

=== Eredmények és értékelés

A tényleges szimuláció során 10.000 szcenáriót generáltam és ahogy azt a három szcenáriót tartalmazó példán is bemutattam, ezek a szcenáriók eltérő viselkedést mutatnak. Ahhoz, hogy kiválasszam azt a szcenáriót, ami minden körzet esetén a legjobb előrejelzést adja, kiszámoltam az RMSE értékeket minden szcenárióra és minden körzetre vonatkozóan, majd kiválasztottam azt a szcenáriót, amelyik a legkisebb átlagos RMSE értéket adta.
Az eredmények összefoglalását az alábbi táblázat mutatja:

#figure(
    caption: [Az eredmények összefoglalása],
    [
        #set text(size: 9pt)
        #pandas-table("Results/gbm_overall_metrics.csv")
        )
    ]
) <geom_brown_simulation_results_rmse_table>
A táblázat alapján látható, hogy a modell 91,07%-os pontosággal (Accuracy) tudta előrejelezni a bűnözés alakulását a teszt időszakban, ami azt jelzi, hogy a geometriai Brown-mozgás jól alkalmazható a bűnözés időbeli modellezésére. Az RMSE és MAE (mean absolute error) értékek alapján is jól teljesített a modell, ezek az értékek azt mutatják, hogy a modell által előrejelzett értékek sehol nem térnek el kiugóan a tényleges értékektől.

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em, // Kicsit szellősebb térköz

    // Első kép és esetleg alá egy kis belső felirat
    align(center)[
      #image("Images/Results_img/gbm_predicted_heatmap_2.png", width: 90%)
      *(a)* Előrejelzés hőtérképen
    ],

    // Második kép
    align(center)[
      #image("Images/Results_img/gbm_actual_heatmap_2.png", width: 90%)
      *(b)* Tényleges adatok hőtérképen
    ]
  ),
  caption: [Az előrejelzés és a tényleges adatok összehasonlítása hőtérképen],
) <osszehasonlito-abra>
A @osszehasonlito-abra alapján is látható, hogy a két hőtérkép hasonló mintázatot mutat, látható, hogy a modell mind a kisebb  mind a nagyobb esetszámú területeket jól azonosította, ami azt jelzi, hogy a modell képes volt megragadni a bűnözés nemcsak időbeli, de térbeli mintázatát is.

#figure(
    image("Images/Results_img/gbm_difference_heatmap_2.png" , width: 40%),
    caption: [Az előrejelzés és a tényleges adatok közötti különbség hőtérképen],
) <gbm_difference_heatmap>
 Hogy vizuálisan is látható legyen a különbség a két hőtérkép között, készítettem egy külön hőtérképet, amely az előrejelzés és a tényleges adatok közötti különbséget mutatja be. A @gbm_difference_heatmap alapján látható, hogy a különbségek nagy része kisebb értékek körül helyezkedik el, de megfiygelhető, hogy a 19-es, 14-es és 12-es körzetekben az abszolút átlagos hiba magasabb.




== Bűnözés előrejelzése Random Forest modellel

A geometriai Brown-mozgás alkalmazásával sikerült feltárni a bűnözés időbeli alakulását és a sztochasztkus differenciálegyenletek segítségével megragadni az előrejelzés bizonytalanságát. Ez a megközelítés elsősorban a múltbeli adatoból származtatott drift és volatilitás paraméterekre támaszkodik és vázolja fel a jövőbeli szcenáriókat, azonban nem ismerjük meg az adatokban lévő struktúrákat és összefüggéseket. Ezért ebben a részben egy másik megközelítést alkalmazok, egy Random Forest modellt, amely képes megragadni az adatokban lévő nemlineáris összefüggéseket és interakciókat. A modell építése során a bűncselekmények számát jelzem előre minden körzetre és minden hónapra vonatkozóan, ugyanazt a tanító és teszt adathalmazatot használva, mint a geometriai Brown-mozgás esetében.

=== Adatok előkészítése

A Random Forest modell esetében is hasonlóan a geometriai Brown-mozgáshoz a 2001 és 2024 közötti időszakot használtam tanító adathalmazatként, míg a 2025 január és augusztus közötti időszakot teszt adathalmazatként. Az adatelőkészítés során azonban nem csak a bűncselekmények számát tartalmazó oszlopokat hagytam meg, hanem további jellemzőket is hozzáadtam, amelyek potenciálisan befolyásolhatják a bűnözés alakulását. A célváltozó most is a bűncselekmények napi átlagos száma minden körzetre és minden hónapra vonatkozóan. Mivel a Random Forest modell nem tudja az időbeliséget megragadni, kiegészítettem az adatokat új bemeneti változókkal, amelyek az időbeli mintázatokat reprezentálják. Ezek a következők voltak:
- _Month_: A hónap száma (1-12)
- _Year index_: Az év indexe, amely a 2001-től kezdődő évek számát jelenti (pl. 2001 = 0, 2002 = 1, stb.)
- _Month sin_: A hónap szinusz transzformációja, amely segít megragadni a szezonális mintázatokat
- _Month cos_: A hónap koszinusz transzformációja, amely segít megragadni a szezonális mintázatokat
- _IsSummer_: Egy bináris változó, amely jelzi, hogy a hónap a nyári időszakban van-e (június, július, augusztus)
- _IsWinter_: Egy bináris változó, amely jelzi, hogy a hónap a téli időszakban van-e (december, január, február)
#figure(
   caption: [Az időbeli jellemzők előkészítése],
  [
```py
def year_indexing(df):
    df['Year_Index'] = 2025 - df['Year'] + 1
    return df
```
```py
def prepare_month_data(df, col):
    df[col] = df[col].astype(float)
    df[f"{col}_Sin"] = df[col].apply(lambda x: (np.sin(((x-1) * 2 * np.pi / 12)+0.5)+1)/2)
    df[f"{col}_Cos"] = df[col].apply(lambda x: (np.cos(((x-1) * 2 * np.pi / 12)+0.5)+1)/2)
    df['Is_Winter'] = df['Month'].isin([12, 1, 2]).astype(int)
    df['Is_Summer'] = df['Month'].isin([6, 7, 8]).astype(int)
    df = year_indexing(df)
    return df
```
]
)
Továbbá mivel a bűnözés jövőbeli rátája egy körzetben nagymértékben függ az elmúlt időszakok tendenciáitól és a hónapok kinyerése és átalakítása segít a szezonalitás modellezésében, de nem képes megragadni a folyamatos időbeli trendet. Tehát, hogy a Random Forest modellt hatékonyan tudjam alkalmazni idősorok elmzésére, az adatelőkészítés során úgynevezett késleltetett változókat (lag features) is létrehoztam. Ezek a változók a bűncselekmények napi átlagos számát tartalmazzák az előző hónapokban minden körzetre vonatkozóan. Tehát így a modell képes lesz emlékezni a múltbeli értékekre.
#figure(
    caption: [Késleltetett változók létrehozása],
    [
```py
def create_lagged_features(df, col, lag=1):
    df_lagged = df.copy()
    for i in range(1, lag + 1):
        df_lagged[f'{col} Lag {i}'] = df_lagged.groupby('District')[col].shift(i)
    return df_lagged
```
])
\

A lag változók létrehozása mellett a múltbeli értékekből kiszámolt mozgóátlagot és mozgószórást is hozzáadtam az adatokhoz, hogy egy-egy kiugró érték ne befolyásolja túlzottan a modellt és hogy a modell a mozgószórás értékek alapján meg tudja ragadni a bűnözés ingadozásait.
#figure(
    caption: [Mozgóátlagok és mozgószórások létrehozása],
    [
```py
def rolling_mean(df, idopontok):
    for i in idopontok:
       df[f'Rolling Mean {i}'] = (
        df.groupby('District')['Number of Crimes Per Day']
        .transform(lambda s: s.shift(1).rolling(window=i).mean()))

    return df
```
```py
def rolling_std(df, idopontok):
    for i in idopontok:
        df[f'Rolling Std {i}'] = (df.groupby('District')['Number of Crimes Per Day'].transform(lambda s: s.shift(1).rolling(window=i).std()))

    return df
```
])
=== Modellépítés és eredmények

Az adatok előkéazítése után a Random Forest modellek betanítása következett. Két különböző modellt építettem, az elsőben csak a késleltetett változókat használtam, míg a második modellben már a mozgóátlagokat és mozgószórásokat is hozzáadtam a bemeneti változókhoz.

==== Modell 1: Késleltetett változók

A modellben során használt bemeneti változók a következők voltak:
- _District_: A körzet azonosítója
- _Year Index_: Az év indexe
- _Month Sin_: A hónap szinusz transzformációja
- _Month Cos_: A hónap koszinusz transzformációja
- _Is Summer_: Bináris változó, amely jelzi, hogy a hónap a nyári időszakban van-e
- _Is Winter_: Bináris változó, amely jelzi, hogy a hónap a téli időszakban van-e
- _Number of Crimes Per Day Lag 1_: A bűncselekmények napi átlagos száma az előző hónapban
- _Number of Crimes Per Day Lag 2_: A bűncselekmények napi átlagos száma két hónappal ezelőtt

A késleltetett (lag) változók számának megválasztása során több különböző beállítást is kipróbáltam, az eredmények alapján a 2 hónapra visszamenő késleltetett változók adták a legjobb eredményeket, ezért ezeket használtam a modellben. Több lag-változó használata esetn a modell teljesítmény már nem mutatott javulást, ezt magyarázhatja, hogy a bűnözés alakulására leginkább az előző hónapok tendenciái vannak hatással, és a túl sok lag-változó használata már nem ad hozzá új információt a modell számára, viszont növeli a modell komplexitását és a túlillesztés kockázatát.

A Random Forest modell nem hónaponként készítette el az előrejelzést, hanem egyszerre, a 8 hónapra vonatkozóan. Így a modell egy adott időpont és körzet alapján egy teljes előrejelzési horizontot állított elő. Ennek előnye, hogy a több hónapra vonatkozó becslések egyszerre készülnek el, vagyis a modell nem kényszerül arra, hogy minden újabb hónap előrejelzéséhez az előző saját becslését használja fel. Ez csökkentheti a hibák továbbterjedését, amely a szekvenciális előrejelzéseknél gyakran problémát jelent.

A Random Forest modell hiperparamétereit RandomizedSearchCV segítségével hangoltam, amely egy véletlenszerű keresést hajt végre a megadott hiperparaméterek között, és a legjobb kombinációt választja ki a modell teljesítménye alapján. A legjobb hiperparaméterek a következők voltak:
- _n_estimators_: 521 (a döntési fák száma a Random Forest modellben)
- _max_depth_: 12 (a döntési fák maximális mélyse)
- _max_features_: '0.5' (a bemeneti változók aránya, amelyet minden döntési fa építésekor véletlenszerűen kiválasztanak)

A modell validálásához walk-forward cross-validation-t alkalmaztam, amely egy időbeli keresztvalidációs módszer. A módszer során a tanító adathalmazatot több részre osztottam, és minden részre külön-külön tanítottam a modellt, majd a következő részre vonatkozóan készítettem előrejelzést, így megőriztem az időbeli sorrendiséget.
A keresztvalidáció során a következő eredményeket kaptam:
#figure(
    caption: [Walk-forward keresztvalidáció eredményei],
    [
        #set text(size: 9pt)
        #pandas-table("Results/walk_forward_cv_results.csv")
    ]
) <walk_forward_cv_results>

A modell teljesítményét a teszt adathalmazaton is értékeltem, amely 2025 január és augusztus közötti időszakot öleli fel. A következő táblázat mutatja a teszt adathalmazaton kapott eredményeket:
#figure(
    caption: [Teszt adathalmazaton \
     kapott eredmények],
    [
        #set text(size: 9pt)
        #pandas-table("Results/lagged_test_results.csv")
    ]
) <test_results_model_1>
A táblázat alapján látható, hogy a modell 90,82%-os pontosággal (Accuracy) tudta előrejelezni a bűnözés alakulását a teszt időszakban, illetve az RMSE érték is viszonlyag alacsony (3,11), ami azt jelenti, hogy az előrejelzett napi átlagos bűncselekményszám átlagosan kis mértékben tér el a tényleges értékektől.
Akárcsak a geometriai Brown-mozgás esetében, a modell előrejelzéseit hőtérképen is megjelenítettem, hogy vizuálisan is összehasonlítható legyen a tényleges adatokkal.
#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em, // Kicsit szellősebb térköz

    // Első kép és esetleg alá egy kis belső felirat
    align(center)[
      #image("Images/Results_img/lagged_predicted_heatmap.png", width: 90%)
      *(a)* Előrejelzés hőtérképen
    ],

    // Második kép
    align(center)[
      #image("Images/Results_img/gbm_actual_heatmap.png", width: 90%)
      *(b)* Tényleges adatok hőtérképen
    ]
  ),
  caption: [Az előrejelzés és a tényleges adatok összehasonlítása hőtérképen],
) <lagged_osszehasonlito_abra>
 A @lagged_osszehasonlito_abra mutatja az előrejelzés és a tényleges adatok hőtérképeit.
Az eltérések vizuális megjelenítéséhez készítettem egy külön hőtérképet, amely az előrejelzés és a tényleges adatok közötti különbséget mutatja be.
#figure(
    image("Images/Results_img/lagged_error_heatmap.png" , width: 40%),
    caption: [Az előrejelzés és a tényleges adatok közötti különbség hőtérképen],
) <lagged_difference_heatmap>
Az @lagged_difference_heatmap alapján látható, hogy a különbségek nagy része nem jelentős, de megfigyelhető pár körzet, ahol az abszolút átlagos hiba magasabb, például a 14, 25 és 19-es körzetekben, ahol 4 fölötti átlagos hibát kaptam.

=== Modell 2: Késleltetett változók, mozgóátlagok és mozgószórások

A második modellben a bemeneti változókat még kiegészítettem a mozgóátlagokkal és mozgószórásokkal, így a bemeneti változók a következők voltak:
- _District_: A körzet azonosítója
- _Year Index_: Az év indexe
- _Month Sin_: A hónap szinusz transzformációja
- _Month Cos_: A hónap koszinusz transzformációja
- _Is Summer_: Bináris változó, amely jelzi, hogy a hónap a nyári időszakban van-e
- _Is Winter_: Bináris változó, amely jelzi, hogy a hónap a téli időszakban van-e
- _Number of Crimes Per Day Lag 1_: A bűncselekmények napi átlagos száma az előző hónapban
- _Number of Crimes Per Day Lag 2_: A bűncselekmények napi átlagos száma két hónappal ezelőtt
- _Rolling Mean 3_: A bűncselekmények napi átlagos számának 3 hónapos mozgóátlaga
- _Rolling Mean 4_: A bűncselekmények napi átlagos számának 4 hónapos mozgóátlaga
- _Rolling Std {k_}: A bűncselekmények napi átlagos számának k hónapos mozgószórása, ahol k = 3, 4, 5, 6

A modell felépítése és a hiperparaméterek hangolása ugyanúgy történt, mint az első modell esetében. A keresztvalidáció során a következő eredményeket kaptam:
#figure(
    caption: [Walk-forwar keresztvalidáció eredményei],
    [
        #set text(size: 9pt)
        #pandas-table("Results/walk_forward_cv_results_rollingmean.csv")
    ]
) <walk_forward_cv_results_model_2>

A teszt adathalmazaton kapott eredményeket a következő táblázat mutatja:
#figure(
    caption: [Teszt adathalmazaton kapott eredmények],
    [
        #set text(size: 9pt)
        #pandas-table("Results/rollingmean_test_results.csv")
    ]) <test_results_model_2>
A táblázat alapján látható, hogy a modell 92,71%-os pontosággal jelzett előre, ebből is látszik, hogy a mozgóátlagok és mozgószórások hozzáadása javította a modell teljesítményét, hiszen az első modellben 90,82%-os pontosággal tudta előrejelezni a bűnözés alakulását. Az RMSE érték is csökkent (2,44), ami azt jelenti, hogy az előrejelzett napi átlagos bűncselekményszám átlagosan kisebb mértékben tér el a tényleges értékektől, mint az első modell esetében.
Ebben az esetben is elkészítettem a hőtérképeket:
#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em, // Kicsit szellősebb térköz

    // Első kép és esetleg alá egy kis belső felirat
    align(center)[
      #image("Images/Results_img/rollingmean_predicted_heatmap.png", width: 90%)
      *(a)* Előrejelzés hőtérképen
    ],

    // Második kép
    align(center)[
      #image("Images/Results_img/gbm_actual_heatmap.png", width: 90%)
      *(b)* Tényleges adatok hőtérképen
    ]
  ),
  caption: [Az előrejelzés és a tényleges adatok összehasonlítása hőtérképen],
) <rollingmean_osszehasonlito_abra>

Továbbá a különbség hőtérképet is elkészítettem:
#figure(
    image("Images/Results_img/rollingmean_error_heatmap.png" , width: 40%),
    caption: [Az előrejelzés és a tényleges adatok közötti különbség hőtérképen],
) <rollingmean_difference_heatmap>

Az ábráról leolvasható, hogy az eltérések értéeki kis tartományban mozognak, de megfigyelhető, hogy a 12-es körzetben jelentős eltérés van, ahol az átlagos hiba 10 fölötti érték, ami kiugróan magas. Ez magyarázható azzal, hogy a körzetben a bűncselekmények száma növekedett a teszt időszakban, míg a tanító adathalmazatban csökkenő tendencia volt megfigyelhető, így a modell nem tudta jól megragadni ezt a változást.

=== Összefoglalás

A bűnözés előrejelzésére több különböző megközelítést alkalmaztam és hasonlítottam össze. Elsőként geometriai Brown-mozgással modelleztem a bűncselekmények időbeli alakulását, majd Random Forest modelleket építettem, amelyek már több bemeneti változót is figyelembe vettek. Az összehasonlítás érdekében egy egyszerű baseline modellt is készítettem, amely a 3 hónapos mozgóátlagon alapult.

A baseline modell célja, hogy egy egyszerű, könnyen érthető előrejelzést adjon, amelyhez a komplexebb modellek teljesítményét viszonyítani lehet. Ennél a módszernél az előrejelzés minden körzet esetén a 2024-es év utolsó három hónapjának (október, november, december) bűncselekményszámának átlagát jelenti.A baseline modell nem tanul külön paramétereket, hanem kizárólag a legutóbbi rövid távú trendet veszi figyelembe. Ezért alkalmas annak vizsgálatára, hogy a geometriai Brown-mozgás és a Random Forest modellek valóban többletinformációt tudnak-e kinyerni az adatokból egy egyszerű mozgóátlagos előrejelzéshez képest.

Az eredményeket az alábbi táblázat foglalja össze:
#figure(
    caption: [Modellek teljesítményének összehasonlítása],
    [
        #set text(size: 9pt)
        #pandas-table("Results/summary.csv")
    ]
) <model_comparison>

A táblázat alapján látható, hogy a különböző hibamutatók nem teljesen ugyanazt a sorrendet adják. RMSE alapján a Random Forest kizárólag késleltetett változókat használó változata érte el a legalacsonyabb hibát, ugyanakkor a MAPE és az Accuracy alapján a rolling feature-ökkel kiegészített Random Forest modell teljesített a legjobban. A MAPE relatív hibát mér, az Accuracy pedig ebből származtatott mutató, ez alapján összességében a Random Forest rolling feature-ökkel kiegészített változata tekinthető a legkedvezőbb modellnek.

A geometriai Brown-mozgás teljesítménye valamivel gyengébb lett, mint a Random Forest rolling feature-ökkel kiegészített változatáé és a baseline modellé. Ennek oka lehet, hogy a geometriai Brown-mozgás elsősorban a múltbeli trendből, a volatilitásból és a korrelált véletlen ingadozásokból indul ki, míg a Random Forest modellek további időbeli jellemzőket, például szezonalitást, lag-változókat, mozgóátlagokat és mozgószórásokat is figyelembe vesznek.

Összességében az eredmények azt mutatják, hogy a bűncselekmények előrejelzésében a múltbeli trend, a rövid távú mozgóátlagok és az időbeli késleltetett változók kiemelten fontos szerepet játszanak. A Random Forest rolling feature-ökkel kiegészített változata azért teljesített jól, mert egyszerre tudta figyelembe venni a múltbeli értékeket, az ingadozásokat és a szezonális mintázatokat. 

#pagebreak()

== Bűnözést befolyásoló demográfiai tényezők elemzése és előrejelzés készítése

Az előző fejezetekben a bűnözés időbeli alakulását vizsgáltam geometriai Brown-mozgás, illetve Random Forest modellek segítségével. Ezekben a modellekben a fő cél az volt, hogy a múltbeli bűnözési adatok alapján minél pontosabb előrejelzést készítsek a következő hónapokra. A modellek elsősorban az idősoros mintázatokra, a szezonalitásra, a lag-változókra és a mozgóátlagokra épültek. Ebben a fejezetben egy ettől eltérő megközelítést vizsgálok. Itt nemcsak maga az előrejelzés a cél, hanem annak vizsgálata is, hogy mely társadalmi-demográfiai jellemzők állhatnak kapcsolatban a bűnözés alakulásával és az egyes bűncselekménytípusok esetében milyen tényezők lehetnek meghatározóak.

További különbség az eddigi fejezetekhez képest, hogy az elemzést már nem körzetekre végzem, hanem ugynevezett community area szinten, amely egy kisebb területi egység, illetve nem havi szinten, hanem éves szinten vizsgálom a bűnözés alakulását. Ennek oka, hogy a társadalmi-demográfiai jellemzők általában éves szinten állnak rendelkezésre és community area szinten aggregálható.

=== Adatok előkészítése

Ebben a fejezetben tanító adatként a 2013 és 2023 közötti időszakot használtam, míg az előrejelzést a 2024-es évre készítettem el, az előző fejezthez képest az eltérés oka, hogy erre a periódusra állnak rendelkezésre a legfrissebb társadalmi-demográfiai adatok.

A demográfiai és társadalmi-gazdasági jellemzők adatainak forrása a U.S. Census Bureau által publikált American Community Survey (ACS) 5 éves becslései voltak, amelyek évente frissülnek és részletes információkat tartalmaznak a lakosság összetételéről, jövedelmi viszonyairól, foglalkoztatottságáról, oktatási szintjéről és egyéb társadalmi-gazdasági jellemzőiről.
Az ACS 5 éves becslések nem egyetlen év pontos állapotát, hanem több év adataiból képzett becslést reprezentálnak. Emiatt ezek a változók inkább a városrészek tartósabb társadalmi-gazdasági jellemzőit írják le, nem pedig hirtelen éves változásokat. Ez ugyanakkor előnyös is lehet a bűnözési mintázatok vizsgálatában, mert a demográfiai tényezők hatása jellemzően nem egyik évről a másikra, hanem hosszabb időtávon jelenik meg.

Az elemzéshez a 2013 és 2023 közötti adatokat használtam fel. Az adatok eredetileg census tract szinten álltak rendelkezésre, amely egy kisebb területi egység, mint a community area. Ezért először a census tract-eket aggregáltam community area szintre. A feldolgozás során több társadalmi és gazdasági mutatót képeztem illetve a nyers adatok helyett arányszámokat alkalmaztam, a jobb összehasonlíthatóság érdekében. Az elemzés során a következő mutatókat használtam:
- _Teljes népesség_: A community area teljes lakossága
- _Munkanélküliek aránya_: A munkanélküliek aránya a teljes munkaerőhöz képest
- _Egy főre jutó jövedelem_: A community area egy főre jutó jövedelme
- _Iskolázottsági mutatók_: A középiskolát végzettek aránya, a diplomások aránya illetve a középiskolai végzettség nélküli lakosok aránya
- _Szegénységi ráta_: A szegénységi küszöb alatt élők aránya
- _Fiatal férfiak aránya_: A 15-34 éves férfiak aránya a teljes lakossághoz képest

Mivel az ACS-adatok csak 2023-ig álltak rendelkezésre, a 2024-es előrejelzéshez a jellemzőket becsülni kellett. Ehhez Community Area-nként negyedfokú polinomiális extrapolációt alkalmaztam, amely a múltbeli értékek alapján egy negyedfokú polinomot illesztett az adatokra, majd ezt a polinomot használva becsültem meg a 2024-es értékeket.

A bűnözési adatok előkészítése során az adatokat community area szintre aggregáltam és éves szinten összesítettem. Elsőként az összes bűncselekményt egyben vizsgáltam, majd külön-külön elemeztem a leggyakoribb bűncselekménytípusokat is, mint például a lopás, testi sértés. A feldolgozás során az előző fejezetekhez hasonlóan létrehoztam késleltetett változókat, mozgóátlagokat és mozgószórásokat is, hogy a modell ne csak a társadalmi-demográfiai jellemzőket, hanem a bűnözés múltbeli alakulását is figyelembe vegye az előrejelzés során.

=== Eredmények és értékelés

A demográfiai adatok bevonásával végzett elemzést két lépésben készítettem el. Elsőként egy összesített modellt építettem, amelyben az adott Community Area-ban és évben előforduló összes bűncselekmény számát vizsgáltam. Ennek célja az volt, hogy általános képet kapjak arról, mely társadalmi-gazdasági és demográfiai jellemzők kapcsolódnak leginkább a bűnözés teljes szintjéhez.

Ezt követően a leggyakoribb bűncselekménytípusokat külön-külön is elemeztem, hogy megvizsgáljam, hogy a különböző bűncselekménytípusok esetében milyen tényezők lehetnek meghatározóak. Erre azért volt szükség, mert például egy vagyon elleni bűncselekmény, egy erőszakos bűncselekmény vagy egy kábítószerrel kapcsolatos eset mögött eltérő társadalmi és gazdasági mintázatok állhatnak.

==== Összesített modell

Tehát elsőként az összes bűncselekmény együttes esetszámát vizsgáltam, a célváltozó ennek megfelelően a bűncselekmények éves száma volt minden Community Area-ban. Az előrejelzés pedig egy évre előre készült, a 2024-es évre vonatkozóan. A modell célja egyrészt az volt, hogy vizsgáljam, hogy a társadalmi-gazdasági és demográfiai jellemzők bevonása javítja-e az előrejelzés pontosságát, másrészt pedig hogy megvizsgáljam, hogy mely tényezők állnak leginkább kapcsolatban a bűnözés alakulásával.

Ennek megfelelően két modellt építettem, az elsőben csak a bűnözés múltbeli alakulását figyelembe vevő változókat használtam, míg a második modellben már a társadalmi-gazdasági és demográfiai jellemzőket is bevontam. A két modell összehasonlítás azért is fontos, mert az előző fejezetekben tárgyalt modellek, amik csak a bűnözés időbeli alakulását használták fel, is jó előrejelzéseket adtak, így a demográfiai adatok hozzáadott értéke csak akkor mutatható ki, ha a második modell a korábbi bűnözési szint figyelembevétele mellett is javítja az előrejelzési teljesítményt.
Az értékelés során a korábban már ismertetett metrikákat használtam: RMSE, MAE, MAPE és Accuracy. Az eredményeket az alábbi táblázat foglalja össze:
#figure(
    caption: [Összesített modell eredményei],
    [
        #set text(size: 9pt)
        #pandas-table("Results/szocdem_vs_rollingmean_summary.csv")
    ]
) <summary_total_crime>

A táblázat alapján látható, hogy a társadalmi-gazdasági és demográfiai jellemzők bevonása javította az előrejelzés pontosságát, 88,74%-ról 90,14%-ra nőtt az Accuracy értéke. Tehát az új jellemzők hozzáadása valóban többletinformációt adott a modellnek, ugyanakkor a javulás mértéke nem volt ugrásszerű. Ennek oka lehet egyrészről, hogy a demográfiai tényezők csak lassan, általában hossazbb időszak alatt mutatnak jelentős változást, így a 2024-es évre vonatkozóan a becsült értékek nem térnek el jelentősen a 2023-as értékektől, másrészről pedig az idősoros jellemzők, mint például a lag-változók és a mozgóátlagok, már önmagukban is sok információt tartalmaznak, a modell már önmagában is viszonylag jó előrejelzést tud adni, így a további jellemzők hozzáadása ehhez képest már csak kisebb mértékben javítja a teljesítményt. További magyarázat lehet, hogy a 2024-es adatra a társadalmi-gazdasági és demográfiai jellemzők nem közvetlen megfigyelésből származnak, hanem becsült értékek, így ezek is hibával terheltek, ami csökkentheti a modell teljesítményét.

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em, // Kicsit szellősebb térköz

    // Első kép és esetleg alá egy kis belső felirat
    align(center)[
      #image("Images/Results_img/RF_2024_byCommunityArea_onlylagged_Results_scatter.png", width: 90%)
      *(a)* Csak idősoros jellemzőket használó modell előrejelzése 
    ],

    // Második kép
    align(center)[
      #image("Images/Results_img/RF_2024_byCommunityArea_laggedrolling_szocdem_Results_scatter.png", width: 90%)
      *(b)* Idősoros jellemzőket és társadalmi-gazdasági, demográfiai jellemzőket is használó modell előrejelzése
    ]
  ),
  caption: [Az előrejelzések és a tényleges adatok összehasonlítása szórásdiagramon]
)<összehasonlító_scatter>
Az ábrán is látható, hogy mindkét modell előrejelzései jól követik a tényleges aatokat, tehát a pontok nagy része a 45 fokos egyenes közelében helyezkedik el, iiletve az ábrán is látható, hogy a magasabb esetszámnál a társadlmi-gazdasági és demográfiai jellemzőket is tartalmazó modell előrejelzései jobban követik a tényleges adatokat.


#figure(
    caption: [A társadalmi-gazdasági és demográfiai jellemzőket \
     is tartalmazó modell feature importance értékei],
    [
        #image("Images/Results_img/RF_2024_byCommunityArea_laggedrolling_szocdem_Feature_importance.png" , width: 80%)
    ]
) <feature_importance>
Az @feature_importance ábra alapján látható, hogy a legfontosabb jellemzők között elsősorban a bűnözés múltbeli alakulását leíró változók szerepelnek, a társadalmi-gazdasági és demográfiai jellemzők közül pedig teljes népesség illetve a fiat férfiak aránya tűnik a legfontosabbnak.

==== Bűncselekménytípusok szerinti elemzés

Az összesített modell után a bűncselekménytípusok elemzésésvel folytattam. A típusonkénti modellben a célváltozó minden esetben a kiválasztott bűncselekménytípus éves esetszáma volt minden Community Area-ban. A modell célja elsősorban au volt, hogy vizsgáljam, hogy az egyes bűncselekménytípusok esetében milyen társadalmi-gazdasági és demográfiai tényezők lehetnek meghatározóak, illetve hogy ezek a tényezők mennyire járulnak hozzá a modell előrejelzési teljesítményéhez. Ennek megfelelően ebben a fejezetben nem használtam a mozgóátlagokat, hanem csak a demográfiai és társadalmi-gazdasági jellemzőket,hogy a modellek értelmezése során egyértelműen meg lehessen vizsgálni, hogy mely tényezők járulnak hozzá leginkább az előrejelzéshez.

A modellek értelmezéséhez minden típus esetében elkészítettem háromféle ábrát:
- _Feature importance_: Random Forest beépített feature importance értéke azt mutatja meg, hogy a döntési fák építése során az adott változó milyen mértékben járult hozzá a célváltozó jobb szétválasztásához
- _SHAP értékek_: Az adott bűncselekménytípus esetében a legfontosabb jellemzők SHAP értékei, amelyek megmutatják, hogy az egyes jellemzők milyen irányban és milyen mértékben befolyásolják a modell előrejelzését
- _Permutation importance_: Ennél a módszernél egy-egy változó értékeit véletlenszerűen összekeverjük, majd megvizsgáljuk, hogy ez mennyire rontja a modell teljesítményét. Ha egy változó összekeverése jelentősen növeli az előrejelzési hibát, akkor az azt jelzi, hogy a modell erősen támaszkodott erre a változóra.

Az eddigi fejezetektől eltérően itt a modelll értékeléséhez WMAPE-t (Weighted Mean Absolute Percentage Error) használtam, mivel az egyes bűncselekménytípusok esetszáma nagyon eltérő lehet. Egy gyakori bűncselekménytípus, például a lopás esetében sokkal nagyobb esetszámok jelennek meg, míg ritkább típusoknál bizonyos Community Area-kban akár nagyon alacsony vagy nulla értékek is előfordulhatnak. Ilyen esetekben a hagyományos MAPE használata problémás lehet, mert az minden megfigyelésnél külön-külön oszt a tényleges értékkel. Ha a tényleges érték nagyon kicsi, akkor már egy kisebb abszolút hiba is aránytalanul nagy százalékos hibát eredményezhet, nulla érték esetén pedig a MAPE nem is értelmezhető.
$
"WMAPE" = (sum_(i=1)^n |y_i - hat(y)_i|) /(sum_(i=1)^n |y_i|)*100
$

A típusonkénti elemzés során minden bűncselekménykategóriánál külön értelmeztem az ábrákat. Elsőként a feature importance alapján megvizsgáltam, mely változók kapták a legnagyobb súlyt a modellben. Ezt követően a permutation importance eredményeivel ellenőriztem, hogy ezek a változók valóban hozzájárultak-e a modell prediktív teljesítményéhez. Végül a SHAP-ábrák segítségével részletesebben elemeztem, hogyan hatottak a legfontosabb változók az előrejelzett bűncselekményszámokra.

===== Lopás

A leggyakarabb bűncselekménytípus a lopás volt. Az alábbi ábrák a lopás esetében mutatják be a feature importance értékeket, a permutation importance eredményeit és a SHAP értékeket:
#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em, // Kicsit szellősebb térköz

    // Első kép és esetleg alá egy kis belső felirat
    align(center)[
      #image("Images/Results_img/RF_2024_by_THEFT_szocdem_Feature_importance.png", width: 90%)
      *(a)* Lopás esetében a feature importance értékek
    ],

    // Második kép
    align(center)[
      #image("Images/Results_img/RF_2024_by_THEFT_szocdem_permutation_importance.png", width: 90%)
      *(b)* Lopás esetében a permutation importance értékek
    ]
  ),
  caption: [Lopás esetében a feature importance és permutation importance értékek összehasonlítása]
)<összehasonlító_scatter>

#figure(
    caption: [Lopás esetében a feature importance értékek],
    [
        #image("Images/Results_img/RF_2024_by_THEFT_szocdem_shap_summary.png" , width: 80%)
    ]
) <theft_feature_importance>                                                                                                                                                                                                                                                                                                                                                                                                                                       
