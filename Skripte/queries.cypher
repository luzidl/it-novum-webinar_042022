// Einfach:
//
// Welche Anbieter gibt es?
MATCH (an:Anbieter)
RETURN an.nameAnbieter AS Anbieter;

// Welche Tarife gibt es?
MATCH (t:Tarif)
RETURN t.nameTarif AS Tarif;

// Zusatz: Welcher Anbieter hat welchen Tarif?
MATCH (an:Anbieter)-[:ANGEBOTEN_VON]-(t:Tarif)
RETURN an.nameAnbieter AS Anbieter, t.nameTarif AS Tarif;

// Was kostet eine KWh in Deutschland?
MATCH (t:Tarif)
RETURN t.nameTarif AS Tarif, t.kwPreisAC AS `€ AC für D`, t.kwPreisDC AS `€ DC für D`;

// Welche Abrechnungsvarianten gibt es?
MATCH (ab:Abrechnung)
RETURN DISTINCT ab.zyklus AS `Abrechnungsarten`;

// Komplexer:
//
//Zusatz: Welche Abrechnungsvariaten gibt es bei welchem Anbieter?
MATCH (ab:Abrechnung)<-[:WIRD_ABGERECHNET]-(:Tarif)-[:ANGEBOTEN_VON]-(an:Anbieter)
RETURN ab.zyklus AS `Abrechnungsarten`, an.nameAnbieter AS `Anbieter`;

// Welche Anbieter decken welche Länder ab und wie sind die Roaming Preise?
MATCH (an:Anbieter)-[]-()-[]-(l:Land)
RETURN an.nameAnbieter, l.laender;

MATCH (an:Anbieter)-[:ANGEBOTEN_VON]-(t:Tarif)-[:VERFUEGBAR_IN]-(l:Land)
RETURN an.nameAnbieter AS `Anbieter`, l.laender AS `Verfügbare Länder`, t.rkwPreisAC AS `Roaming Preis AC`, t.rkwPreisDC AS `Roaming Preis DC`;


// Welche Ladesäulen finde ich in meiner Umgebung von Anbieter X?
// e.g. Karlsruhe
// ll: 8.451529 49.001650
// ur: 8.462568 49.005226
WITH point({longitude: 49.001650, latitude: 8.451529}) AS lowerLeft, point({longitude: 49.005226, latitude: 8.462568}) AS upperRight
MATCH (an:Anbieter)-[:HAT_SAEULE]->(s:Ladesaeule)
WHERE point.withinBBox(s.geoLoc, lowerLeft, upperRight)
RETURN an.nameAnbieter AS `Anbieter`, s.geoLoc AS `Lokation`;














AuraFree --> BU0A3RADWXrUHPSNXVUwWXVcO04sShkNjEv1AOUKJsc