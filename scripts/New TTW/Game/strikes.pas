function AddBot(Name: string; Team: byte): byte; forward;

procedure InitializeStrikes();
begin
	StrikeBot := AddBot('bomber', 5);
end;

procedure CallAirStrike(Team: byte; stype: (__enemybase, __napalm, __nuke, __barrage, __zeppelin, __airco, __clusterstr, __burst));
var sName: String;
begin
	Teams[Team].Strike.InProgress := true;
	Teams[Team].Strike.stype := stype;
	Teams[Team].Strike.CountDown := STRIKE_COUNTDOWN;
	
	case stype of
		__enemybase: begin
			EnemyBaseStrike(Team);
			sName := 'EnemyBase';
		end;
		__napalm: 	begin
			NapalmStrike(Team);
			sName := 'Napalm';
		end;
		__nuke: 	begin
			NukeStrike(Team);
			sName := 'Nuke';
		end;
		__barrage: 	begin
			BarrageStrike(Team);
			sName := 'Barrage';
		end;
		__zeppelin: begin
			ZeppelinStrike(Team);
			sName := 'Zeppelin';
		end;
		__airco: 	begin
			AircoStrike(Team);
			sName := 'Airco';
		end;
		__clusterstr: begin
			ClusterStrike(Team);
			sName := 'Cluststr';
		end;
		__burst:	begin
			BurstStrike(Team);
			sName := 'Burst';
		end;
	end;
	WriteLn('Team ' + inttostr(Team) + ' called an AirStrike: ' + sName);
end;

procedure ResetStrike(Team: byte);
begin
	Teams[Team].Strike.InProgress := false;
	Teams[Team].Strike.CountDown := 0;
	Teams[Team].Strike.Bullets := 0;
	Teams[Team].Strike.LastBullet.X := 0;
	SetArrayLength(Teams[Team].Strike.Area, 0);
end;

procedure ProcessAirStrike(Team: byte; Ticks: integer);
var
	i, j, k, l: byte;
begin
	if not Teams[Team].Strike.InProgress then
		exit;
	
	if Ticks mod 60 = 0 then begin
		if Teams[Team].Strike.CountDown > 0 then begin
			Teams[Team].Strike.CountDown := Teams[Team].Strike.CountDown - 1;
			if GetArrayLength(Teams[Team].member) > 0 then
				for i := 0 to GetArrayLength(Teams[Team].member) - 1 do
					case Teams[Team].Strike.stype of
						__enemybase: DrawText(Teams[Team].member[i], t(130, player[Teams[Team].member[i]].Translation, 'Enemy base strike')+iif_str(Teams[Team].Strike.CountDown > 0, ' ['+IntToStr(Teams[Team].Strike.CountDown)+']', '!'), 180, iif_uint32(Team = 1, $FF140A, $1414FF), 0.1, 20, 370);
						__napalm: DrawText(Teams[Team].member[i], t(131, player[Teams[Team].member[i]].Translation, 'Napalm strike')+iif_str(Teams[Team].Strike.CountDown > 0, ' ['+IntToStr(Teams[Team].Strike.CountDown)+']', '!'), 180, iif_uint32(Team = 1, $FF140A, $1414FF), 0.1, 20, 370);
						__nuke: DrawText(Teams[Team].member[i], t(132, player[Teams[Team].member[i]].Translation, 'Nuke strike')+iif_str(Teams[Team].Strike.CountDown > 0, ' ['+IntToStr(Teams[Team].Strike.CountDown)+']', '!'), 180, iif_uint32(Team = 1, $FF140A, $1414FF), 0.1, 20, 370);
						__barrage: DrawText(Teams[Team].member[i], t(133, player[Teams[Team].member[i]].Translation, 'Mortar barrage')+iif_str(Teams[Team].Strike.CountDown > 0, ' ['+IntToStr(Teams[Team].Strike.CountDown)+']', '!'), 180, iif_uint32(Team = 1, $FF140A, $1414FF), 0.1, 20, 370);
						__zeppelin: DrawText(Teams[Team].member[i], t(134, player[Teams[Team].member[i]].Translation, 'Zeppelin strike')+iif_str(Teams[Team].Strike.CountDown > 0, ' ['+IntToStr(Teams[Team].Strike.CountDown)+']', '!'), 180, iif_uint32(Team = 1, $FF140A, $1414FF), 0.1, 20, 370);
						__airco: DrawText(Teams[Team].member[i], t(135, player[Teams[Team].member[i]].Translation, 'Airco strike')+iif_str(Teams[Team].Strike.CountDown > 0, ' ['+IntToStr(Teams[Team].Strike.CountDown)+']', '!'), 180, iif_uint32(Team = 1, $FF140A, $1414FF), 0.1, 20, 370);
						__clusterstr: DrawText(Teams[Team].member[i], t(136, player[Teams[Team].member[i]].Translation, 'Cluster strike')+iif_str(Teams[Team].Strike.CountDown > 0, ' ['+IntToStr(Teams[Team].Strike.CountDown)+']', '!'), 180, iif_uint32(Team = 1, $FF140A, $1414FF), 0.1, 20, 370);
						__burst: DrawText(Teams[Team].member[i], t(137, player[Teams[Team].member[i]].Translation, 'Burst strike')+iif_str(Teams[Team].Strike.CountDown > 0, ' ['+IntToStr(Teams[Team].Strike.CountDown)+']', '!'), 180, iif_uint32(Team = 1, $FF140A, $1414FF), 0.1, 20, 370);
					end;
			if Teams[Team].Strike.CountDown > 0 then exit;
		end;
		case Teams[Team].Strike.stype of
			__enemybase: ProcessEnemyBaseStrike(Team, Ticks);
			__napalm: ProcessNapalmStrike(Team, Ticks);
			__nuke: ProcessNukeStrike(Team, Ticks);
			__barrage: ProcessBarrageStrike(Team, Ticks);
			__zeppelin: ProcessZeppelinStrike(Team, Ticks);
			__airco: ProcessAircoStrike(Team, Ticks);
			__clusterstr: ProcessClusterStrike(Team, Ticks);
			__burst: ProcessBurstStrike(Team, Ticks);
		end;
	end;
	
	if GetArrayLength(Teams[Team].Strike.Area) > 0 then begin
		j := GetArrayLength(Teams[Team].Strike.Area)-1;
		for i := 0 to j do
			if Ticks >= Teams[Team].Strike.Area[i].start then begin
				if Teams[Team].Strike.Area[i].child > 0 then begin
					case Teams[Team].Strike.stype of
						__napalm: Bomb(Teams[Team].Strike.Area[i].X, Teams[Team].Strike.Area[i].Y-10, ANGLE_30, ANGLE_60, 50, 150, true, 0, team, 1);
						__nuke: begin
							case Teams[Team].Strike.Area[i].child of
								1: Bomb(Teams[Team].Strike.Area[i].X, Teams[Team].Strike.Area[i].Y-10, ANGLE_60, ANGLE_80, 50, 150, false, 0, Team, 1);
								2: Bomb(Teams[Team].Strike.Area[i].X, Teams[Team].Strike.Area[i].Y-10, ANGLE_60, ANGLE_80, 50, Trunc(abs((Teams[Team].Strike.X1-Teams[Team].Strike.X2))) div 2, false, 1, Team, 1);
							end;
						end;
						__clusterstr: Bomb(Teams[Team].Strike.Area[i].X, Teams[Team].Strike.Area[i].Y-10, ANGLE_60, ANGLE_70, 50, 300, false, 0, Team, 1);
						__burst: begin
								if Team = 1 then
									Bomb2(Teams[Team].Strike.Area[i].X, Teams[Team].Strike.Area[i].Y-10, ANGLE_15, ANGLE_60, 300, 600, false, 0, Team, 2)
								else Bomb2(Teams[Team].Strike.Area[i].X, Teams[Team].Strike.Area[i].Y-10, ANGLE_15, ANGLE_60, 300, 600, false, 0, Team, 0);
						end;
					end;
					Teams[Team].Strike.Area[i].child := Teams[Team].Strike.Area[i].child - 1;
				end;
				
				k := GetStatgunAt(Teams[Team].Strike.Area[i].X, Teams[Team].Strike.Area[i].Y, Teams[Team].Strike.Area[i].range);
				if k > 0 then begin
					DestroyStat(k);
					SendToLive('rigsg '+inttostr(k));
					Teams[k].StatgunRefreshTimer := STATGUN_COOLDOWN_TIME;
					if GetArrayLength(Teams[k].member) > 0 then
						for l := 0 to GetArrayLength(Teams[k].member)-1 do
							WriteConsole(Teams[k].member[l], t(122, player[Teams[k].member[l]].translation, 'Your team''s statgun has been destroyed!'), BAD);
					k := 2/k;
					if GetArrayLength(Teams[k].member) > 0 then
						for l := 0 to GetArrayLength(Teams[l].member)-1 do
							WriteConsole(Teams[k].member[l], t(138, player[Teams[k].member[l]].translation, 'Airstrike destroyed enemy statgun!'), GOOD);
				end;
				for k := 1 to MAXMINES do
					if Mines[k].placed then
						if IsInRange(Teams[Team].Strike.Area[i].X, Teams[Team].Strike.Area[i].Y, Mines[k].X, Mines[k].Y, Teams[Team].Strike.Area[i].range) then begin
							DestroyMine(k, true);
						end;
				
				if i = j then
					SetArrayLength(Teams[Team].Strike.Area, GetArrayLength(Teams[Team].Strike.Area)-1)
				else begin
					j := j - 1;
					for k := i to j do begin
						Teams[Team].Strike.Area[k].X := Teams[Team].Strike.Area[k+1].X;
						Teams[Team].Strike.Area[k].Y := Teams[Team].Strike.Area[k+1].Y;
						Teams[Team].Strike.Area[k].start := Teams[Team].Strike.Area[k+1].start;
						Teams[Team].Strike.Area[k].child := Teams[Team].Strike.Area[k+1].child;
						Teams[Team].Strike.Area[k].range := Teams[Team].Strike.Area[k+1].range;
					end;
					SetArrayLength(Teams[Team].Strike.Area, j+1);
				end;
			end;
	end else if Teams[Team].Strike.Bullets = 0 then
		ResetStrike(Team);
end;
