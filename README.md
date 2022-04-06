# IT-Novum Webinar 7. April 2022 Demo

Demo Daten und Skripte vom IT Novum Seminar - Ich sehe was, was du nicht siehst - Graph Datenbanken

### Verzeichnisse:

Daten --> Enthält die Anbieter Daten und die Daten für die Ladesäulen. Die Daten für die Ladesäulen sind generiert, drum teilweise über die Welt verstreut. Sie dienen nur, um die Nutzung von Geo-Koordinaten zu zeigen.

Skripte --> Enthält das Loading Skript und die Queries, welche die Fragen des im Webinar gezeigten Business Case beantworten.

Dashboard --> NeoDash Dashboard welche im Webinar gezeigt wurde. Das Dashboard kann über die Import Funktion in [NeoDash](https://neo4j.com/developer-blog/neodash-2-0-a-brand-new-way-to-visualize-neo4j) importiert und genutzt werden.

### Vorgehen, um die Demo vom Webinar nachzustellen

1. Installiere [Neo4j Desktop](https://neo4j.com/download/) oder nutze unseren freien SaaS Service [AuraDB Free](https://neo4j.com/cloud/aura/?ref=get-started-dropdown-cta)
2. Weiteres Vorgehen mit Neo4j Desktop -- > Lege ein Projekt und darin eine leere Datenbank an. Den Namen kannst du frei wählen.
3. Öffne den Neo4j Browser und wähle die leere Datenbank aus.
4. Kopiere die beiden Daten Files in das **import** Verzeichnis des Projekts. Das Verzeichnis öffnet man über die drei Punkte hinter dem Open Button im Neo4j Desktop Fenster und selektiert dort Open Folder --> Import. Dann geht ein Fenster auf, was direkt auf das import Verzeichnis zeigt. Dort kann man die Dateien ablegen.
5. Nun kann man das Load-Skript öffnen und den gesamten Inhalt per Copy&Paste im Browser ausführen. Das Skript erwartet die Daten im import Verzeichnis, drum die Vorarbeit in Schritt 4.
6. Sobald die Daten geladen sind, kann man die einzelnen Queries des Query-Skipt-Files ausprobieren.

Um das Dashboard in NeoDash installieren zu können, muss man dies im Neo4j Desktop erst installieren. Mehr dazu in der Hilfe oder auf der oben verlinkten Webseite.

Viel Spaß beim Ausprobieren.
