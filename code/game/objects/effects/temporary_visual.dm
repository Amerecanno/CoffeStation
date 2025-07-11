//temporary visual effects
/obj/effect/temp_visual
	icon_state = "nothing"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	unacidable = 1
	var/duration = 10 //in deciseconds
	var/randomdir = TRUE //If true makes the dir random, picks cardinals
	var/autoset = TRUE //If true uses duration var above

/obj/effect/temp_visual/shorter
	duration = 5 //in deciseconds
	randomdir = FALSE
	autoset = FALSE

/obj/effect/temp_visual/Initialize()
	. = ..()
	if(randomdir)
		dir = (pick(cardinal))

	if(autoset)
		QDEL_IN(src, duration)

/obj/effect/temp_visual/Destroy()
	. = ..()

/obj/effect/temp_visual/singularity_act()
	return

/obj/effect/temp_visual/singularity_pull()
	return

/obj/effect/temp_visual/ex_act()
	return

/obj/effect/temp_visual/dir_setting
	randomdir = FALSE

/obj/effect/temp_visual/dir_setting/Initialize(mapload, set_dir)
	if(set_dir)
		dir = set_dir
	. = ..()
