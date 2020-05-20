function Cmmd2RealCmd(ID, Task: byte; Cmmd: string; display: boolean): string;
var cmd: byte;
begin
	case Cmmd of
		'/heal', '/cmmd1', '/cc1', '/smoke': cmd := 1;
		'/def', '/cmmd2', '/cc2', '/takeoff':  cmd := 2;
		'/ofs', '/cmmd3', '/cc3', '/victory':  cmd := 3;
		'/smn', '/summon', '/summ', '/cmmd4', '/cc4', '/tabac': cmd := 4;
		else 
		begin
			Result := Cmmd;
			Exit;
		end;
	end;

	case Cmd of
		1: 	case Task of
				1: Result := '/mre';
				2: Result := '/mre';
				3: Result := '/vetme';
				4: Result := '/mre';
				5: Result := '/vestgen';
				6: Result := '/mre';
				7: Result := '/mine';
				8: Result := '';
				9: Result := '/stealth';
				10: Result := '/nade';
			end;
			
		2: 	case Task of
				1: Result := '/mre';
				2: Result := '/mre';
				3: Result := '/vet';
				4: Result := '/conquer';
				5: Result := '/tap';
				6: Result := '/rig';
				7: Result := '/build';
				8: Result := '';
				9: Result := '/obs';
				10: Result := '/nade';
			end;
			
		3: 	case Task of
				1: Result := '/mre';
				2: Result := '/mre';
				3: Result := '/vet';
				4: Result := '/conquer';
				5: Result := '/para';
				6: Result := '/rig';
				7: Result := '/get';
				8: Result := '';
				9: Result := '/place 3';
				10: Result := '/mark';
			end;			

		4: 	case Task of
				1: Result := '/mre';
				2: Result := '/mre';
				3: Result := '/kit';
				4: Result := '/conquer';
				5: Result := '/barrage';
				6: Result := '/rig';
				7: Result := '/fix';
				8: Result := '';
				9: Result := '/act';
				10: Result := '/mortar';
			end;			
		end;
	if display then WriteConsole(ID, Cmmd + ' -> ' + Result, INFORMATION);
end;

function GetFoodMessage(Lang: byte): string;
begin
	case RandInt(1, 10) of
		1: Result := t(1, Lang, 'Beans! Time for some deadly flatulence.');
		2: Result := t(2, Lang, 'Nice!');
		3: Result := t(3, Lang, 'Burger time!');
		4: Result := t(4, Lang, 'Ahhhhhh.');
		5: Result := t(5, Lang, 'Just what I needed!');
		6: Result := t(6, Lang, 'That hits the spot!');
		7: Result := t(7, Lang, 'Yes!');
		8: Result := t(8, Lang, 'Who needs a medic anyway?');
		9: Result := t(9, Lang, 'Apples are good for your health!');
		10: Result := t(10, Lang, 'You feel much better');
	end;
end;

function taskToShortName(Task, Lang: byte): string;
begin
	case Task of
		1: Result := t(11, Lang, 'LRI');
		2: Result := t(12, Lang, 'SRI');
		3: Result := t(13, Lang, 'Med');
		4: Result := t(14, Lang, 'Gen');
		5: Result := t(15, Lang, 'Rad');
		6: Result := t(16, Lang, 'Sab');
		7: Result := t(17, Lang, 'Eng');
		8: Result := t(18, Lang, 'Eli');
		9: Result := t(19, Lang, 'Spy');
		10: Result := t(20, Lang, 'Art');
		11: Result := 'Para';
	end;
end;

function taskToName(Task, Lang: byte): string;
begin
	case Task of
		1: Result := t(21, Lang, 'Long range infantry');
		2: Result := t(22, Lang, 'Short range infantry');
		3: Result := t(23, Lang, 'Medic');
		4: Result := t(24, Lang, 'General');
		5: Result := t(25, Lang, 'Radioman');
		6: Result := t(26, Lang, 'Saboteur');
		7: Result := t(27, Lang, 'Engineer');
		8: Result := t(28, Lang, 'Elite');
		9: Result := t(29, Lang, 'The Spy');
		10: Result := t(30, Lang, 'Artillery');
		11: Result := 'Paratrooper';
	end;
end;

procedure DisplayTable(ID: byte);
var
	i, w: byte;
	str, Text: string;
begin
	WriteConsole(ID, t(31, player[ID].translation, 'Quick commands:'), H_COLOUR);
	WriteConsole(ID, t(32, player[ID].translation, 'TASK'), I_COLOUR);
	WriteConsole(ID, '      |/cc1     |/cc2     |/cc3     |/cc4     |', I_COLOUR);
	WriteConsole(ID, '      |/cmmd1   |/cmmd2   |/cmmd3   |/cmmd4   |', I_COLOUR);
	for i := 1 to 10 do begin
		str := taskToShortName(i, player[ID].translation);
		str := str + StringOfChar(' ',6 - Length(str))+'|';
		for w := 1 to 4 do begin
			Text := Cmmd2RealCmd(ID, i, '/cmmd'+IntToStr(w), false);
			str := str + Text + StringOfChar(' ', 8 - Length(Text))+' |';
		end;
		if player[ID].task = i then WriteConsole(ID, UpperCase(str), $FF7F50) else WriteConsole(ID, str, INFORMATION);
	end;
	WriteConsole(ID, t(33, player[ID].translation, 'You are able to play all tasks using only set of 4 taunts'), I_COLOUR);
	WriteConsole(ID, t(34, player[ID].translation, 'You can use Hexer taunts as aliases to commands (/heal, /def, /ofs, /smn)'), I_COLOUR);
end;

procedure DisplayInfo(ID: byte; Text: string);
begin
	WriteConsole(ID, ' ', INFORMATION);
	case Text of
		'/help', '!help': 	begin
						WriteConsole(ID, t(35, player[ID].translation, '* Tactical Trenchwar *'), H_COLOUR );
						WriteConsole(ID, t(36, player[ID].translation, 'Tactical trenchwar is about teamwork, every soldier has'), INFORMATION );
						WriteConsole(ID, t(37, player[ID].translation, 'a distinct task in the team. There are 10 tasks available.'), INFORMATION );
						Sleep(10);
						WriteConsole(ID, t(38, player[ID].translation, 'Type /apply for a list of all tasks'), C_COLOUR );
						WriteConsole(ID, t(39, player[ID].translation, 'Type /commands to get a list of commands'), C_COLOUR );
					end;	
		
		
		'/apply': begin
						WriteConsole(ID, t(40, player[ID].translation, 'Please choose a task. To apply, type:'), H_COLOUR );
						WriteConsole(ID, t(41, player[ID].translation, '/short  for short range infantry'), C_COLOUR );
						WriteConsole(ID, t(42, player[ID].translation, '/long   for long range infantry'), C_COLOUR );
						WriteConsole(ID, t(43, player[ID].translation, '/gen    for General who conquers bunkers'), C_COLOUR );
						WriteConsole(ID, t(44, player[ID].translation, '/medic  for Medic'), C_COLOUR );
						WriteConsole(ID, t(45, player[ID].translation, '/eng    for Engineer who has a statgun and mines'), C_COLOUR );;
						WriteConsole(ID, t(46, player[ID].translation, '/rad    for Radioman who orders supplies for the team'), C_COLOUR );
						WriteConsole(ID, t(47, player[ID].translation, '/elite  for Elite, the sharpshooter'), C_COLOUR );
						WriteConsole(ID, t(48, player[ID].translation, '/art    for the Artillery'), C_COLOUR );
						WriteConsole(ID, t(49, player[ID].translation, '/spy    for Spy who uses stealth and timed bombs'), C_COLOUR );
						WriteConsole(ID, t(50, player[ID].translation, '/sabo   for Saboteur who''s able to rig'), C_COLOUR );
					end;	
		
		
		'/commands': begin
						WriteConsole(ID, t(51, player[ID].translation, 'Global commands:'), H_COLOUR);
						WriteConsole(ID, t(52, player[ID].translation, '/apply - list of all available tasks'), C_COLOUR );							
						WriteConsole(ID, t(53, player[ID].translation, '/list  - shows all tasks in your team'), C_COLOUR );
						WriteConsole(ID, t(54, player[ID].translation, '/free  - shows a list of free tasks'), C_COLOUR);							
						WriteConsole(ID, t(55, player[ID].translation, '/table - shows a table of commands aliases'), C_COLOUR);
						WriteConsole(ID, t(56, player[ID].translation, '/maps  - shows the list of maps'), C_COLOUR );
						WriteConsole(ID, t(57, player[ID].translation, '/quick - chooses a random task'), C_COLOUR);
						WriteConsole(ID, '---------', H_COLOUR);
						WriteConsole(ID, t(58, player[ID].translation, 'Task specific commands:'), H_COLOUR);
					end;
		
		'/table': DisplayTable(ID);
	end;
end;
