#include maps\_utility; 
#include common_scripts\utility; 
#include maps\_zombiemode_utility;
#include maps\_hud_util;

/* 
SPECIALTIES:
*specialty_armorvest: Juggernaut
*specialty_bulletaccuracy: DeadShot
*specialty_detectexplosives: PHD
*specialty_extraammo: Mule Kick
*specialty_fastreload: Speed Cola
*specialty_fireproof: ZMP
*specialty_gpsjammer: shocknade
*specialty_longersprint: Staminup
*specialty_quickrevive: Quick Revive with solo qr
*specialty_rof: Double tap
*specialty_shades: Elecric Cherry
*specialty_twoprimaries: DoubleMag
specialty_boost: ?
specialty_bulletdamage: Stopping Power
specialty_bulletpenetration: Deep Impact
specialty_explosivedamage: Fireworks - like sonic boom in COD4
specialty_gas_mask: Reduces the effects of gas grenade attacks
specialty_grenadepulldeath: Martyrdom
specialty_holdbreath: Iron lungs
specialty_leadfoot: Increase tank's drive speed
specialty_ordinance: Faster firing main tank gun
specialty_pin_back: Toss back - resets timer on throwing back grenades
specialty_pistoldeath: Last stand
specialty_quieter: Dead Silence
specialty_specialgrenade: Specials Grenades x 3
specialty_water_cooled: Slows the overheating of tank guns
X-specialty_doublegrenade: (Doesn't work)
X-specialty_flak_jacket: (Doesn't work)
X-specialty_greased_bearings: (Doesn't work)
X-specialty_recon: (Doesn't work)
X-specialty_weapon_betty: (Doesn't work)
X-specialty_weapon_flamethrower: (Doesn't work)
X-specialty_weapon_rpg: (Doesn't work)
X-specialty_weapon_satchel: (Doesn't work)
*/

init()
{
	//MODDER ADJUSTMENTS======================================================================

	//perk limit
	level.mcperklimit = 5;//undefined if no limit

	//perk menu hud
	level.usemenuforhud = 1;//undefined or 0 for using hud instead of menu
	level.usemenuforhint = 0;//undefiend or 0 for using hud instead of menu

	//Sell Back perks
	level.perksellback = true;//make false to not sell back perks and true to do so
	level.sellbackweapon = "syrette";//weapon to give during sell back progress bar

	//randomizer
	level.randomize_perk_rounds = undefined; //rAndomize ever # of rounds, undefined=not at all, 0 - only at beginning

	//electric cherry
	level.eleccherryfx = level._effect["elec_torso"];//can change to other fx that has short life span, like 2 secs
	level.eleccherryradius = 112;//extra radius for electric cherry based on percentage of clip
	level.eleccherryface = 1; //0 for no electric in face, 1 for electric in face
	level.eleccherrydamage = 1000;

	//phd
	level.phdheight = 0;//0= from the ground, increase by 1 to make higher... and so on
	level.phdradius = 200;
	level.phddamage = 3000;

	//jugg
	set_zombie_var( "zombie_perk_juggernaut_health",	320 );

	//zmp
	level.zmp_recharge = 10;//seconds till zmp works again
	level.zmpradius = 80;
	level.zmpfx = level._effect["elec_torso"];//can change to other fx that has short life span, like 2 secs

	//shock nade
	level.shocknadetime = 5;
	level._effect["shocknade"]				          = loadfx("custom/shocknade");
	level.shocknadefx = level._effect["shocknade"];
	level.shocknadedamage = 2;//damage per second

	//quick revive
	level.revivelimit = 3;//make undefined for no limit
	level.qrvanishfx = level._effect["poltergeist"];

	//One weapon file for bottles
	level.UseOneBottle = 1;//0 for other weapon files, 1 for only one
	

	//Fix end game dvars, when game ends reset dvars
	thread FixEndGameDvars("cg_laserForceOn", 0);
	thread FixEndGameDvars("perk_weapSpreadMultiplier", .65);
	//END MODDER ADJUSTMENTS======================================================================

	vending_triggers = GetEntArray( "zombie_vending", "targetname" );

	if ( vending_triggers.size < 1 ) return;
	// thread PerkRewards();

	vending_upgrade_trigger = GetEntArray("zombie_vending_upgrade", "targetname");

	if ( vending_upgrade_trigger.size >= 1 ) array_thread( vending_upgrade_trigger, ::vending_upgrade );

	// this map uses atleast 1 perk machine
	//AddThisPerk(reward function,specialty,shader,hintstring,bottle,sound,vox)
	//::None is used when no extra function is needed
	//This function is thread on each player
	AddThisPerk(::ZMP,"specialty_fireproof", "vending_zmp_shader","Press & hold &&1 to buy ZMP [Cost: 3000]","zombie_perk_bottle_revive");
	//zmp uses bear perk bottle and all others without one use it too

	AddThisPerk(::None,"specialty_rof", "specialty_doubletap_zombies","Press & hold &&1 to buy Double Tap Root Beer [Cost: 2000]","zombie_perk_bottle_doubletap", "mx_doubletap_sting","vox_perk_doubletap_0");
	AddThisPerk(::Jugg,"specialty_armorvest", "specialty_juggernaut_zombies","Press & hold &&1 to buy Jugger-Nog [Cost: 2500]","zombie_perk_bottle_jugg", "mx_jugger_sting","vox_perk_jugga_0");
	AddThisPerk(::None,"specialty_fastreload", "specialty_fastreload_zombies","Press & hold &&1 to buy Speed Cola [Cost: 3000]","zombie_perk_bottle_sleight", "mx_speed_sting","vox_perk_speed_0");
	
	//bo perks
	AddThisPerk(::PHD,"specialty_detectexplosive","specialty_divetonuke_zombies","Press & hold &&1 to buy PHD-Flopper [Cost: 1500]","zombie_perk_bottle_revive","mx_phd_sting","vox_perk_phdflopper_d_0");
	AddThisPerk(::None,"specialty_longersprint","specialty_marathon_zombies","Press & hold &&1 to buy Stamin-up [Cost: 2000]","zombie_perk_bottle_revive","mx_staminup_sting","vox_perk_stamine_d_0");
	AddThisPerk(::None,"specialty_extraammo","specialty_mulekick_zombies","Press & hold &&1 to buy Mule Kick [Cost: 3000]","zombie_perk_bottle_revive","mx_mule_sting","vox_perk_mule_d_0");
	AddThisPerk(::DeadShot,"specialty_bulletaccuracy","specialty_bulletaccuracy","Press & hold &&1 to buy DeadShot Daquiri [Cost: 1500]","zombie_perk_bottle_revive","mx_deadshot_sting","vox_perk_deadshot_d_0");
	
	AddThisPerk(::ElecCherry,"specialty_shades", "vending_electric_cherry_shader","Press & hold &&1 to buy Electric Cherry [Cost: 2000]","zombie_perk_bottle_revive","mx_electric_cherry_sting");
	
	AddThisPerk(::None,"specialty_quickrevive", "specialty_quickrevive_zombies","Press & hold &&1 to buy Quick Revive [Cost: 1500]","zombie_perk_bottle_revive", "mx_revive_sting","vox_perk_revive_0");
	
	//custom perks
	AddThisPerk(::DoubleMag,"specialty_twoprimaries", "vending_doublemag_shader","Press & hold &&1 to buy Split-Mag [Cost: 2000]","zombie_perk_bottle_revive");
	AddThisPerk(::None,"specialty_gpsjammer", "vending_shocknade_shader","Press & hold &&1 to buy Shock-Nade [Cost: 2000]","zombie_perk_bottle_revive");

	thread PerkRewards(::setPerkDvars);

	//add bottles to use
	preCacheItem( "zombie_perk_bottle" );
	PrecacheItem( "zombie_knuckle_crack" );

	//PI ESM - sumpf vending machine
	
	precachemodel("zombie_vending_packapunch_on");

	//for other fx, add to script_string of trigger use for zombie_vending targetname trigger and here
	level._effect["sleight_light"] = loadfx("mc_perks/fx_zombie_cola_on");
	level._effect["doubletap_light"] = loadfx("mc_perks/fx_zombie_cola_dtap_on");
	level._effect["jugg_light"] = loadfx("mc_perks/fx_zombie_cola_jugg_on");
	level._effect["revive_light"] = loadfx("mc_perks/fx_zombie_cola_revive_on");
	level._effect["packapunch_fx"] = loadfx("mc_perks/fx_zombie_packapunch");


	if( !isDefined( level.packapunch_timeout ) )
	{
		level.packapunch_timeout = 15;
	}

	// PrecacheString( &"ZOMBIE_PERK_JUGGERNAUT" );
	// PrecacheString( &"ZOMBIE_PERK_QUICKREVIVE" );
	// PrecacheString( &"ZOMBIE_PERK_FASTRELOAD" );
	// PrecacheString( &"ZOMBIE_PERK_DOUBLETAP" );
	PrecacheString( &"ZOMBIE_PERK_PACKAPUNCH" );

	set_zombie_var( "zombie_perk_cost",					2000 );
	

	// this map uses atleast 1 perk machine

	array_thread( vending_triggers, ::vending_trigger_think );
	array_thread( vending_triggers, ::electric_perks_dialog);
	array_thread( vending_triggers, ::turn_perk_on);
	if(level.perksellback) array_thread( vending_triggers, ::Sell_Back);

	level thread turn_PackAPunch_on();	
	
	// thread electric_on();
	// level thread machine_watcher();

	//PERK RANDOMIZER
	if(isDefined(level.randomize_perk_rounds)) thread PerkSetup();

}

SetBottle(perk){
	flag_wait("all_players_connected");
	wait(1);
	if(!isDefined(level.OneBottle)) level.OneBottle=[];
	wait(.1);
	wait(.1);
	level.OneBottle[level.OneBottle.size] = perk;
	
}
None(){
	//Reward handled elsewhere
}
ResetStuff(){
	while(isDefined(self)) wait(.1);
	self setClientDvar( "cg_laserForceOn", 0 );
}
DeadShot(){
	self thread ResetStuff();
	self endon("disconnect");
	while(1){
		self waittill_any("weapon_change","weapon_change_complete");
		if(self HasPerk("specialty_bulletaccuracy")){
			if(IsSubStr(self getCurrentWeapon(),"bottle") || IsSubStr(self getCurrentWeapon(),level.sellbackweapon)){
				self setClientDvar( "cg_laserForceOn", 0 );
			}else{
				self setClientDvar( "cg_laserForceOn", 1 );
			}
		}else{
			self setClientDvar( "cg_laserForceOn", 0 );
			self setclientdvar( "perk_weapSpreadMultiplier", .65);
		}
	}
}
DoubleMag(){
	self endon("disconnect");
	if(!isDefined(self.doublemag)) self.doublemag = 0;
	while(1){
		self waittill("weapon_fired");
		if(!self HasPerk("specialty_twoprimaries")) continue;
		if(self.doublemag==1){
			ammo = self GetCurrentWeaponClipAmmo();
			self setWeaponAmmoClip(self getCurrentWeapon(),ammo+1);
			self.doublemag=0;
			continue;
		}
		if(self.doublemag==0) self.doublemag = 1;
	}
}
ZMP(){
	self endon("disconnect");
	if(!isDefined(self.zmp)) self.zmp = 0;
	while(1){
		self waittill("damage", amount, attacker);
		if(attacker==self) continue;
		if(!self HasPerk("specialty_fireproof")) continue;
		if(self.zmp==0){
			zmp = 1;
			if(!IsDefined( level.usemenuforhud ) || !level.usemenuforhud){
				if(!isDefined(self.perk_hud[ "specialty_fireproof" ])) continue;
				self.perk_hud[ "specialty_fireproof" ].alpha = .3;
			}
			self enableInvulnerability();
			self playlocalsound("zombie_arc");
			PlayFXOnTag(level.zmpfx, self, "J_SpineLower");
			ai = GetAiArray( "axis" ); 
			for( i = 0; i < ai.size; i++ ){
				if(distance2D(self.origin,ai[i].origin) < level.zmpradius){
					PlayFXOnTag(level.zmpfx, ai[i], "J_SpineLower");
					ai[i] DoDamage( ai[i].health + 666, ai[i].origin );
				}
			}
			self disableInvulnerability();
			if(IsDefined( level.usemenuforhud ) && level.usemenuforhud){
				for(j=0;j<14;j++){
					for(i=0;i<self.perk_hud.size;i++){
						if(self.perk_hud[i] == level.specialties["specialty_fireproof"]["shader"]) self SetClientDvar("mc_perk_" + i, "");
					}
					wait(level.zmp_recharge/40);
					for(i=0;i<self.perk_hud.size;i++){
						if(self.perk_hud[i] == level.specialties["specialty_fireproof"]["shader"]) self SetClientDvar("mc_perk_" + i, self.perk_hud[i]);
					}
					wait(level.zmp_recharge/40);
				}
				for(j=0;j<6;j++){
					for(i=0;i<self.perk_hud.size;i++){
						if(self.perk_hud[i] == level.specialties["specialty_fireproof"]["shader"]) self SetClientDvar("mc_perk_" + i, "");
					}
					wait(level.zmp_recharge/80);
					for(i=0;i<self.perk_hud.size;i++){
						if(self.perk_hud[i] == level.specialties["specialty_fireproof"]["shader"]) self SetClientDvar("mc_perk_" + i, self.perk_hud[i]);
					}
					wait(level.zmp_recharge/80);
				}
			}else{
				wait(level.zmp_recharge-3);
				for(i=1;i<6;i++){
					if(isDefined(self.perk_hud[ "specialty_fireproof" ]))  self.perk_hud[ "specialty_fireproof" ].alpha = .5+(i*.1);
					wait(.25/i);
					if(isDefined(self.perk_hud[ "specialty_fireproof" ]))  self.perk_hud[ "specialty_fireproof" ].alpha = .3;
					wait(.25/i);
				}
				self.perk_hud[ "specialty_fireproof" ].alpha = 1;
			}
			zmp = 0;
			
		}
	}
}
Jugg(){
	self endon("disconnect");
	while(1){
		if(self HasPerk("specialty_armorvest")){
			self.maxhealth = level.zombie_vars["zombie_perk_juggernaut_health"];
		}
		wait(.1);
	}
}
AddThisPerk(function,specialty,shader,string,bottle,sound,vox){
	if(isDefined(level.UseOneBottle) && level.UseOneBottle) thread SetBottle(specialty);
	thread PerkRewards(function);
	if(!isDefined(level.specialties)) level.specialties = [];
	DoubleCheck("sound",specialty,sound);
	DoubleCheck("string",specialty,string);
	DoubleCheck("shader",specialty,shader);
	if(isDefined(shader)) PrecacheShader(shader);
	if(!level.UseOneBottle){
		DoubleCheck("bottle",specialty,bottle);
		if(isDefined(bottle)) PrecacheItem(bottle);
	}
	DoubleCheck("vox",specialty,vox);
}
DoubleCheck(var,specialty,value){
	if(!isDefined(level.specialties[specialty])) level.specialties[specialty] = [];
	if(isDefined(specialty)) level.specialties[specialty][var] = value;
}

ElecCherry(){
	self endon("disconnect");
	while(1){
		self waittill_any("reload_start", "fake_death", "death", "player_downed");
		if(self HasPerk("specialty_shades")){
			if(level.eleccherryface) self setElectrified(0.03);
			self playLocalSound("cherry_reload_charge");//"zombie_arc"//use this if don't have cherry sound
			PlayFXOnTag(level.eleccherryfx, self, "J_SpineLower");
			zombies = GetAiSpeciesArray( "axis", "all" );
			gun = self getCurrentWeapon();
			if(WeaponType(gun)=="grenade") gun = self GetWeaponsListPrimaries()[0];
			for(i=0;i<zombies.size;i++){
				if(distance(self.origin,zombies[i].origin)<50+(level.eleccherryradius-(level.eleccherryradius * (self GetWeaponAmmoClip(gun)/WeaponClipSize( gun ))))){
					PlayFxOnTag( level.eleccherryfx, zombies[i], "J_SpineLower" );
					zombies[i] DoDamage( level.eleccherrydamage, zombies[i].origin );
					if(IsAlive(zombies[i])) zombies[i] thread StunZombies();
				}
			}
			wait(2);//delay before it can be done again.
		}
	}
}
StunZombies(){
	self endon("death");
	if(IsAlive(self)) {
		if(!self.has_legs) self animscripted("stun", self.origin, self.angles, level._zombie_melee_crawl["zombie"][0]);
		else self animscripted("stun", self.origin, self.angles, level._zombie_board_taunt["zombie"][randomint(6)]);
	}

	
	self waittill("stun");
	

}
PerkRewards(function){
	flag_wait("all_players_connected");
	players = get_players();
	for(i=0;i<players.size;i++){
		players[i] thread [[ function ]]();
	}
}

PHD()
{
	self endon("disconnect");
	height = 10.3+level.phdheight; //anything less than 12 will allow from the ground flopping
	surface = 0;
	new_surface = 0;
	while(1){
		if( self HasPerk( "specialty_detectexplosive" ) ){
			while(self IsOnGround()){
				wait(.1);
				surface =self.origin[2];
			}
			while(!self IsOnGround()){
				if(self GetStance() == "crouch" ){ 
					self SetStance("prone");
				}
				wait(.1);
			}
			new_surface = self.origin[2];
			if(new_surface + height < surface){
				if( (self GetStance() == "crouch" || self GetStance() == "prone") && self IsOnGround()){
					timeToProne = 0;
					while(timeToProne<.3){//gives .3 seconds to register prone
						if( self GetStance() == "prone"){
							self thread Splash();
							break;
						}
						wait(.05);
						timeToProne=timeToProne+.05;
					}
				}
				wait(.1);
			}
		}
		wait(.1);
	}
}
Splash()
{
	self EnableInvulnerability();
	self PlaySound( "phd_explode" );//"nuke_flash"//play this if you don't have phd sound
	PlayFX( LoadFX( "explosions/default_explosion"), self.origin );
	RadiusDamage( self.origin, level.phdradius, level.phddamage, level.phddamage/2, self );
	self DisableInvulnerability();
}

turn_perk_on(){
	machine = GetEnt(self.target,"targetname");
	PrecacheModel(machine.model + "_on");
	flag_wait("all_players_connected");
	wait(1);
	self SetCursorHint( "HINT_NOICON" );
	if(self.script_noteworthy == "specialty_quickrevive" && get_players().size>1 || self.script_noteworthy != "specialty_quickrevive") flag_wait("electricity_on");
	machine setmodel(machine.model + "_on");
	machine vibrate((0,-100,0), 0.3, 0.4, 3);
	machine playsound("perks_power_on");
	machine thread perk_fx(self.script_string);
	level notify( self.script_noteworthy + "_power_on");
}

perk_fx( fx )
{
	wait(3);
	if(isDefined(self.target)){
		struct = getstruct(self.target,"targetname");//	maps\_utility.gsc:
		myfx = spawn("script_model",struct.origin);
		myfx setmodel("tag_origin");
		myfx.angles = struct.angles;
		myfx linkto(self);
		playfxontag( level._effect[ fx ], myfx, "tag_origin" );
	}else{
		playfxontag( level._effect[ fx ], self, "tag_origin" );
	}
}

electric_perks_dialog()
{

	self endon ("warning_dialog");
	level endon("switch_flipped");
	timer =0;
	while(1)
	{
		wait(0.5);
		players = get_players();
		for(i = 0; i < players.size; i++)
		{		
			dist = distancesquared(players[i].origin, self.origin );
			if(dist > 70*70)
			{
				timer = 0;
				continue;
			}
			if(dist < 70*70 && timer < 3)
			{
				wait(0.5);
				timer ++;
			}
			if(dist < 70*70 && timer == 3)
			{
				
				players[i] thread do_player_vo("vox_start", 5);	
				wait(3);				
				self notify ("warning_dialog");
				iprintlnbold("warning_given");
			}
		}
	}
}
ByByQR(hum){//need to improve this and make it all go away, and remove sounds too or just shut off machine?
	level waittill("bybyqr");
	
	machine = spawn("script_model",self.origin );
	machine setmodel("tag_origin");
	machine.angles = self.angles;
	machine.trigger = machine GetMyTrigger("zombie_vending");
	machine.buy_back = machine GetMyTrigger("buy_back");
	machine GetMyStruct();
	machine.audio = machine GetMyTrigger("audio_bump_trigger");
	machine GetMyModel(self.target);
	machine GetMyModel(self.target+ "_clip"); //if you make clips scripts and uncomment this
	machine moveto(machine.origin + (0,0,40),5);
	machine Vibrate( (50, 0, 0), 10, 0.5, 5 );
	wait(5);
	playsoundatposition ("box_poof", hum.origin);
	hum delete();
	playfx(level.qrvanishfx, machine.origin);
	machine moveto(self.origin+(0,0,-10000),.01);

	// machine = getent(self.target, "targetname");
	// machine delete();
	// audiotrig = machine GetMyTrigger("audio_bump_trigger");
	// audiotrig delete();
	// machine MoveTo(self.origin+(0,0,-10000),.01);
	// self delete();
}
vending_trigger_think()
{
	flag_wait("all_players_connected");
	//self thread turn_cola_off();
	perk = self.script_noteworthy;
	

	if(self.classname == "trigger_use") self SetHintString( &"ZOMBIE_FLAMES_UNAVAILABLE" );
	else self Perksethintstring("The power must be activated first");
	self UseLookAt();
	// self SetCursorHint( "HINT_NOICON" );
	// self UseTriggerRequireLookAt();

	notify_name = perk + "_power_on";
	self thread machine_watcher_factory();
	level waittill( notify_name );
	
	perk_hum = spawn("script_origin", self.origin);
	perk_hum playloopsound("perks_machine_loop");

	self thread check_player_has_perk(perk);
	
	self vending_set_hintstring(perk);
	if(get_players().size==1 && perk == "specialty_quickrevive") self thread ByByQR(perk_hum);
	for( ;; )
	{
		self waittill( "trigger", player );
		
		if(!player useButtonPressed() || player HasPerk(perk) || IsSubStr(player getCurrentWeapon(),"bottle") || IsSubStr(player getCurrentWeapon(),level.sellbackweapon)) continue;
		if(IsDefined( level.mcperklimit ) && (level.mcperklimit<=0 || (isdefined(player.perk_hud.size) && player.perk_hud.size >= level.mcperklimit))){
			answers = [];
			answers[answers.size] = "Sorry, the perk limit is " + level.mcperklimit;
			answers[answers.size] = "No more perks for you, limit " + level.mcperklimit + " met";
			answers[answers.size] = "You've reached the perk limit of " + level.mcperklimit;
			answers[answers.size] = "I think you've had enough. Limited to " + level.mcperklimit;
			asnwers[answers.size] = "Want another perk? Maybe sell one back? Limited to " + level.mcperklimit;
			answer = array_randomize(answers)[0];//	maps\_utility.gsc:

			player IPrintLnBold( answer );
			player playLocalSound("no_cha_ching");
			wait(3);
			continue;
		}
		index = maps\_zombiemode_weapons::get_player_index(player);
		
		cost = level.zombie_vars["zombie_perk_cost"];
		if(isDefined(self.zombie_cost)) cost = self.zombie_cost;
		if(perk == "specialty_quickrevive" && get_players().size<=1) cost = 500;
		if (player maps\_laststand::player_is_in_laststand() )
		{
			continue;
		}

		if(player in_revive_trigger() || player isThrowingGrenade() || player isSwitchingWeapons())
		{
			continue;
		}
		

		if ( player HasPerk( perk ) )
		{
			cheat = false;

			/#
			if ( GetDVarInt( "zombie_cheat" ) >= 5 )
			{
				cheat = true;
			}
			#/

			if ( cheat != true )
			{
				//player iprintln( "Already using Perk: " + perk );
				self playsound("deny");
				player thread play_no_money_perk_dialog();
				continue;
			}
		}

		if ( player.score+5 < cost )
		{
			//player iprintln( "Not enough points to buy Perk: " + perk );
			self playsound("deny");
			player thread play_no_money_perk_dialog();
			continue;
		}

		sound = "bottle_dispense3d";
		if(perk == "specialty_longersprint"){
			player setmovespeedscale(1.05);
			player SetClientDvars("player_sprintUnlimited", "1");
		}

		player achievement_notify( "perk_used" );
		playsoundatposition(sound, self.origin);
		player maps\_zombiemode_score::minus_to_player_score( cost ); 
		///bottle_dispense
		if(isDefined(level.specialties[perk]["sound"])) sound = level.specialties[perk]["sound"];
		else sound = "";
		self thread play_vendor_stings(sound);


		// do the drink animation
		gun = player perk_give_bottle_begin( perk );
		player.is_drinking = 1;
		player waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );

		// restore player controls and movement
		player perk_give_bottle_end( gun, perk );
		player.is_drinking = undefined;
		// TODO: race condition?
		if ( player maps\_laststand::player_is_in_laststand() )
		{
			continue;
		}

		player SetPerk( perk );
		if(IsDefined( level.usemenuforhud ) && level.usemenuforhud) player notify("perk update");
		switch(perk){
			case "specialty_gpsjammer":
				iPrintLnBold("Shock and hold zombies with grenades.");
				break;
			case "specialty_fireproof":
				iPrintLnBold("Zombies are shocked when they hit you, with " + level.zmp_recharge + " second delay.");
				break;
			case "specialty_twoprimaries":
				iPrintLnBold("For every 2 bullets you get 1 back.");
				break;
			case "specialty_shades":
				iPrintLnBold("Electric Cherry radius increases with less ammo in your clip.");
				break;
			case "specialty_explosivedamage":
				iPrintLnBold("Press crouch or prone in the air to flop!");
			default:
				break;
		}
		player thread perk_vo(perk);
		player setblur( 4, 0.1 );
		wait(0.1);
		player setblur(0, 0.1);
		//earthquake (0.4, 0.2, self.origin, 100);
		if(perk == "specialty_armorvest")
		{
			player.maxhealth = level.zombie_vars["zombie_perk_juggernaut_health"];
			player.health = level.zombie_vars["zombie_perk_juggernaut_health"];
			//player.health = 160;
		}

		
		player perk_hud_create( perk );

		//stat tracking
		player.stats["perks"]++;

		//player iprintln( "Bought Perk: " + perk );
		bbPrint( "zombie_uses: playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type perk",
			player.playername, player.score, level.round_number, cost, perk, self.origin );

		player thread perk_think( perk);
		if(perk == "specialty_bulletaccuracy"){
			player setClientDvar("perk_weapSpreadMultiplier", .42);
			player setClientDvar( "cg_laserForceOn", 1 );
		} 
	}
}
play_no_money_perk_dialog()
{
	
	index = maps\_zombiemode_weapons::get_player_index(self);
	
	player_index = "plr_" + index + "_";
	if(!IsDefined (self.vox_nomoney_perk))
	{
		num_variants = maps\_zombiemode_spawner::get_number_variants(player_index + "vox_nomoney_perk");
		self.vox_nomoney_perk = [];
		for(i=0;i<num_variants;i++)
		{
			self.vox_nomoney_perk[self.vox_nomoney_perk.size] = "vox_nomoney_perk_" + i;	
		}
		self.vox_nomoney_perk_available = self.vox_nomoney_perk;		
	}	
	sound_to_play = random(self.vox_nomoney_perk_available);
	
	self.vox_nomoney_perk_available = array_remove(self.vox_nomoney_perk_available,sound_to_play);
	
	if (self.vox_nomoney_perk_available.size < 1 )
	{
		self.vox_nomoney_perk_available = self.vox_nomoney_perk;
	}
			
	self maps\_zombiemode_spawner::do_player_playdialog(player_index, sound_to_play, 0.25);
	
	
		
	
}
check_player_has_perk(perk)
{
	/#
		if ( GetDVarInt( "zombie_cheat" ) >= 5 )
		{
			return;
		}
#/

		dist = 128 * 128;
		while(true)
		{
			players = get_players();
			for( i = 0; i < players.size; i++ )
			{
				if(DistanceSquared( players[i].origin, self.origin ) < dist)
				{
					if(!players[i] hasperk(perk) && !(players[i] in_revive_trigger()))
					{
						//PI CHANGE: this change makes it so that if there are multiple players within the trigger for the perk machine, the hint string is still 
						//                   visible to all of them, rather than the last player this check is done for
						if (IsDefined(level.script) && level.script == "nazi_zombie_theater")
							self setinvisibletoplayer(players[i], false);
						else
							self setvisibletoplayer(players[i]);
						//END PI CHANGE
						//iprintlnbold("turn it off to player");

					}
					else
					{
						self SetInvisibleToPlayer(players[i]);
						//iprintlnbold(players[i].health);
					}
				}


			}

			wait(0.1);

		}

}

vending_set_hintstring( perk ){
	self UseLookAt();
	if(perk=="specialty_quickrevive" && get_players().size<=1){
		if(self.classname == "trigger_use") self SetHintString("Press & hold &&1 to buy Quick Revive [Cost: 500]");
		else self PerkSetHintString("Press & hold &&1 to buy Quick Revive [Cost: 500]");
		self.zombie_cost = 500;
		return;
	}
	if(isDefined(level.specialties[perk]["string"])){
		if(self.classname == "trigger_use") self SetHintString(level.specialties[perk]["string"]);
		else self PerkSetHintString(level.specialties[perk]["string"]);
	}else{
		if(self.classname == "trigger_use") self SetHintString( perk + " Cost: " + level.zombie_vars["zombie_perk_cost"] );
		else self PerkSetHintString( perk + " Cost: " + level.zombie_vars["zombie_perk_cost"] );
	}
}


perk_think( perk )
{
	if(perk=="specialty_quickrevive" && get_players().size==1){
		if(isDefined(level.revivelimit) && level.revivelimit <=0){
			level notify("bybyqr");
			wait(.1);
			if(isdefined(level.usemenuforhint) && level.usemenuforhint){
				self SetClientDvar("hintstring","");
			}else{
				if(isDefined(self) && isDefined(self.hintString)) self.hintString SetText("");
			}
			
		}
		if(isDefined(level.revivelimit)) level.revivelimit--;
	}
	/#
		if ( GetDVarInt( "zombie_cheat" ) >= 5 )
		{
			if ( IsDefined( self.perk_hud[ perk ] ) )
			{
				return;
			}
		}
#/
		self waittill_any( "fake_death", "death", "player_downed" ,perk+"_sold");
		while(self useButtonPressed()) wait(.1);
		wait(.3);
		if(perk=="specialty_bulletaccuracy"){
			self setClientDvar( "cg_laserForceOn", 0 );
			self setClientDvar("perk_weapSpreadMultiplier", .65);
		}
		if(perk=="specialty_longersprint") self setmovespeedscale(1);
		if(perk=="specialty_armorvest") self.maxhealth = 100;
		
		// self.maxhealth = 100;
		self perk_hud_destroy( perk);
		//self iprintln( "Perk Lost: " + perk );
		
		self UnsetPerk( perk );
}


perk_hud_create( perk )
{
	if ( !IsDefined( self.perk_hud ) )
	{
		self.perk_hud = [];
	}

	/#
		if ( GetDVarInt( "zombie_cheat" ) >= 5 )
		{
			if ( IsDefined( self.perk_hud[ perk ] ) )
			{
				return;
			}
		}
#/


		shader = "black";//default if you don't have shader yet
		if(isDefined(level.specialties[perk]["shader"])) shader = level.specialties[perk]["shader"];

		if(IsDefined( level.usemenuforhud ) && level.usemenuforhud){
			self.perk_hud[ self.perk_hud.size ] = shader;
			self notify("perk update");
		}else{
			hud = create_simple_hud( self );
			hud.foreground = true; 
			hud.sort = 1; 
			hud.hidewheninmenu = false; 
			hud.alignX = "left"; 
			hud.alignY = "bottom";
			hud.horzAlign = "left"; 
			hud.vertAlign = "bottom";
			hud.x = (self.perk_hud.size * 30) + 5; 
			hud.y = hud.y - 70; 
			hud.alpha = 1;
			hud SetShader( shader, 24, 24 );

			self.perk_hud[ perk ] = hud;
		}

			
}


perk_hud_destroy( perk )
{
	
	if(IsDefined( level.usemenuforhud ) && level.usemenuforhud){
		self perk_hud_shift(perk);
	// 	self SetClientDvar("mc_perk_" + number, "");
	// 	iPrintLnBold(number);
	// 	iPrintLnBold(self.perk_hud[ number ]);
	// 	self.perk_hud[ number ] = undefined;

	}else{
		self.perk_hud[ perk ] destroy_hud();
		self.perk_hud[ perk ] = undefined;
	}
	
}

perk_give_bottle_begin( perk )
{
	self DisableOffhandWeapons();
	self DisableWeaponCycling();

	self AllowLean( false );
	self AllowAds( false );
	self AllowSprint( false );
	self AllowProne( false );		
	self AllowMelee( false );

	wait( 0.05 );

	if ( self GetStance() == "prone" )
	{
		self SetStance( "crouch" );
	}

	gun = self GetCurrentWeapon();
	weapon = "zombie_perk_bottle";
	var = 0;
	if(level.UseOneBottle){
		weapon = "zombie_perk_bottle";
		var = GetBottle(perk);
	}else{
		if(isDefined(level.specialties[perk]["bottle"])) weapon = level.specialties[perk]["bottle"];
	}
	// iPrintLnBold(weapon,var);
	self GiveWeapon( weapon , var);
	self SwitchToWeapon( weapon );

	return gun;
}
GetBottle(perk){
	for(i=0;i<level.OneBottle.size;i++){
		// iPrintLnBold(perk, i, isDefined(level.OneBottle), isDefined(level.OneBottle[i]));
		if(perk==level.OneBottle[i]) return i;
	}
	return 0;
}

perk_give_bottle_end( gun, perk )
{
	assert( !IsSubStr(gun,"bottle"));
	assert( !IsSubStr(gun,level.sellbackweapon) );

	self EnableOffhandWeapons();
	self EnableWeaponCycling();

	self AllowLean( true );
	self AllowAds( true );
	self AllowSprint( true );
	self AllowProne( true );		
	self AllowMelee( true );
	// weapon = "";
	weapon = "zombie_perk_bottle_revive";
	if(isDefined(level.specialties[perk]["bottle"])) weapon = level.specialties[perk]["bottle"];

	// TODO: race condition?

	if ( self maps\_laststand::player_is_in_laststand() )
	{
		self TakeWeapon(weapon);
		return;
	}

	if ( gun != "none" && gun != "mine_bouncing_betty" )
	{
		self SwitchToWeapon( gun );
	}
	else 
	{
		// try to switch to first primary weapon
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
	}

	self TakeWeapon(weapon);
}

perk_vo(type)
{
	self endon("death");
	self endon("disconnect");

	index = maps\_zombiemode_weapons::get_player_index(self);
	sound = undefined;

	if(!isdefined (level.player_is_speaking))
	{
		level.player_is_speaking = 0;
	}
	player_index = "plr_" + index + "_";
	//wait(randomfloatrange(1,2));

	sound_to_play = "";
	
	if(isDefined(level.specialties[type]["vox"])) sound_to_play = level.specialties[type]["vox"];
	else sound_to_play = "";
	// iPrintLnBold(sound_to_play);
	// iPrintLnBold(player_index, self.entity_num);
	wait(1.0);
	self maps\_zombiemode_spawner::do_player_playdialog(player_index, sound_to_play, 0.25);
}

//PI ESM - added for support for two switches in factory
machine_watcher_factory(waitforit)
{
	if(isDefined(waitforit)) level waittill(waitforit);
	temp_script_sound="";
	temp_machines = getstructarray("perksacola", "targetname");
	for (x = 0; x < temp_machines.size; x++)
	{
		if (distance2D(temp_machines[x].origin,self.origin)<500 && self.script_string == temp_machines[x].script_string){
			if(isDefined(temp_machines[x].script_sound)) temp_machines[x] thread perks_a_cola_jingle();
			else temp_machines[x] thread play_random_broken_sounds();	
		}
	}
}

play_vendor_stings(sound)
{	
	if(!isdefined(self.jingleplaying)) self.jingleplaying = 0;
	if(!IsDefined (level.packa_jingle)) level.packa_jingle = 0; 
	if(!IsDefined (level.eggs)) level.eggs = 0; 
	if (level.eggs == 0)
	{
		if(self.jingleplaying == 0 ) 
		{
//			iprintlnbold("stinger speed:" + level.speed_jingle);
			self.jingleplaying = 1;		
			temp_org_speed_s = spawn("script_origin", self.origin);	
			// iPrintLnBold(sound, " playing sound");	
			temp_org_speed_s playsound (sound, "sound_done");
			temp_org_speed_s waittill("sound_done");
			self.jingleplaying = 0;
			temp_org_speed_s delete();
//			iprintlnbold("stinger speed:" + level.speed_jingle);
		}
		else if(sound == "mx_packa_sting" && level.packa_jingle == 0) 
		{
			level.packa_jingle = 1;
//			iprintlnbold("stinger packapunch:" + level.packa_jingle);
			temp_org_pack_s = spawn("script_origin", self.origin);		
			temp_org_pack_s playsound (sound, "sound_done");
			temp_org_pack_s waittill("sound_done");
			level.packa_jingle = 0;
			temp_org_pack_s delete();
//			iprintlnbold("stinger packapunch:"  + level.packa_jingle);
		}
	}
}

perks_a_cola_jingle()
{	
	self thread play_random_broken_sounds();
	if(!IsDefined(self.perk_jingle_playing))
	{
		self.perk_jingle_playing = 0;
	}
	if (!IsDefined (level.eggs))
	{
		level.eggs = 0;
	}
	while(1)
	{
		//wait(randomfloatrange(60, 120));
		wait(randomfloatrange(31,45));
		if(randomint(100) < 15 && level.eggs == 0)
		{
			level notify ("jingle_playing");
			//playfx (level._effect["electric_short_oneshot"], self.origin);
			playsoundatposition ("electrical_surge", self.origin);
			if(self.jingleplaying  == 0) 
			{
				self.jingleplaying = 1;
				temp_org_speed = spawn("script_origin", self.origin);
				wait(0.05);
				temp_org_speed playsound (self.script_sound, "sound_done");
				temp_org_speed waittill("sound_done");
				self.jingleplaying = 0;
				temp_org_speed delete();
			}
			if(self.script_sound == "mx_packa_jingle" && level.packa_jingle == 0) 
			{
				level.packa_jingle = 1;
				temp_org_packa = spawn("script_origin", self.origin);
				temp_org_packa playsound (self.script_sound, "sound_done");
				temp_org_packa waittill("sound_done");
				level.packa_jingle = 0;
				temp_org_packa delete();
			}

			self thread play_random_broken_sounds();
		}		
	}	
}
play_random_broken_sounds()
{
	level endon ("jingle_playing");
	if (!isdefined (self.script_sound))
	{
		self.script_sound = "null";
	}
	if (self.script_sound == "mx_revive_jingle")
	{
		while(1)
		{
			wait(randomfloatrange(7, 18));
			playsoundatposition ("broken_random_jingle", self.origin);
		//playfx (level._effect["electric_short_oneshot"], self.origin);
			playsoundatposition ("electrical_surge", self.origin);
	
		}
	}
	else
	{
		while(1)
		{
			wait(randomfloatrange(7, 18));
		// playfx (level._effect["electric_short_oneshot"], self.origin);
			playsoundatposition ("electrical_surge", self.origin);
		}
	}
}
//Pap stuff moved down here
play_packa_wait_dialog(player_index)
{
	waittime = 0.05;
	if(!IsDefined (self.vox_perk_packa_wait))
	{
		num_variants = maps\_zombiemode_spawner::get_number_variants(player_index + "vox_perk_packa_wait");
		self.vox_perk_packa_wait = [];
		for(i=0;i<num_variants;i++)
		{
			self.vox_perk_packa_wait[self.vox_perk_packa_wait.size] = "vox_perk_packa_wait_" + i;
		}
		self.vox_perk_packa_wait_available = self.vox_perk_packa_wait;
	}
	if(!isdefined (level.player_is_speaking))
	{
		level.player_is_speaking = 0;
	}
	sound_to_play = random(self.vox_perk_packa_wait_available);
	self maps\_zombiemode_spawner::do_player_playdialog(player_index, sound_to_play, waittime);
	self.vox_perk_packa_wait_available = array_remove(self.vox_perk_packa_wait_available,sound_to_play);
	
	if (self.vox_perk_packa_wait_available.size < 1 )
	{
		self.vox_perk_packa_wait_available = self.vox_perk_packa_wait;
	}
}

play_packa_get_dialog(player_index)
{
	waittime = 0.05;
	if(!IsDefined (self.vox_perk_packa_get))
	{
		num_variants = maps\_zombiemode_spawner::get_number_variants(player_index + "vox_perk_packa_get");
		self.vox_perk_packa_get = [];
		for(i=0;i<num_variants;i++)
		{
			self.vox_perk_packa_get[self.vox_perk_packa_get.size] = "vox_perk_packa_get_" + i;
		}
		self.vox_perk_packa_get_available = self.vox_perk_packa_get;
	}
	if(!isdefined (level.player_is_speaking))
	{
		level.player_is_speaking = 0;
	}
	sound_to_play = random(self.vox_perk_packa_get_available);
	self maps\_zombiemode_spawner::do_player_playdialog(player_index, sound_to_play, waittime);
	self.vox_perk_packa_get_available = array_remove(self.vox_perk_packa_get_available,sound_to_play);
	
	if (self.vox_perk_packa_get_available.size < 1 )
	{
		self.vox_perk_packa_get_available = self.vox_perk_packa_get;
	}
}

setPerkDvars(){
	if(!IsDefined( level.mcperklimit )) level.mcperklimit = level.specialties.size;
	self endon( "disconnect" );
	while(1){

		for(i = 0; i < level.mcperklimit; i ++){//
			perk = "";
			if(IsDefined( self.perk_hud[i] )) perk = self.perk_hud[i];
			self SetClientDvar("mc_perk_" + i, perk);
		}
		self waittill_any( "fake_death", "death", "player_downed", "perk update");//, "weapon_change_complete" 
	}	
}

third_person_weapon_upgrade( current_weapon, origin, angles, packa_rollers, perk_machine )
{
	forward = anglesToForward( angles );
	interact_pos = origin + (forward*-25);
	
	worldgun = spawn( "script_model", interact_pos );
	worldgun.angles  = self.angles;
	worldgun setModel( GetWeaponModel( current_weapon ) );
	PlayFx( level._effect["packapunch_fx"], origin+(0,1,-34), forward );
	
	worldgun rotateto( angles+(0,90,0), 0.35, 0, 0 );
	wait( 0.5 );
	worldgun moveto( origin, 0.5, 0, 0 );
	packa_rollers playsound( "packa_weap_upgrade" );
	if( isDefined( perk_machine.wait_flag ) )
	{
		perk_machine.wait_flag rotateto( perk_machine.wait_flag.angles+(179, 0, 0), 0.25, 0, 0 );
	}
	wait( 0.35 );
	worldgun delete();
	wait( 3 );
	packa_rollers playsound( "packa_weap_ready" );
	worldgun = spawn( "script_model", origin );
	worldgun.angles  = angles+(0,90,0);
	worldgun setModel( GetWeaponModel( current_weapon+"_upgraded" ) );
	worldgun moveto( interact_pos, 0.5, 0, 0 );
	if( isDefined( perk_machine.wait_flag ) )
	{
		perk_machine.wait_flag rotateto( perk_machine.wait_flag.angles-(179, 0, 0), 0.25, 0, 0 );
	}
	wait( 0.5 );
	worldgun moveto( origin, level.packapunch_timeout, 0, 0);
	return worldgun;
}

vending_upgrade()
{
	perk_machine = GetEnt( self.target, "targetname" );
	if( isDefined( perk_machine.target ) )
	{
		perk_machine.wait_flag = GetEnt( perk_machine.target, "targetname" );
	}
	
	self UseTriggerRequireLookAt();
	self SetHintString( &"ZOMBIE_FLAMES_UNAVAILABLE" );
	self SetCursorHint( "HINT_NOICON" );
	level waittill("Pack_A_Punch_on");
	
	self thread maps\_zombiemode_weapons::decide_hide_show_hint();
	
	packa_rollers = spawn("script_origin", self.origin);
	packa_timer = spawn("script_origin", self.origin);
	packa_rollers playloopsound("packa_rollers_loop");
	
	self SetHintString( &"ZOMBIE_PERK_PACKAPUNCH" );
	cost = level.zombie_vars["zombie_perk_cost"];
	
	for( ;; )
	{
		self waittill( "trigger", player );
		index = maps\_zombiemode_weapons::get_player_index(player);	
		cost = 5000;
		plr = "plr_" + index + "_";
		
		if( !player maps\_zombiemode_weapons::can_buy_weapon() )
		{
			wait( 0.1 );
			continue;
		}
		
		if (player maps\_laststand::player_is_in_laststand() )
		{
			wait( 0.1 );
			continue;
		}
		
		if( player isThrowingGrenade() )
		{
			wait( 0.1 );
			continue;
		}
		
		if( player isSwitchingWeapons() )
		{
			wait(0.1);
			continue;
		}
		
		current_weapon = player getCurrentWeapon();

		if( !IsDefined( level.zombie_include_weapons[current_weapon] ) || !IsDefined( level.zombie_include_weapons[current_weapon + "_upgraded"] ) )
		{
			continue;
		}

		if ( player.score+5 < cost )
		{
			//player iprintln( "Not enough points to buy Perk: " + perk );
			self playsound("deny");
			player thread play_no_money_perk_dialog();
			continue;
		}
		player maps\_zombiemode_score::minus_to_player_score( cost ); 
		self achievement_notify("perk_used");
		sound = "bottle_dispense3d";
		playsoundatposition(sound, self.origin);
		rand = randomintrange(1,100);
		
		if( rand <= 8 )
		{
			player thread play_packa_wait_dialog(plr);
		}
		
		self thread play_vendor_stings("mx_packa_sting");
		
		origin = self.origin;
		angles = self.angles;
		
		if( isDefined(perk_machine))
		{
			origin = perk_machine.origin+(0,0,35);
			angles = perk_machine.angles+(0,90,0);
		}
		
		self disable_trigger();
		
		player thread do_knuckle_crack();

		// Remember what weapon we have.  This is needed to check unique weapon counts.
		self.current_weapon = current_weapon;
											
		weaponmodel = player third_person_weapon_upgrade( current_weapon, origin, angles, packa_rollers, perk_machine );
		
		self enable_trigger();
		self SetHintString( &"ZOMBIE_GET_UPGRADED" );
		self setvisibletoplayer( player );
		
		self thread wait_for_player_to_take( player, current_weapon, packa_timer );
		self thread wait_for_timeout( packa_timer );
		
		self waittill_either( "pap_timeout", "pap_taken" );
		
		self.current_weapon = "";
		weaponmodel delete();
		self SetHintString( &"ZOMBIE_PERK_PACKAPUNCH" );
		self setvisibletoall();
	}
}

wait_for_player_to_take( player, weapon, packa_timer )
{
	index = maps\_zombiemode_weapons::get_player_index(player);
	plr = "plr_" + index + "_";
	
	self endon( "pap_timeout" );
	while( true )
	{
		packa_timer playloopsound( "ticktock_loop" );
		self waittill( "trigger", trigger_player );
		packa_timer stoploopsound(.05);
		if( trigger_player == player ) 
		{
			if( !player maps\_laststand::player_is_in_laststand() )
			{
				self notify( "pap_taken" );
				primaries = player GetWeaponsListPrimaries();
				if( isDefined( primaries ) && primaries.size >= 2 )
				{
					player maps\_zombiemode_weapons::weapon_give( weapon+"_upgraded" );
				}
				else
				{
					player GiveWeapon( weapon+"_upgraded" );
					player GiveMaxAmmo( weapon+"_upgraded" );
				}
				
				player SwitchToWeapon( weapon+"_upgraded" );
				player achievement_notify( "DLC3_ZOMBIE_PAP_ONCE" );
				player achievement_notify( "DLC3_ZOMBIE_TWO_UPGRADED" );
				player thread play_packa_get_dialog(plr);
				return;
			}
		}
		wait( 0.05 );
	}
}

wait_for_timeout( packa_timer )
{
	self endon( "pap_taken" );
	
	wait( level.packapunch_timeout );
	
	self notify( "pap_timeout" );
	packa_timer stoploopsound(.05);
	packa_timer playsound( "packa_deny" );
}

do_knuckle_crack()
{
	gun = self upgrade_knuckle_crack_begin();
	
	self.is_drinking = 1;
	self waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );
	
	self upgrade_knuckle_crack_end( gun );
	self.is_drinking = undefined;
}

upgrade_knuckle_crack_begin()
{
	self DisableOffhandWeapons();
	self DisableWeaponCycling();

	self AllowLean( false );
	self AllowAds( false );
	self AllowSprint( false );
	self AllowProne( false );		
	self AllowMelee( false );
	
	if ( self GetStance() == "prone" )
	{
		self SetStance( "crouch" );
	}

	primaries = self GetWeaponsListPrimaries();

	gun = self GetCurrentWeapon();
	weapon = "zombie_knuckle_crack";
	
	if ( gun != "none" && gun != "mine_bouncing_betty" )
	{
		self TakeWeapon( gun );
	}
	else
	{
		return;
	}

	if( primaries.size <= 1 )
	{
		self GiveWeapon( "zombie_colt" );
	}
	
	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );

	return gun;
}

upgrade_knuckle_crack_end( gun )
{
	assert( gun != "zombie_perk_bottle_doubletap" );
	assert( gun != "zombie_perk_bottle_revive" );
	assert( gun != "zombie_perk_bottle_jugg" );
	assert( gun != "zombie_perk_bottle_sleight" );
	assert( gun != level.sellbackweapon );

	self EnableOffhandWeapons();
	self EnableWeaponCycling();

	self AllowLean( true );
	self AllowAds( true );
	self AllowSprint( true );
	self AllowProne( true );		
	self AllowMelee( true );
	weapon = "zombie_knuckle_crack";

	// TODO: race condition?
	if ( self maps\_laststand::player_is_in_laststand() )
	{
		self TakeWeapon(weapon);
		return;
	}

	self TakeWeapon(weapon);
	primaries = self GetWeaponsListPrimaries();
	if( isDefined( primaries ) && primaries.size > 0 )
	{
		self SwitchToWeapon( primaries[0] );
	}
	else
	{
		self SwitchToWeapon( "zombie_colt" );
	}
}

// PI_CHANGE_BEGIN
// JMA - in order to have multiple Pack-A-Punch machines in a map we're going to have
//			to run a thread on each on.
//	NOTE:  In the .map, you'll have to make sure that each Pack-A-Punch machine has a unique targetname
turn_PackAPunch_on()
{
	level waittill("Pack_A_Punch_on");

	vending_upgrade_trigger = GetEntArray("zombie_vending_upgrade", "targetname");
	for(i=0; i<vending_upgrade_trigger.size; i++ )
	{
		// vending_upgrade_trigger[i] thread machine_watcher_factory("Pack_A_Punch_on");
		perk = getent(vending_upgrade_trigger[i].target, "targetname");
		if(isDefined(perk))
		{
			perk thread activate_PackAPunch();
		}
	}
}

activate_PackAPunch()
{
	self setmodel("zombie_vending_packapunch_on");
	self playsound("perks_power_on");
	self vibrate((0,-100,0), 0.3, 0.4, 3);
	/*
	self.flag = spawn( "script_model", machine GetTagOrigin( "tag_flag" ) );
	self.angles = machine GetTagAngles( "tag_flag" );
	self.flag setModel( "zombie_sign_please_wait" );
	self.flag linkto( machine );
	self.flag.origin = (0, 40, 40);
	self.flag.angles = (0, 0, 0);
	*/
	timer = 0;
	duration = 0.05;

	level notify( "Carpenter_On" );
}


//PERK RANDOMIZER

PerkSetup(){

	// flag_wait("all_players_connected");
	// wait(5);
	level.perks = getstructarray("random_perks", "targetname");
	for(i=0;i<level.perks.size;i++){
		machine = spawn("script_model",level.perks[i].origin );
		machine setmodel("tag_origin");
		machine.angles = level.perks[i].angles;
		machine.trigger = machine GetMyTrigger("zombie_vending");
		machine.buy_back = machine GetMyTrigger("buy_back");
		machine GetMyStruct();
		machine.audio = machine GetMyTrigger("audio_bump_trigger");
		machine GetMyModel(level.perks[i].target);
		machine GetMyModel(level.perks[i].target+ "_clip"); //if you make clips scripts and uncomment this
		machine thread MoveStuff(i);
	}
	thread RandomizePerks();
	// thread SinglePlayerRevive();
}
MoveStuff(index){
	while(1){
		level waittill("randomize");
		// self moveto(self.origin + (0, 0, 20),3);
		// self thread TurnMe();
		// wait(3);
		playfx( level._effect["poltergeist"],self.origin);
		playsoundatposition( "box_poof", self.origin );
		self moveto(self.origin + (0, 0, -10000),.1);
		wait(.1);
		mystruct = level.perks[index];
		
		others = getstructarray("random_perks_"+mystruct.target,"targetname");
		others[others.size] = mystruct;
		others = array_randomize(others);
		mystruct = others[0];
		
		self moveto(mystruct.origin+(0,0,1),.1);
		self.angles = mystruct.angles;
		wait(.1);
		playfx( level._effect["poltergeist"],self.origin);
		playsoundatposition( "box_poof", self.origin );
		// self moveto(self.origin + (0, 0, -20),3);
		// self thread TurnMe();
		// wait(3);
		self playsound ( "box_poof_land" );
		self playsound( "couch_slam" );
	}
}
RandomizePerks(){
	while(1){
		level.perks = array_randomize(level.perks);
		level notify("randomize");
		if(!level.randomize_perk_rounds){
			break;
		}else{
			for(i=0;i<level.randomize_perk_rounds;i++){
				level waittill("between_round_over"); //wait to next round to do it again
			}
		}	
		wait(.1);
	}
}
TurnMe(){
	self rotateyaw(360*10,2.9);
	wait(3);
}
GetMyTrigger(trig, closest){
	range = 1000;
	triggers = getentarray(trig,"targetname");
	for(i=0;i<triggers.size;i++){
		if(distance(triggers[i].origin,self.origin)<range){
			mydistance = distance(triggers[i].origin,self.origin);
			if(mydistance<range){
				range = mydistance;
				closest = triggers[i];
			}	
		}
	}
	if(isdefined(closest)){
		closest unlink();
		closest enablelinkto();
		closest linkto(self);
		return closest;
	}
}
CheckForStruct(){
	if(!isDefined(self.target)) return;
	struct=getstruct(self.target, "targetname");
	self thread BeforeMoveStructs(struct);
	wait(5);
	self thread AfterMoveStructs(struct);
}

BeforeMoveStructs(struct){//struct moving functions
	ent = spawn("script_origin",struct.origin);
	ent.origin = struct.origin;
	ent linkto(self);
	struct.ent = ent;
}
AfterMoveStructs(struct){//struct moving functions
	struct.origin = struct.ent.origin;
	struct.ent delete();
	struct.ent = undefined;
	// PlayFx(level._effect["poltergeist"], struct.origin);
}
GetMyStruct(){
	structs = getstructarray("perkscola", "targetname");
	for(i=0;i<structs.size;i++){
		if(distance(structs[i].origin,self.origin)<100){
			structs[i] unlink();
			structs[i] linkto(self);
			return structs[i];
		}
	}
}
GetMyModel(target){
	models = getentarray(target, "targetname"); //target of script_origin equals this
	for(i=0;i<models.size;i++){
		if(distance(models[i].origin,self.origin)<200){
			models[i] unlink();
			models[i] linkto(self);
			models[i] thread CheckForStruct();
			if(isDefined(models[i].target)) models[i] thread GetMyModel(models[i].target);
		}
	}
}

//Solo ZOMBIE_PERK_QUICKREVIVE
solo_qr(){
	self.revive = true;
	self.being_revived = true;
	self.revivetrigger = 1;
	level notify ("fake_death");
	self notify ("fake_death");
	weapons = self GetWeaponsListPrimaries();
	if(weapons.size>2){
		if(WeaponType(self getCurrentWeapon()) == "grenade" || IsSubStr(self getCurrentWeapon(),"bottle")){
			self TakeWeapon(weapons[0]);
		}else{
			self takeWeapon(self getCurrentWeapon());
		}
	}
	
	self maps\_laststand::laststand_take_player_weapons();
 
	focuses = getstructarray("solo_quickrevive","targetname");//place script_struct in starting zone in map with kvp
 	closest = undefined;
 	for(i=0;i<focuses.size;i++){
	 	z_interest = spawn("script_model",focuses[i].origin);
		z_interest setmodel("tag_origin");
		if(isdefined(closest)){
			if(distance(self.origin,z_interest.origin)<distance(self.origin,closest.origin)){
				closest = z_interest;
			}else{
				z_interest delete();
			}
		}else{
			closest = z_interest;
		}
 	}
 	if(isDefined(closest)){
 		closest create_zombie_point_of_interest( 6000, 96, 10000, true );
		closest thread StopInterest();
 	}
	if(isDefined(self.last_stand_weapon)){
		self GiveWeapon(self.last_stand_weapon);
		self SwitchToWeapon( self.last_stand_weapon );
	}else{
		self GiveWeapon(level.laststandpistol);
		self SwitchToWeapon( level.laststandpistol );
	}
		

	self DisableWeaponCycling();

	VisionSetNaked( "laststand", 1 ); 

	self AllowStand( false );
	self AllowCrouch( false );
	self AllowSprint(false);
	self AllowProne( true );

	self.ignoreme = true;
	self EnableInvulnerability();

	wait 8;

	self EnableWeaponCycling();

	self TakeWeapon( self.last_stand_weapon );
	self maps\_laststand::laststand_giveback_player_weapons();


	VisionSetNaked( "zombie_factory", 1 ); 

	self AllowStand( true );
	self AllowCrouch( true );
	self AllowProne( true );
	self AllowSprint(true);

	self SetStance( "stand" );

	self.ignoreme = false;
	self DisableInvulnerability();
	self.being_revived = false;
	self.revivetrigger = undefined;
	weapons = self getWeaponsListPrimaries(); 
	self switchToWeapon(weapons[0]);
}
StopInterest(){
	wait(8);
	self create_zombie_point_of_interest( 0, 0, 0, false );
	self delete();
}


//Perk Hint Huds

PerkSetHintString(hint){
	self.myHint = UserHint(hint);
	if(self.classname == "trigger_multiple"){
		self thread WaitForPerk();
	}
}
WaitForPerk(){
	while(isDefined(self)){
		self waittill("trigger",player);
		if(isDefined(self.lookat) && self.lookat){
			if(isDefined(level.usemenuforhint) && level.usemenuforhint){
				if(!player canSeeThisEnt(self)){
					player SetClientDvar("hinstring", "");
				 	continue;
				}
			}else{
				if(!player canSeeThisEnt(self)){
					if(isDefined(player.hintString)) player.hintString destroy();
				 	continue;
				}
			}
				
		}
		if(isdefined(level.usemenuforhint) && level.usemenuforhint){
			if(player HasPerk(self.script_noteworthy) && level.perksellback) player SetClientDvar("hintstring","^1 to sell back perk for " + self.zombie_cost/2);
			else player SetClientDvar("hintstring",MenuFix(self.myHint));
			self thread KillMePlease(player);
			continue;
		}
		if(isDefined(player.hintString)){
			if(player HasPerk(self.script_noteworthy) && level.perksellback) player.hintString SetText(UserHint("^1Press & hold &&1 to sell back perk for " + self.zombie_cost/2));
			else player.hintString SetText(self.myHint);
			continue;
		}

		if(isdefined(level.usemenuforhint) && level.usemenuforhint){
			player SetClientDvar("hintstring",MenuFix(self.myHint));
			if(player HasPerk(self.script_noteworthy) && level.perksellback) player SetClientDvar("hintstring","^1 to sell back perk for " + self.zombie_cost/2);
			self thread KillMePlease(player);
		}
		if(!isDefined(player.hintString)){
			player SetPlayerHint(self.myHint);
			self thread KillMePlease(player);
		}else{
			player.hintString SetText(self.myHint);
			if(player HasPerk(self.script_noteworthy) && level.perksellback) player.hintString SetText(UserHint("^1Press & hold &&1 to sell back perk for " + self.zombie_cost/2));
		}
	}
}

MenuFix(hint){
	if(!IsSubStr(hint,"Press & hold [{+activate}]")) return hint;
	toks = StrTok(hint, " ");
	begin = 0;
	newhint = "";
	for(i=0;i<toks.size;i++){
		if(begin) newhint = newhint + " " + toks[i];
		if(!begin && (toks[i] == "&&1" || toks[i] == "[{+activate}]")) begin = 1;
		
	}
	return newhint;
}
KillMePlease(player){
	player endon("disconnect");
	while(player canSeeThisEnt(self) ){
		wait(.01);
		if(isDefined(self.script_noteworthy) && player HasPerk(self.script_noteworthy) && !level.perksellback) break;
	}
	if(isDefined(player.hintString)) player.hintString destroy();
	if(isDefined(level.usemenuforhint) && level.usemenuforhint) player SetClientDvar("hintstring", "");
}
UserHint(hint_string){
	//Changes the &&1 to the players use button
	if(!IsSubStr(hint_string,"&&1")) return hint_string;
	hint_string = string(hint_string);
	tokens = strtok(hint_string," ");
	new_hint = "";
	for(i=0;i<tokens.size;i++){
		if(tokens[i] == "&&1"){
			new_hint = new_hint + " " + "[{+activate}]";
		}else{
			new_hint = new_hint + " " + tokens[i];
		}
	}
	return new_hint;
}
UseLookAt(){
	self.lookat = true;
}
FadeMe(a,b){
	self endon("mchudhint");
	self.hintString.alpha = int(a);
	self.hintString FadeOverTime( .5 );
	self.hintString.alpha = int(b);

}
SetPlayerHint(hint){
	hud = create_simple_hud( self );
	hud.alignX = "center"; 
    hud.alignY = "middle";
    hud.horzAlign = "center"; 
    hud.vertAlign = "middle";
    hud.y = hud.y + 70; 
    hud.fontscale = 14;
    hud SetText(hint);
    self.hintString = hud;
    self thread FadeMe(0,1);
}
canSeeThisEnt(trig){//ent canSeeThisEnt(ent);
	self endon("disconnect");
	if(!self IsTouching(trig)) return false;
	if(distance2D(self.origin,trig.origin)<10) return true;//give me leeway
	if(!bulletTracePassed(self.origin,trig.origin,false,undefined)) return false;
	//Checks if player is at good angle
	angles = vectortoAngles(trig.origin - self.origin);
	trigangle = angles[1];
	myangle = self.angles[1];
	if(trigangle > 180) trigangle = trigangle - 360;
	looking = (myangle-trigangle);
	if(looking>340) looking = looking - 360;
	if(looking < -340) looking = looking + 360;
	if(looking > -35 && looking < 35 ) return 1;
	return 0;
}

//Sell Back Perks
Sell_Back(){
	for( ;; ){
		self waittill( "trigger", player );
		if(!isdefined(player.selling)) self thread SellPerk(player);
		wait(.3);
	}
}
SellPerk(player){
	if(IsSubStr(player getCurrentWeapon(),"bottle") || IsSubStr(player getCurrentWeapon(),level.sellbackweapon) || isDefined(player.selling)) return;
	player.selling = true;
	if(!player HasPerk(self.script_noteworthy) || !player useButtonPressed()){
		player.selling = undefined;
		return;
	}
	removePerk = self ProgressBars(2,player);
	if(!removePerk){
		player.selling = undefined;
		return;
	} 

	player maps\_zombiemode_score::add_to_player_score( int(self.zombie_cost/2) );
	// while(player useButtonPressed()) wait(.1);
	player perk_hud_shift(self.script_noteworthy);
	player notify(self.script_noteworthy+"_sold");
	while(player useButtonPressed()) wait(.1);
	player.selling = undefined;
	if(IsDefined( level.usemenuforhud ) && level.usemenuforhud) player notify("perk update");
	
}
ProgressBars(timer,player){
	player endon("disconnect");
	if(!isDefined(timer)) timer=3;
	constTime = timer;
	gun = player GetCurrentWeapon();
	if(WeaponType(gun) == "grenade") gun = player getWeaponsListPrimaries()[0];
	player GiveWeapon( level.sellbackweapon );
	player SwitchToWeapon( level.sellbackweapon );
	player DisableWeaponCycling();
	player DisableOffhandWeapons();
	player SetWeaponAmmoStock( level.sellbackweapon, 1 );
	player.PBar = player CreatePrimaryProgressBar();
	player.PBar.color = ( .5, 1, 1 );
	player.PBar UpdateBar( 0.01, 1/constTime );
	while(player canSeeThisEnt(self) && player hasperk(self.script_noteworthy) && player UseButtonPressed() && player IsTouching(self) && player isOnGround() && !player maps\_laststand::player_is_in_laststand() && timer>0){
		wait(.1);
		timer = timer-.1;
	}
	player TakeWeapon( level.sellbackweapon );
	player EnableWeaponCycling();
	player EnableOffhandWeapons();
	player SwitchToWeapon(gun);
	player.PBar destroyElem();
	player.PBar = undefined;
	if(timer<=0) return true;
	return false;
}

perk_hud_shift(perk){
	self endon("disconnect");
	if(isDefined(level.usemenuforhud) && level.usemenuforhud){
		number = undefined;
		for(i=0;i<self.perk_hud.size;i++){
			if(self.perk_hud[i] == level.specialties[perk]["shader"]){
				number = i;
				break;
			}
		}
		if(isDefined(number)){
			for(i=0;i<self.perk_hud.size;i++){
				if(i>=number){
					if(isDefined(self.perk_hud[i+1])){
						self.perk_hud[i] = self.perk_hud[i+1];
					}else{
						self.perk_hud[i] = undefined;
						break;
					}
				}
			}
		}
		self notify("perk update");
	}else{
		x = self.perk_hud[ perk ].x;
		// self perk_hud_destroy( perk );
		perks = GetArrayKeys(self.perk_hud);
		for(i=0;i<perks.size;i++){
			if(self.perk_hud[ perks[i]].x > x) self.perk_hud[ perks[i]].x = self.perk_hud[ perks[i]].x - 30;
		}
	}
}

FixEndGameDvars(dvar,setting){
	level waittill("end_game");
	players = get_players();//	maps\_utility.gsc:
	for(i=0;i<players.size;i++){
		players[i] setClientDvar(dvar,setting);
	}
}
