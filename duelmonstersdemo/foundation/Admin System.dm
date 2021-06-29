/*
Variable Library

Variable           Purpose
--------           -------
list/owner         hardcoded list of the game's owners
list/admin         dynamic list of the game's admins
ban_save           directory where to save the ban_key, ban_ip, and ban_id lists
list/ban_key       a list of keys that are not allowed to connect to the game
list/ban_ip        a list of IP addresses that are not allowed to connect to the game
list/ban_id        a list of computer IDs that are not allowed to connect to the game
admin_save         directory where to save the admin list

Proc Library

Proc               Purpose
----               -------
add_ban            takes a client argument and adds that client's key, IP, and ID to
                   their respective lists and saves them into the ban_save directory
save_ban           saves the ban_key, ban_ip, and ban_id into the ban_Save directory
load_ban           retrieves any information from the ban_save directory and stores
                   the info into the respective ban_key, ban_ip, and ban_id lists
save_admin         saves the admin list into the admin_save directory
load_admin         retrieves any information stored in the admin_save directory and
                   stores the info into the admin list

isBanned           disallows connection if the connecting client's key, IP, or ID are
                   found within either of the ban lists, unless the connecting client
                   is found in the owner list

edit               owner verb - allows an owner to edit text and number variables during
                   runtime
delete             owner verb - allows an owner to delete an atom during runtime
add_admin          owner verb - allows an owner to add a key to the admin list and saves
                   the list
remove_admin       owner verb - allows an owner to remove a key from the admin list and
                   saves the list
wipe_save          owner verb - allows an owner to delete a savefile during runtime
                   without the host's permission
unmute             owner verb - not needed; allows an owner to unmute a player if necessary
unban              owner verb - allows an owner to remove a key, IP, or ID from their
                   respective lists during runtime
tele_coords        owner verb - allows an owner to teleport to any valid coordinate in the game

ban                admin verb - allows an admin to ban a player's key, IP, and ID simultaneously
manual_ban         admin verb - allows an admin to ban a player's key, IP, or ID selectively
mute               admin verb - allows an admin to disable a player's chat
teleport           admin verb - allows an admin to teleport next to a player
*/

var
	list/owner = list("Spunky_Girl")
	list/admin
	ban_save = "saves/ban.rofl"
	list/ban_key
	list/ban_ip
	list/ban_id
	admin_save = "saves/admin.rofl"
proc
	add_ban(client/c)
		if(c)
			if(!ban_key) ban_key = new
			ban_key += c.key
			if(!ban_ip) ban_ip = new
			ban_ip += c.address
			ban_ip[c.address] = c.key
			if(!ban_id) ban_id = new
			ban_id += c.computer_id
			ban_id[c.computer_id] = c.key
			save_ban()
	save_ban()
		if(fexists(ban_save))
			fdel(ban_save)
		if(ban_key || ban_ip || ban_id)
			var/savefile/s = new(ban_save)
			s["keys"] << ban_key
			s["IPs"] << ban_ip
			s["IDs"] << ban_id
	load_ban()
		if(fexists(ban_save))
			var/savefile/s = new(ban_save)
			s["keys"] >> ban_key
			s["IPs"] >> ban_ip
			s["IDs"] >> ban_id
	save_admin()
		if(fexists(admin_save))
			fdel(admin_save)
		var/savefile/s = new(admin_save)
		s["admins"] << admin
	load_admin()
		if(fexists(admin_save))
			var/savefile/s = new(admin_save)
			s["admins"] >> admin

world/New()
	..()
	load_ban()
client
	var
		rank = null
	proc/isBanned()
		if(src.key in owner)
			if((src.key in ban_key) || (src.address in ban_ip) || (src.computer_id in ban_id))
				src<<"<b><font color=red>Owner ban fail-safe has been triggered!</font></b>"
				return 0
		if(src.key in ban_key)
			return 1
		if(src.address in ban_ip)
			return 1
		if(src.computer_id in ban_id)
			return 1
		return 0
	New()
		..()
		if(!src.isBanned())
			if(src.key in owner)
				src.verbs += typesof("/owner/verb")
				src.verbs += typesof("/admin/verb")
				src.rank = "Owner"
			else if(src.key in admin)
				src.verbs += typesof("/admin/verb")
				src.rank = "Admin"
			for(var/client/c)
				if((c.key in admin) || (c.key in owner))
					c<<"<b>[src.key]</b> has connected <b>\[IP: [src.address]]\[ID: [src.computer_id]]</b>"
				else c<<"<b>[src.key]</b> has connected"

owner
	verb
		edit(atom/a in view(usr))
			set category = null
			if(a)
				var/list/L = new
				for(var/v in a.vars)
					if(isnum(a.vars[v]) || istext(a.vars[v]))
						L += v
						L[v] = a.vars[v]
				if(L.len)
					var/x = input(usr,"","Edit") as null|anything in L
					if(x)
						if(isnum(L[x]))
							var/n = input(usr,"","Edit: Number",a.vars[x]) as null|num
							if(n != L[x])
								a.vars[x] = n
						else if(istext(L[x]))
							var/t = input(usr,"","Edit: Text",a.vars[x]) as null|text
							if(t != L[x])
								a.vars[x] = t
		delete(atom/a in view(usr))
			set category = null
			if(a)
				if(alert(usr,"Are you sure you would like to delete [a.name]?","Delete","Yes","No") == "Yes")
					del a
		add_admin()
			set category = "Staff"
			var/list/L = new
			for(var/client/c)
				if(!(c.key in admin) && !(c.key in owner))
					L += c.mob
			if(L.len)
				var/mob/pl/x = input(usr,"","Add Admin") as null|anything in L
				if(x && alert(usr,"","Add Admin","Yes","No") == "Yes")
					if(!admin) admin = new
					admin += x.key
					x.verbs += typesof("/admin/verb")
					save_admin()
			else if(alert(usr,"There is no one online eligible to be given admin. Would you like to enter a key manually?","Add Admin","Yes","No") == "Yes")
				var/k = input(usr,"","Add Admin") as null|text
				if(k)
					if(!admin) admin = new
					admin += k
					save_admin()
					usr<<"You have added the key <i>[k]</i> to the admin list"
		remove_admin()
			set category = "Staff"
			var/list/L = new
			for(var/client/c)
				if(c.key in admin)
					L += c.mob
			if(L.len)
				var/mob/pl/x = input(usr,"","Remove Admin") as null|anything in L
				if(x && alert(usr,"Are you sure you would like to take [x.name] off the admin list?","Remove Admin","Yes","No") == "Yes")
					admin -= x.key
					x.verbs -= typesof("/admin/verb")
					save_admin()
			else if(alert(usr,"There is no one online eligible to be stripped of admin. Would you like to enter a key manually?","Remove Admin","Yes","No") == "Yes")
				var/k = input(usr,"","Remove Admin") as null|text
				if(k && (k in admin))
					admin -= k
					save_admin()
					usr<<"You have removed the key [k] from the admin list"
		wipe_save()
			set category = "Staff"
			var/k = input(usr,"Enter a BYOND Key","Wipe Save") as null|text
			if(k && fexists("saves/players/[k]/"))
				var/file = input(usr,"","Wipe Save") as null|anything in flist("saves/players/[k]/")
				if(file && alert(usr,"Are you sure you would like to delete [file]?","Wipe Save","Yes","No") == "Yes")
					file = "saves/players/[k]/"+file
					fdel(file)
					if(!fexists(file))
						usr<<"<b>[file]</b> deleted"
					else usr<<"BUG! File was not found"
			else usr<<"ERROR! No key entered or key not found"
		unmute()
			set category = "Staff"
			if(mute_list)
				var/k = input(usr,"","Unmute") as null|anything in mute_list
				if(k && alert(usr,"Are you sure you would like to unmute [k]?","Unmute","Yes","No") == "Yes")
					mute_list -= k
					for(var/client/c)
						if(c.key == k)
							var/mob/pl/m = c.mob
							mute_list -= m.key
							m<<"[usr.name] has wiped your mute duration"
							usr<<"You re-enabled [m.name]'s chat"
		unban()
			set category = "Staff"
			if(ban_key)
				var/k = input(usr,"","Unban") as null|anything in ban_key
				if(k && alert(usr,"Are you sure you would like to completely unban [k]?","Unban","Yes","No") == "Yes")
					ban_key -= k
					for(var/ip in ban_ip)
						if(ban_ip[ip] == k)
							ban_ip -= ip
					for(var/id in ban_id)
						if(ban_id[id] == k)
							ban_id -= id
					if(ban_key && !ban_key.len)
						ban_key = null
					if(ban_ip && !ban_ip.len)
						ban_ip = null
					if(ban_id && !ban_id.len)
						ban_id = null
					save_ban()
		tele_coords()
			set category = "Staff"
			var/x = input(usr,"Enter the X value\n\nMax: [world.maxx]","Teleport Coords: X") as null|num
			if(x)
				x = round(x)
				if(x < 1 || x > world.maxx)
					alert(usr,"Invalid X coordinate","ERROR!")
					return
				var/y = input(usr,"Enter the Y value\n\nMax: [world.maxy]","Teleport Coords: Y") as null|num
				if(y)
					y = round(y)
					if(y < 1 || y > world.maxy)
						alert(usr,"Invalid Y coordinate","ERROR!")
						return
					var/z = input(usr,"Enter the Z value\n\nMax: [world.maxz]","Teleport Coords: Z") as null|num
					if(z)
						z = round(z)
						if(z < 1 || z > world.maxz)
							alert(usr,"Invalid Z coordinate","ERROR!")
							return
						if(!usr.Move(locate(x,y,z)))
							usr.loc = locate(x,y,z)

admin
	verb
		ban()
			set category = "Staff"
			var/list/L = new
			if(usr.key in owner)
				for(var/client/c)
					if(c.key != usr.key)
						L += c.mob
			else if(usr.key in admin)
				for(var/client/c)
					if(!(c.key in owner) && !(c.key in admin))
						L += c.mob
			if(L.len)
				var/mob/pl/p = input(usr,"","Ban") as null|anything in L
				if(p)
					add_ban(p.client)
					for(var/client/c)
						if(c.mob == p)
							del c
							return
		manual_ban()
			set category = "Staff"
			switch(alert(usr,"","Manual Ban","Key","IP","ID"))
				if("Key")
					var/k = input(usr,"Enter a BYOND Key","Manual Ban: Key") as null|text
					if(k && alert(usr,"Are you sure you would like to ban [k]?","Manual Ban: Key","Yes","No") == "Yes")
						if(!ban_key) ban_key = new
						ban_key += k
						save_ban()
				if("IP")
					var/ip = input(usr,"Enter an IP address","Manual Ban: IP") as null|text
					if(ip && alert(usr,"Are you sure you would like to ban [ip]?","Manual Ban: IP","Yes","No") == "Yes")
						if(!ban_ip) ban_ip = new
						ban_ip += ip
						save_ban()
				if("ID")
					var/id = input(usr,"Enter a Computer ID","Manual Ban: ID") as null|text
					if(id && alert(usr,"Are you sure you would like to ban [id]?","Manual Ban: Key","Yes","No") == "Yes")
						if(!ban_id) ban_id = new
						ban_id += id
						save_ban()
		mute()
			set category = "Staff"
			var/list/L = new
			if(usr.key in owner)
				for(var/client/c)
					L += c.mob
			else if(usr.key in admin)
				for(var/client/c)
					if(!(c.key in admin) && !(c.key in owner))
						L += c.mob
			if(L.len)
				var/mob/pl/x = input(usr,"","Mute") as null|anything in L
				if(x)
					var/dur = input(usr,"Mute duration (in minutes)","Mute") as null|num
					if(dur)
						if(x.key in mute_list)
							mute_list[x.key] = dur*60
							x<<"Your chat's disabled duration has been renewed to [dur] minute\s ([dur*60] second\s)"
							usr<<"You renewed [x.name]'s mute duration to [dur] minute\s ([dur*60] second\s)"
						else
							if(!mute_list) mute_list = new
							mute_list += x.key
							mute_list[x.key] = dur*60
							save_mutes()
							x.mute_proc()
							x<<"Your chat has been disabled for [dur] minute\s ([dur*60] second\s)"
							usr<<"You disabled [x.name]'s chat for [dur] minute\s ([dur*60] second\s)"
							for(var/chat_prompt/p)
								if(p.owner == x)
									del p
		teleport()
			set category = "Staff"
			var/list/L = new
			for(var/client/c)
				if(c.key != usr.key)
					L += c.mob
			if(L.len)
				var/mob/pl/x = input(usr,"","Teleport") as null|anything in L
				if(x)
					var/list/turfs = new
					for(var/turf/t in oview(1,x))
						if(t && !t.density && t != get_step(x,x.dir))
							turfs += t
					usr.Move(pick(turfs))