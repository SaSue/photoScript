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




", "In Album kopieren über auswählen/erstellen", "--- Meta Daten bearbeiten ---", "Titel einfügen", "Beschreibung einfügen", "Schlagwörter ergänzen", "--- GPS Daten bearbeiten ---", "GPS Daten hinzufügen", "Kopiere GPS auf anderes Foto", "--- Datum bearbeiten ---", "Kopiere Datum auf anderes Foto", "Datum aus Dateiname", "--- Konvertieren ---", "AVI nach mp4 konvertieren", "TIFF/PSD nach jpg konvertieren", "--- Alben suchen ---", "Zeige weitere Alben", "--- Sortieren ---", "Nach Jahren sortieren", "Nach Dateigröße sortieren"}

## Bekannte Probleme
