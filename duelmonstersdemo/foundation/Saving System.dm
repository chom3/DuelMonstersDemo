/*
Variable Library
Variable               Purpose
--------               -------
save_dir               directory in which the player will save their progress

list/overs             list of the player's overlays that WILL be saved
list/unders            list of the player's underlays that WILL be saved
list/t_overs           list of the player's overlays that will NOT be saved
list/t_unders          list of the player's underlays that will NOT be saved

Proc Library
Proc              Purpose
----              -------
save_proc         saves the player's progress in the save_dir directory
load_proc         loads the player's progress from the save_dir directory

redo_lays         rebuilds a mob's overlays/underlays/equipment

Verb Library
Verb              Purpose
----              -------
save_progress     calls the save_proc to save the player
*/

client
	var
		save_dir
	New()
		..()
		src.save_dir = "saves/players/[src.key]/save.rofl"
	proc
		save_proc()
			if(fexists(src.save_dir))
				fdel(src.save_dir)
			var/savefile/s = new(src.save_dir)
			s["mob"] << src.mob
			if(fexists(src.save_dir))
				return 1
			else return 0
		load_proc()
			if(fexists(src.save_dir))
				var/savefile/s = new(src.save_dir)
				var/mob/pl/m = src.mob
				s["mob"] >> src.mob
				del m
	verb
		save_progress()
			if(src.save_proc())
				src<<"Progress saved"
			else src<<"Saving failed"

mob
	Read(savefile/s)
		..()
		if(!src.Move(locate(s["last_x"],s["last_y"],s["last_z"])))
			src<<"Normal movement failed"
			src.loc = locate(s["last_x"],s["last_y"],s["last_z"])
		src.redo_lays()
	Write(savefile/s)
		src.overlays = null
		src.underlays = null
		..()
		s["last_x"] << src.x
		s["last_y"] << src.y
		s["last_z"] << src.z
		src.redo_lays()
	var
		list
			overs //saved overlays
			unders //saved underlays
		tmp
			list
				t_overs //unsaved overlays
				t_unders //unsaved underlays
	proc
		redo_lays()
			for(var/a in src.overs)
				src.overlays += a
			for(var/a in src.t_overs)
				src.overlays += a
			for(var/a in src.unders)
				src.underlays += a
			for(var/a in src.t_unders)
				src.underlays += a