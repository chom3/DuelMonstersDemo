/*
Variable Library
Variable       Purpose
--------       -------
afk            TRUE means the player is Away From Keyboard (AFK)
afk_limit      this is the time limit of inactivity before the player is put on auto-AFK

Verb Library
Verb             Purpose
----             -------
online_players   outputs a list of players connected to the world, their character
                 name, their key, and whether or not they are AFK

afk              Marks the player has AFK, or unmarks them if they were AFK
report_bug       the importance of bug reports is self-explainatory; this gives players
                 the ability to fill out a bug report which will be added to to a .txt
                 file for the game owner(s) to look at later
*/

mob
	pl
		verb
			online_players()
				src<<"----- ----- ----- ----- -----"
				if((usr.key in admin) || (usr.key in owner))
					for(var/client/c)
						usr<<"[c.afk ? "<font color=red>Away</font> ":null][c.rank ? "{[c.rank]} ":null]<b>[c.mob.name]</b> ([c.key]) <b>\[IP: [c.address]]\[ID: [c.computer_id]]</b>"
				else
					for(var/client/c)
						usr<<"[c.afk ? "<font color=red>Away</font> ":null][c.rank ? "{[c.rank]} ":null]<b>[c.mob.name]</b> ([c.key])"
				src<<"----- ----- ----- ----- -----"

client
	var
		afk = FALSE
		afk_limit = 600
	verb
		afk()
			if(!afk)
				src.afk = TRUE
				src<<"You are now marked as Away"
			else
				src.afk = FALSE
				src<<"You are no longer marked as Away"
		report_bug()
			var/report = input(src,"Please be VERY specific. Your key, IP, ID, and date of submission will be recorded along with the report.","Report Bug") as null|message
			if(report)
				text2file("[time2text(world.timeofday,"Month DD, YYYY - hh:mm")]\n[src.key] \[IP: [src.address]]\[ID: [src.computer_id]]\n[report]\n\n","saves/bug reports.txt")
	Stat()
		if(!src.afk && src.inactivity >= src.afk_limit)
			src.afk = TRUE
			src<<"You are now marked as away"