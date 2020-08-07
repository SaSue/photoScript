# photoScript

## Einleitung

Das photoScript ist eine Sammlung von Scripten, welche ich für mich erstellt habe, um mir das Verwalten meiner photos (ca. 60.000 in 15 Jahren) in Apple Photos zu vereinfachen. Insbesondere um: GPS Daten hinzuzufügen, Bilder in andere Ordner zu kopieren und Schlagwörter anzupassen - und das möglichst alles per Tastatur. Das Script ist auf mich zugeschnitten, lässt sich aber natürlich an eigene Bedürfnisse anpassen.
Das Script ist auch Spielwiese für mich, GitHub kennenzulernen und etwas auszuprobieren.

Alle Infos findet Ihr hier:
https://github.com/SaSue/photoScript

Gern eröffnet ein Ticket wenn Ihr Probleme habt oder etwas nicht funktioniert. Ich schaue es mir an. Aber wie gesagt: Es ist mein Hobby ... daher kann es manchmal auch dauern.

Ihr wollt mich unterstützen oder euch bedanken: Gern! Hier ein anonymer Moneypool bei Paypal, ich freue mich über jeden Cent Beitrag!
https://paypal.me/pools/c/8qE1Jd37Lq

Oder Ihr helft einfach mit.

Vielen Dank insbesondere an https://discussions.apple.com/profile/léonie - seine Beiträge haben mich sehr inspiriert und geholfen mein Script umzusetzen!

## Installieren

Das Script ist schnell implementiert... also los gehts ...

### Script/Programm erstellen

Startet den Applescript Editor und erstellt ein neues Script. Kopiert das Script in den Editor und speichert es als Dateityp Programm in eurem Programmordner .... Thats all ... also fast ...

### Aufruf

Selektiert eure Photos und Startet das Programm aus dem Programmordner. Es geht aber auch noch einfacher.

### in Photos über Automator einbinden

Ihr könnt das Script über den Automator aber auch direkt einbinden:
https://support.apple.com/de-de/guide/automator/aut4bb6b2b4f/mac
bzw.
https://apple.stackexchange.com/questions/175215/how-do-i-assign-a-keyboard-shortcut-to-an-applescript-i-wrote

Ist das Vorgehen erklärt. Ihr könnt dann sogar einen Shortcut hinterlegen, mit dem Ihr das Script aus Photos aufruft, nachdem Ihr die zu bearbeitenden Fotos markiert habt.

### Updates

Siehe installieren, beachtet aber bitte, dass Ihr eure Lokations und Ordnerfavoriten in Zeile 1-5 nicht überschreibt. Diese Zeilen einfach **nicht** austauschen. (also auch nicht danach setzen, sonst überschreibt ihr die Variable)

## Limitations

1. Das Script funktioniert nicht in intelligenten Alben. Dies ist kein Bug des Scripts sondern eine Einschränkung Apples
2. Ordner und Alben dürfen kein / im Namen haben (gilt für die meisten Scripte, für alle die mit Ordner/Alben arbeiten). Auch das ist aktuell dem geschuldet, dass AppleScript sehr eingeschränkt ist und ich mit Strings und deren Aufsplitten arbeiten muss
3. Größenangaben können etwas abweichen von der Anzeige in Fotos. Ich rechne mit 1024, Apple scheint mit 1000 zu rechnen ... 
4. Das Script ist privat bei mir entstanden - ich bin Hobby Programmierer ... daher ist die Doku, das Logging des Scripts, die Codekommentierung und leider auch das Fehlerhandling ausbaufähig. Es kann daher sein, dass nicht alle Fehler abgefangen werden und das Script nicht 100% zu euren Bedürfnissen passt. Feel free to open a ticket: https://github.com/SaSue/photoScript/issues - ich schaue mir es auf jeden Fall an und evtl. kann ich etwas machen
5. Bekannte Bugs: Siehe 4. ... alle auf GitHub zu finden.

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
```
set myLocations to {{"Clipboard", 0, 0}, {"Brandenburger Tor", 52.5164, 13,3780}, {"Piccaddily Circus", 51.5101, -0.1344}, {"Eifelturm", 48.8580, 2.2947}}
```
Dies erfolgt immer in der Form:
`{"Brandenburger Tor", 52.5164, 13,3780}`

Hier können Sie Orte hinterlegen an denen Sie regelm. fotografieren (Ihr Haus, Ihr Garten, der Sportplatz,...). Bei Aufruf des Scriptes und Auswahl der Lokation werden die Koordinaten für alle Fotos übernommen

**WICHTIG** bitte löschen Sie den Eintrag Clipboard nicht, den brauchen Sie noch!

#### Auswahl Clipboard

Hier können Sie eine URL aus Apple Maps übergeben und zwar wie folgt:

* Suchen Sie die Lokation in Apple Maps
* Rechte Maustaste, Stecknadel setzen
* Es wird eine **lilane** Stecknadel angelegt
* mit (i) in die Details der Stecknadel
* rechts oben auf teilen
* "Link kopieren" auswählen

Der Link sollte wie folgt aussehen:
`https://maps.apple.com/?q=41.015652,8.887729&sll=41.015652,8.887729&sspn=0.046965,0.103335`

Jetzt das Script aufrufen, Clipboard wählen und die Lokation aus Apple Maps wird für die ausgewählten Fotos übernommen.

Wichtig! Das Script funktioniert **nicht** mit roten Stecknadeln (POI) da hier leider keine Koordinaten weitergegeben werden. Ich habe dafür noch keine Lösung gefunden...

Special Gimmick: Wenn das Foto das Schlagwort "Ohne Standort" hat, wird dieses automatisch entfernt! So lässt sich tracken, welche Fotos noch keinen Standort haben.

### Kopiere GPS auf anderes Foto

Das Script kopiert die GPS Koordinaten vom ersten selektierten Foto auf alle weiteren. (ggf. Sortierrichtung anpassen oder manuell umsortieren, wenn das Foto mit den Koordinaten nicht am Anfang steht)
Anwendung: 1. Foto mit dem Handy gemacht und alle weiteren dann mit der DSLR die kein GPS hat. So bekommen diese Fotos dann auch die Koordinaten.

Special Gimmick: Wenn das Zielfoto das Schlagwort "Ohne Standort" hat, wird dieses automatisch entfernt! So lässt sich tracken, welche Fotos noch keinen Standort haben.


### Kopiere Datum auf anderes Foto

Das Script kopiert das Aufnahmedatum vom ersten selektierten Foto auf alle weiteren. (ggf. Sortierrichtung anpassen oder manuell umsortieren, wenn das Foto mit den Koordinaten nicht am Anfang steht)
Anwendung: Ein bearbeites Foto, erstelltes Panorama oder HDR Bild hat nicht mehr das Original Aufnahmedatum wie das Orignal Bild

### Datum aus Dateiname

Lautet der Dateiname 2020-07-07 um 23-59-59.jpg wird aus diesem das Datum ausgelesen und für das Foto übernommen.

Anwendung: Einige Fotos haben bei mir das falsche Aufnahmedatum, im Dateinamen passt es aber. 

### AVI nach mp4 konvertieren

Voraussetzung: Handbrale CLI (! also die Commandoline Version) muss im Programme Ordner installiert sein.
https://handbrake.fr/downloads2.php

Dieses Script konvertiert ein Video in einem alten Format (bspw. AVI mit Codec Motion JPEG OpenDML) wie es ältere Kompaktkameras erzeugt haben/erzeugen direkt in eine MP4 mit Codec H.264. Diese sind wesentlich kleiner *und* kompatibler.
Es werden alle Metadaten übernommen.
Während der Konvertierung müssen Sie einen Tempordner angeben. Dieser muss **zwingend** leer sein.
Wird ein Video ausgewählt, werden alle Ordner angezeigt in dem das Video aktuell liegt und Sie müssen auswählen, in welchen es danach wieder importiert werden soll.
Werden mehrere Videos ausgewählt, werden alle exportiert und konvertiert. Die Videos werden dabei in die gleichen Alben importiert, in denen sie vorher enthalten waren.
Schlussendlich können Sie noch die Qualität auswählen LOW oder HIGH - gibt es Unterschiede - schwer zu sagen. Meist sollte LOW reichen. Sind mehrer Videos slektiert, erscheint die Auswahl nur einmal und gilt für alle Videos.

Special Gimmick: Wenn das Zielfoto das Schlagwort "AVI" hat, wird dieses automatisch entfernt! So lässt sich tracken, welche Video noch im alten Format ist haben.

### TIFF/PSD nach jpg konvertieren

Dieses Script konvertiert ein Bild, welches im PSD oder TIF Format vorliegt, in JPG - in dem es es exportiert in JPG und danach direkt wieder importiert. Dies spart teils 100erte MB pro Foto
Es werden alle Metadaten übernommen.
Während der Konvertierung müssen Sie einen Tempordner angeben. Dieser muss **zwingend** leer sein.
Wird nur ein Foto selektoert, werden alle Alben angezeigt in dem das Foto aktuell liegt und Sie müssen auswählen, in welchen es danach wieder importiert werden soll.
Werden mehrere Fotos ausgewählt, werden alle exportiert und konvertiert. Die Bilder werden in die gleichen Alben importiert, in denen sie vorher enthalten waren.

### Zeige weitere Alben

Das Script zeigt alle Alben, in dem das Foto liegt - unabhängig in welchem Order das Album liegt! (Achtung dauert u.U. etwas). Mit Doppelklick auf einen Ornder, wird dieser in die Zwischenablage kopiert und kann bspw. als Favoritenordner für das Script Kopiere in Alben genutzt werden.

### Nach Jahren sortieren

Benötigt einen Ordner "nach Jahren" im Root meiner Alben. Das Script sortiert dann die Fotos in Ordner nach dem Format

```
nach Jahren/YYYY/MM/TT
```
ein.
Wobei 
YYYY = Ordner für das Jahr
MM = Ordner für den Monat
TT = Album für den Tag

### Nach Dateigröße sortieren

Vergibt ein Label (Schlagwort) für alle selektierten Fotos:

```
zwischen 30 und 50 MB
zwischen 50 und 100 MB
zwischen 100 und 150 MB
zwischen 150 und 200 MB
mehr als 200 MB
```

Unter 30 MB werden nicht gelabelt.
