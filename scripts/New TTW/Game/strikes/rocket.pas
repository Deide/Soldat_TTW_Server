procedure RocketStrike(Team: byte);
var
	dist: single;
	vec: tVector;
begin
	if Team = 1 then begin
		Teams[Team].Strike.X1 := Bunker[Teams[Team].bunker].X2;
		Teams[Team].Strike.X2 :=  Bunker[Teams[Team].bunker+1].X1;
	end else begin
		Teams[Team].Strike.X1 := Bunker[Teams[Team].bunker].X1;
		Teams[Team].Strike.X2 :=  Bunker[Teams[Team].bunker-1].X2;
	end;
	Teams[Team].Strike.Bullets := Trunc(abs(Teams[Team].Strike.X1-Teams[Team].Strike.X2)*0.02); //one bullet each 50 pixels
	
	Teams[Team].Strike.Y := Bunker[Teams[Team].bunker].ReinforcmentY-700;
	if not RayCast(Teams[Team].Strike.X1, Teams[Team].Strike.Y, Teams[Team].Strike.X1+10*(4/Team-3), Teams[Team].Strike.Y, dist, 11) then begin
		WriteConsole(Radioman[Team].ID, t(0, player[Radioman[Team].ID].translation, 'Sorry, but rocket strike can''t be droped here'), BAD);
		Teams[Team].SP := Teams[Team].SP + AIRCOCOST;
		Teams[Team].Strike.CountDown := 0;
		Teams[Team].Strike.InProgress := false;
		exit;
	end;
	while RayCast(Bunker[Teams[Team].bunker].ReinforcmentX, Teams[Team].Strike.Y, Bunker[Teams[Team].bunker].ReinforcmentX, Teams[Team].Strike.Y+10, dist, 6) do
		Teams[Team].Strike.Y := Teams[Team].Strike.Y + 10;
	repeat
		vec.x := Teams[Team].Strike.X1 + dist;
		vec.y := Teams[Team].Strike.Y;
		vec.vx := 30*(4/Team-3);
		vec.vy := 20;
		vec.t := 1000;
		BallisticCast(vec.x, vec.y, 0.06, vec);
		dist := dist + 10*(4/Team-3);
	until ((Team = 1) and (vec.x > Teams[Team].Strike.X2)) or ((Team = 2) and (vec.x < Teams[Team].Strike.X2));
	dist := dist - 20*(4/Team-3);
	Teams[Team].Strike.X2 := Bunker[Teams[Team].bunker].X1 + dist;
end;

procedure ProcessRocketStrike(Team: byte; Ticks: integer);
var
	vec: tVector;
	i, j, k: byte;
begin
	if Teams[Team].Strike.Bullets > 0 then begin
		if Teams[Team].Strike.Bullets > 3 then
			i := 2
		else
			i := 1;
		for j := i downto 1 do begin
			i := 0;
			while i < 20 do begin
				vec.X := RandFlt(Teams[Team].Strike.X1, Teams[Team].Strike.X2);
				if (abs(vec.X - Teams[Team].Strike.LastBullet.X) > 40) and (Teams[Team].Strike.LastBullet.X <> 0) then
					break;
				i := i + 1;
			end;	
			Teams[Team].Strike.LastBullet.X := vec.X;
			vec.Y := Teams[Team].Strike.Y;
			vec.t := 1000;
			vec.vx := 30*(4/Team-3);
			vec.vy := 20;
			CreateBullet(vec.X, vec.Y, vec.vx, vec.vy, 100, 4, Radioman[Team].ID);
			BallisticCast(vec.X, vec.Y, 0.06, vec);
			SetArrayLength(Teams[Team].Strike.Area, GetArrayLength(Teams[Team].Strike.Area)+1);
			Teams[Team].Strike.Area[GetArrayLength(Teams[Team].Strike.Area)-1].X :=  vec.X;
			Teams[Team].Strike.Area[GetArrayLength(Teams[Team].Strike.Area)-1].Y :=  vec.Y;
			Teams[Team].Strike.Area[GetArrayLength(Teams[Team].Strike.Area)-1].start :=  Ticks+1000-vec.t;
			Teams[Team].Strike.Bullets := Teams[Team].Strike.Bullets - 1;
		end;
	end;
	if GetArrayLength(Teams[Team].Strike.Area) > 0 then begin
		j := GetArrayLength(Teams[Team].Strike.Area)-1;
		for i := 0 to j do
			if Ticks+30 >= Teams[Team].Strike.Area[i].start then begin
				k := GetStatgunAt(Teams[Team].Strike.Area[i].X, Teams[Team].Strike.Area[i].Y, 0, 20);
				if k > 0 then
					DestroyStat(k);
				for k := 1 to MAXMINES do
					if Mines[k].placed then
						if IsInRange(Teams[Team].Strike.Area[i].X, Teams[Team].Strike.Area[i].Y, Mines[k].X, Mines[k].Y, 20) then
							DestroyMine(k);
				if i = j then
					SetArrayLength(Teams[Team].Strike.Area, GetArrayLength(Teams[Team].Strike.Area)-1)
				else begin
					j := j - 1;
					for k := i to j do begin
						Teams[Team].Strike.Area[k].X := Teams[Team].Strike.Area[k+1].X;
						Teams[Team].Strike.Area[k].Y := Teams[Team].Strike.Area[k+1].Y;
						Teams[Team].Strike.Area[k].start := Teams[Team].Strike.Area[k+1].start;
					end;
					SetArrayLength(Teams[Team].Strike.Area, j+1);
				end;
			end;
	end else if Teams[Team].Strike.Bullets = 0 then
		Teams[Team].Strike.InProgress := false;
end;