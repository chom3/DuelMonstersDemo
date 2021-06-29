/*
Variable Library
Variable                Purpose
--------                -------
list/friends            a list of keys that the player adds to/removes from that
                        is used to display online status of the keys
list/ignores            a list of keys that the player adds to/removes from that
                        is used to filter out chat messages associated to the keys
friend_save             the directory in which the friends list and ignores list
                        will be saved; is different for each each

Proc Library
Proc                 Purpose
----                 -------
save_friends         stores any information contained in the friends and ignored lists
                     into the friend_save directory
load_friends


Verb Library
Verb                 Purpose
----                 -------
show_friends         outputs the friends list as well as online status to the player
show_ignored         outputs the ignores list to the player
add_friend           adds a key to the friends list
add_ignored          adds a key to the ignores list
remove_friend        deletes a key from the friends list
remove_ignored       deletes a key from the ignores list
*/

client
	var
		list/friends
		list/ignores
		friend_save
	verb
		show_friends()
			if(src.friends)
				var/list/dummy = src.friends.Copy()
				for(var/client/c)
					if(c.key in dummy)
						dummy -= c.key
						src<<"<font color=green>Online</font> <b>[c.mob.name]</b> ([c.key])[c.afk ? " <font color=red>Away</font>":null]"
				for(var/k in dummy)
					src<<"<font color=silver>Offline</font> ---------- ([k])"
			else src<<"You do not have any friends"
		show_ignored()
			if(src.ignores)
				src<<"<u><b>Ignore List</b></u>"
				for(var/k in src.ignores)
					src<<"([k])"
				src<<"----- ----- ----- ----- -----"
		add_friend()
			var/k = input(src,"Type in the BYOND Key of your friend","Add Friend") as null|text
			if(k && !(k in src.friends))
				if(!(k in src.ignores))
					if(!src.friends) src.friends = new
					src.friends += k
					src.save_friend()
				else src<<"This person is ignored"
		add_ignored()
			var/k = input(src,"Type in the BYOND Key of the person you want to ignore","Add Ignored") as null|text
			if(k && !(k in src.ignores))
				if(!(k in src.friends))
					if(!src.ignores) src.ignores = new
					src.ignores += k
					src.save_friend()
				else src<<"This person is your friend"
		remove_friend()
			if(src.friends)
				var/k = input(src,"","Remove Friend") as null|anything in src.friends
				if(k && (k in src.friends))
					src.friends -= k
					if(src.friends && !src.friends.len)
						src.friends = null
						if(!src.ignores) fdel(src.friend_save)
					else src.save_friend()
		remove_ignored()
			if(src.ignores)
				var/k = input(src,"","Remove Ignored") as null|anything in src.ignores
				if(k && (k in src.ignores))
					src.ignores -= k
					if(src.ignores && !src.ignores.len)
						src.ignores = null
						if(!src.friends) fdel(src.friend_save)
					else src.save_friend()
	proc
		save_friend()
			if(fexists(src.friend_save))
				fdel(friend_save)
			var/savefile/s = new(friend_save)
			s["friends"] << src.friends
			s["ignores"] << src.ignores
		load_friend()
			if(fexists(friend_save))
				var/savefile/s = new(friend_save)
				s["friends"] >> src.friends
				s["ignores"] >> src.ignores
				src<<"Friend list & Ignore list loaded"

client/New()
	..()
	src.friend_save = "saves/players/[src.key]/friends.rofl"
	src.load_friend()