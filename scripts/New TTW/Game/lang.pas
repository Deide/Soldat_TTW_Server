procedure OnLangJoinGame(ID: byte);
var
	countryid: byte;
begin
	//countryid := GetCountryID(IDToIP(ID));
	countryid := 0;
	case countryid of
		0: begin
			//WriteConsole(ID, 'Script were unable to detect your country', BAD);
			WriteConsole(ID, 'loaded English translation', GOOD);
		end;
		225, 77: player[ID].translation := 0;
		5, 36, 63, 79, 122, 130, 132, 222, 227: begin
			WriteConsole(ID, 'We have no translation for'+CountryNames[countryid]+' yet!', BAD);
			WriteConsole(ID, 'Russian translation loaded instead', GOOD);
			player[ID].translation := 185;
		end;
		17, 22, 201, 240: begin
			WriteConsole(ID, 'We have no translation for'+CountryNames[countryid]+' yet!', BAD);
			WriteConsole(ID, 'Dutch translation loaded instead', GOOD);
			player[ID].translation := 185;
		end;
		19, 194, 239: begin
			WriteConsole(ID, 'We have no translation for'+CountryNames[countryid]+' yet!', BAD);
			WriteConsole(ID, 'Croatian translation loaded instead', GOOD);
			player[ID].translation := 97;
		end;
		15, 43: begin
			WriteConsole(ID, 'We have no translation for'+CountryNames[countryid]+' yet!', BAD);
			WriteConsole(ID, 'German translation loaded instead', GOOD);
			player[ID].translation := 56;
		end;		
		22, 23, 27, 26, 47, 38, 41, 40, 57, 207, 116, 85, 76, 98, 131, 137, 140, 135, 157, 42, 186, 199, 189, 209, 114, 24, 52, 59, 64, 87, 92, 124, 134, 146, 149, 136, 184, 125, 202, 214, 233: begin
			WriteConsole(ID, 'We have no translation for'+CountryNames[countryid]+' yet!', BAD);
			WriteConsole(ID, 'French translation loaded instead', GOOD);
			player[ID].translation := 74;
		end;
		else if GetArrayLength(translation[countryid]) > 0 then begin
			player[ID].translation := countryid;
			WriteConsole(ID, 'Loaded translation for '+CountryNames[countryid], GOOD);
		end else begin
			WriteConsole(ID, 'We don''t have translation for '+CountryNames[countryid]+' yet!', BAD);
			WriteConsole(ID, 'Visit our forums to help us translating this gamemode!', BAD);
		end;
	end;
	if player[ID].translation <> 0 then
		WriteConsole(ID, 'To switch to english version, write /english', GOOD);
	WriteConsole(ID, 'To see other available languages, do /langs', GOOD);
end;

function OnLangCommand(ID: byte; Text: string): boolean;
begin
	case LowerCase(GetPiece(Text, ' ', 0)) of
		'/english': begin
			player[ID].translation := 0;
			WriteConsole(ID, 'Switched to English version.', GOOD);
		end;
		'/russian': begin
			player[ID].translation := 185;
			WriteConsole(ID, 'Switched to Russian version.', GOOD);
		end;
		'/polish': begin
			player[ID].translation := 174;
			WriteConsole(ID, 'Switched to Polish version.', GOOD);
		end;
		'/german': begin
			player[ID].translation := 56;
			WriteConsole(ID, 'Switched to German version.', GOOD);
		end;
		'/dutch': begin
			player[ID].translation := 161;
			WriteConsole(ID, 'Switched to Dutch version.', GOOD);
		end;
		'/croatian': begin
			player[ID].translation := 97;
			WriteConsole(ID, 'Switched to Croatian version.', GOOD);
		end;
		'/french': begin
			player[ID].translation := 74;
			WriteConsole(ID, 'Switched to French version.', GOOD);
		end;
		'/turkish': begin
			player[ID].translation := 217;
			WriteConsole(ID, 'Switched to Turkish version.', GOOD);
		end;		
		'/langs', '/languages': begin
			WriteConsole(ID, 'Translations available:', GOOD);
			WriteConsole(ID, 'Croatian, Dutch, English, German, Polish, Russian, French, Turkish', GOOD);
		end;
		else exit;
	end;
	Result := false;
end;
