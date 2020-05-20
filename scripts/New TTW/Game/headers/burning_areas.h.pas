const
	MAXAREAS =      8; // max number of flame areas
	FLAMEAREADMG = 0; // damage of flames per second if player is in range
	AREADMG = 12; // damage of flames 
	FLAMESNUM = 6; // number of flames on burning area

type
	tBurningAreasSys = record
		FrequencyFactor, FlameRad: single;
		Active: boolean;
		area: array [1..MAXAREAS] of record
			active: boolean;
			x, y: single;
			fx, fy: array[1..FLAMESNUM] of single;
			fn: array[1..FLAMESNUM] of byte;
			fa: array[1..FLAMESNUM] of boolean;
			duration, owner, flameN: byte;
		end;
	end;

var
	BurningAreas: tBurningAreasSys;