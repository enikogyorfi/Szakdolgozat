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
  caption: [Chicago bűnügyi adatok (minta)],
  [
    #set text(size: 9pt)
    #table(
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
    )
  ]
)
#figure(
  image("Images/EDA/major_crimes_chicago.svg", width: 80%),
  caption: [Chicago bűnesemények típusai és gyakorisága]
)<buneset_tipusok_chicago>

A @buneset_tipusok_chicago a Chicagoban elkövetett bűnesetek típusait és azok gyakoriságát mutatja be 2001 és 2025 között. A leggyakoribb bűncselekménytípusok közé tartozik a lopás (THEFT, több mint 1,7 millió eset), a testi sértés (BATTERY, több mint 1,5 millió eset)  illetve fontos lehet még kiemelni a kábítószerrek kapcsolatos bűncselekmények magasabb számát is (NARCOTICS, több mint 700 ezer eset). Ezek az adatok fontosak lehetnek a bűnmegelőzési stratégiák kialakításához és a későbbi elemzések során vizsgálhatjuk azt is, hogy ezek a bűncselekménytípusok hogyan változnak időben és térben, valamint milyen demográfiai tényezők befolyásolják előfordulásukat.

#figure(
  image("Images/EDA/buneset_suruseg_terkep.png", width: 60%),
  caption: [Chicago bűnözési sűrűségének térképe])<buneset_suruseg_terkep>
A @buneset_suruseg_terkep a rendőri körzeteket mutatja Chicagoban a bűnözési sűrűség alapján színezve. Azonosíthatóak azok a kerületek, amik a leginkább érintettek, ezek a térképen a sötétebb színnel vannak jelölve. 

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
A @buneset_havi_alakulasa és a @buneset_havi_alakulasa_osszesitett a bűncselekmények havi alakulását mutatja be. A @buneset_havi_alakulasa alapján látható a bűnözés éven belüli szezonális mintázata, jellemzően a nyári hónapokban a legmagasabb a bűncselekmények száma, míg a téli hónapokban egy jelentős csökkenés figyelhető meg. Bár a bűnözés csökkenő trndet mutata a 2001 és 2025 közötti időszakban, a szezonalitás továbbra is megfigyelhető. Ezeket a megfigyeléseket számszerűsíti a @buneset_havi_alakulasa_osszesitett, itt is megfigyelhető, hogy valóban a nyári hónapokban a legmagasabb a bűncselekmények száma, míg ez a szám a téli hónapokra csökken