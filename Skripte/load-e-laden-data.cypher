// # Setze Filename als Parameter
:param filename => 'file:/E-Laden-Data.csv';

// Lade Graph Knoten zuerst

// Anbieter Knoten
LOAD CSV WITH HEADERS FROM $filename AS line FIELDTERMINATOR ';'
WITH line.AnbieterID AS anbId, line.Anbieter AS anb, line.Web AS web
CREATE (a:Anbieter{anbieterId: anbId})
SET a.nameAnbieter = anb, a.webSeite = web
RETURN count(a);

// Tarif / Roaming + Abrechnung Knoten (wenn Roamingkosten verfügbar) anlegen
LOAD CSV WITH HEADERS FROM $filename AS line FIELDTERMINATOR ';'
WITH line.AnbieterID AS anbId,line.Tarif AS tarif, line.Roaming AS roampartner, tofloat(line.Grundgebuehr) AS grund, tofloat(line.Zusatzgebuehr) AS zusatz, tofloat(line.kwAC) AS kwac, tofloat(line.kwDC) AS kwdc, tofloat(line.rkwAC) as rkwac, tofloat(line.rkwDC) as rkwdc, line.Zahlungszyklus AS zyk, line.Zahlungsart AS zart
WHERE rkwac <> 0.0
CREATE (t:Tarif:Roaming)
SET t.nameTarif = tarif, t.roamingPartner = roampartner, t.grundGebuehr = grund, t.zusatzGebuehr = zusatz, t.kwPreisAC = kwac, t.kwPreisDC = kwdc, t.rkwPreisAC = rkwac, t.rkwPreisDC = rkwdc
CREATE (ab:Abrechnung)
SET ab.zyklus = zyk, ab.zahlungsArt = zart
CREATE (t)-[:WIRD_ABGERECHNET]->(ab)
WITH t, ab, anbId
MATCH (an:Anbieter {anbieterId: anbId})
CREATE (an)<-[:ANGEBOTEN_VON]-(t)
RETURN count(t);

// Tarif + Abrechnung Knoten ohne Roaming anlegen
LOAD CSV WITH HEADERS FROM $filename AS line FIELDTERMINATOR ';'
WITH line.AnbieterID AS anbId, line.Tarif AS tarif, line.Roaming AS roampartner, tofloat(line.Grundgebuehr) AS grund, tofloat(line.Zusatzgebuehr) AS zusatz, tofloat(line.kwAC) AS kwac, tofloat(line.kwDC) AS kwdc, tofloat(line.rkwAC) as rkwac, tofloat(line.rkwDC) as rkwdc, line.Zahlungszyklus AS zyk, collect(line.Zahlungsart) AS zart
WHERE rkwac = 0.0
CREATE (t:Tarif)
SET t.nameTarif = tarif, t.roamingPartner = roampartner, t.grundGebuehr = grund, t.zusatzGebuehr = zusatz, t.kwPreisAC = kwac, t.kwPreisDC = kwdc
CREATE (ab:Abrechnung)
SET ab.zyklus = zyk, ab.zahlungsArt = zart
CREATE (t)-[:WIRD_ABGERECHNET]->(ab)
WITH t, ab, anbId
MATCH (an:Anbieter {anbieterId: anbId})
CREATE (an)<-[:ANGEBOTEN_VON]-(t)
RETURN count(t);

// Länder laden
LOAD CSV WITH HEADERS FROM $filename AS line FIELDTERMINATOR ';'
WITH line.Tarif as tarif, reduce(a=[], v in split(line.Laender,',')| a + [trim(v)]) AS laender
MATCH (t:Tarif)
WHERE t.nameTarif = tarif
MERGE (t)-[:VERFUEGBAR_IN]->(l:Land)
ON CREATE SET l.laender = laender
RETURN count(l);

:param filename => 'file:/E-Laden-Data_Saeulen.csv';

// Ladesäulen anlegen und Relationships mit Anbieter / Tarif anlegen
LOAD CSV WITH HEADERS FROM $filename AS line FIELDTERMINATOR ';'
WITH line.AnbieterID as aid, line.saeulenID as sid, line.ladenAC AS lac, line.ladenDC AS ldc, tofloat(line.Lokation1) AS geoloc1, tofloat(line.Lokation2) AS geoloc2, line.Zugangsart AS zugang
MATCH (an:Anbieter)
WHERE an.anbieterId = aid
MERGE (an)-[:HAT_SAEULE]->(ls:Ladesaeule {lsId: sid})
ON CREATE SET ls.ladenAC = toboolean(lac), ls.ladenDC = toboolean(ldc), ls.geoLoc = point({latitude: geoloc1, longitude: geoloc2}), ls.zugang = zugang
RETURN count(an);

:param filename => 'file:/E-Laden-Data.csv';

// Anlegen der Relationship Tarif zur Säule
LOAD CSV WITH HEADERS FROM $filename AS line FIELDTERMINATOR ';'
WITH line.AnbieterID as aid, line.Tarif AS tarif
MATCH (an:Anbieter)-[:HAT_SAEULE]->(ls:Ladesaeule)
WHERE an.anbieterId = aid
MATCH (t:Tarif {nameTarif: tarif})
MERGE (t)-[:LADEN_AN]->(ls)
RETURN count(an);
