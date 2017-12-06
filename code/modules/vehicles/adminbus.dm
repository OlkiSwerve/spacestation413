/*/obj/vehicle/adminbus
	name = "Admin Bus"
	desc = "A short yellow bus that looks reinforced."
	icon = 'icons/obj/vehicles2.dmi'
	icon_state = "adminbus"
	var/nonmoving_state = "adminbus"
	var/moving_state = "adminbus2"
	var/antispam = 0
	rider_visible = 0
	sealed_cabin = 1
	var/gib_onhit = 0
	var/is_badmin_bus = 0
	var/atom/movable/effect/darkness/darkness
	var/hornspam = 0
	actions_types = list(/datum/action/item_action/loud_horn, /datum/action/item_action/stopthebus)

/obj/vehicle/adminbus/Del()
	if(darkness)
		qdel(darkness)
	..()

/obj/vehicle/adminbus/Move()
	if(src.darkness)
		src.darkness.forceMove(src.loc)
		if(prob(3))
			src.do_darkness()

	return ..()


obj/vehicle/adminbus/proc/horn()
	if(hornspam < world.time)
		playsound(src.loc, "sound/items/vuvuzela.ogg", 50, 1)
		hornspam = world.time + 80

obj/vehicle/adminbus/proc/stop()
	..()
	icon_state = nonmoving_state

/obj/vehicle/adminbus/relaymove(mob/user as mob, dir)
	src.overlays = null
	if(rider && user == rider)
		if(istype(src.loc, /turf/open/space))
			src.overlays += icon('icons/mob/robots.dmi', "up-speed")
		icon_state = moving_state
		walk(src, dir, 1)
		if(antispam < world.time)
			playsound(src, "sound/machines/rev_engine.ogg", 50, 1)
			antispam = world.time + 20
			//play engine sound
	else
		..()
		return
*/