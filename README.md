# photoScript
 
## Einleitung

Das photoScript ist eine Sammlung von Scripten, welche ich für mich erstellt habe, um mir das verwalten meiner photos (ca. 60.000 in 15 Jahren) in Apple Photos zu verwalten. Insbesondere auch GPS Daten hinzuzufügen und in andere Ordner zuverschieben. Das Script ist auf mich angepasst, lässt sich aber natürlich an eigene Bedürfnisse anpassen.

Vielen Dank insbesondere an https://discussions.apple.com/profile/léonie - seine Beiträge haben mich sehr inspiriert und geholfen mein Script umzusetzen!

## Installieren

### Script/Programm erstellen

### in Photos über Automator einbinden

## Übersicht über die Scripte

### Voraussetzung

Vor dem Start der Scripte müssen immer alle Fotos selektiert sein, auf die das Script angewendet werden soll.

### In Album kopieren

Dieses Script ermöglicht es eine bliebig lange Liste an Alben zu definieren. Es können mehrere Alben selektiert werden. Alle selektierten Photos werden dann in das entsprechende Album kopiert.

Die Definition der Alben erfolgt in Zeile 2 des Scriptes. Das Album muss immer in folgender Form angegeben werden:

```
set theAlbumChoices to {"Familie und Kinder/Kinder", "Familie und Kinder/Ausflüge/Verschiedene Ausflüge", "Haus und Garten/Garten", "Haus und Garten/Haus", "Haustiere/Aquarium", "Haustiere/Hamster", "Haustiere/Kaninchen", "Haustiere/Katze", "! Wartungsalben/! ToDo", "Essen und Grillen", "Dias zum sortieren", "! Wartungsalben/! Test"}
```

Alle hier angegebenen Ordner werden beim Start des Scriptes angeboten Dabei muss die Angabe jeweils wie folgt erfolgen:

```
Ordner/Ordner/Ordner/Album
```
liegt das Album auf Rootebene, dann:
```
Album
```
Der Pfad kann beliebig viele Ebenen haben (zumindest aus Sicht meines Scriptes)

### In Album kopieren über auswählen/erstellen

Es wird eine Auswahl angeboten, in der durch die Alben navigiert werden kann (nur vorwärts aktuell). Die gewählten Fotos werden dann in das gewählte Album kopiert (es kann nur ein Album gewählt werden). Es können direkt im Script Ordner und Alben angelegt werden! Wird ein Album angewählt, wird es direkt als Ziel ausgewählt.

### Titel einfügen

Alle selektierten Fotos bekommen einen fortlaufenden Titel in der Form:

```
Titel yyyy-mm-tt ####
```
wobei
yyyy = Jahr, mm = Monat, tt = Tag, #### = fortlaufende Nummer

### Beschreibung einfügen

Ermöglicht es eine Beschreibung anzugeben. Diese kann die bestehende Beschreibung ersetzen oder kann vor die bestehende Beschreibung gesetzt werden

D.h. bei ergänzen wird aus
Bild 1
```
Petter Solberg im Subaru
```
Bild 2
```
Markus Grönholm im Ford Focus
```

wird mit der Beschreibung `WRC Rallye Deutschland 2006`
```
WRC Rally Deutschland 2006 Petter Solberg im Subaru
```
```
WRC Rally Deutschland 2006 Markus Grönholm im Ford Focus
```

bei Ersetzen würde die bestehende Beschreibung komplett ersetzt

### Schlagwörter ergänzen

Es können Schlagwörter in der Form
```
Katze,Kaninchen,Fische,Hamster
```
angegeben werden. Es kann ausgewählt werden, ob die bestehenden Schlagwörter ersetzt oder ergänzt werden können.

### GPS Daten hinzufügen

Das war mein erstes Script und ist mein Favorit ... es gibt 2 Funktionen.

#### GPS Koordinaten hinterlegen

Im Script können in Zeile 5 GPS Favoriten hinterlegt werden.
set myLocations to {{"Clipboard", 0, 0}, {"Brandenburger Tor", 52.5164, 13,3780}, {"Piccaddily Circus", 51.5101, -0.1344}, {"Eifelturm", 48.8580, 2.2947}}

Dies erfolgt immer in der Form:
{"Brandenburger Tor", 52.5164, 13,3780}

Hier können Sie Orte hinterlegen an denen Sie regelm. fotografieren (Ihr Haus, Ihr Garten, der Sportplatz,...). Bei Aufruf des Scriptes und Auswahl der Lokation werden die Koordinaten für alle Fotos übernommen

**WICHTIG** bitte löschen Sie den Eintrag Clipboard nicht, den brauchen Sie noch!

#### Auswahl Clipboard

Hier können Sie eine URL aus Apple Maps übergeben und zwar wie folgt:


, "Kopiere GPS auf anderes Foto", "--- Datum bearbeiten ---", "Kopiere Datum auf anderes Foto", "Datum aus Dateiname", "--- Konvertieren ---", "AVI nach mp4 konvertieren", "TIFF/PSD nach jpg konvertieren", "--- Alben suchen ---", "Zeige weitere Alben", "--- Sortieren ---", "Nach Jahren sortieren", "Nach Dateigröße sortieren"}

## Bekannte Probleme
