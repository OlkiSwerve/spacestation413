// Difarem, december 2017

/area/mobcapsule
	name = "\improper Mob Capsule"
	icon_state = "away"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	requires_power = FALSE
	has_gravity = TRUE
	valid_territory = FALSE

/datum/map_template/mobcapsule
	var/capsule_id
	var/description

/datum/map_template/mobcapsule/regular
	name = "Lazarus Capsule interior"
	description = "A Lazarus capsule offering basic accomodation."
	capsule_id = "capsule_regular"
	mappath = "_maps/templates/capsule_1.dmm"


// OUTSIDE MONITOR VIEW
/obj/machinery/computer/camera_advanced/mobcapsule
	name = "Outside"
	desc = ""
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "telescreen"

	station_lock_override = TRUE
	jump_action = null

	var/obj/item/device/mobcapsule/capsule // associated capsule

/obj/machinery/computer/camera_advanced/mobcapsule/attack_hand(mob/user)
	if(current_user)
		to_chat(user, "The console is already in use!")
		return
	if(!capsule)
		throw EXCEPTION("no linked capsule")
		return
	var/mob/living/L = user

	if(!eyeobj)
		CreateEye()

	if(!eyeobj.eye_initialized)
		var/camera_location = get_turf(capsule)
		eyeobj.eye_initialized = TRUE
		give_eye_control(L)
		eyeobj.setLoc(camera_location)
	else
		give_eye_control(L)
		eyeobj.setLoc(eyeobj.loc)
