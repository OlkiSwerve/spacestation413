// This is synced up to the poster placing animation.
#define PLACE_SPEED 37

// The poster item

/obj/item/poster
	name = "poorly coded poster"
	desc = "You probably shouldn't be holding this."
	icon = 'icons/obj/contraband.dmi'
	force = 0
	resistance_flags = FLAMMABLE
	var/poster_type
	var/obj/structure/sign/poster/poster_structure

/obj/item/poster/Initialize(mapload, obj/structure/sign/poster/new_poster_structure)
	. = ..()
	poster_structure = new_poster_structure
	if(!new_poster_structure && poster_type)
		poster_structure = new poster_type(src)

	// posters store what name and description they would like their
	// rolled up form to take.
	if(poster_structure)
		name = poster_structure.poster_item_name
		desc = poster_structure.poster_item_desc
		icon_state = poster_structure.poster_item_icon_state

		name = "[name] - [poster_structure.original_name]"

/obj/item/poster/Destroy()
	poster_structure = null
	. = ..()

// These icon_states may be overriden, but are for mapper's convinence
/obj/item/poster/random_contraband
	name = "random contraband poster"
	poster_type = /obj/structure/sign/poster/contraband/random
	icon_state = "rolled_poster"

/obj/item/poster/random_official
	name = "random official poster"
	poster_type = /obj/structure/sign/poster/official/random
	icon_state = "rolled_legit"

// The poster sign/structure

/obj/structure/sign/poster
	name = "poster"
	var/original_name
	desc = "A large piece of space-resistant printed paper."
	icon = 'icons/obj/contraband.dmi'
	anchored = TRUE
	var/ruined = FALSE
	var/random_basetype
	var/never_random = FALSE // used for the 'random' subclasses.

	var/poster_item_name = "hypothetical poster"
	var/poster_item_desc = "This hypothetical poster item should not exist, let's be honest here."
	var/poster_item_icon_state = "rolled_poster"

/obj/structure/sign/poster/Initialize()
	. = ..()
	if(random_basetype)
		randomise(random_basetype)
	if(!ruined)
		original_name = name // can't use initial because of random posters
		name = "poster - [name]"
		desc = "[desc]"

/obj/structure/sign/poster/proc/randomise(base_type)
	var/list/poster_types = subtypesof(base_type)
	var/list/approved_types = list()
	for(var/t in poster_types)
		var/obj/structure/sign/poster/T = t
		if(initial(T.icon_state) && !initial(T.never_random))
			approved_types |= T

	var/obj/structure/sign/poster/selected = pick(approved_types)

	name = initial(selected.name)
	desc = initial(selected.desc)
	icon_state = initial(selected.icon_state)
	poster_item_name = initial(selected.poster_item_name)
	poster_item_desc = initial(selected.poster_item_desc)
	poster_item_icon_state = initial(selected.poster_item_icon_state)
	ruined = initial(selected.ruined)


/obj/structure/sign/poster/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/wirecutters))
		playsound(loc, I.usesound, 100, 1)
		if(ruined)
			to_chat(user, "<span class='notice'>You remove the remnants of the poster.</span>")
			qdel(src)
		else
			to_chat(user, "<span class='notice'>You carefully remove the poster from the wall.</span>")
			roll_and_drop(user.loc)

/obj/structure/sign/poster/attack_hand(mob/user)
	if(ruined)
		return
	visible_message("[user] rips [src] in a single, decisive motion!" )
	playsound(src.loc, 'sound/items/poster_ripped.ogg', 100, 1)

	var/obj/structure/sign/poster/ripped/R = new(loc)
	R.pixel_y = pixel_y
	R.pixel_x = pixel_x
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/sign/poster/proc/roll_and_drop(loc)
	pixel_x = 0
	pixel_y = 0
	var/obj/item/poster/P = new(loc, src)
	forceMove(P)
	return P

//separated to reduce code duplication. Moved here for ease of reference and to unclutter r_wall/attackby()
/turf/closed/wall/proc/place_poster(obj/item/poster/P, mob/user)
	if(!P.poster_structure)
		to_chat(user, "<span class='warning'>[P] has no poster... inside it? Inform a coder!</span>")
		return

	// Deny placing posters on currently-diagonal walls, although the wall may change in the future.
	if (smooth & SMOOTH_DIAGONAL)
		for (var/O in our_overlays)
			var/image/I = O
			if (copytext(I.icon_state, 1, 3) == "d-")
				return

	var/stuff_on_wall = 0
	for(var/obj/O in contents) //Let's see if it already has a poster on it or too much stuff
		if(istype(O, /obj/structure/sign/poster))
			to_chat(user, "<span class='warning'>The wall is far too cluttered to place a poster!</span>")
			return
		stuff_on_wall++
		if(stuff_on_wall == 3)
			to_chat(user, "<span class='warning'>The wall is far too cluttered to place a poster!</span>")
			return

	to_chat(user, "<span class='notice'>You start placing the poster on the wall...</span>"	)

	var/obj/structure/sign/poster/D = P.poster_structure

	var/temp_loc = get_turf(user)
	flick("poster_being_set",D)
	D.forceMove(src)
	qdel(P)	//delete it now to cut down on sanity checks afterwards. Agouri's code supports rerolling it anyway
	playsound(D.loc, 'sound/items/poster_being_created.ogg', 100, 1)

	if(do_after(user, PLACE_SPEED, target=src))
		if(!D || QDELETED(D))
			return

		if(iswallturf(src) && user && user.loc == temp_loc)	//Let's check if everything is still there
			to_chat(user, "<span class='notice'>You place the poster!</span>")
			return

	to_chat(user, "<span class='notice'>The poster falls down!</span>")
	D.roll_and_drop(temp_loc)

// Various possible posters follow

/obj/structure/sign/poster/ripped
	ruined = TRUE
	icon_state = "poster_ripped"
	name = "ripped poster"
	desc = "You can't make out anything from the poster's original print. It's ruined."

/obj/structure/sign/poster/random
	name = "random poster" // could even be ripped
	icon_state = "random_anything"
	never_random = TRUE
	random_basetype = /obj/structure/sign/poster

/obj/structure/sign/poster/contraband
	poster_item_name = "contraband poster"
	poster_item_desc = "This poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface. Its vulgar themes have marked it as contraband aboard Nanotrasen space facilities."
	poster_item_icon_state = "rolled_poster"

/obj/structure/sign/poster/contraband/random
	name = "random contraband poster"
	icon_state = "random_contraband"
	never_random = TRUE
	random_basetype = /obj/structure/sign/poster/contraband

/obj/structure/sign/poster/contraband/free_tonto
	name = "~ATH"
	desc = "A poster advertising the ultimate programming language. Or the ultimate programmer. You're not sure which."
	icon_state = "poster1"

/obj/structure/sign/poster/contraband/atmosia_independence
	name = "SBURB by Tyler Dever"
	desc = "Did you know this piano album is actually based on Christian concepts? If you didn't, you should be ashamed of yourself."
	icon_state = "poster2"

/obj/structure/sign/poster/contraband/fun_police
	name = "Sweet Brother"
	desc = "today i put.............JELLY on this hot god"
	icon_state = "poster3"

/obj/structure/sign/poster/contraband/lusty_xenomorph
	name = "Sepulchritude"
	desc = "You are intrigued by Problem Sleuth's diplomacy skills. Also by his huge sword and wings."
	icon_state = "poster4"

/obj/structure/sign/poster/contraband/syndicate_recruitment
	name = "STRIFE!"
	desc = "Bro is a really bad guy. A really BAD-ASS guy."
	icon_state = "poster5"

/obj/structure/sign/poster/contraband/clown
	name = "Clown"
	desc = "Honk."
	icon_state = "poster6"

/obj/structure/sign/poster/contraband/smoke
	name = "The Felt"
	desc = "Cigarette ashes burn red, but they fall like snow, and I hear this world calling my name, and this world's got to end someday soon."
	icon_state = "poster7"

/obj/structure/sign/poster/contraband/grey_tide
	name = "Cool and New Greatest Hits 2"
	desc = "Featuring over 30 non-memetic tracks!"
	icon_state = "poster8"

/obj/structure/sign/poster/contraband/missing_gloves
	name = "Missing Gloves"
	desc = "This poster references the uproar that followed Nanotrasen's financial cuts toward insulated-glove purchases."
	icon_state = "poster9"

/obj/structure/sign/poster/contraband/hacking_guide
	name = "Hacking Guide"
	desc = "This poster details the internal workings of the common Nanotrasen airlock. Sadly, it appears out of date."
	icon_state = "poster10"

/obj/structure/sign/poster/contraband/rip_badger
	name = "Cool and New Web Comic"
	desc = "4 kids habv play a game to make a unaverse and some other thigns hapen too."
	icon_state = "poster11"

/obj/structure/sign/poster/contraband/ambrosia_vulgaris
	name = "Fat Husky"
	desc = "Huskies are energetic and athletic. This one isn't."
	icon_state = "poster12"

/obj/structure/sign/poster/contraband/donut_corp
	name = "Nicolas Cage"
	desc = "WHY COULDN'T YOU PUT THE BUNNY BACK IN THE BOX?"
	icon_state = "poster13"

/obj/structure/sign/poster/contraband/eat
	name = "Yeah!!!!!!!!"
	desc = "This poster took a few too many liberties depicting Vriska. She should look deader."
	icon_state = "poster14"

/obj/structure/sign/poster/contraband/tools
	name = "Cherubim"
	desc = "Damn, Calliope looks like THAT?"
	icon_state = "poster15"

/obj/structure/sign/poster/contraband/power
	name = "Cool and New Music Team"
	desc = "Envy, greed, despair, memes."
	icon_state = "poster16"

/obj/structure/sign/poster/contraband/space_cube
	name = "Homestuck Vol. 5"
	desc = "Featuring over 5 volumes of Doctor remixes!"
	icon_state = "poster17"

/obj/structure/sign/poster/contraband/communist_state
	name = "Communist State"
	desc = "All hail the Communist party!"
	icon_state = "poster18"

/obj/structure/sign/poster/contraband/lamarr
	name = "Symphony Impossible to Hear"
	desc = "You place your ear on the poster to test its claim, but you can only hear the crew laughing at you."
	icon_state = "poster19"

/obj/structure/sign/poster/contraband/borg_fancy_1
	name = "BOWMANIA"
	desc = "a tribute to a bowman, who, even he himself, was once a bowboy."
	icon_state = "poster20"

/obj/structure/sign/poster/contraband/borg_fancy_2
	name = "Femorafreack"
	desc = "STOP, in the name of the law! Space justice must be a serve."
	icon_state = "poster21"

/obj/structure/sign/poster/contraband/kss13
	name = "Who Cares"
	desc = "A poster that claims nobody cares by the man who stopped caring."
	icon_state = "poster22"

/obj/structure/sign/poster/contraband/rebels_unite
	name = "2.5 MILLION DOLLARS JADE"
	desc = "At least it's not a lumberjack again..."
	icon_state = "poster23"

/obj/structure/sign/poster/contraband/c20r
	// have fun seeing this poster in "spawn 'c20r'", admins...
	name = "JUSTICE IS BLIND"
	desc = "blind girl has nice ass?????"
	icon_state = "poster24"

/obj/structure/sign/poster/contraband/have_a_puff
	name = "Dude Weed Lmao"
	desc = "420 or something. I accidentally wrote over this poster's original description."
	icon_state = "poster25"

/obj/structure/sign/poster/contraband/revolver
	name = "Ithaca"
	desc = "Long before there was you and I, Bowman made tunes to soothe our lives."
	icon_state = "poster26"

/obj/structure/sign/poster/contraband/d_day_promo
	name = "Megan"
	desc = "She hates her fucking job."
	icon_state = "poster27"

/obj/structure/sign/poster/contraband/syndicate_pistol
	name = "Wait what?"
	desc = "Wonders where the fuck that pumpkin went???"
	icon_state = "poster28"

/obj/structure/sign/poster/contraband/energy_swords
	name = "Disapproving Black Man"
	desc = "You STILL like Homestuck in 2017? Pathetic."
	icon_state = "poster29"

/obj/structure/sign/poster/contraband/red_rum
	name = "How High"
	desc = "AHAHAHAHAHA JUST HOW HIGH DO YOU EVEN HAVE TO BE JUST TO DO SOMETHING LIKE THAT........"
	icon_state = "poster30"

/obj/structure/sign/poster/contraband/cc64k_ad
	name = "One Year Older"
	desc = "Jit's Face will look disapproving if people don't hang this poster every October 18th."
	icon_state = "poster31"

/obj/structure/sign/poster/contraband/punch_shit
	name = "SBURB"
	desc = "This poster usually gets ignored in favor of teen drama. Sorry, space teen drama."
	icon_state = "poster32"

/obj/structure/sign/poster/contraband/the_griffin
	name = "Kawaii Jade"
	desc = "The moment you lay eyes on this abomination, an urge to murder weebs awakens."
	icon_state = "poster33"

/obj/structure/sign/poster/contraband/lizard
	name = "Cool and New Greatest Hits"
	desc = "You wish Rose was the Lord of Space Station 413 too..."
	icon_state = "poster34"

/obj/structure/sign/poster/contraband/free_drone
	name = "No offense but...isnt that kind of GAY"
	desc = "TL note: gay means homo"
	icon_state = "poster35"

/obj/structure/sign/poster/contraband/busty_backdoor_xeno_babes_6
	name = "Act 7"
	desc = "This is as much of a disappointment as your performance last round."
	icon_state = "poster36"

/obj/structure/sign/poster/contraband/robust_softdrinks
	name = "Heir Transparent"
	desc = "Haha what are you saying this is a perfectly normal hideously long arm, foreshortening and such."
	icon_state = "poster37"

/obj/structure/sign/poster/contraband/shamblers_juice
	name = "Seer of Mind"
	desc = "Maybe the back of the poster contains the meaning to Terezi: Remember... nope."
	icon_state = "poster38"

/obj/structure/sign/poster/contraband/pwr_game
	name = "Cascade"
	desc = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
	icon_state = "poster39"

/obj/structure/sign/poster/contraband/sun_kist
	name = "Midnight Crew"
	desc = "You are but a DVS sax compared to this band's shadow music skills."
	icon_state = "poster40"

/obj/structure/sign/poster/contraband/space_cola
	name = "Colours and Mayhem"
	desc = "Over 10% of the characters featured in this poster got some development!"
	icon_state = "poster41"

/obj/structure/sign/poster/contraband/space_up
	name = "Bowman"
	desc = "How relevant, how new, buy his albums!"
	icon_state = "poster42"

/obj/structure/sign/poster/contraband/kudzu
	name = "Lord English"
	desc = "After hanging this poster, you will realize it was already there all along."
	icon_state = "poster43"

/obj/structure/sign/poster/contraband/masked_men
	name = "Caliborn"
	desc = "A poster depicting a finalist of the Jade and Calliope Rumble, to date his biggest achievement."
	icon_state = "poster44"

/obj/structure/sign/poster/official
	poster_item_name = "motivational poster"
	poster_item_desc = "An official Nanotrasen-issued poster to foster a compliant and obedient workforce. It comes with state-of-the-art adhesive backing, for easy pinning to any vertical surface."
	poster_item_icon_state = "rolled_legit"

/obj/structure/sign/poster/official/random
	name = "random official poster"
	random_basetype = /obj/structure/sign/poster/official
	icon_state = "random_official"
	never_random = TRUE

/obj/structure/sign/poster/official/here_for_your_safety
	name = "SGRUB"
	desc = "All in all: 7/10 game. ALL my friends died. 7/10."
	icon_state = "poster1_legit"

/obj/structure/sign/poster/official/nanotrasen_logo
	name = "Nanotrasen Logo"
	desc = "A poster depicting the Nanotrasen logo."
	icon_state = "poster2_legit"

/obj/structure/sign/poster/official/cleanliness
	name = "Cleanliness"
	desc = "A poster warning of the dangers of poor hygiene."
	icon_state = "poster3_legit"

/obj/structure/sign/poster/official/help_others
	name = "Help Others"
	desc = "A poster encouraging you to help fellow crewmembers."
	icon_state = "poster4_legit"

/obj/structure/sign/poster/official/build
	name = "Build"
	desc = "A poster glorifying the engineering team."
	icon_state = "poster5_legit"

/obj/structure/sign/poster/official/bless_this_spess
	name = "Bless This Spess"
	desc = "A poster blessing this area."
	icon_state = "poster6_legit"

/obj/structure/sign/poster/official/science
	name = "Science"
	desc = "A poster depicting an atom."
	icon_state = "poster7_legit"

/obj/structure/sign/poster/official/ian
	name = "Ian"
	desc = "Arf arf. Yap."
	icon_state = "poster8_legit"

/obj/structure/sign/poster/official/obey
	name = "Obey"
	desc = "A poster instructing the viewer to obey authority."
	icon_state = "poster9_legit"

/obj/structure/sign/poster/official/walk
	name = "Walk"
	desc = "A poster instructing the viewer to walk instead of running."
	icon_state = "poster10_legit"

/obj/structure/sign/poster/official/state_laws
	name = "State Laws"
	desc = "A poster instructing cyborgs to state their laws."
	icon_state = "poster11_legit"

/obj/structure/sign/poster/official/love_ian
	name = "YOU'RE WELCOME"
	desc = "So long, and thanks for all the ships."
	icon_state = "poster12_legit"

/obj/structure/sign/poster/official/space_cops
	name = "What Pumpkin"
	desc = "You almost applied there, but dying in a Space Station seems like a better way to waste your life."
	icon_state = "poster13_legit"

/obj/structure/sign/poster/official/ue_no
	name = "Homestuck Vol. 10"
	desc = "PENUMBRA PHANTASM WHEN"
	icon_state = "poster14_legit"

/obj/structure/sign/poster/official/get_your_legs
	name = "Get Your LEGS"
	desc = "LEGS: Leadership, Experience, Genius, Subordination."
	icon_state = "poster15_legit"

/obj/structure/sign/poster/official/do_not_question
	name = "Do Not Question"
	desc = "A poster instructing the viewer not to ask about things they aren't meant to know."
	icon_state = "poster16_legit"

/obj/structure/sign/poster/official/work_for_a_future
	name = "Work For A Future"
	desc = " A poster encouraging you to work for your future."
	icon_state = "poster17_legit"

/obj/structure/sign/poster/official/soft_cap_pop_art
	name = "Hiveswap"
	desc = "Pfft, if you wanted funny item descriptions you'd read these posters."
	icon_state = "poster18_legit"

/obj/structure/sign/poster/official/safety_internals
	name = "Safety: Internals"
	desc = "A poster instructing the viewer to wear internals in the rare environments where there is no oxygen or the air has been rendered toxic."
	icon_state = "poster19_legit"

/obj/structure/sign/poster/official/safety_eye_protection
	name = "Safety: Eye Protection"
	desc = "A poster instructing the viewer to wear eye protection when dealing with chemicals, smoke, or bright lights."
	icon_state = "poster20_legit"

/obj/structure/sign/poster/official/safety_report
	name = "Safety: Report"
	desc = "A poster instructing the viewer to report suspicious activity to the security force."
	icon_state = "poster21_legit"

/obj/structure/sign/poster/official/report_crimes
	name = "Yikes"
	desc = "I don't want to participate in this discussion but I want to feel superior anyway."
	icon_state = "poster22_legit"

/obj/structure/sign/poster/official/ion_rifle
	name = "Nepeta"
	desc = "A truly terrible choice for a waifu."
	icon_state = "poster23_legit"

/obj/structure/sign/poster/official/foam_force_ad
	name = "Pose as a team"
	desc = "Cause shit just got real."
	icon_state = "poster24_legit"

/obj/structure/sign/poster/official/cohiba_robusto_ad
	name = "Dirk Strider"
	desc = "He's back, now without child abuse!"
	icon_state = "poster25_legit"

/obj/structure/sign/poster/official/anniversary_vintage_reprint
	name = "Rorb Lalorb"
	desc = "ur so pretty"
	icon_state = "poster26_legit"

/obj/structure/sign/poster/official/fruit_bowl
	name = "Pink Butterfly Man"
	desc = "All who diss metal will have to answer to this eldritch creature."
	icon_state = "poster27_legit"

/obj/structure/sign/poster/official/pda_ad
	name = "Mobius Trip and Hadron Kaleido"
	desc = "IT WAS THE DAWN OF BOW-MAN"
	icon_state = "poster28_legit"

/obj/structure/sign/poster/official/enlist
	name = "Roxygen"
	desc = "This poster will keep being manufactured until the end of time, to make the other posters look better."
	icon_state = "poster29_legit"

/obj/structure/sign/poster/official/nanomichi_ad
	name = "Rose and Star Platinum"
	desc = "Fucking jojobronies, you swear."
	icon_state = "poster30_legit"

/obj/structure/sign/poster/official/twelve_gauge
	name = "Worm"
	desc = "Read it! http://parahumans.wordpress.com/"
	icon_state = "poster31_legit"

/obj/structure/sign/poster/official/high_class_martini
	name = "Wizard of Chaos"
	desc = "You suddenly feel the urge to superglue your hand and stick it inside the supermatter."
	icon_state = "poster32_legit"

/obj/structure/sign/poster/official/the_owl
	name = "Jojostuck"
	desc = "Have you read Jojostuck?"
	icon_state = "poster33_legit"

/obj/structure/sign/poster/official/no_erp
	name = "No ERP"
	desc = "This poster reminds the crew that Eroticism, Rape and Pornography are banned on Nanotrasen stations."
	icon_state = "poster34_legit"

/obj/structure/sign/poster/official/wtf_is_co2
	name = "Carbon Dioxide"
	desc = "This informational poster teaches the viewer what carbon dioxide is."
	icon_state = "poster35_legit"

#undef PLACE_SPEED
