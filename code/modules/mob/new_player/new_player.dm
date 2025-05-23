//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	var/ready = 0
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		 //Player counts for the Lobby tab
	var/totalPlayersReady = 0
	var/datum/browser/panel
	var/datum/tgui_module/late_choices/late_choices_dialog = null
	var/datum/tgui_module/manifest/manifest_panel = null
	universal_speak = 1

	invisibility = 101

	density = 0
	stat = DEAD
	movement_handlers = list()

	anchored = 1	//  don't get pushed around
/*
/mob/new_player/New()
	mob_list += src*/

/mob/new_player/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="")
	if (client)
		client.ooc(message)

/mob/new_player/verb/new_player_panel()
	set src = usr
	new_player_panel_proc()


/mob/new_player/proc/new_player_panel_proc()
	var/output = "<div align='center'><B>New Player Options</B>"
	output +="<hr>"
	output += "<p><a href='byond://?src=\ref[src];show_preferences=1'>Setup Character</A></p>"

	if(SSticker.current_state <= GAME_STATE_PREGAME)
		if(ready)
			output += "<p>\[ <span class='linkOn'><b>Ready</b></span> | <a href='byond://?src=\ref[src];ready=0'>Not Ready</a> \]</p>"
		else
			output += "<p>\[ <a href='byond://?src=\ref[src];ready=1'>Ready</a> | <span class='linkOn'><b>Not Ready</b></span> \]</p>"

	else
		output += "<a href='byond://?src=\ref[src];manifest=1'>View the Crew Manifest</A><br><br>"
		output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</A></p>"

	output += "<p><a href='byond://?src=\ref[src];observe=1'>Observe</A></p>"

	if(!IsGuestKey(src.key))
		establish_db_connection()
		if(dbcon.IsConnected())
			var/isadmin = 0
			if(src.client && src.client.holder)
				isadmin = 1
			// TODO: reimplement database interaction
			var/DBQuery/query = dbcon.NewQuery("SELECT id FROM erro_poll_question WHERE [(isadmin ? "" : "adminonly = false AND")] Now() BETWEEN starttime AND endtime AND id NOT IN (SELECT pollid FROM erro_poll_vote WHERE ckey = \"[ckey]\") AND id NOT IN (SELECT pollid FROM erro_poll_textreply WHERE ckey = \"[ckey]\")")
			query.Execute()
			var/newpoll = 0
			while(query.NextRow())
				newpoll = 1
				break

			if(newpoll)
				output += "<p><b><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A> (NEW!)</b></p>"
			else
				output += "<p><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A></p>"

	output += "</div>"

	panel = new(src, "Welcome","Welcome", 210, 280, src)
	panel.set_window_options("can_close=0")
	panel.set_content(output)
	panel.open()
	return

/mob/new_player/get_status_tab_items()
	. = ..()

	if(SSticker.current_state == GAME_STATE_PREGAME)
		// stat("Storyteller:", "[master_storyteller]") // Old setting for showing the game mode
		. += "Time To Start: [SSticker.pregame_timeleft][round_progressing ? "" : " (DELAYED)"]"
		. += "Players: [totalPlayers]"
		. += "Players Ready: [totalPlayersReady]"

		totalPlayers = 0
		totalPlayersReady = 0
		for(var/mob/new_player/player in GLOB.player_list)
			totalPlayers++
			if(player.ready)
				totalPlayersReady++
				var/job_of_choice = "Unknown"
				// Player chose to be a vagabond, that takes priority over all other settings,
				// and is in a low priority job list for some reason
				if("Colonist" in player.client.prefs.job_low)
					job_of_choice = "Colonist"
				// Only take top priority job into account, no use divining what lower priority job player could get
				else if(player.client.prefs.job_high)
					job_of_choice = player.client.prefs.job_high
				. += "[player.client.prefs.real_name] : [job_of_choice]"

/mob/new_player/Topic(href, href_list[])
	if(src != usr || !client)
		return 0

	if(href_list["show_preferences"])
		client.prefs.ShowChoices(src)
		return 1

	if(href_list["ready"])
		if(SSticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
			if(!ready)
				// Warn the player if they are trying to spawn without a brain
				var/datum/body_modification/mod = client.prefs.get_modification(BP_BRAIN)
				if(istype(mod, /datum/body_modification/limb/amputation))
					if(alert(src,"Are you sure you wish to spawn without a brain? This will likely cause you to do die immediately. \
								If not, go to the Augmentation section of Setup Character and change the \"brain\" slot from Removed to the desired kind of brain.", \
								"Player Setup", "Yes", "No") == "No")
						ready = 0
						return

				// Warn the player if they are trying to spawn without eyes
				mod = client.prefs.get_modification(BP_EYES)
				if(istype(mod, /datum/body_modification/limb/amputation))
					if(alert(src,"Are you sure you wish to spawn without eyes? It will likely be difficult to see without them. \
								If not, go to the Augmentation section of Setup Character and change the \"eyes\" slot from Removed to the desired kind of eyes.", \
								"Player Setup", "Yes", "No") == "No")
						ready = 0
						return
				var/datum/preferences/records_check = client.prefs.get_records()
				if(!records_check)
					if(alert(src,"Are you sure you wish to spawn without records? Our rules require them colonist roles. \
								Visitors, Hunters and Outsiders are excluded and may ignore this warning. \
								If not, go to the Backround section of Setup Character and set Records. \
								Our records templates and requirement specifics can be found at: https://sojourn13.space/wiki/Example_Paperwork#Character_Records", \
								"Player Setup", "Yes", "No") == "No")
						ready = 0
						return
			if(!BC_IsKeyAllowedToConnect(ckey) && !usr.client.holder)
				alert("Border Control is enabled, and you haven't been whitelisted!  You're welcome to observe, \
					   but in order to play, you'll need to be whitelisted!  Please visit our discord to submit an access request!" , "Border Control Active")
				ready = 0
			else
				ready = text2num(href_list["ready"])
		else
			ready = 0

	if(href_list["refresh"])
		panel.close()
		new_player_panel_proc()

	if(href_list["observe"])

		if(alert(src,"Are you sure you wish to observe? You will have to wait 30 minutes before being able join the crew! But you can play as a mouse or drone immediately.","Player Setup","Yes","No") == "Yes")
			if(!client)	return 1
			var/mob/observer/ghost/observer = new()

			spawning = 1
			sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))

			observer.started_as_observer = TRUE
			close_spawn_windows()
			var/turf/T = pick_spawn_location("Observer")
			if(istype(T))
				to_chat(src, SPAN_NOTICE("You are observer now."))
				observer.forceMove(T)
			else
				to_chat(src, "<span class='danger'>Could not locate an observer spawn point. Use the Teleport verb to jump to the station map.</span>")
			observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

			announce_ghost_joinleave(src)
			observer.icon = client.prefs.update_preview_icon()
			observer.alpha = 127

			if(client.prefs.be_random_name)
				client.prefs.real_name = random_name(client.prefs.gender)
			observer.real_name = client.prefs.real_name
			observer.name = observer.real_name
			if(!client.holder && !config.antag_hud_allowed)           // For new ghosts we remove the verb from even showing up if it's not allowed.
				remove_verb(observer, /mob/observer/ghost/verb/toggle_antagHUD)        // Poor guys, don't know what they are missing!
			//observer.key = key
			observer.ckey = ckey
			observer.initialise_postkey()

			observer.client.create_UI(observer.type)
			qdel(src)

			return 1

	if(href_list["late_join"])

		if(SSticker.current_state != GAME_STATE_PLAYING)
			to_chat(usr, "\red The round is either not ready, or has already finished...")
			return

		// Warn the player if they are trying to spawn without a brain
		var/datum/body_modification/mod = client.prefs.get_modification(BP_BRAIN)
		if(istype(mod, /datum/body_modification/limb/amputation))
			if(alert(src,"Are you sure you wish to spawn without a brain? This will likely cause you to do die immediately. \
			              If not, go to the Augmentation section of Setup Character and change the \"brain\" slot from Removed to the desired kind of brain.", \
						  "Player Setup", "Yes", "No") == "No")
				return 0

		// Warn the player if they are trying to spawn without eyes
		mod = client.prefs.get_modification(BP_EYES)
		if(istype(mod, /datum/body_modification/limb/amputation))
			if(alert(src,"Are you sure you wish to spawn without eyes? It will likely be difficult to see without them. \
			              If not, go to the Augmentation section of Setup Character and change the \"eyes\" slot from Removed to the desired kind of eyes.", \
						  "Player Setup", "Yes", "No") == "No")
				return 0
		// var/datum/preferences/records_check = client.prefs.get_records()
		// if(!records_check)
		// 	if(alert(src,"Are you sure you wish to spawn without records? You will likely be arrested.
		// 				If not, go to the Backround section of Setup Character and set Records.",
		// 				"Player Setup", "Yes", "No") == "No")
		// 		return 0
		if(!check_rights(R_ADMIN, 0))
			var/datum/species/S = all_species[client.prefs.species]
			if((S.spawn_flags & IS_WHITELISTED) && !is_alien_whitelisted(src, client.prefs.species))
				src << alert("You are currently not whitelisted to play [client.prefs.species].")
				return 0

			if(!(S.spawn_flags & CAN_JOIN))
				src << alert("Your current species, [client.prefs.species], is not available for play on the station.")
				return 0

		if(!BC_IsKeyAllowedToConnect(ckey) && !usr.client.holder)
			alert("Border Control is enabled, and you haven't been whitelisted!  You're welcome to observe, \
				   but in order to play, you'll need to be whitelisted!  Please visit our discord to submit an access request!" , "Border Control Active")
			return 0

		LateChoices()

	if(href_list["manifest"])
		if(!istype(manifest_panel))
			manifest_panel = new(src)
		manifest_panel.ui_interact(src)

	if(href_list["SelectedJob"])

		if(!config.enter_allowed)
			to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
			return
		else if(SSticker.nuke_in_progress)
			to_chat(usr, "<span class='danger'>The station is currently exploding. Joining would go poorly.</span>")
			return

		var/datum/species/S = all_species[client.prefs.species]
		if((S.spawn_flags & IS_WHITELISTED) && !is_alien_whitelisted(src, client.prefs.species))
			src << alert("You are currently not whitelisted to play [client.prefs.species].")
			return 0

		if(!(S.spawn_flags & CAN_JOIN))
			src << alert("Your current species, [client.prefs.species], is not available for play on the station.")
			return 0

		AttemptLateSpawn(href_list["SelectedJob"], client.prefs.spawnpoint)
		return

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)
	else if(!href_list["late_join"])
		new_player_panel()

	if(href_list["showpoll"])
		handle_player_polling()
		return

	if(href_list["poll_id"])
		var/poll_id = href_list["poll_id"]
		if(istext(poll_id))
			poll_id = text2num(poll_id)
		if(isnum(poll_id))
			src.poll_player(poll_id)
		return

	if(href_list["vote_on_poll"] && href_list["vote_type"])
		var/poll_id = text2num(href_list["vote_on_poll"])
		var/vote_type = href_list["vote_type"]
		switch(vote_type)
			if("OPTION")
				var/option_id = text2num(href_list["vote_option_id"])
				vote_on_poll(poll_id, option_id)
			if("TEXT")
				var/reply_text = href_list["reply_text"]
				log_text_poll_reply(poll_id, reply_text)


/mob/new_player/proc/IsJobAvailable(rank)
	var/datum/job/job = SSjob.GetJob(rank)
	if(!job)	return 0
	if(!job.is_position_available()) return 0
	if(jobban_isbanned(src,rank))	return 0
	return 1

/mob/new_player/proc/AttemptLateSpawn(rank, var/spawning_at)
	if(src != usr)
		return 0
	if(!BC_IsKeyAllowedToConnect(ckey) && !usr.client.holder)
		alert("Border Control is enabled, and you haven't been whitelisted!  You're welcome to observe, \
			but in order to play, you'll need to be whitelisted!  Please visit our discord to submit an access request!" , "Border Control Active")
		return FALSE
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(usr, "\red The round is either not ready, or has already finished...")
		return 0
	if(!config.enter_allowed)
		to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
		return 0
	if(!IsJobAvailable(rank))
		src << alert("[rank] is not available. Please try another.")
		return 0

	spawning = 1
	close_spawn_windows()

	SSjob.AssignRole(src, rank, 1)
	var/datum/job/job = src.mind?.assigned_job
	var/mob/living/character = create_character()	//creates the human and transfers vars and mind

	// AIs don't need a spawnpoint, they must spawn at an empty core
	if(rank == "AI")

		character = character.AIize(move=0) // AIize the character, but don't move them yet

			// IsJobAvailable for AI checks that there is an empty core available in this list
		var/obj/structure/AIcore/deactivated/C = empty_playable_ai_cores[1]
		empty_playable_ai_cores -= C

		character.forceMove(C.loc)

		AnnounceArrival(character, rank, "has been downloaded to the empty core in \the [character.loc.loc]")

		qdel(C)
		qdel(src)
		return


	var/datum/spawnpoint/spawnpoint = SSjob.get_spawnpoint_for(character.client, rank, late = TRUE)
	spawnpoint.put_mob(character) // This can fail, and it'll result in the players being left in space and not being teleported to the station. But atleast they'll be equipped. Needs to be fixed so a default case for extreme situations is added.
	character = SSjob.EquipRank(character, rank) //equips the human
	equip_custom_items(character)
	character.lastarea = get_area(loc)

	if(SSjob.ShouldCreateRecords(job.title))
		if(character.mind.assigned_role != "Robot")
			CreateModularRecord(character)
			data_core.manifest_inject(character)
			matchmaker.do_matchmaking()
			SSticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn

			//Grab some data from the character prefs for use in random news procs.

	AnnounceArrival(character, character.mind.assigned_role, spawnpoint.message)	//will not broadcast if there is no message



	qdel(src)

/datum/tgui_module/late_choices
	name = "Late Join"
	tgui_id = "LateChoices"

GLOBAL_VAR_CONST(TGUI_LATEJOIN_EVAC_HAS_EVACUATED, "Gone")
GLOBAL_VAR_CONST(TGUI_LATEJOIN_EVAC_EMERGENCY, "Emergency")
GLOBAL_VAR_CONST(TGUI_LATEJOIN_EVAC_TRANSFER, "CrewTransfer")
GLOBAL_VAR_CONST(TGUI_LATEJOIN_EVAC_NONE, "None")

/datum/tgui_module/late_choices/ui_data(mob/new_player/user)
	if(!istype(user))
		return

	var/list/dept_data = list(
		list("key" = "heads", "flag" = COMMAND),
		list("key" = "sec", "flag" = SECURITY),
		list("key" = "bls", "flag" = BLACKSHIELD),
		list("key" = "med", "flag" = MEDICAL),
		list("key" = "sci", "flag" = SCIENCE),
		list("key" = "chr", "flag" = CHURCH),
		list("key" = "sup", "flag" = LSS),
		list("key" = "eng", "flag" = ENGINEERING),
		list("key" = "pro", "flag" = PROSPECTORS),
		list("key" = "civ", "flag" = CIVILIAN),
		list("key" = "bot", "flag" = MISC),
		list("key" = "ldg", "flag" = LODGE)
	)

	var/list/data = list()

	var/name = user.client.prefs.be_random_name ? "friend" : user.client.prefs.real_name

	data["name"] = name
	data["duration"] = roundduration2text()

	if(evacuation_controller.has_evacuated())
		data["evac"] = GLOB.TGUI_LATEJOIN_EVAC_HAS_EVACUATED
	else if(evacuation_controller.is_evacuating())
		if(evacuation_controller.emergency_evacuation)
			data["evac"] = GLOB.TGUI_LATEJOIN_EVAC_EMERGENCY
		else
			data["evac"] = GLOB.TGUI_LATEJOIN_EVAC_TRANSFER
	else
		data["evac"] = GLOB.TGUI_LATEJOIN_EVAC_NONE

	var/list/jobs = list()

	for(var/datum/job/job in SSjob.occupations)
		if(job && user.IsJobAvailable(job.title))
			if(job.is_restricted(user.client.prefs))
				continue

			var/active = 0
			// Only players with the job assigned and AFK for less than 10 minutes count as active
			for(var/mob/M in GLOB.player_list)
				if(M.mind?.assigned_role == job.title && M.client?.inactivity <= 10 * 60 * 10)
					active++

			var/list/departments = list()
			for(var/list/department in dept_data)
				if(job.department_flag & department["flag"])
					departments += department["key"]

			jobs += list(list(
				"title" = job.title,
				"departments" = departments,
				"current_positions" = job.current_positions,
				"active" = active
			))

	data["jobs"] = jobs

	return data

/datum/tgui_module/late_choices/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(!isnewplayer(usr))
		return
	var/mob/new_player/user = usr

	switch(action)
		if("join")
			var/job = params["job"]

			if(!config.enter_allowed)
				to_chat(user, "<span class='notice'>There is an administrative lock on entering the game!</span>")
				return
			else if(SSticker.nuke_in_progress)
				to_chat(user, "<span class='danger'>The station is currently exploding. Joining would go poorly.</span>")
				return

			var/datum/species/S = all_species[user.client.prefs.species]
			if((S.spawn_flags & IS_WHITELISTED) && !is_alien_whitelisted(user, user.client.prefs.species))
				user << alert("You are currently not whitelisted to play [user.client.prefs.species].")
				return

			if(!(S.spawn_flags & CAN_JOIN))
				user << alert("Your current species, [user.client.prefs.species], is not available for play on the station.")
				return

			user.AttemptLateSpawn(job, user.client.prefs.spawnpoint)
			return

/datum/tgui_module/late_choices/ui_status(mob/user, datum/ui_state/state)
	if(isnewplayer(user))
		. = UI_INTERACTIVE
	else
		// should be impossible but hey
		. = UI_CLOSE

/mob/new_player/proc/LateChoices()
	if(!istype(late_choices_dialog))
		late_choices_dialog = new(src)
	late_choices_dialog.ui_interact(src)

/mob/new_player/proc/create_character()
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	var/use_species_name
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]
		use_species_name = chosen_species.get_station_variant() //Only used by pariahs atm.

	var/use_form_name
	var/datum/species_form/chosen_form
	if(client.prefs.species_form)
		chosen_form = GLOB.all_species_form_list[client.prefs.species_form]
		use_form_name = chosen_form.get_station_variant() //Not used at all but whatever.

	if(chosen_species && use_species_name)
		// Have to recheck admin due to no usr at roundstart. Latejoins are fine though.
		if(!is_species_whitelisted(chosen_species) && !has_admin_rights())
			use_species_name = null
		if(!is_form_whitelisted(chosen_form) && !has_admin_rights())
			use_form_name = null
		new_character = new(loc, use_species_name, use_form_name)

	if(!new_character)
		new_character = new(loc)
	if(chosen_species)
		chosen_species.add_stats(new_character)

	new_character.lastarea = get_area(loc)

	for(var/lang in client.prefs.alternate_languages)
		var/datum/language/chosen_language = all_languages[lang]
		if(chosen_language)
			if(!(chosen_language.flags & WHITELISTED) || is_alien_whitelisted(src, lang) || has_admin_rights() \
				|| (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
				new_character.add_language(lang)

	if(mind)
		mind.active = 0//we wish to transfer the key manually
		mind.original = new_character
		if(client.prefs.relations.len)
			for(var/T in client.prefs.relations)
				var/TT = matchmaker.relation_types[T]
				var/datum/relation/R = new TT
				R.holder = mind
				R.info = client.prefs.relations_info[T]
			mind.gen_relations_info = client.prefs.relations_info["general"]
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	if(SSticker.random_players)
		new_character.gender = pick(MALE, FEMALE)
		client.prefs.real_name = random_name(new_character.gender)
		client.prefs.randomize_appearance_and_body_for(new_character)
	else
		client.prefs.copy_to(new_character)

	sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))

	new_character.name = real_name
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type
	new_character.sync_organ_dna()
	if(client.prefs.disabilities)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
		new_character.dna.SetSEState(GLASSESBLOCK,1,0)
		new_character.disabilities |= NEARSIGHTED

/*	new_character.species_aan = client.prefs.species_aan
	new_character.species_color_key = client.prefs.species_color
	new_character.species_name = client.prefs.custom_species

	new_character.ears = GLOB.ears_styles_list[client.prefs.ears_style]
	new_character.ears_colors = client.prefs.ears_colors
	new_character.tail = GLOB.tail_styles_list[client.prefs.tail_style]
	new_character.tail_colors = client.prefs.tail_colors
	new_character.wings = GLOB.wings_styles_list[client.prefs.wings_style]
	new_character.wings_colors = client.prefs.wings_colors

	new_character.body_markings = client.prefs.body_markings*/

	// And uncomment this, too.
	//new_character.dna.UpdateSE()

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_eyes()
	new_character.regenerate_icons()
	new_character.key = key//Manually transfer the key to log them in
	new_character.client.init_verbs()

	return new_character

/mob/new_player/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	return 0

/mob/new_player/proc/close_spawn_windows()
	src << browse(null, "window=latechoices") //closes late choices window
	panel.close()

/mob/new_player/proc/is_species_whitelisted(datum/species/S)
	if(!S) return 1
	return is_alien_whitelisted(src, S.name) || !(S.spawn_flags & IS_WHITELISTED)

/mob/new_player/proc/is_form_whitelisted(datum/species_form/F)
	if(!F) return 1
	return F.playable

/mob/new_player/get_species()
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]

	if(!chosen_species)
		return "Human"

	if(is_species_whitelisted(chosen_species) || has_admin_rights())
		return chosen_species.name

	return "Human"

/mob/new_player/get_gender()
	if(!client || !client.prefs) ..()
	return GLOB.gender_datums[client.prefs.gender]

/mob/new_player/is_ready()
	return ready && ..()

/mob/new_player/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	return

/mob/new_player/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0)
	return

mob/new_player/MayRespawn()
	return 1
