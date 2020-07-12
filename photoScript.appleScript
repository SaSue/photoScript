-- favorit folders für kopieren anlegen
set theAlbumChoices to {"Familie und Kinder/Kinder", "Familie und Kinder/Ausflüge/Verschiedene Ausflüge", "Haus und Garten/Garten", "Haus und Garten/Haus", "Haustiere/Aquarium", "Haustiere/Hamster", "Haustiere/Kaninchen", "Haustiere/Katze", "! Wartungsalben/! ToDo", "Essen und Grillen", "Dias zum sortieren", "! Wartungsalben/! Test"}

-- locations setzen, bitte Clipboard *nicht* entfernen
set myLocations to {{"Clipboard", 0, 0}, {"Brandenburger Tor", 52.5164, 13,3780}, {"Piccaddily Circus", 51.5101, -0.1344}, {"Eifelturm", 48.8580, 2.2947}}

-- fragen welches Script ausgeführt werden soll
set meldung to "" as string
set meldung_title to "" as string
set script_liste to {"--- Fotos kopieren ---", "In Album kopieren", "In Album kopieren über auswählen/erstellen", "--- Meta Daten bearbeiten ---", "Titel einfügen", "Beschreibung einfügen", "Schlagwörter ergänzen", "--- GPS Daten bearbeiten ---", "GPS Daten hinzufügen", "Kopiere GPS auf anderes Foto", "--- Datum bearbeiten ---", "Kopiere Datum auf anderes Foto", "Datum aus Dateiname", "--- Konvertieren ---", "AVI nach mp4 konvertieren", "TIFF/PSD nach jpg konvertieren", "--- Alben suchen ---", "Zeige weitere Alben", "--- Sortieren ---", "Nach Jahren sortieren", "Nach Dateigröße sortieren"}

-- Script auswählen
set choosen_Script to choose from list script_liste with prompt "Wählen Sie das auszufüherende Script:"

if (choosen_Script is false) or (item 1 of choosen_Script starts with "---") then -- falls nichts ausgewählt wurde
	log "Nichts ausgewählt"
	set meldung to meldung & "Kein Script ausgewählt" & return
	set meldung_title to "Abbruch"
	
else
	set meldung_title to item 1 of choosen_Script -- Titel für die Meldung festelegen auf das ausgewählte Script
	
	log "Gewähltes Script: "
	log choosen_Script
	
	if item 1 of choosen_Script is equal to "In Album kopieren über auswählen/erstellen" then
		log "Starte mit Schleife " & item 1 of choosen_Script
		
		set my_album to my find_album_selector("initalize", "")
		
		tell application "Photos"
			activate
			
			try
				set meldung to "Datei(en):" & return
				set sel to selection
				if sel is {} then error "The selection  is empty" -- no selection
				
			on error errTexttwo number errNumtwo
				display dialog "No photos selected " & errNumtwo & return & errTexttwo
				return
			end try
			
			set imageList to {}
			
			repeat with source in sel
				set meldung to (meldung & filename of source & return)
				set end of imageList to source
			end repeat
			
			set meldung to (meldung & "zu: " & return)
			if my_album is false then
				return
			else
				
				set meldung to meldung & my_album & return
				add imageList to my find_album(my_album)
				
				set meldung to meldung & "hinzugefügt."
			end if
		end tell
	else if item 1 of choosen_Script is equal to "AVI nach mp4 konvertieren" then
		log "Starte mit Schleife " & item 1 of choosen_Script
		
		set sourceFolder to choose folder with prompt "Wählen Sie einen temporären Ordner für die Konvertierung aus:" with multiple selections allowed
		set dest_folder to sourceFolder
		
		tell application "Photos"
			activate
			-- Add the photo you want to search for to a top level album as the first item in the album
			try
				set sel to selection
				if sel is {} then error "The selection  is empty" -- no selection
				set length_of_sel to length of sel as number
				
				if length_of_sel > 1 then
					set theDialogText to ("Es werden " & length_of_sel as string) & " Videos konvertiert. " & return & "Bitte Qualität auswählen"
					display dialog theDialogText buttons {"Low", "High"} default button "High"
					if button returned of result = "Low" then
						set quality to "Low"
					else if button returned of result = "High" then
						set quality to "High"
					end if
				else
					set quality to ""
				end if
			on error errTexttwo number errNumtwo
				display dialog "No photos selected " & errNumtwo & return & errTexttwo
				return
			end try
		end tell
		
		repeat with int_sel from 1 to length_of_sel
			
			set meldung to ""
			tell application "Photos"
				activate
				set export_list to {}
				set end of export_list to item int_sel of sel
				export export_list to sourceFolder with using originals
				-- Add the photo you want to search for to a top level album as the first item in the album
				set imagename to "unknown filename"
				set favoriteSource to false
				try
					set target to item int_sel of sel -- the image to seach for
					tell target
						set imagename to the filename of target
						set loc to get the location --retrieve longitude and latitude as list
						set alti to get the altitude -- retrieve the altitude
						set keywordsSource to get the keywords
						set nameSource to get name
						set descriptionSource to get description
						set favoriteSource to get favorite
						set dateSource to date of target
						set latiSource to (the first item of loc) -- as number
						set longiSource to (the second item of loc) -- as number
						set filesizeSource to get size
					end tell
					
					set meldung to meldung & "Datei: " & imagename & return
					set meldung to (meldung & "Mit Dateigröße: " & ((round (filesizeSource * 10) / 1024 / 1024)) / 10 as string) & " MB" & return
					set meldung to meldung & "exportiert" & return
					
					
				on error errTexttwo number errNumtwo
					display dialog "Cannot get the filename of the first image: " & errNumtwo & return & errTexttwo
				end try
				
				-- set sel to selection
				if sel is {} then return -- no selection
				try
					set thisId to id of item int_sel of sel
				on error errText number errNum
					display dialog "Error: cannot get the image ID" & errNum & return & errText & "Trying again"
					
					try
						delay 2
						set thisId to id of int_sel of sel
					on error errTexttwo number errNumtwo
						display dialog "Skipping image due to repeated error: " & errNumtwo & return & errTexttwo
						error "giving up"
						return
					end try --second attempt
				end try
				
			end tell
			
			set theseNames to my find_folder_recursive(thisId, "initialize", {}, {})
			tell application "Photos"
				if theseNames is not {} then
					activate
					
					if length_of_sel > 1 then
						set theSelectedAlbum to theseNames
						--	set theSelectedAlbum to choose from list theAlbumChoices with prompt "Album für den Import der konvertierten Datei:" with multiple selections allowed
					else
						set theAlbumChoices to theseNames
						set theSelectedAlbum to choose from list theAlbumChoices with prompt "Album für den Import der konvertierten Datei:" with multiple selections allowed
						set theDialogText to ("Bitte Qualität auswählen - aktuelle Dateigröße: " & ((round (filesizeSource * 10) / 1024 / 1024)) / 10 as string) & " MB"
						display dialog theDialogText buttons {"Low", "High"} default button "High"
						if button returned of result = "Low" then
							set quality to "Low"
						else if button returned of result = "High" then
							set quality to "High"
						end if
					end if
				else
					set t to "No album"
					return
				end if
				
				set theDialogText to ("Bitte Qualität auswählen - aktuelle Dateigröße: " & ((round (filesizeSource * 10) / 1024 / 1024)) / 10 as string) & " MB"
				--	display dialog theDialogText buttons {"Low", "High"} default button "High"
				
				set quality to "High"
				
				
			end tell
			if theSelectedAlbum is false then
				return
			else
				
				with timeout of (720 * 60) seconds
					tell application "Finder"
						
						set OrdnerInhalt to (every file of folder sourceFolder whose name extension is in {"avi", "mov"})
						set dateiListe to (every item of OrdnerInhalt) as list
						
						--Repeat for all files in above folder
						repeat with datei in dateiListe
							
							try
								
								--Assemble original and new file paths
								set origFilepath to quoted form of POSIX path of (datei as alias)
								set newFilepath to (characters 1 thru -5 of origFilepath as string) & "mp4'"
								--Start the conversion
								
								
								if quality is equal to "Low" then
									set shellCommand to "nice /Applications/HandBrakeCLI -i " & origFilepath & " -o " & newFilepath & " -e x264 -q 20 -B 160 ;"
								else if quality is equal to "High" then
									set shellCommand to "nice /Applications/HandBrakeCLI -i " & origFilepath & " -o " & newFilepath & " -e x264 -b 4000 -a 1 -E faac -B 160 -R 48 -6 dpl2 -f mp4 –crop 0:0:0:0 -x level=40:ref=2:mixed-refs:bframes=3:weightb:subme=9:direct=auto:b-pyramid:me=umh:analyse=all:no-fast-pskip:filter=-2,-1 ;"
								end if
								do shell script shellCommand
								
								set shellCommand to "rm -f " & origFilepath
								do shell script shellCommand
							on error errmsg
								--Set the label to red to indicate failure
								display dialog errmsg as text
							end try
						end repeat
					end tell
				end timeout
				
				tell application "Photos"
					activate
					set meldungAlben to "" as string
					
					repeat with d from 1 to the length of theSelectedAlbum
						
						set meldungAlben to meldungAlben & item d of theSelectedAlbum & return
						set selectedAlbum to my find_album(item d of theSelectedAlbum)
						
						-- Add the photo you want to search for to a top level album as the first item in the album
						set imageList to {}
						set extensionsList to {"mp4"}
						tell application "Finder" to set theFiles to (every file of folder sourceFolder whose name extension is extensionsList)
						
						set imageList to {}
						repeat with i from 1 to number of items in theFiles
							set this_item to item i of theFiles as alias
							set the end of imageList to this_item
						end repeat
						
						if d = 1 then -- im ersten Durchgang importieren in das Album
							set importedFileList to import imageList into selectedAlbum
						else if d > 1 then -- in allen nachfolgenden Durchgängen dem Album zuweisen
							add importedFileList to selectedAlbum
						end if
						
					end repeat
					set shellCommand to "rm -f " & newFilepath
					do shell script shellCommand
					
					repeat with importedFile in importedFileList
						tell importedFile
							if latiSource is not equal to missing value and longiSource is not equal to missing value then set its location to {latiSource, longiSource}
							if keywordsSource is not equal to missing value then
								
								-- AVI aus den Keywords entfernen
								set theList to keywordsSource
								
								set itemsToDelete to {"AVI", "MOV"}
								
								set cleanList to {}
								
								repeat with i_keywords from 1 to count theList
									if {theList's item i_keywords} is not in itemsToDelete then set cleanList's end to theList's item i_keywords
								end repeat
								
								if cleanList is not equal to missing value then set its keywords to cleanList
							end if
							if nameSource is not equal to missing value then set its name to nameSource
							if descriptionSource is not equal to missing value then set its description to descriptionSource
							set its favorite to favoriteSource
							
							set imagename to the filename of importedFile
							set filesizeSource to get size
						end tell
						set date of importedFile to dateSource
					end repeat
					set meldung to meldung & "Datei: " & imagename & return
					set meldung to (meldung & "Mit Dateigröße: " & ((round (filesizeSource * 10) / 1024 / 1024)) / 10 as string) & " MB" & return
					set meldung to meldung & "importiert in Alben:" & return
					
					set meldung to meldung & meldungAlben
					
				end tell
			end if
			
		end repeat
		if length_of_sel > 1 then set meldung to "Es wurden " & length_of_sel & " Alben konvertiert."
		
	else if item 1 of choosen_Script is equal to "TIFF/PSD nach jpg konvertieren" then
		log "Starte mit Schleife " & item 1 of choosen_Script
		
		set sourceFolder to choose folder with prompt "Wählen Sie einen temporären Ordner für die Konvertierung aus:" with multiple selections allowed
		set dest_folder to sourceFolder
		tell application "Photos"
			activate
			-- Add the photo you want to search for to a top level album as the first item in the album
			
			try
				
				set sel to selection
				if sel is {} then error "The selection  is empty" -- no selection
				set length_of_sel to length of sel as number
				
				
			on error errTexttwo number errNumtwo
				display dialog "No photos selected " & errNumtwo & return & errTexttwo
				return
			end try
		end tell
		
		repeat with int_sel from 1 to length_of_sel
			
			tell application "Photos"
				activate
				
				set exportlist to {}
				set end of exportlist to item int_sel of sel
				export exportlist to sourceFolder
				
				set imagename to "unknown filename"
				set favoriteSource to false
				try
					set target to item int_sel of sel -- the image to seach for
					tell target
						set imagename to the filename of target
						set loc to get the location --retrieve longitude and latitude as list
						set alti to get the altitude -- retrieve the altitude
						set keywordsSource to get the keywords
						set nameSource to get name
						set descriptionSource to get description
						set favoriteSource to get favorite
						set dateSource to date of target
						set latiSource to (the first item of loc) -- as number
						set longiSource to (the second item of loc) -- as number
						set filesizeSource to get size
					end tell
					
					set meldung to meldung & "Datei: " & imagename & return
					set meldung to (meldung & "Mit Dateigröße: " & ((round (filesizeSource * 10) / 1024 / 1024)) / 10 as string) & " MB" & return
					set meldung to meldung & "exportiert" & return
					
				on error errTexttwo number errNumtwo
					display dialog "Cannot get the filename of the first image: " & errNumtwo & return & errTexttwo
				end try
			end tell
			
			tell application "Photos"
				-- set sel to selection
				
				try
					set thisId to id of (item int_sel of sel)
				on error errText number errNum
					display dialog "Error: cannot get the image ID" & errNum & return & errText & "Trying again"
					
					try
						delay 2
						set thisId to id of (item int_sel of sel)
					on error errTexttwo number errNumtwo
						display dialog "Skipping image due to repeated error: " & errNumtwo & return & errTexttwo
						error "giving up"
						return
					end try --second attempt
				end try
				
				set theseNames to my find_folder_recursive(thisId, "initialize", {}, {})
			end tell
			
			if theseNames is not {} then
				
				if length_of_sel > 1 then
					set theSelectedAlbum to theseNames
				else
					tell application "Photos"
						activate
						set theAlbumChoices to theseNames
						set theSelectedAlbum to choose from list theAlbumChoices with prompt "Album für den Import der konvertierten Datei:" with multiple selections allowed
					end tell
				end if
			else
				set t to "No album"
				return
			end if
			
			log ((count of the theSelectedAlbum) as string) & " Alben gefunden"
			
			if theSelectedAlbum is false then
				return
			else
				tell application "Photos"
					set meldungAlben to "" as string
					repeat with i from 1 to the length of theSelectedAlbum
						
						set meldungAlben to meldungAlben & item i of theSelectedAlbum & return
						set selectedAlbum to my find_album(item i of theSelectedAlbum)
						
						activate
						
						-- Add the photo you want to search for to a top level album as the first item in the album
						
						--	tell application "Finder" to set importList to every file of importFolder whose name extension is "mp4"
						set imageList to {}
						set extensionsList to {"jpeg"}
						tell application "Finder" to set theFiles to (every file of folder sourceFolder whose name extension is extensionsList)
						
						set imageList to {}
						repeat with i2 from 1 to number of items in theFiles
							set this_item to item i2 of theFiles as alias
							set the end of imageList to this_item
							log "Durchgang " & i & ": " & this_item
						end repeat
						
						if i = 1 then
							set importedFileList to import imageList into selectedAlbum
						else if i > 1 then
							add importedFileList to selectedAlbum
						end if
					end repeat
					-- set shellCommand to "rm -f " & newFilepath
					-- do shell script shellCommand
					
					tell application "Finder" to delete item 1 of theFiles
					
					repeat with importedFile in importedFileList
						tell importedFile
							if latiSource is not equal to missing value and longiSource is not equal to missing value then set its location to {latiSource, longiSource}
							if keywordsSource is not equal to missing value then set its keywords to keywordsSource
							if nameSource is not equal to missing value then set its name to nameSource
							if descriptionSource is not equal to missing value then set its description to descriptionSource
							set its favorite to favoriteSource
							
							set imagename to the filename of importedFile
							set filesizeSource to get size
							
						end tell
						set date of importedFile to dateSource
					end repeat
					
					
					set meldung to meldung & "Datei: " & imagename & return
					set meldung to (meldung & "Mit Dateigröße: " & ((round (filesizeSource * 10) / 1024 / 1024)) / 10 as string) & " MB" & return
					set meldung to meldung & "importiert in Alben:" & return
					
					set meldung to meldung & meldungAlben
					
				end tell
			end if
		end repeat
		
		if length_of_sel > 1 then set meldung to "Es wurden " & length_of_sel & " Bilder konvertiert"
		
	else if item 1 of choosen_Script is equal to "TIFF/PSD nach jpg konvertieren_ALT" then
		log "Starte mit Schleife " & item 1 of choosen_Script
		
		set sourceFolder to choose folder with prompt "Wählen Sie einen temporären Ordner für die Konvertierung aus:" with multiple selections allowed
		set dest_folder to sourceFolder
		
		tell application "Photos"
			activate
			-- Add the photo you want to search for to a top level album as the first item in the album
			
			try
				
				set sel to selection
				if sel is {} then error "The selection  is empty" -- no selection
				
				export sel to sourceFolder
				
			on error errTexttwo number errNumtwo
				display dialog "No photos selected " & errNumtwo & return & errTexttwo
				return
			end try
			
			set imagename to "unknown filename"
			set favoriteSource to false
			try
				set target to item 1 of sel -- the image to seach for
				tell target
					set imagename to the filename of target
					set loc to get the location --retrieve longitude and latitude as list
					set alti to get the altitude -- retrieve the altitude
					set keywordsSource to get the keywords
					set nameSource to get name
					set descriptionSource to get description
					set favoriteSource to get favorite
					set dateSource to date of target
					set latiSource to (the first item of loc) -- as number
					set longiSource to (the second item of loc) -- as number
					set filesizeSource to get size
				end tell
				
				set meldung to meldung & "Datei: " & imagename & return
				set meldung to (meldung & "Mit Dateigröße: " & ((round (filesizeSource * 10) / 1024 / 1024)) / 10 as string) & " MB" & return
				set meldung to meldung & "exportiert" & return
				
			on error errTexttwo number errNumtwo
				display dialog "Cannot get the filename of the first image: " & errNumtwo & return & errTexttwo
			end try
		end tell
		
		tell application "Photos"
			-- set sel to selection
			if sel is {} then return -- no selection
			try
				set thisId to id of item 1 of sel
			on error errText number errNum
				display dialog "Error: cannot get the image ID" & errNum & return & errText & "Trying again"
				
				try
					delay 2
					set thisId to id of item 1 of sel
				on error errTexttwo number errNumtwo
					display dialog "Skipping image due to repeated error: " & errNumtwo & return & errTexttwo
					error "giving up"
					return
				end try --second attempt
			end try
			
			set theseNames to my find_folder_recursive(thisId, "initialize", {}, {})
		end tell
		
		if theseNames is not {} then
			activate
			
			set theAlbumChoices to theseNames
			set theSelectedAlbum to choose from list theAlbumChoices with prompt "Album für den Import der konvertierten Datei:" with multiple selections allowed
			
		else
			set t to "No album"
			return
		end if
		
		log ((count of the theSelectedAlbum) as string) & " Alben gefunden"
		
		if theSelectedAlbum is false then
			return
		else
			tell application "Photos"
				set meldungAlben to "" as string
				repeat with i from 1 to the length of theSelectedAlbum
					
					set meldungAlben to meldungAlben & item i of theSelectedAlbum & return
					set selectedAlbum to my find_album(item i of theSelectedAlbum)
					
					activate
					
					-- Add the photo you want to search for to a top level album as the first item in the album
					
					--	tell application "Finder" to set importList to every file of importFolder whose name extension is "mp4"
					set imageList to {}
					set extensionsList to {"jpeg"}
					tell application "Finder" to set theFiles to (every file of folder sourceFolder whose name extension is extensionsList)
					
					set imageList to {}
					repeat with i2 from 1 to number of items in theFiles
						set this_item to item i2 of theFiles as alias
						set the end of imageList to this_item
						log "Durchgang " & i & ": " & this_item
					end repeat
					
					if i = 1 then
						set importedFileList to import imageList into selectedAlbum
					else if i > 1 then
						add importedFileList to selectedAlbum
					end if
				end repeat
				-- set shellCommand to "rm -f " & newFilepath
				-- do shell script shellCommand
				
				tell application "Finder" to delete item 1 of theFiles
				
				repeat with importedFile in importedFileList
					tell importedFile
						if latiSource is not equal to missing value and longiSource is not equal to missing value then set its location to {latiSource, longiSource}
						if keywordsSource is not equal to missing value then set its keywords to keywordsSource
						if nameSource is not equal to missing value then set its name to nameSource
						if descriptionSource is not equal to missing value then set its description to descriptionSource
						set its favorite to favoriteSource
						
						set imagename to the filename of importedFile
						set filesizeSource to get size
						
					end tell
					set date of importedFile to dateSource
				end repeat
				
				
				set meldung to meldung & "Datei: " & imagename & return
				set meldung to (meldung & "Mit Dateigröße: " & ((round (filesizeSource * 10) / 1024 / 1024)) / 10 as string) & " MB" & return
				set meldung to meldung & "importiert in Alben:" & return
				
				set meldung to meldung & meldungAlben
				
			end tell
		end if
		
	else if item 1 of choosen_Script is equal to "Schlagwörter ergänzen" then
		log "Starte mit Schleife " & item 1 of choosen_Script
		
		tell application "Photos"
			set actionString to "" as string
			activate
			set currentSelection to selection
			if currentSelection is {} then
				error "The selection  is empty" -- no selection
			else
				
				-- clipboard auslesen, wenn fehler weil Clipboard kein Text set to ""
				try
					set defaultText to the clipboard as text
				on error errTexttwo number errNumtwo
					if errNumtwo is -1700 then set defaultText to ""
				end try
				set result to display dialog "Bitte Schlagwörter für die Fotos eingeben:" default answer (defaultText) with icon note buttons {"Cancel", "Replace", "Append"} default button "Append"
				copy the result to {button returned:buttonPressed, text returned:keyWordString}
				
				set keywordsToApply to my splitText(keyWordString, ",")
				
				repeat with i from 1 to the count of currentSelection
					set thisItem to item i of currentSelection
					
					-- get the current keywords of the photo
					set theseKeywords to the keywords of thisItem
					if theseKeywords is missing value then
						set actionString to "hinzugefügt."
						set keywords of thisItem to keywordsToApply
					else if keywordsToApply is {} then -- option for deleting all existing keywords
						if buttonPressed is "Replace" then
							set actionString to "ersetzt."
							set keywords of thisItem to {}
						end if
					else
						if buttonPressed is "Append" then
							set actionString to "hinzugefügt."
							-- check to see if new keyword already exists
							set filteredKeywords to {}
							repeat with q from 1 to the count of keywordsToApply
								set thisKeyword to item q of keywordsToApply
								if thisKeyword is not in theseKeywords then
									set the end of the filteredKeywords to thisKeyword
								end if
							end repeat
							if filteredKeywords is not {} then
								-- append checked keywords to existing keywords
								set keywords of thisItem to (theseKeywords & filteredKeywords)
							end if
						else -- replace keywords with new ones
							set actionString to "ersetzt."
							set keywords of thisItem to keywordsToApply
						end if
					end if
				end repeat
				set meldung to meldung & "Stichwörter " & keyWordString & " zu " & i & " Fotos " & actionString
				
			end if
			
		end tell
		
	else if item 1 of choosen_Script is equal to "Nach Dateigröße sortieren" then
		log "Starte mit Schleife " & item 1 of choosen_Script
		
		tell application "Photos"
			activate
			
			set s_msg to "" as string
			set imageSel to (get selection)
			set meldung to "" as string
			
			if imageSel is {} then
				error "Please select some images."
			else
				set range1 to 0 as number
				set range2 to 0 as number
				set range2 to 0 as number
				set range3 to 0 as number
				set range4 to 0 as number
				set range5 to 0 as number
				set range6 to 0 as number
				repeat with selImg in imageSel
					
					tell selImg --get the file size
						set sizeByte to its size
						set filenameStr to its filename
						set theseKeywords to its keywords
						
					end tell
					
					set sizeKByte to round (sizeByte / 1024)
					set sizeMByte to (round ((sizeKByte / 1024) * 10)) / 10
					set s_msg to "kleiner 30 MB"
					
					
					if sizeMByte > 30 then
						if (sizeMByte < 49.9) then
							set s_msg to "zwischen 30 und 50 MB"
							set range2 to range2 + 1
						else if (sizeMByte > 50 and sizeMByte < 100) then
							set s_msg to "zwischen 50 und 100 MB"
							set range3 to range3 + 1
						else if (sizeMByte > 100 and sizeMByte < 150) then
							set s_msg to "zwischen 100 und 150 MB"
							set range4 to range4 + 1
						else if (sizeMByte > 150 and sizeMByte < 200) then
							set s_msg to "zwischen 150 und 200 MB"
							set range5 to range5 + 1
						else if sizeMByte > 200 then
							set s_msg to "mehr als 200 MB"
							set range6 to range6 + 1
						end if
						set keywordsSource to {}
						set end of keywordsSource to s_msg
						
						set filteredKeywords to {}
						
						set thisKeyword to s_msg
						
						if thisKeyword is not in theseKeywords then
							set the end of the filteredKeywords to thisKeyword
						end if
						if filteredKeywords is not {} then
							if theseKeywords is missing value then
								set keywords of selImg to filteredKeywords
							else
								set keywords of selImg to (theseKeywords & filteredKeywords)
							end if
						end if
					else
						set range1 to range1 + 1
						
					end if
					log (filenameStr & ": " & sizeMByte as string) & " MB - " & s_msg
					
				end repeat
				
				set meldung to (meldung & "Dateien größer als 200MB: " & range6 as string) & return
				set meldung to (meldung & "Dateien zwischen 150MB und 200MB: " & range5 as string) & return
				set meldung to (meldung & "Dateien zwischen 100MB und 150MB: " & range4 as string) & return
				set meldung to (meldung & "Dateien zwischen 50MB und 100MB: " & range3 as string) & return
				set meldung to (meldung & "Dateien zwischen 30MB und 50MB: " & range2 as string) & return
				set meldung to (meldung & "Dateien kleiner 30MB: " & range1 as string) & return
				
			end if
			
		end tell
		
	else if item 1 of choosen_Script is equal to "Nach Jahren sortieren" then
		log "Starte mit Schleife " & item 1 of choosen_Script
		
		tell application "Photos"
			
			set sel to selection
			
			set rootFolder to folder "Nach Jahren"
			
			set MonatsListe to {"Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"}
			set i_count to 0
			repeat with selItem in sel
				
				set i_count to i_count + 1
				set datum_d to the date of selItem
				set tag_i to the day of (datum_d as date)
				set monat_i to the ((month of (datum_d as date)) * 1) as number
				set jahr_i to the year of (datum_d as date)
				
				set jahr_s to jahr_i as string
				set monat_s to "" as string
				set tag_s to "" as string
				
				if not (exists folder jahr_s in rootFolder) then
					make folder named jahr_s at rootFolder
				end if
				
				set jahrFolder to folder jahr_s in rootFolder
				
				if monat_i < 10 then set monat_s to "0"
				
				set monat_s to ((monat_s & monat_i as string) & " " & item monat_i of MonatsListe)
				
				if not (exists folder monat_s in jahrFolder) then
					make folder named monat_s at jahrFolder
				end if
				
				set monatFolder to folder monat_s in jahrFolder
				
				if tag_i < 10 then
					set tag_s to "0" & tag_i as string
				else
					set tag_s to tag_i as string
				end if
				
				if not (exists album tag_s in monatFolder) then
					make album named tag_s at monatFolder
				end if
				
				set imageList to {}
				set end of imageList to selItem
				
				set selectedAlbum to album tag_s in monatFolder
				add imageList to selectedAlbum
				
			end repeat
			
			set meldung to meldung & i_count & " Fotos wurden sortiert."
		end tell
		
	else if item 1 of choosen_Script is equal to "Beschreibung einfügen" then
		log "Starte mit Schleife " & item 1 of choosen_Script
		
		tell application "Photos"
			activate
			
			-- clipboard auslesen, wenn fehler weil Clipboard kein Text set to ""
			try
				set defaultText to the clipboard as text
			on error errTexttwo number errNumtwo
				if errNumtwo is -1700 then set defaultText to ""
			end try
			
			set result to display dialog "Bitte Beschreibung für die Fotos eingeben:" default answer (defaultText) with icon note buttons {"Cancel", "Replace", "Append"} default button "Append"
			copy the result to {button returned:buttonPressed, text returned:theResponse}
			set kommentar to theResponse
			try
				set sel to selection
				if sel is {} then error "The selection  is empty" -- no selection
				
			on error errTexttwo number errNumtwo
				display dialog "No photos selected " & errNumtwo & return & errTexttwo
				return
			end try
			if buttonPressed = "Replace" then
				
				-- Add the photo you want to search for to a top level album as the first item in the album
				
				set i_count to 0
				repeat with source in sel
					try
						set i_count to i_count + 1
						set description of source to kommentar
						
					on error errTexttwo number errNumtwo
						display dialog "Konnte nicht eingefügt werden " & errNumtwo & return & errTexttwo
						return
					end try
				end repeat
				set meldung to "Kommentar: " & kommentar & " wurde in " & i_count & " Fotos gesetzt."
				
			else if buttonPressed = "Append" then
				
				set i_count to 0
				repeat with source in sel
					try
						set i_count to i_count + 1
						set oldKommentar to get description of source
						if oldKommentar = missing value then set oldKommentar to ""
						set description of source to kommentar & " " & oldKommentar
						
					on error errTexttwo number errNumtwo
						display dialog "Konnte nicht eingefügt werden " & errNumtwo & return & errTexttwo
						return
					end try
				end repeat
				set meldung to "Kommentar: " & kommentar & " wurde in " & i_count & " Fotos angehängt."
			else
				
				set meldung to "Abgebrochen"
			end if
			
		end tell
	else if item 1 of choosen_Script is equal to "Titel einfügen" then
		log "Starte mit Schleife " & item 1 of choosen_Script
		
		-- clipboard auslesen, wenn fehler weil Clipboard kein Text set to ""
		try
			set defaultText to the clipboard as text
		on error errTexttwo number errNumtwo
			if errNumtwo is -1700 then set defaultText to ""
		end try
		
		set dialogTitlePreFix to display dialog "Welcher Titel?" default answer (defaultText)
		set string_input to text returned of dialogTitlePreFix
		set lengthSize to length of text returned of dialogTitlePreFix
		set titlePreFix to "" as string
		if lengthSize > 0 then set titlePreFix to titlePreFix & string_input & " " as string
		
		tell application "Photos"
			activate
			-- Add the photo you want to search for to a top level album as the first item in the album
			
			set resultcaption to "Searching for: "
			try
				
				set sel to selection
				if sel is {} then error "The selection  is empty" -- no selection
				
			on error errTexttwo number errNumtwo
				display dialog "No photos selected " & errNumtwo & return & errTexttwo
				return
			end try
			
			set i_count to number of items in sel
			
			set meldung to (meldung & i_count as string) & " Titel eingefügt"
			
			repeat with i from 1 to i_count
				
				if i < 10 then set zahlenBasis to "000" as string
				if i ≥ 10 and i < 100 then set zahlenBasis to "00" as string
				if i ≥ 100 and i < 1000 then set zahlenBasis to "0" as string
				if i ≥ 1000 then set zahlenBasis to "" as string
				
				set zahlAlsString to zahlenBasis & i as string
				
				set this_item to item i of sel
				set dateSource to date of this_item
				set stringMonth to "" as string
				set numberMonth to month of dateSource as number
				set stringDay to "" as string
				set numberDay to day of dateSource as number
				
				
				
				if numberMonth < 10 then
					set stringMonth to "0" & numberMonth as string
				else
					set stringMonth to numberMonth as string
				end if
				
				if numberDay < 10 then
					set stringDay to "0" & numberDay as string
				else
					set stringDay to numberDay as string
				end if
				
				set datumsBasis to year of dateSource & "-" & stringMonth & "-" & stringDay as string
				set titleString to titlePreFix & datumsBasis & " " & zahlAlsString as string
				
				tell this_item
					
					if titleString is not equal to missing value then set its name to titleString
				end tell
				
			end repeat
			
		end tell
		
	else if item 1 of choosen_Script is equal to "Kopiere Datum auf anderes Foto" then
		log "Starte mit Schleife " & item 1 of choosen_Script
		
		tell application "Photos"
			activate
			set imageSel to (get selection)
			if (imageSel is {}) or (the length of imageSel < 2) then
				error "Bitte 2 Bilder auswählen"
			else
				
				try
					
					set dateSource to date of first item of imageSel
					
				on error errTexttwo number errNumtwo
					display dialog errNumtwo & return & errTexttwo
					return
				end try
				
				repeat with i from 2 to count of imageSel
					
					set next_image to item i of imageSel
					
					set date of next_image to dateSource
					
					
				end repeat
			end if
			
			set meldung to meldung & (dateSource as string) & " gesetzt"
			
		end tell
		
	else if item 1 of choosen_Script is equal to "Kopiere GPS auf anderes Foto" then
		log "Starte mit Schleife " & item 1 of choosen_Script
		
		tell application "Photos"
			activate
			set imageSel to (get selection)
			if (imageSel is {}) or (the length of imageSel < 2) then
				error "Please select at least two images."
			else
				set withAlti to false
				set withLati to false
				set withLongi to false
				
				try
					tell the first item of imageSel
						set loc to get the location --retrieve longitude and latitude as list
						set alti to get the altitude -- retrieve the altitude
						
						set lati to (the first item of loc) -- as number
						set longi to (the second item of loc) -- as number
						
						-- return altiS
						set withAlti to (alti is not equal to missing value)
						set withLati to (lati is not equal to missing value)
						set withLongi to (longi is not equal to missing value)
						
						if not withLati then
							set withLati to false
							error "Photo has no Latitude assigned"
						end if
						
						if not withLongi then
							error "Photo has no Latitude assigned"
						end if
						if (lati > 90.0) or (lati < -90.0) then
							error "Latitude out of range " & lati
						end if
						if (longi > 180.0) or (longi < -180.0) then
							error "Longitude out of range " & longi
						end if
						
					end tell
				on error errTexttwo number errNumtwo
					display dialog "No GPS: " & errNumtwo & return & errTexttwo
					return
				end try
				
				if (not withLongi or not withLati) then
					
					return {loc, alti} --testing
				end if
				
				repeat with i from 2 to count of imageSel
					
					set next_image to item i of imageSel
					
					set cleanList to missing value
					
					tell next_image -- lese keywords ein, prüfe ob "Ohne Standort" enthalten ist und entferne es
						set keywordsSource to get the keywords
					end tell
					
					if keywordsSource is not equal to missing value then
						
						-- "Ohne Standort" aus den Keywords entfernen
						set theList to keywordsSource
						
						set itemsToDelete to {"Ohne Standort"}
						
						set cleanList to {}
						
						repeat with i_keywords from 1 to count theList
							if {theList's item i_keywords} is not in itemsToDelete then set cleanList's end to theList's item i_keywords
						end repeat
						
					end if
					
					tell next_image
						set its location to {lati, longi}
						if cleanList is not equal to missing value then set its keywords to cleanList
						
						-- if withAlti then -- photo has altitude tag
						-- set its altitude to alti
						-- end if
					end tell
					if withAlti then -- photo has altitude tag
						tell next_image
							-- set its altitude to alti as number  -- does not work
						end tell
					end if
					
					
				end repeat
			end if
			
			return {loc, alti, "Done"} -- for testing
		end tell
	else if item 1 of choosen_Script is equal to "In Album kopieren" then
		log "Starte mit Schleife " & item 1 of choosen_Script
		
		-- hier die Alben hinterlegen
		
		set theSelectedAlbum to choose from list theAlbumChoices with prompt "Zielablen wählen:" with multiple selections allowed
		
		tell application "Photos"
			activate
			-- Add the photo you want to search for to a top level album as the first item in the album
			
			try
				set meldung to "Datei(en):" & return
				set sel to selection
				if sel is {} then error "The selection  is empty" -- no selection
				
			on error errTexttwo number errNumtwo
				display dialog "No photos selected " & errNumtwo & return & errTexttwo
				return
			end try
			
			
			set imageList to {}
			
			repeat with source in sel
				set meldung to (meldung & filename of source & return)
				set end of imageList to source
			end repeat
			
			set meldung to (meldung & "zu: " & return)
			if theSelectedAlbum is false then
				return
			else
				
				repeat with d from 1 to the count of theSelectedAlbum
					set idOfAlbum to "NotSet" as string
					set meldung to meldung & item d of theSelectedAlbum & return
					add imageList to my find_album(item d of theSelectedAlbum)
				end repeat
				set meldung to meldung & "hinzugefügt."
			end if
		end tell
		
	else if item 1 of choosen_Script is equal to "Datum aus Dateiname" then
		log "Starte mit Schleife " & item 1 of choosen_Script
		
		tell application "Photos"
			activate
			
			set sel to selection
			
			set i_count to 0
			
			-- 2008-10-27 um 12-17-58.m4v
			
			repeat with selImage in sel
				
				set i_count to i_count + 1
				
				set selImageFilename to filename of selImage
				set Wordlist to my splitText(selImageFilename, " ")
				-- 2008-10-27,um,12-17-58.m4v
				
				set listDatum to my splitText(item 1 of Wordlist, "-")
				
				-- 2008-10-27
				
				set jahr to item 1 of listDatum as number
				set monat to item 2 of listDatum as number
				set tag to item 3 of listDatum as number
				
				set listZeitTemp to my splitText(item 3 of Wordlist, ".")
				
				-- 12-17-58.avi
				
				set listZeit to my splitText(item 1 of listZeitTemp, "-")
				
				set stunde to item 1 of listZeit as number
				set minute to item 2 of listZeit as number
				set sekunde to item 3 of listZeit as number
				
				set datum to current date
				tell datum to set {its day, its month, its day, its year} to {1, monat, tag, jahr}
				
				tell datum to set {its hours, its minutes, its seconds} to {stunde, minute, sekunde}
				
				-- display dialog item 1 of Wordlist2 as string
				
				-- display dialog datum as string
				
				set date of selImage to datum
				
				
				
			end repeat
			
			set meldung to meldung & "Datum für " & i_count & " Bilder gesetzt"
			
		end tell
		
	else if item 1 of choosen_Script is equal to "GPS Daten hinzufügen" then
		
		-- ergänzt GPS Daten zu Fotos
		
		log "Starte mit Schleife " & item 1 of choosen_Script
		
		
		log (length of myLocations as string) & " Locations gefunden"
		
		-- Auswahl der Lokations initialisieren
		set theLocationChoices to {}
		
		-- Liste der Lokations auslesen
		repeat with Location in myLocations
			
			-- an Liste anhängen
			set end of theLocationChoices to (item 1 of Location)
			
		end repeat
		
		-- Auswahl der locations anzeigen
		
		set theSelectedLocation to choose from list theLocationChoices with prompt "Zuzuweisenden Ort auswählen:"
		if theSelectedLocation is false then
			display dialog "Kein Ort ausgewählt"
		else
			set lati to 0 as number
			set longi to 0 as number
			
			set mySelection to item 1 of theSelectedLocation
			
			log "Auswahl: "
			log mySelection
			if mySelection is equal to "Clipboard" then
				
				log "Starte auslesen des Clipboards"
				set completeURL to the clipboard as text
				-- URL sollte in diesem Format sein https://maps.apple.com/?q=50.278899,8.801589&sll=50.278899,8.801589&sspn=0.035761,0.085831
				log completeURL
				
				set modifiedURL to replace_chars(completeURL, "&", "=")
				
				set completeLocation to item 2 of splitText(modifiedURL, "=")
				
				set lati to replace_chars(item 1 of splitText(completeLocation, ","), ".", ",") as number
				set longi to replace_chars(item 2 of splitText(completeLocation, ","), ".", ",") as number
				
				
			else
				-- Koordinaden für die Selection raussuchen
				repeat with possible_location in myLocations
					if item 1 of possible_location is equal to mySelection then
						
						-- Koord setzen
						log item 1 of possible_location
						log "gefunden"
						
						set lati to item 2 of possible_location
						set longi to item 3 of possible_location
						log lati as string
						log longi as string
						
					end if
				end repeat
			end if
			set meldung to meldung & ((mySelection & " mit Koordinaten " & lati as string) & "/" & longi as string) & return
			
			tell application "Photos"
				activate
				-- Add the photo you want to search for to a top level album as the first item in the album
				
				try
					
					set sel to selection
					if sel is {} then error "The selection  is empty" -- no selection
					
				on error errTexttwo number errNumtwo
					display dialog "No photos selected " & errNumtwo & return & errTexttwo
					return
				end try
				set i_count to 0
				repeat with source in sel
					set i_count to i_count + 1
					try
						tell source
							set its location to {lati, longi}
							
						end tell
					on error errTexttwo number errNumtwo
						display dialog "Konnte nicht eingefügt werden " & errNumtwo & return & errTexttwo
						return
					end try
					
					tell source -- lese keywords ein, prüfe ob "Ohne Standort" enthalten ist und entferne es
						set keywordsSource to get the keywords
					end tell
					if keywordsSource is not equal to missing value then
						
						-- "Ohne Standort" aus den Keywords entfernen
						set theList to keywordsSource
						
						set itemsToDelete to {"Ohne Standort"}
						
						set cleanList to {}
						
						repeat with i_keywords from 1 to count theList
							if {theList's item i_keywords} is not in itemsToDelete then set cleanList's end to theList's item i_keywords
						end repeat
						tell source
							if cleanList is not equal to missing value then set its keywords to cleanList
						end tell
					end if
				end repeat
				set meldung to meldung & "für " & i_count & " Bilder gesetzt."
			end tell
			
		end if
	else if item 1 of choosen_Script is equal to "Zeige weitere Alben" then
		log "Starte mit Schleife " & item 1 of choosen_Script
		
		tell application "Photos"
			activate
			-- Add the photo you want to search for to a top level album as the first item in the album
			
			set resultcaption to "Suche nach: "
			try
				
				set sel to selection
				if sel is {} then error "The selection  is empty" -- no selection
				
			on error errTexttwo number errNumtwo
				display dialog "No photos selected " & errNumtwo & return & errTexttwo
				return
			end try
			
			set imagename to "unknown filename"
			try
				set target to item 1 of sel -- the image to seach for
				tell target
					set imagename to the filename of target
				end tell
			on error errTexttwo number errNumtwo
				display dialog "Cannot get the filename of the first image: " & errNumtwo & return & errTexttwo
			end try
			set resultcaption to (resultcaption & imagename)
			
			try
				set item_id to id of item 1 of sel
			on error errText number errNum
				display dialog "Error: cannot get the image ID" & errNum & return & errText & "Trying again"
				
				try
					delay 2
					set item_id to id of item 1 of sel
				on error errTexttwo number errNumtwo
					display dialog "Skipping image due to repeated error: " & errNumtwo & return & errTexttwo
					error "giving up"
					return
				end try --second attempt
			end try
			
		end tell
		
		set theseNames to my find_folder_recursive(item_id, "initialize", {}, {})
		
		if theseNames is not {} then
			-- meldung anzeigen
			tell application "Photos"
				activate
				set theAlbumChoices to theseNames
				set theSelectedAlbum to choose from list theAlbumChoices with prompt "Gefunden in folgenden Alben:"
				if theSelectedAlbum is false then error number -128 -- user canceled
				set the clipboard to (item 1 of theSelectedAlbum as string)
				set meldung to (item 1 of the theSelectedAlbum as string) & " in die Zwischenablage kopiert."
				log meldung
				log "Fertig"
			end tell
		end if
	end if
end if
-- meldung anzeigen
tell application "Photos"
	activate
	display dialog meldung with title meldung_title
	log meldung
	log "Fertig"
end tell

-- ab hier wiederverwendete Funktionen
on find_album_selector(actualFolder, fullPath)
	tell application "Photos"
		set folderlist to {}
		set Albumlist to {}
		set entryList to {}
		if actualFolder = "initalize" then
			set folderlist to every folder
			
			set Albumlist to every album
		else
			set tmpPath to my splitText(fullPath, "/")
			
			set countMaxFolder to (length of tmpPath) - 1
			
			repeat with d from 1 to countMaxFolder
				
				if d = 1 then
					set temp_Folder to folder (item d of tmpPath)
				else
					set temp_Folder to folder (item d of tmpPath) in subfolder
				end if
				
				set subfolder to temp_Folder
				
			end repeat
			
			set folderlist to every folder in subfolder
			set Albumlist to every album in subfolder
		end if
		
		
		
		if length of folderlist > 0 then
			repeat with tempFolder in folderlist
				
				set end of entryList to "Folder:" & name of tempFolder
				
			end repeat
		end if
		if length of Albumlist > 0 then
			repeat with tempAlbum in Albumlist
				
				set end of entryList to "Album:" & name of tempAlbum
				
			end repeat
		end if
		
		set end of entryList to "Erstelle:Folder"
		set end of entryList to "Erstelle:Album"
		
		set theSelected to choose from list entryList with prompt "Gefunden in Ordner und Alben in :" & fullPath
		
		set ergebnis to my splitText(item 1 of theSelected, ":")
		
		if item 1 of ergebnis = "Erstelle" then
			if item 2 of ergebnis = "Folder" then
				set newFolder to the text returned of (display dialog "Wie soll der Ordner heißen?" default answer "")
				if actualFolder = "initalize" then
					make new folder named newFolder
				else
					make new folder named newFolder at subfolder
				end if
				set item 1 of ergebnis to "Folder"
				set item 2 of ergebnis to newFolder
			else if item 2 of ergebnis = "Album" then
				
				set newAlbum to the text returned of (display dialog "Wie soll das Album heißen?" default answer "")
				if actualFolder = "initalize" then
					make new album named newAlbum
				else
					make new album named newAlbum at subfolder
				end if
				set item 1 of ergebnis to "Album"
				set item 2 of ergebnis to newAlbum
			end if
		end if
		if item 1 of ergebnis = "Folder" then
			set fullPath to fullPath & item 2 of ergebnis & "/"
			set fullPath to my find_album_selector(item 2 of ergebnis, fullPath)
		else if item 1 of ergebnis = "Album" then
			set fullPath to fullPath & item 2 of ergebnis
			return fullPath
			
		end if
	end tell
	return fullPath
end find_album_selector

on find_folder_recursive(thisId, actualFolder, fullPath, sammlung)
	tell application "Photos"
		set tempPath to fullPath
		set tmp_sammlung to {}
		
		
		activate
		-- albumsliste setzten auf leer / ini it
		set albumNamesTemp to {}
		
		if actualFolder = "initialize" then
			set theseAlbums to (albums whose id of media items contains thisId)
			if theseAlbums is not {} then
				
				repeat with actualAlbum in theseAlbums
					set end of sammlung to (name of actualAlbum as string)
					log (name of actualAlbum as string)
					
				end repeat
			end if
			
			
			set folderlist to every folder
			
		else
			set folderlist to every folder of actualFolder
			set tempPath to tempPath & (name of actualFolder as string)
		end if
		
		set item_count to (get count of items in folderlist)
		
		repeat with the_item in folderlist
			
			
			set theseAlbums to (albums of the_item whose id of media items contains thisId)
			if theseAlbums is not {} then
				
				repeat with actualAlbum in theseAlbums
					set tmp_path_complete to "" as string
					if actualFolder is not "initialize" then
						
						repeat with tmp_path in tempPath
							set tmp_path_complete to tmp_path_complete & tmp_path & "/"
						end repeat
					end if
					set tmp_path_complete to (tmp_path_complete & name of the_item as string) & "/" & name of actualAlbum as string
					set end of sammlung to tmp_path_complete
					log tmp_path_complete
				end repeat
			end if
			set sammlung to my find_folder_recursive(thisId, the_item, tempPath, sammlung)
		end repeat
	end tell
	return sammlung
end find_folder_recursive

on find_album(complete_album_string)
	set textArray to my splitText(complete_album_string, "/")
	
	tell application "Photos"
		activate
		
		set countMax to length of textArray
		if countMax = 1 then
			set selectedAlbum to album (item 1 of textArray)
		else if countMax > 1 then
			set countMaxFolder to countMax - 1
			
			repeat with d from 1 to countMaxFolder
				
				if d = 1 then
					set tempFolder to folder (item d of textArray)
				else
					set tempFolder to folder (item d of textArray) in subfolder
				end if
				
				set subfolder to tempFolder
				
			end repeat
			
			set selectedAlbum to album (item countMax of textArray) in tempFolder
		end if
		
		return selectedAlbum
	end tell
end find_album

on splitText(theText, theDelimiter)
	set AppleScript's text item delimiters to theDelimiter
	set theTextItems to every text item of theText
	set AppleScript's text item delimiters to ""
	return theTextItems
end splitText

on list_unique(the_list)
	
	-- Neue Liste für die Rückgabe definieren
	set my_new_list to {}
	
	-- Jedes Item der bestehenden Liste durchlaufen
	repeat with counter from 1 to count the_list
		
		-- Neu zu setzenden Listeneintrag definieren
		set new_item to item counter of the_list
		
		-- Den neuen Listeneintrag nur dann an das Ende der
		-- neuen Liste hinzufügen, wenn er noch nicht enthalten ist
		considering case
			if new_item is not in my_new_list then
				set end of my_new_list to new_item
			end if
		end considering
		
	end repeat
	
	-- Neue Liste zurückgeben
	return my_new_list
	
end list_unique

on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars