procedure NukeStrike(Team: byte);
begin
	if Team = 1 then begin
		Teams[Team].Strike.X1 := Bunker[Teams[Team].bunker].X2+160;
		Teams[Team].Strike.X2 := Bunker[Teams[Team].bunker+1].X1-160;
	end else begin
		Teams[Team].Strike.X1 := Bunker[Teams[Team].bunker-1].X2+160;
		Teams[Team].Strike.X2 := Bunker[Teams[Team].bunker].X1-160;
	end;
	Teams[Team].Strike.Bullets := 1;
end;

procedure ProcessNukeStrike(Team: byte; Ticks: integer);
var
	vec: tVector;
begin
	if Teams[Team].Strike.Bullets > 0 then begin
		vec.X := (Teams[Team].Strike.X1+Teams[Team].Strike.X2)/2;
		vec.Y := (Bunker[Teams[Team].bunker].ReinforcmentY+Bunker[Teams[2/Team].bunker].ReinforcmentY)/2-700;
		vec.t := 1000;
		vec.vx := 0;
		vec.vy := 0;
		CreateBullet(vec.X, vec.Y, vec.vx, vec.vy, 100, 4, StrikeBot);
		BallisticCast(vec.X, vec.Y, 0.06, vec);
		SetArrayLength(Teams[Team].Strike.Area, GetArrayLength(Teams[Team].Strike.Area)+1);
		Teams[Team].Strike.Area[GetArrayLength(Teams[Team].Strike.Area)-1].X :=  vec.X;
		Teams[Team].Strike.Area[GetArrayLength(Teams[Team].Strike.Area)-1].Y :=  vec.Y;
		Teams[Team].Strike.Area[GetArrayLength(Teams[Team].Strike.Area)-1].start :=  Ticks+1000-vec.t;
		Teams[Team].Strike.Area[GetArrayLength(Teams[Team].Strike.Area)-1].child := 2;
		Teams[Team].Strike.Area[GetArrayLength(Teams[Team].Strike.Area)-1].range := 30;
		Teams[Team].Strike.Bullets := Teams[Team].Strike.Bullets - 1;
		Teams[Team].Strike.Bullets := 0;
	end;
end;