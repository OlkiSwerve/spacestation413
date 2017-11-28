obj/item/vent_dummy
	name = "Ventriloquist Dummy"
	icon = 'icons/obj/dummies.dmi'
	icon_state = "dummy_default"
	item_state = "dummy_default"
	lefthand_file = 'icons/mob/inhands/lefthand.dmi'
	righthand_file = 'icons/mob/inhands/righthand.dmi'
	var/custom_name = null
	var/held = FALSE
	var/spam_flag = 0
	var/cooldowntime = 20
	var/CanRename = TRUE
	desc = "It's a puppet with a controllable mouth and arms. Suitable for ventriloquism acts."
	attack_verb = list("slapped", "fistbumped")

obj/item/vent_dummy/attack_self(mob/living/user)
	if(CanRename)
		if (custom_name == null)
			custom_name = stripped_input(user, "What is the dummies name?")
			if(length(custom_name) > MAX_NAME_LEN)
				to_chat(user, "<span class='danger'>Name is too long!</span>")
				return FALSE
			if(custom_name)
				name = custom_name
				desc = "It's [custom_name] the ventriloquist dummy... did it just move?"
		else
			if (!spam_flag)
				spam_flag = 1
				user.visible_message("<span class='notice'>[user] gives [name] a nervous fistbump. </span>")
				spawn(cooldowntime)
					spam_flag = 0
	return

obj/item/vent_dummy/sockpuppet
	name = "Sockpuppet"
	icon_state = "sockpuppet"
	desc = "A sock with buttons for eyes. Just stick it on your hand and you'll have your own portable buddy!"


//Hand lion - More obscure british television references!

obj/item/vent_dummy/handlion
	name = "hand lion"
	icon_state = "handlion"
	item_state = "handlion"
	CanRename = FALSE
	desc = "An animatronic hand lion, straight out of Mr. Whittlinghams cupboard. It can be set to lick or strike."
	attack_verb = "licked"
	force = 0
	throwforce = 0
	var/lick = TRUE

obj/item/vent_dummy/handlion/attack_self(mob/living/user)
	if (lick)
		user.visible_message("<span class='notice'>The hand lion gently licks [user]s hand.</span>")
	else
		playsound(src.loc, 'sound/effects/snap.ogg', 50, 1)
		user.visible_message("<span class='userdanger'>The hand lion fiercely strikes [user]s hand.</span>")

obj/item/vent_dummy/handlion/AltClick(mob/living/user)
	lick = !lick
	if (lick)
		to_chat(user, "<span class='notice'>The hand lion is now set to lick.</span>")
		force = 0
		throwforce = 0
		attack_verb = "licked"
	else
		to_chat(user, "<span class='notice'>The hand lion is now set to strike!</span>")
		force = 12
		throwforce = 20
		attack_verb = "striked"

obj/item/vent_dummy/handlion/throw_impact(atom/A)
	. = ..()
	if(!lick)
		playsound(src.loc, 'sound/effects/catgrowl.ogg', 50, 1)

//CURSED DUMMY
obj/item/vent_dummy/cursed
	var/awoken = FALSE
	var/cannot_be_seen = 1
	var/evil_lines = list()
	var/mob/living/carrier
	var/angry_line = "You shouldn't have done that..."

obj/item/vent_dummy/proc/Life()
	set waitfor = 0
	return

obj/item/vent_dummy/cursed/proc/awaken()
	awoken = TRUE
	flicker_lights()
	log_admin("[name] has awoken.")
	message_admins("[name] has awoken.")

obj/item/vent_dummy/cursed/say()
	if (prob(1) && !awoken) //1% chance to awaken the dummy each time it speaks
		awaken()
	. = ..()

obj/item/vent_dummy/cursed/throw_impact(atom/A)
	..()
	if (prob(15)) //15% chance to awaken the dummy when throwing it around
		if (!awoken)
			awaken()
		say(angry_line)

/obj/item/vent_dummy/cursed/pickup(mob/user)
	held = TRUE
	carrier = user
	. = ..()

obj/item/vent_dummy/cursed/dropped(mob/user)
	held = FALSE
	carrier = null
	. = ..()

// Awoken dummy shenanigans

/obj/item/vent_dummy/cursed/Life()

/obj/item/vent_dummy/cursed/proc/flicker_lights()
	var/area/A = get_area(get_turf(src))
	for(var/obj/machinery/light/L in A)
		L.flicker()
	return

/obj/item/vent_dummy/cursed/proc/can_be_seen(turf/destination)
	if(!cannot_be_seen)
		return null
	// Check for darkness
	var/turf/T = get_turf(loc)
	if(T && destination && T.lighting_object)
		if(T.get_lumcount()<0.1 && destination.get_lumcount()<0.1) // No one can see us in the darkness, right?
			return null
		if(T == destination)
			destination = null

	// We aren't in darkness, loop for viewers.
	var/list/check_list = list(src)
	if(destination)
		check_list += destination

	// This loop will, at most, loop twice.
	for(var/atom/check in check_list)
		for(var/mob/living/M in viewers(world.view + 1, check) - src)
			if(M.client && isliving(M) && !M.has_unlimited_silicon_privilege)
				if(!M.eye_blind)
					return M
		for(var/obj/mecha/M in view(world.view + 1, check)) //assuming if you can see them they can see you
			if(M.occupant && M.occupant.client)
				if(!M.occupant.eye_blind)
					return M.occupant
	return null


obj/item/vent_dummy/cursed/woody
	icon_state = "woody"
	var/pullcord_lines = list()

obj/item/vent_dummy/cursed/makin
	name = "puppet Makin"
	icon_state = "makin"
	CanRename = FALSE
	desc = "This ventriloquist dummy has an air of rationality about it."
	attack_verb = list("rationalized", "discoursed", "banned", "shilled")
	angry_line = "That was a bit... irrational"