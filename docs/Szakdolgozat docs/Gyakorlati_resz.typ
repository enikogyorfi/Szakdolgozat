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
#codly(
languages: (
 py: (

 name: [Python], color: green),))
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

== Bűnözés időbeli modellezése geometriai Brown-mozgással

Ebben a fejezetben a bűnözés időbeli alakulását modellezem geometriai Brown-mozgással. A felépített modell alapját Julia Calatayud és tárasi (@calatayud2023) 2023-ban megjelent tanulmánya adja, amelyben a bűnözés időbeli alakulását sztochasztikus differenciálegyenletekkel modellezték. A szerzők a spanyolországi Valencia város bűnözési adatait vizsgálták geometriai Brown-mozgás segítségével, de az általuk javasolt módszertan alkalmazható más városok, így Chicago bűnözési adatainak modellezésére is. A következőkben bemutatom hogyan készítettem elő az adatokat és hogyan határoztam meg a geometriai Brown-mozgás paramétereit, majd a modell segítségével előrejelzéseket készítek a bűnözés alakulására vonatkozóan.

=== Adatok előkészítése

Elsőként, hogy a modellt alkalmazni tudjam, a nyers adatokat megfelelő térbeli és időbeli felbontásra kellett hozni. Ahogy az @buneset_suruseg_terkep is mutatja, a bűnözési mintázat jelentős eltéréseket mutat a városon belül, ezért az előrejelzéseket kerültenként készítem el (a 21-es és 31-es kerületre nem állt rendelkezésre elég információ, így azokat az elemzés során nem vettem figyelembe). Az időbeli felbontáshoz először minden körzetre és évre kiszámoltam a havi bűncselekmények számát, majd ebből az adatból kiszámoltam a bűncselekmények napi átlagos számát, így figyelembe tudtam venni, hogy az egyes hónapok különböző hosszúságúak. Tanító adathalmazatként a 2001 és 2024 közötti időszakot, míg teszt adatként 2025 január és augusztus közötti időszakot használtam. Illetve még az adatelőkészítés során eltávolítottam azokat az oszlopokat amelykre nem lesz szükség a modellépítés során, például a bűncselekmények pontos helyét jelző földrajzi koordinátákat, illetve a bűncselekmények típusát jelző oszlopokat is, mivel ezek nem relevánsak a bűnözés időbeli alakulásának modellezése szempontjából.

=== Paraméterek meghatározása

Elsőként a szimuláció alapparamétereit határoztam meg, ezek a következők voltak:
- _dt_: A szimuláció időlépése, amelyet 1 hónapra állítottam be, mivel a bűnözési adatokat havi szinten aggregáltam.
- _T_: A szimuláció teljes időtartama, amely az én esetemben 8 hónap volt, mivel a teszt adatok 2025 január és augusztus közötti időszakot ölelik fel.
- _N_: A szimuláció lépéseinek száma, amelyet a teljes időtartam és az időlépés alapján számoltam ki, így $N =T/("dt")$
- _$S_0$_: A szimuláció kezdeti értéke, amely minden körzetre a 2024 decemberében elkövetett bűncselekmények napi átlagos számát jelenti, mivel ez az utolsó ismert adatpont a tanító adathalmazatban.
- _t_: A szimuláció időtengelye, amely tartalmazza a szimuláció minden időpontját a kezdeti időponttól a teljes időtartam végéig, az időlépésnek megfelelően.
Majd ezt követően meghatároztam a geometriai Brown-mozgás paramétereit, amelyek a következők voltak:
- _μ_: A drift paraméter, amely a bűnözés hosszú távú trendjét jelenti. Ezt a paramétert minden körzetre külön-külön határoztam meg. Ehhez kiszámoltam a 2001 és 2024 közötti időszakban az egymást követő hónapok közötti relatív változást minden körzetre:
 $
 R=(S_(t+1)-S_t)/S_t
 $
 ahol $S_t$ a bűncselekmények napi átlagos száma egy adott körzetben a t-edik hónapban. Ezután kiszámoltam ezen relatív változások átlagát minden körzetre, és ezt az értéket használtam a drift paraméterként.
- _σ_: A volatilitás paraméter, amely a bűnözés rövid távú ingadozásait jelenti. Ezt a paramétert szintén minden körzetre külön-külön határoztam meg. A $sigma$ kiszámolásához is a relatív változásokat használtam, de ezúttal a szórásukat számoltam ki minden körzetre, és ezt az értéket használtam a volatilitás paraméterként.
Minden körzetre két lehetséges szcenáriót szimuláltam, úgy, hogy minden körzetre és minden időpontra generáltam egy véletlenszerű számot a standard normális eloszlásból. Ezután a sztochasztikus paraméter meghatározásához mindenkét szcenárióban vettem a véletlen számok kommulált összegét és így kaptam meg a _$W$_ paramétert. Végül a szimulációt a következő képlettel hajtottam végre minden körzetre és minden időpontra:
 $
 S_(t+1)=S_0*exp((μ-σ^2/2)*("dt")+σ*sqrt("dt")*W_t)
 $
 ahol $S_0$ a szimuláció kezdeti értéke, $μ$ a drift paraméter, $σ$ a volatilitás paraméter, $("dt")$ az időlépés, és $W_t$ a sztochasztikus paraméter.

=== Eredmények és értékelés

A szimuláció eredményeként minden körzetre és minden időpontra két lehetséges szcenáriót kaptam, az @geom_brown_simulation_results_1_kerulet az első körzetre kapott előrejelzéseket mutatja be a két szcenárióban.
#figure(
    caption: [Az első körzetre kapott előrejelzések a két szcenárióban],
    [
        #set text(size: 9pt)
        #pandas-table("Results/predicted_df.csv")
        
    ]
) <geom_brown_simulation_results_1_kerulet>

Ahhoz, hogy ezeket a szcenáriókat értékelni tudjam, összehasonlítottam őket a teszt adatokkal, amelyek 2025 január és augusztus közötti időszakot ölelik fel. A @geom_brown_simulation_results_1_kerulet_actual_vs_predicted  mutatja a tényleges bűncselekmények napi átlagos számát a teszt időszakban, valamint a két szcenárióban kapott előrejelzéseket.

#figure(
    image("Images/Results_img/prediction_plot.png", width: 65%),
    caption: [Tényleges bűncselekmények napi átlagos száma a teszt időszakban és a két szcenárióban kapott előrejelzések],
) <geom_brown_simulation_results_1_kerulet_actual_vs_predicted>

Már az ábra alapján is látható, hogy a két szcenárióban kapott előrejelzések jelentős eltéréseket mutatnak, ami a sztochasztikus paraméter véletlenszerűségéből adódik. Az ábra alapján leolvasható, hogy a  második szcenárióban kapott előrejelzések közelebb állnak a tényleges adatokhoz. Ez azt jelzi, hogy a geometriai Brown-mozgás érzékeny a sztochasztikus paraméter értékére, ezért fontos lehet több szcenáriót is szimulálni, hogy jobban megértsük a bűnözés időbeli alakulásának bizonytalanságát. A két szcenárió összehasonlításáshoz kiszámoltam az RMSE (Root Mean Square Error) értékét minden körzetre.
$
"RMSE" = sqrt(sum_(i=1)^(n)(y_i - (hat(y))_i)^2)
$
így számszerűsíteni tudtam a két szcenárió előrejelzéseinek pontosságát. Az RMSE értékek alapján a második szcenárióban kapott előrejelzések a 25. körzet kivételével minden körzetben alacsonyabb RMSE értéket mutattak, ami megerősíti azt a megfigyelést, hogy a második szcenárióban kapott előrejelzések közelebb állnak a tényleges adatokhoz. Az első körzet esetén a @geom_brown_simulation_results_1_kerulet_rmse mutatja a két RMSE értéket.
#figure(
    image("Images/Results_img/rmse_plot.png", width: 75%),
    caption: [Az első körzet esetén a két szcenárió RMSE értékei],
   ) <geom_brown_simulation_results_1_kerulet_rmse>

Az eredmények összefoglalását az alábbi táblázat mutatja:

#figure(
    caption: [Az eredmények összefoglalása],
    [
        #set text(size: 9pt)
        #pandas-table("Results/overall_metrics.csv")
        )
    ]
) <geom_brown_simulation_results_rmse_table>
A táblázat alapján látható, hogy a modell 93,08%-os pontosággal (Accuracy) tudta előrejelezni a bűnözés alakulását a teszt időszakban, ami azt jelzi, hogy a geometriai Brown-mozgás jól alkalmazható a bűnözés időbeli modellezésére. Az RMSE és MAE (mean absolute error) értékek alapján is jól teljesített a modell, ezek az értékek azt mutatják, hogy a modell által előrejelzett értékek nem sehol nem térnek el kiugóan a tényleges értékektől.

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em, // Kicsit szellősebb térköz

    // Első kép és esetleg alá egy kis belső felirat
    align(center)[
      #image("Images/Results_img/gbm_predicted_heatmap.png", width: 90%)
      *(a)* Előrejelzés hőtérképen
    ],

    // Második kép
    align(center)[
      #image("Images/Results_img/gbm_actual_heatmap.png", width: 90%)
      *(b)* Tényleges adatok hőtérképen
    ]
  ),
  caption: [Az előrejelzés és a tényleges adatok összehasonlítása hőtérképen],
) <osszehasonlito-abra>
A @osszehasonlito-abra alapján is látható, hogy a két hőtérkép hasonló mintázatot mutat, látható, hogy a modell mind a kisebb  mind a nagyobb esetszámú területeket jól azonosította, ami azt jelzi, hogy a modell képes volt megragadni a bűnözés nemcsak időbeli, de térbeli mintázatát is.

#figure(
    image("Images/Results_img/gbm_difference_heatmap.png" , width: 40%),
    caption: [Az előrejelzés és a tényleges adatok közötti különbség hőtérképen],       
) <gbm_difference_heatmap>
 Hogy vizuálisan is látható legyen a különbség a két hőtérkép között, készítettem egy külön hőtérképet, amely az előrejelzés és a tényleges adatok közötti különbséget mutatja be. A @gbm_difference_heatmap alapján látható, hogy a különbségek nagy része kisebb értékek körül helyezkedik el, de megfiygelhető, hogy egy kiugró körzet (19-es), ahol az abszolút hiba magasabb, 7 körüli érték.
 
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
```py
def year_indexing(df):
    df['Year_Index'] = 2025 - df['Year'] + 1
    return df

def prepare_month_data(df, col):
    df[col] = df[col].astype(float)
    df[f"{col}_Sin"] = df[col].apply(lambda x: (np.sin(((x-1) * 2 * np.pi / 12)+0.5)+1)/2)
    df[f"{col}_Cos"] = df[col].apply(lambda x: (np.cos(((x-1) * 2 * np.pi / 12)+0.5)+1)/2)
    df['Is_Winter'] = df['Month'].isin([12, 1, 2]).astype(int)
    df['Is_Summer'] = df['Month'].isin([6, 7, 8]).astype(int)
    df = year_indexing(df)
    return df
```

Továbbá mivel a bűnözés jövőbeli rátája egy kerületben nagymértékben függ az elmúlt időszakok tendenciáitól és a hónapok kinyerése és átalakítása segít a szezonalitás modellezésében, de nem képes megragadni a folyamatos időbeli trendet. Tehát, hogy a Random Forest modellt hatékonyan tudjam alkalmazni idősorok elmzésére, az adatelőkészítés során úgynevezett késleltetett változókat (lag features) is létrehoztam. Ezek a változók a bűncselekmények napi átlagos számát tartalmazzák az előző hónapokban minden körzetre vonatkozóan. Tehát így a modell képes lesz emlékezni a múltbeli értékekre.
```py
def create_lagged_features(df, col, lag=1):
    df_lagged = df.copy()
    for i in range(1, lag + 1):
        df_lagged[f'{col} Lag {i}'] = df_lagged.groupby('District')[col].shift(i)
    return df_lagged
```
\

A lag változók létrehozása mellett a múltbeli értékekből kiszámolt mozgóátlagot és mozgószórást is hozzáadtam az adatokhoz, hogy egy-egy kiugró érték ne befolyásolja túlzottan a modellt és hogy a modell a mozgószórás értékek alapján meg tudja ragadni a bűnözés ingadozásait.
```py
def rolling_mean(df, idopontok):
    for i in idopontok:
        df[f'Rolling Mean {i}'] = (df.groupby('District')['Number of Crimes Per Day']
            .rolling(window=i)
            .mean()
            .shift(1)
            .reset_index(0, drop=True)
                                   )
    return df

def rolling_std(df, idopontok):
    for i in idopontok:
        df[f'Rolling Std {i}'] = (df.groupby('District')['Number of Crimes Per Day']
                                  .rolling(window=i)
                                  .std()
                                  .shift(1)
                                  .reset_index(0, drop=True)
                                  )
    return df
```
=== Modellépítés

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
A Random Forest modell nem hónaponként készítette el az előrejelzést, hanem egyszerre, a 8 hónapra vonatkozóan. Így a modell egy adott időpont és kerület alapján egy teljes előrejelzési horizontot állított elő. Ennek előnye, hogy a több hónapra vonatkozó becslések egyszerre készülnek el, vagyis a modell nem kényszerül arra, hogy minden újabb hónap előrejelzéséhez az előző saját becslését használja fel. Ez csökkentheti a hibák továbbterjedését, amely a szekvenciális előrejelzéseknél gyakran problémát jelent.




== Bűnözést befolyásoló demográfiai tényezők elemzése és előrejelzés készítése