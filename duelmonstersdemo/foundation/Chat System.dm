/*
Variable Library

Variable            Purpose
--------            -------
list/mute_list      a list of stored mute durations associated to keys of players
                    whose chats have been disabled
mute_save           the directory in which the mute_list list is stored
list/html_filter    a hardcoded list of HTML tags that will trigger the filter

owner               a reference to the "owner" of the chat box

channel             distinguishes between which channel any messages will be sent
                    to
antiSpam            defined simply to prevent players from spamming chat messages
spam_delay          how long until a player can send another chat message
isMuted             when TRUE, disables the ability for a player to chat
accept_pm           when FALSE, no one will be able to send a private message to
                    that particular player

Proc Library

Proc                 Purpose
----                 -------
save_mutes           saves the mute_list list to the mute_save directory
load_mutes           retrieves information stored in the mute_save directory and
                     stores it in the mute_list list
filter               prevents chat message from displaying if filter returns positive

prompt               Gives the user a chat box to type in for the appropriate channel
                     as well as filtering the text submited

mute_proc            called when a player connects and disables their chat if their
                     key was found in the mute_list list with a duration
Topic                allows players to click on another player's name/key in the
                     output to send them a private message

Verb Library

Verb                 Purpose
----                 -------
toggle_channel       cycles which channel chat messages will be sent to
chat                 the main chat verb; sends chat messages to the appropriate players
                     based on the active channel
toggle_pm            allows players to turn off their reception of private messages
*/


var
	list/mute_list //format: key = muteTime (time in seconds)
	mute_save = "saves/mute.rofl"
	list/html_filter = list("<a","<b","<f","<i","<o","<s","<u")

world/New()
	..()
	load_mutes()

client/New()
	..()
	var/mob/pl/p = src.mob
	p.mute_proc()

proc
	save_mutes()
		if(fexists(mute_save))
			fdel(mute_save)
		var/savefile/s = new(mute_save)
		s["mutes"] << mute_list
	load_mutes()
		if(fexists(mute_save))
			var/savefile/s = new(mute_save)
			s["mutes"] >> mute_list
	findtet(list/F,txt)
		for(var/string in F)
			if(findtext(txt,string))
				return 1
		return 0

chat_prompt
	var
		mob/pl/owner
	New(mob/pl/a)
		src.owner = a
	proc
		prompt(mob/pl/a)
			var/x
			switch(a.channel)
				if(1) x = input(a,"","World Chat") as null|text
				if(2) x = input(a,"","Say Chat") as null|text
				if(3)
				if(4)
					if(a.client.myGuild)
						x = input(a,"","Guild Chat") as null|text
					else a<<"You do not have a guild"
			if(x)
				if(!findtext(html_filter,x))
					return x
				else
					alert(a,"No HTML is allowed in the chat","WARNING!")
					return -1
			else return null

mob
	pl
		var
			tmp
				channel = 1 //1: world (default), 2: say, 3: party
				antiSpam = FALSE //prevents spam
				spamDelay = 20 //delay before being able to send another message
				isMuted = FALSE
			accept_pm = TRUE
		verb
			toggel_channel()
				switch(src.channel)
					if(1)
						src.channel = 2
						src<<"Messages will be sent to everyone visible"
					if(2)
						src.channel = 3
						src<<"Messages will be sent to party members"
					if(3)
						src.channel = 4
						src<<"Messages will be sent to guild members"
					if(4)
						src.channel = 1
						src<<"Messages will be sent to everyone"
			chat()
				if(!src.antiSpam && !src.isMuted)
					for(var/chat_prompt/chats)
						if(chats.owner == src)
							return
					var/chat_prompt/prompt = new(src)
					var/txt = prompt.prompt(src)
					if(txt && txt != -1 && !src.antiSpam)
						var/staff_color = null
						if(src.key in owner) staff_color = "<font color=#3399FF>"
						else if(src.key in admin) staff_color = "<font color=#FF3300>"
						var/pm_html
						switch(src.channel)
							if(1)
								var/client/m = src.client
								for(var/client/c)
									if(!(src.key in m.ignores))
										pm_html = {"<a href="byond://?whisper=1&src=\ref[c.mob]&recipient=\ref[src]">[src.name]</a>)</b> [staff_color ? "[staff_color]":null][txt]</font>"}
										c<<"<font size=1>\[[time2text(world.timeofday,"hh:mm:ss")]]</font>-[src.client.myGuild ? "<font color=green>{[src.client.myGuild.tagg]}</font>":null]<b>("+pm_html
							if(2)
								var/client/m = src.client
								for(var/mob/pl/p in view(src))
									if(!(src.key in m.ignores))
										pm_html = {"<a href="byond://?whisper=1&src=\ref[p]&recipient=\ref[src]">[src.name]</a>}</b> [staff_color ? "[staff_color]":null][txt]</font>"}
										p<<"<font size=1>\[[time2text(world.timeofday,"hh:mm:ss")]]</font>-[src.client.myGuild ? "<font color=green>{[src.client.myGuild.tagg]}</font>":null]<b>{"+pm_html
							if(3)
							if(4)
								var/client/m = src.client
								for(var/client/c)
									if(!(src.key in m.ignores))
										if(c.myGuild == m.myGuild)
											pm_html = {"<a href="byond://?whisper=1&src=\ref[c.mob]&recipient=\ref[src]">[src.name]</a>~</b> [txt]</font>"}
											c<<"<font size=1>\[[time2text(world.timeofday,"hh:mm:ss")]]</font><b>~"+pm_html
						src.antiSpam = TRUE
						spawn(src.spamDelay)
							if(src) src.antiSpam = FALSE
			toggle_pm()
				if(src.accept_pm)
					src.accept_pm = FALSE
					src<<"You are no longer accepting Private Messages"
				else
					src.accept_pm = TRUE
					src<<"You are now accepting Private Messages"
		proc
			mute_proc()
				if(src.key in mute_list)
					if(mute_list[src.key] > 0)
						src.isMuted = TRUE
						src<<"Your chat has been disabled"
						spawn(0)
							while(src)
								sleep(10)
								if(src.key in mute_list)
									if(mute_list[src.key] > 0)
										mute_list[src.key] --
										save_mutes()
										continue
								break
							mute_list -= src.key
							if(mute_list && !mute_list.len)
								mute_list = null
								fdel(mute_save)
							src.isMuted = FALSE
							src<<"Your chat has been re-enabled"
		Topic(href,href_list[])
			..()
			if(!href || !href_list) return
			if(href_list["whisper"])
				var/mob/pl/rec = locate(href_list["recipient"])
				if(rec && rec.accept_pm)
					var/msg = input(src,"To: [rec.name]","Private Message") as null|text
					if(msg)
						if(!findtext(msg,html_filter))
							var/html = {"<a href="byond://?whisper=1&src=\ref[src]&recipient=\ref[rec]"><b>[rec.name]</b></a> [msg]"}
							src<<"<font color=yellow>PM</font><font size=1>\[[time2text(world.timeofday,"hh:mm:ss")]]</font> To "+html
							var/html2 = {"<a href="byond://?whisper=1&src=\ref[rec]&recipient=\ref[src]"><b>[src.name]</b></a> [msg]"}
							rec<<"<font color=yellow>PM</font><font size=1>\[[time2text(world.timeofday,"hh:mm:ss")]]</font> From "+html2
						else alert(src,"No HTML is allowed in the chat","WARNING!")
				else src<<"[rec.name] is not accepting private messages right now"