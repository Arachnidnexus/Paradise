/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * 		Beds
 *		Roller beds
 *		Dog Beds
 */

/*
 * Beds
 */

/obj/structure/bed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	icon = 'icons/obj/objects.dmi'
	icon_state = "bed"
	can_buckle = TRUE
	anchored = TRUE
	buckle_lying = TRUE
	burn_state = FLAMMABLE
	burntime = 30
	var/buildstacktype = /obj/item/stack/sheet/metal
	var/buildstackamount = 2
	buckle_offset = -6
	var/comfort = 2 // default comfort

/obj/structure/bed/psych
	name = "psych bed"
	desc = "For prime comfort during psychiatric evaluations."
	icon_state = "psychbed"
	buildstackamount = 5
	can_buckle = TRUE
	buckle_lying = TRUE

/obj/structure/bed/alien
	name = "resting contraption"
	desc = "This looks similar to contraptions from Earth. Could aliens be stealing our technology?"
	icon_state = "abed"
	comfort = 0.3

/obj/structure/bed/proc/handle_rotation()
	return

/obj/structure/bed/attackby(obj/item/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/wrench))
		playsound(loc, W.usesound, 50, 1)
		new buildstacktype(loc, buildstackamount)
		qdel(src)

/obj/structure/bed/attack_animal(mob/living/simple_animal/user)
	if(user.environment_smash)
		user.do_attack_animation(src)
		visible_message("<span class='danger'>[user] smashes [src] apart!</span>")
		new buildstacktype(loc, buildstackamount)
		qdel(src)

/*
 * Roller beds
 */

/obj/structure/bed/roller
	name = "roller bed"
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "down"
	burn_state = FIRE_PROOF
	anchored = FALSE
	comfort = 1

/obj/structure/bed/roller/attackby(obj/item/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/roller_holder))
		if(buckled_mob)
			user_unbuckle_mob(user)
		else
			user.visible_message("<span class='notice'>[user] collapses \the [name].</span>", "<span class='notice'>You collapse \the [name].</span>")
			new/obj/item/roller(get_turf(src))
			qdel(src)

/obj/structure/bed/roller/post_buckle_mob(mob/living/M)
	if(M == buckled_mob)
		density = TRUE
		icon_state = "up"
		M.pixel_y = initial(M.pixel_y)
	else
		density = FALSE
		icon_state = "down"
		M.pixel_x = M.get_standard_pixel_x_offset(M.lying)
		M.pixel_y = M.get_standard_pixel_y_offset(M.lying)

/obj/item/roller
	name = "roller bed"
	desc = "A collapsed roller bed that can be carried around."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	w_class = WEIGHT_CLASS_BULKY // Can't be put in backpacks.

/obj/item/roller/attack_self(mob/user)
	var/obj/structure/bed/roller/R = new /obj/structure/bed/roller(user.loc)
	R.add_fingerprint(user)
	qdel(src)

/obj/item/roller/attackby(obj/item/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/roller_holder))
		var/obj/item/roller_holder/RH = W
		if(!RH.held)
			user.visible_message("<span class='notice'>[user] collects \the [name].</span>", "<span class='notice'>You collect \the [name].</span>")
			forceMove(RH)
			RH.held = src

/obj/structure/bed/roller/MouseDrop(over_object, src_location, over_location)
	..()
	if(over_object == usr && Adjacent(usr) && (in_range(src, usr) || usr.contents.Find(src)))
		if(!ishuman(usr))
			return
		if(buckled_mob)
			return 0
		usr.visible_message("<span class='notice'>[usr] collapses \the [name].</span>", "<span class='notice'>You collapse \the [name].</span>")
		new/obj/item/roller(get_turf(src))
		qdel(src)

/obj/item/roller_holder
	name = "roller bed rack"
	desc = "A rack for carrying a collapsed roller bed."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	var/obj/item/roller/held

/obj/item/roller_holder/New()
	..()
	held = new /obj/item/roller(src)

/obj/item/roller_holder/attack_self(mob/user as mob)
	if(!held)
		to_chat(user, "<span class='info'> The rack is empty.</span>")

	to_chat(user, "<span class='notice'>You deploy the roller bed.</span>")
	var/obj/structure/bed/roller/R = new /obj/structure/bed/roller(user.loc)
	R.add_fingerprint(user)
	QDEL_NULL(held)

/*
 * Dog beds
 */

/obj/structure/bed/dogbed
	name = "dog bed"
	icon_state = "dogbed"
	desc = "A comfy-looking dog bed. You can even strap your pet in, just in case the gravity turns off."
	anchored = FALSE
	buildstackamount = 10
	buildstacktype = /obj/item/stack/sheet/wood
	buckle_offset = 0
	comfort = 0.5

/obj/structure/bed/dogbed/ian
	name = "Ian's bed"
	desc = "Ian's bed! Looks comfy."
	anchored = TRUE

/obj/structure/bed/dogbed/renault
	desc = "Renault's bed! Looks comfy. A foxy person needs a foxy pet."
	name = "Renault's bed"
	anchored = TRUE

/obj/structure/bed/dogbed/runtime
	desc = "A comfy-looking cat bed. You can even strap your pet in, in case the gravity turns off."
	name = "Runtime's bed"
	anchored = TRUE
