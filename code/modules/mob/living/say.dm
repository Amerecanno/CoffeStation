var/list/department_radio_keys = list(
	"r" = "right ear",
	"l" = "left ear",
	"i" = "intercom",
	"h" = "department",
	"+" = "special",	 //activate radio-specific special functions
	"c" = "Command",
	"n" = "Science",
	"m" = "Medical",
	"j" = "Medical(I)",
	"e" = "Engineering",
	"s" = "Marshal",
	"b" = "Blackshield",
	"w" = "whisper",
	"y" = "Mercenary",
	"u" = "Supply",
	"v" = "Service",
	"p" = "AI Private",
	"t" = "Church",
	"k" = "Prospector",
	"a" = "Plasmatag B",
	"o" = "Plasmatag R",
	"q" = "Plasmatag Y",
	"z" = "Plasmatag G"
)


var/list/channel_to_radio_key = new
/proc/get_radio_key_from_channel(var/channel)
	var/key = channel_to_radio_key[channel]
	if(!key)
		for(var/radio_key in department_radio_keys)
			if(department_radio_keys[radio_key] == channel)
				key = radio_key
				break
		if(!key)
			key = ""
		channel_to_radio_key[channel] = key

	return key

/mob/living/proc/binarycheck()

	if(istype(src, /mob/living/silicon/pai))
		return

	if(!ishuman(src))
		return

	var/mob/living/carbon/human/H = src
	if(H.l_ear || H.r_ear)
		var/obj/item/device/radio/headset/dongle
		if(istype(H.l_ear, /obj/item/device/radio/headset))
			dongle = H.l_ear
		else
			dongle = H.r_ear
		if(!istype(dongle))
			return FALSE
		if(dongle.translate_binary)
			return TRUE

/mob/living/proc/get_default_language()
	return default_language

/mob/living/proc/is_muzzled()
	if(istype(src.wear_mask, /obj/item/clothing/mask/muzzle) || istype(src.wear_mask, /obj/item/grenade))
		return TRUE
	return FALSE

/mob/living/proc/handle_speech_problems(var/message, var/verb)
	var/list/returns[3]
	var/speech_problem_flag = 0

	if((HULK in mutations) && health >= 25 && length(message))
		message = "[uppertext(message)]!!!"
		verb = pick("кричит","вопит") //INF, WAS verb = pick("yells","roars","hollers")
		speech_problem_flag = 1
	if(slurring)
		message = slur(message)
		verb = "заплетается" //INF, WAS verb = pick("slobbers","slurs")
		speech_problem_flag = 1
	if(stuttering)
		message = stutter(message)
		verb = pick("бормочет","заикается") //INF, WAS verb = pick("stammers","stutters")
		speech_problem_flag = 1

	returns[1] = message
	returns[2] = verb
	returns[3] = speech_problem_flag
	return returns

/mob/living/proc/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name, speech_volume)
	if(message_mode == "intercom")
		for(var/obj/item/device/radio/intercom/I in view(1, null))
			I.talk_into(src, message, verb, speaking, speech_volume)
			used_radios += I
	return 0

/mob/living/proc/handle_speech_sound()
	var/list/returns[2]
	returns[1] = null
	returns[2] = null
	return returns

/mob/living/proc/get_speech_ending(verb, var/ending)
	if(ending=="!")
		return pick("восклицает","выкрикивает") //INF, WAS return pick("exclaims","shouts","yells")
	else if(ending=="?")
		return "спрашивает" //INF, WAS return "asks"
	else if(ending=="@")
		verb="докладывает"
	return verb

// returns message
/mob/living/proc/getSpeechVolume(var/message)
	var/volume = chem_effects[CE_SPEECH_VOLUME] ? round(chem_effects[CE_SPEECH_VOLUME]) : 2	// 2 is default text size in byond chat
	var/ending = copytext_char(message, length(message))
	if(ending == "!")
		volume ++
	return volume

/mob/living/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="")
	if(client)
		if(client.prefs.muted&MUTE_IC)
			to_chat(src, "\red You cannot speak in IC (Muted).")
			return

	if(stat)
		var/last_symbol = copytext_char(message, length(message))
		if(stat == DEAD)
			return say_dead(message)
		else if(last_symbol=="@")
			if(src.stats.getPerk(PERK_CODESPEAK))
				return
			else
				to_chat(src, "You don't know the codes, pal.")
		return

	if(HUSK in mutations)
		return

	if(is_muzzled())
		to_chat(src, SPAN_DANGER("You're muzzled and cannot speak!"))
		return

	var/prefix = copytext_char(message,1,2)
	if(prefix == get_prefix_key(/decl/prefix/custom_emote))
		return emote(copytext_char(message,2))
	if(prefix == get_prefix_key(/decl/prefix/visible_emote))
		return custom_emote(1, copytext_char(message,2))

	//parse the radio code and consume it
	var/message_mode = parse_message_mode(message, "headset")
	if (message_mode)
		//it would be really nice if the parse procs could do this for us.
		if (message_mode == "headset")
			message = copytext_char(message,2)
		else
			message = copytext_char(message,3)

	message = trim_left(message)

	//parse the language code and consume it
	if(!speaking)
		speaking = parse_language(message)
	if(speaking)
		message = copytext_char(message, 2 + length(speaking.key))
	else
		speaking = get_default_language()

	message = capitalize(message)
	// This is broadcast to all mobs with the language,
	// irrespective of distance or anything else.
	if(speaking && speaking.flags&HIVEMIND)
		speaking.broadcast(src, trim(message))
		return 1

	verb = say_quote(message, speaking)

	message = trim_left(message)
	var/message_pre_stutter = message

	message = format_say_message(message)

	message = formatSpeech(message, "/", "<i>", "</i>")

	message = formatSpeech(message, "*", "<b>", "</b>")

	if(!(speaking && speaking.flags&NO_STUTTER))

		var/list/handle_s = handle_speech_problems(message, verb)
		message = handle_s[1]
		verb = handle_s[2]

	if(!message)
		return 0

	var/list/obj/item/used_radios = new


	if(handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name, getSpeechVolume(message)))
		return TRUE

	var/list/handle_v = handle_speech_sound()
	var/sound/speech_sound = handle_v[1]
	var/sound_vol = handle_v[2] * (chem_effects[CE_SPEECH_VOLUME] ? chem_effects[CE_SPEECH_VOLUME] : 1)

	var/italics = FALSE
	var/message_range = world.view
	//speaking into radios
	if(used_radios.len)
		italics = TRUE
		message_range = 1
		if(speaking)
			message_range = speaking.get_talkinto_msg_range(message)
		var/msg
		if(!speaking || !(speaking.flags&NO_TALK_MSG))
			msg = SPAN_NOTICE("\The [src] talks into \the [used_radios[1]]")
		for(var/mob/living/M as anything in hearers(5, src))
			if((M != src) && msg)
				M.show_message(msg)
			if(speech_sound)
				sound_vol *= 0.5

	var/turf/T = get_turf(src)

	//handle nonverbal and sign languages here
	if(speaking)
		if(speaking.flags&NONVERBAL)
			if(prob(30))
				src.custom_emote(1, "[pick(speaking.signlang_verb)].")

		if(speaking.flags&SIGNLANG)
			return say_signlang(message, pick(speaking.signlang_verb), speaking)

	var/list/listening = list()
	var/list/listening_obj = list()
	var/list/listening_falloff = list() //People that are quite far away from the person speaking, who just get a _quiet_ version of whatever's being said.

	if(T)
		//make sure the air can transmit speech - speaker's side
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = (environment) ? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE)
			message_range = 1

		//sound distortion pressure, to help clue people in that the air is thin, even if it isn't a vacuum yet
		if(pressure < ONE_ATMOSPHERE * 0.4)
			italics = TRUE
			sound_vol *= 0.5 //muffle the sound a bit, so it's like we're actually talking through contact
		var/falloff = (message_range + round(3 * (chem_effects[CE_SPEECH_VOLUME] ? chem_effects[CE_SPEECH_VOLUME] : 1))) //A wider radius where you're heard, but only quietly. This means you can hear people offscreen.
		//DO NOT FUCKING CHANGE THIS TO GET_OBJ_OR_MOB_AND_BULLSHIT() -- Hugs and Kisses ~Ccomp
		var/list/hear_falloff = hear_movables(falloff, T)

		for(var/atom/movable/AM as anything in hear_falloff)
			var/list/recursive_contents_with_self = (AM.get_recursive_contents_until(3))
			recursive_contents_with_self += AM
			for (var/atom/movable/recursive_content as anything in recursive_contents_with_self) // stopgap between getting contents and getting full recursive contents
				if (ismob(recursive_content))
					var/distance = get_dist(get_turf(recursive_content), src)
					if (distance <= message_range) //if we're not in the falloff distance
						listening |= recursive_content
						continue
					else if (distance <= falloff) //we're in the falloff distance
						listening_falloff |= recursive_content
				else if (isobj(recursive_content))
					if (recursive_content in GLOB.hearing_objects)
						listening_obj |= recursive_content

		for (var/mob/M as anything in SSmobs.ghost_list) // too scared to make a combined list
			if(M.get_preference_value(/datum/client_preference/ghost_ears) == GLOB.PREF_ALL_SPEECH)
				listening |= M
				listening_falloff &= ~M
				continue

	var/speech_bubble_test = say_test(message)
	var/image/speech_bubble = image('icons/mob/talk.dmi', src, "h[speech_bubble_test]")
	speech_bubble.layer = ABOVE_MOB_LAYER
	QDEL_IN(speech_bubble, 30)

	var/list/speech_bubble_recipients = list()
	for(var/mob/M as anything in listening) //Again, as we're dealing with a lot of mobs, typeless gives us a tangible speed boost.
		if(M.client)
			speech_bubble_recipients += M.client
		M.hear_say(message, verb, speaking, alt_name, italics, src, speech_sound, sound_vol, getSpeechVolume(message))
	for(var/mob/M as anything in listening_falloff)
		if(M.client)
			speech_bubble_recipients += M.client
		M.hear_say(message, verb, speaking, alt_name, italics, src, speech_sound, sound_vol, 1)

	INVOKE_ASYNC(GLOBAL_PROC, .proc/animate_speechbubble, speech_bubble, speech_bubble_recipients, 30)
	INVOKE_ASYNC(src, /atom/movable/proc/animate_chat, message, speaking, italics, speech_bubble_recipients, 40)

	for(var/obj/O as anything in listening_obj)
		spawn(0)
			if(!QDELETED(O)) //It's possible that it could be deleted in the meantime.
				O.hear_talk(src, message, verb, speaking, getSpeechVolume(message), message_pre_stutter)


	log_say("[name]/[key] : [message]")
	return TRUE

mob/proc/format_say_message(var/message = null)

	///List of symbols that we dont want a dot after
	var/list/punctuation = list("!","?",".","-","~")

	///Last character in the message
	var/last_character = copytext_char(message,length_char(message))
	if(!(last_character in punctuation))
		message += "."
	return message

// Utility procs for handling speech formatting
/proc/formatSpeech(var/message, var/delimiter, var/openTag, var/closeTag)
	var/location = findtextEx(message, delimiter)
	while(location)
		if(findtextEx(message, delimiter, location + 1)) // Only work with matching pairs
			var/list/result = replaceFirst(message, delimiter, openTag, location)
			message = result[1]
			result = replaceFirst(message, delimiter, closeTag, result[2])
			message = result[1]
			location = findtextEx(message, delimiter, result[2] + 1)
		else
			break
	return message

/proc/replaceFirst(var/message, var/toFind, var/replaceWith, var/startLocation)
	var/location = findtextEx(message, toFind, startLocation)
	var/replacedLocation = 0
	if(location)
		var/findLength = length(toFind)
		var/head = copytext_char(message, 1, location)
		var/tail = copytext_char(message, location + findLength)
		message = head + replaceWith + tail
		replacedLocation = length(head) + length(replaceWith)
	return list(message, replacedLocation)

/proc/replaceAll(var/message, var/toFind, var/replaceWith)
	var/location = findtextEx(message, toFind)
	var/findLength = length(toFind)
	while(location > 0)
		var/head = copytext_char(message, 1, location)
		var/tail = copytext_char(message, location + findLength)
		message = head + replaceWith + tail
		location = findtextEx(message, toFind, length(head) + length(replaceWith) + 1)
	return message







/proc/animate_speechbubble(image/I, list/show_to, duration)
	var/matrix/M = matrix()
	M.Scale(0,0)
	I.transform = M
	I.alpha = 0
	for(var/client/C in show_to)
		C.images += I
	animate(I, transform = 0, alpha = 255, time = 5, easing = ELASTIC_EASING)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fade_speechbubble), I), duration-5)

/proc/fade_speechbubble(image/I)
	animate(I, alpha = 0, time = 5, easing = EASE_IN)


/mob/living/proc/say_signlang(var/message, var/verb="gestures", var/datum/language/language)
	for (var/mob/O in viewers(src, null))
		O.hear_signlang(message, verb, language, src)
	return 1

/obj/effect/speech_bubble
	var/mob/parent

/mob/living/proc/GetVoice()
	return name

/mob/living/hear_say(message, verb = "says", datum/language/language = null, alt_name = "", italics = FALSE,\
		mob/speaker = null, speech_sound, sound_vol, speech_volume)
	if(!client)
		return

	if(sdisabilities&DEAF || ear_deaf)
		// INNATE is the flag for audible-emote-language, so we don't want to show an "x talks but you cannot hear them" message if it's set
		if(!language || !(language.flags & INNATE))
			if(speaker == src)
				to_chat(src, SPAN_WARNING("You cannot hear yourself speak!"))
			else
				var/speaker_name = speaker.name
				if(ishuman(speaker))
					var/mob/living/carbon/human/H = speaker
					speaker_name = H.rank_prefix_name(speaker_name)
				to_chat(src,"<span class='name'>[speaker_name]</span>[alt_name] talks but you cannot hear \him.")
		return

	//make sure the air can transmit speech - hearer's side
	var/turf/T = get_turf(src)
	if(T)
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = (environment) ? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE && get_dist(speaker, src) > 1)
			return

		//sound distortion pressure, to help clue people in that the air is thin, even if it isn't a vacuum yet
		if(pressure < ONE_ATMOSPHERE * 0.4)
			italics = TRUE
			sound_vol *= 0.5 //muffle the sound a bit, so it's like we're actually talking through contact

	if(sleeping || stat == UNCONSCIOUS)
		hear_sleep(message)
		return

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if(language && !(verb == "reports"))
		if(language.flags&NONVERBAL)
			if(!speaker || (src.sdisabilities&BLIND || src.blinded) || !(speaker in view(src)))
				message = stars(message)

	if(!(language && language.flags&INNATE) && !(verb == "reports")) // skip understanding checks for INNATE languages
		if(!say_understands(speaker, language))
			if(isanimal(speaker))
				var/mob/living/simple/S = speaker
				if(S.speak.len)
					message = pick(S.speak)
			else
				if(language)
					message = language.scramble(message, languages)
				else
					message = stars(message)

	..()

/mob/living/hear_radio(message, verb="says", datum/language/language=null, part_a, part_b, part_c, speaker = null, hard_to_hear = 0, voice_name ="")
	if(!client)
		return

	if(sdisabilities&DEAF || ear_deaf)
		if(prob(20))
			to_chat(src, SPAN_WARNING("You feel your headset vibrate but can hear nothing from it!"))
		return

	if(sleeping || stat == UNCONSCIOUS) //If unconscious or sleeping
		hear_sleep(message)
		return

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if(language && !(verb == "reports"))
		if(language.flags&NONVERBAL)
			if(!speaker || (src.sdisabilities&BLIND || src.blinded) || !(speaker in view(src)))
				message = stars(message)

		// skip understanding checks for INNATE languages
		if(!(language.flags&INNATE))
			if(!say_understands(speaker, language))
				if(isanimal(speaker))
					var/mob/living/simple/S = speaker
					if(S.speak && S.speak.len)
						message = pick(S.speak)
					else
						return
				else
					if(language)
						message = language.scramble(message, languages)
					else
						message = stars(message)

			if(hard_to_hear)
				message = stars(message)

	..()

/mob/living/proc/hear_sleep(var/message)
	var/heard = ""
	if(prob(15))
		var/list/punctuation = list(",", "!", ".", ";", "?")
		var/list/messages = splittext(message, " ")
		var/R = rand(1, messages.len)
		var/heardword = messages[R]
		if(copytext_char(heardword, 1, 1) in punctuation)
			heardword = copytext_char(heardword, 2)
		if(copytext_char(heardword, -1) in punctuation)
			heardword = copytext_char(heardword, 1, length(heardword))
		heard = "<span class = 'game_say'>...You hear something about...[heardword]</span>"

	else
		heard = "<span class = 'game_say'>...<i>You almost hear someone talking</i>...</span>"

	to_chat(src, heard)
