function mi_vse_umrem(player)
	if GetObjectiveState("obj1", player)==OBJECTIVE_FAILED then
		SetObjectiveState("obj2", OBJECTIVE_ACTIVE);
		Trigger(OBJECTIVE_STATE_CHANGE_TRIGGER, "obj1", nil);
	end;
end;

Trigger(OBJECTIVE_STATE_CHANGE_TRIGGER, "obj1", "mi_vse_umrem");