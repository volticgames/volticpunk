package volticpunk.worlds
{
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import assets.A;
	
	import components.player.PlayerAnimationController;
	
	import cutscenes.Cutscene;
	import entities.Delayer;
	import entities.DemoWalker;
	import entities.DistantBackground;
	import entities.Floaty;
	import entities.Interactable;
	import entities.RoomManager;
	import entities.chargable.Chargable;
	import entities.environment.Grappleable;
	import entities.lighting.FullscreenFlash;
	import entities.lighting.Light;
	import entities.loadable.ChargeStation;
	import entities.loadable.Door;
	import entities.loadable.HouseDoor;
	import entities.loadable.NPC;
	import entities.loadable.Player;
	import entities.menu.CutsceneBars;
	import entities.menu.Dialogue;
	import entities.menu.Notification;
	import entities.particles.Flash;
	
	import menus.ItemMenu;
	import menus.NoteMenu;
	import menus.PauseMenu;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Data;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	import util.SaveUtil;
	
	import volticpunk.components.PlatformerMovement;
	import volticpunk.entity.Camera;
	import volticpunk.entity.Group;
	import volticpunk.entity.VEntity;
	import volticpunk.util.Choose;
	
	import worlds.Menu;
	import worlds.util.CutsceneLookup;
	import worlds.util.TileLoader;
	
	public class Room extends OgmoLevelLoader
	{
		public var player:Player = null;
		public var lights:Group;
		public var doors:Group;
		public var houseFrontLights:Group;
		public var insideHouse:Group;
		
		private var demo:DemoWalker;
		
		private var notification:Notification;
		
		public var pauseMenu:PauseMenu;
		public var itemMenu:ItemMenu;
		public var noteMenu:NoteMenu;
		public var cutsceneBars:CutsceneBars;
		public var dialogue:Dialogue;
		
		public var cam:Camera;
		
		private var currentCutscene:Cutscene = null;
		
		private var toLoad:String;
		private var toLoadOptions:Object;
		private var toLoadCutscene: String = null;
		private var toLoadFadeIn: Boolean = true;
		
		private var shouldFadeIn:Boolean = true;
		private var fadeEnt:Entity;
		private var fadeImage:Image;
		private var fadeTween:VarTween;
		
		private var loadOptions:Object;
		
		private var streamLevels:Boolean;
		private var mapName:String;
		
		private var ambientTrack:Sfx;
		
		private var npcs:Object = {};
		
		private var initialCutscene: String = null;
		
		private var timer:Timer;
		
		private var levelOptionsLoaded: Boolean = false;
		
		private var blurFilter: BlurFilter;
		private var blurTween: MultiVarTween;
		private var blurEnabled: Boolean = false;
		
		public function Room(mapName:String, fadeIn:Boolean=true, options:Object=null, cutscene: String = null)
		{
			super();
			toLoad = mapName;
			shouldFadeIn = fadeIn;
			this.streamLevels = Main.STREAM_LEVELS;
			this.mapName = mapName;
			
			this.loadOptions = options;
			doors = new Group(0, 0);
			
			var track:Array = Choose.choose([A.AmbientrumbleSound, 0.05], [A.CavewindSound, 0.5]);
			ambientTrack = track[0];
			track[0].loop(track[1]);
			
			if (cutscene)
			{
				initialCutscene = cutscene;
			}	
			
			blurFilter = new BlurFilter(0, 0);
			blurTween = new MultiVarTween();
		}
		
		public function enableBlur():void
		{
			updateBlur();
			blurEnabled = true;
		}
		
		public function updateBlur(): void
		{
			FP.engine.getChildAt(0).filters = [blurFilter];
		}
		
		public function disableBlur():void
		{
			FP.engine.getChildAt(0).filters = [];
			blurEnabled = false;
		}
		
		public function configureBlur(radius: Number): void
		{
			blurFilter.blurX = radius;
			blurFilter.blurY = radius;
		}
		
		public function tweenBlur(to: Number, duration: Number): void
		{
			blurTween.tween(blurFilter, {blurX: to, blurY: to}, duration, Ease.quadIn);
		}
		
		public function flashWhite(): void
		{
			add( new FullscreenFlash() );
		}
		
		public function getLoadedMap(): String
		{
			return toLoad;
		}
		
		public function getCurrentScene(): Cutscene
		{
			return currentCutscene;
		}
		
		override public function end(): void
		{
			super.end ();
		}
		
		public function activateDemoMode():void
		{
			add(demo = new DemoWalker(200, 200));
		}
		
		public function stopDemoMode():void
		{
			remove(demo);
			cam.follow(player);
		}
		
		public function showNotification(message:String):void
		{
			add(new Notification(message));
		}
		
		public function addNpc(name:String, npc:NPC):void
		{
			npcs[name] = npc;	
		}
		
		public function removeNpc(name:String):NPC
		{
			var npc:NPC = npcs[name];
			npcs[name] = null;
			
			return npc;
		}
		
		public function getNpc(name:String):NPC
		{
			return npcs[name];
		}
		
		public function getMapName():String
		{
			return mapName;
		}
		
		override public function begin():void
		{
			super.begin();
			
			add(new RoomManager());
			
			fadeImage = new Image(new BitmapData(Main.WIDTH, Main.HEIGHT, false, 0xFF000000));
			fadeImage.scrollX = fadeImage.scrollY = 0;
			fadeImage.alpha = 1;
			fadeEnt = new Entity(0, 0, fadeImage);
			fadeEnt.layer = -20;
			
			log("Level began");
			
			loadLevel(toLoad, streamLevels);
			
			var distant:DistantBackground = new DistantBackground(0, 0, this.levelWidth, this.levelHeight, area, cliffBackground, skyBackground);
			add(distant);
			distant.layer = C.LAYER_BACKGROUND + 100;
			
			addTween(blurTween);
			
			initDebugDisplay();
			SaveUtil.saveGame();
			
		}
		
		private function initDebugDisplay(): void
		{
			var h: HudText = new HudText(mapName);
			
			h.scrollX = 0;
			h.scrollY = 0;
			
			var e: Entity = addGraphic(h, C.LAYER_MENU, 480, 5);
		}
		
		/**
		 * Load an ogmo editor level, NOTE: add more layer loading here! 
		 * @param map Which map to load
		 */
		public function loadLevel(map:String, liveLoad:Boolean=false):void
		{
			var xml:XML;
			
			log("Map to load: " + map);
			
			if (!liveLoad)
			{
				var c:Class = A.LEVELS[map];
				var bytes:ByteArray = new c();
				xml = new XML(bytes.readUTFBytes(bytes.length));
				setUpLevel(xml);
				ready();
			} else {
				
				log("Loading file: " + "assets/Levels/" + map + ".oel");
				var loader:URLLoader = new URLLoader(new URLRequest("assets/Levels/" + map + ".oel"));
				loader.addEventListener(Event.COMPLETE, loadingLevelComplete);
			}
			
		}
		
		private function setUpLevel(xml:XML):void
		{
			levelWidth = xml.@width;
			levelHeight = xml.@height;
			area =  xml.@Area;
			cliffBackground =  xml.@CliffBackground == "True";
			skyBackground =  xml.@SkyBackground == "True";
			tileLoader = new TileLoader(xml);
			add(tileLoader);
			fileLoaded = true;
		}
		
		
		private function loadingLevelComplete(e:Event):void
		{
			var xml:XML = new XML(e.target.data);
			fileLoaded = true;
			
			setUpLevel(xml);
			ready();
		}
		
		
		protected function ready():void
		{
			
			if (shouldFadeIn) fadeInLevel();
			
			lights = new Group(0,0);
			add(lights);
			
			houseFrontLights = new Group(0, 0);
			insideHouse = new Group(0, 0);
			
			pauseMenu = new PauseMenu();
			itemMenu = new ItemMenu();
			noteMenu = new NoteMenu();
			cutsceneBars = new CutsceneBars();
			dialogue = new Dialogue();
			
			add(cutsceneBars);
			add(dialogue);
			
			cam = new Camera(0, 0, this);
			add(cam);
			
			//Initial item counts for testing
			Data.writeInt("boot_count", 1);
			Data.writeInt("key_count", 99);
			Data.writeInt("shield_count", 1);
			Data.writeInt("match_count", 99);
			Data.writeInt("piston_count", 1);
			Data.writeInt("hook_count", 99);
			Data.writeInt("rope_count", 99);
			Data.writeInt("cell_count", 1);
			
			itemMenu.load();
			noteMenu.load();
			
		}
		
		public function save():void
		{
			Data.writeString("current_room", mapName);
			
			noteMenu.save();
		}
		
		public function load(): void
		{
			noteMenu.load();
		}
		
		/**
		 * Flicker the lights for one frame in the room. 
		 * 
		 */		
		public function flickerLights():void
		{
			Light.lightAlpha = 0.7;
		}
		
		/**
		 * Fade the level in from black, DO NOT CALL BEFORE FADING IN OR OUT HAS FINISHED. 
		 * 
		 */		
		public function fadeInLevel():void
		{
			fadeImage.alpha = 1;
			if (fadeEnt.world == null) add(fadeEnt);
			fadeTween = new VarTween(finishedFadeIn);
			addTween(fadeTween);
			fadeTween.tween(fadeImage, "alpha", 0, C.FADE_TWEEN);
		}
		
		public function isFading():Boolean
		{
			if (fadeTween != null)
			{
				return fadeTween.active;
			} else {
				return false; 
			}
		}
		
		private function finishedFadeIn():void
		{
			remove(fadeEnt);
			removeTween(fadeTween);
			fadeTween = null;
		}
		
		/**
		 * Change the map using a fade out transition, DO NOT CALL BEFORE FADING IN OR OUT HAS FINISHED. 
		 * @param map
		 * 
		 */		
		public function fadeOutLevel(map:String=null, options:Object=null, cutscene: String = null, fadeIn: Boolean = true):void
		{
			fadeImage.alpha = 0;
			add(fadeEnt);
			fadeTween = new VarTween(finishedFadeOut);
			addTween(fadeTween);
			fadeTween.tween(fadeImage, "alpha", 1, C.FADE_TWEEN);
			
			toLoad = map;
			toLoadOptions = options;
			toLoadCutscene = cutscene;
			toLoadFadeIn = fadeIn;
		}
		
		/**
		 * Ensure we can't add a null reference to the world.
		 * @param e Entity
		 * @return The added entity or null
		 */
		override public function add(e:Entity):Entity
		{
			if (e == null) return null;
			return super.add(e);
		}
		
		private function finishedFadeOut():void
		{
			if (fadeTween) removeTween(fadeTween);
			fadeTween = null;
			if (toLoad != null) changeMap(toLoad, toLoadFadeIn, toLoadOptions, toLoadCutscene);
		}
		
		/**
		 * Change the currently loaded map. 
		 * @param map New level to load.
		 * 
		 */		
		public function changeMap(mapName: String, shouldFadeIn: Boolean = true, options: Object = null, cutscene: String = null):void
		{
			var r:Room = new Room(mapName, shouldFadeIn, options, cutscene);
			FP.world = r;
			
			ambientTrack.stop();
		}
		
		/**
		 * Load the supplied options for the map
		 */
		public function loadLevelOptions():void
		{
			
			if (loadOptions == null)
			{
				initCameraOnPlayer();
				return;
			}
			
			log("Loading level options:");
			
			for (var key:String in loadOptions)
			{
				log(key + " : " + loadOptions[key]);
			}
			
			//If we had a specified coordinate
			if ("player_pos_x" in loadOptions)
			{
				
				player.x = loadOptions["player_pos_x"];
				player.y = loadOptions["player_pos_y"];
				
				log("Moved player to " + player.x + " " + player.y);
				
				if (!loadOptions["player_facing_right"])
				{
					player.faceLeft();
					player.x -= C.DOOR_OFFSET_AMOUNT;
					player.x -= 12;
				} else {
					player.x += 12 + C.DOOR_OFFSET_AMOUNT;
				}
				
				//Otherwise search for a door leading to the previous level
			} else {
				for each( var door:Door in doors.getMembers())
				{
					log(door.getMapName());
					if (door.getMapName() == loadOptions["old_map_name"])
					{
						player.x = door.x;
						player.y = door.y + Door.DOOR_HEIGHT;
						log("Moved player to " + player.x + " " + player.y);
						
						player.y = door.y + Door.DOOR_HEIGHT - Player.FRAMEHEIGHT;
						
						log("Put player " + player.x + " " + player.y);
						
						if (!loadOptions["player_facing_right"])
						{
							player.faceLeft();
							player.x -= C.DOOR_OFFSET_AMOUNT;
							player.x -= 12;
							log("hm");
						} else {
							player.x += 12 + C.DOOR_OFFSET_AMOUNT;
							
						}
						
					}
				}
				
			}
			
			player.getPlatformMovement().resetFallDistance();
			initCameraOnPlayer();
		}
		
		private function initCameraOnPlayer(): void
		{
			cam.snapTo(player.x, player.y);
			cam.follow(player);
			log("Snapped camera to: " + cam.x + ", " + cam.y);
		}
		
		override public function update():void
		{
			super.update();
			
			if (player)
			{
				var move:PlatformerMovement = player.lookup("move") as PlatformerMovement;
				var anim:PlayerAnimationController = player.lookup("anim") as PlayerAnimationController;
			}
			
			if (!fileLoaded) return;
			
			if (blurEnabled)
			{
				updateBlur();
			}
			
			
			if (Input.mousePressed)
			{
				log(FP.camera.x + Input.mouseX, FP.camera.y + Input.mouseY, "(" + int((FP.camera.x + Input.mouseX)/32)*32, int((FP.camera.y + Input.mouseY)/32)*32 + ")");
				//add(new RandomLight(Math.round((FP.camera.x + Input.mouseX) / 32) * 32, Math.round((FP.camera.y + Input.mouseY) / 32) * 32));
				//add(new Fire((FP.camera.x + Input.mouseX), (FP.camera.y + Input.mouseY)));
				
				player.x = FP.camera.x + Input.mouseX;
				player.y = FP.camera.y + Input.mouseY;
			}
			
			//Get player ref
			if (player == null)
			{
				player = getInstance("Player");
				cam.follow(player);
				itemMenu.evaluateItemCombintion();
				
			} else if (!levelOptionsLoaded)
			{
				loadLevelOptions();
				levelOptionsLoaded = true;
				
				if (C.levelBegin[toLoad])
				{
					C.levelBegin[toLoad]();
				}
				itemMenu.evaluateItemCombintion();
			}
			
			if (initialCutscene)
			{
				startCutscene(CutsceneLookup.scenes[initialCutscene]);
				initialCutscene = null;
			}
			
			if (currentCutscene != null) currentCutscene.update();
			
			
			if (Input.pressed(Key.DIGIT_1))
			{
				A.MusicArea1Short1Sound.play();
			}
			
			if (Input.pressed(Key.DIGIT_2))
			{
				A.MusicArea1Short2Sound.play();
			}
			
			if (Input.pressed(Key.DIGIT_3))
			{
				A.MusicArea1Short3Sound.play();
			}
			
			if (Input.pressed(Key.DIGIT_4))
			{
				A.MusicArea1Short4Sound.play();
			}
			
			if (Input.pressed(Key.DIGIT_5))
			{
				A.MusicArea1Short5Sound.play();
			}
			
			if (Input.pressed(Key.DIGIT_6))
			{
				A.MusicArea1Short6Sound.play();
			}
			
			if (!player.ignoreControls)
			{
				
				if (Input.pressed(Key.R) && !(FP.world is Menu))
				{
					changeMap(mapName, true, loadOptions);
				}
				
				
				//if (Input.pressed(Key.SHIFT)) startCutscene(new TestScene());
				
				//Pause Menu test
				if (Input.pressed(Key.ENTER))
				{
					if (!pauseMenu.isAdded)
					{
						add(pauseMenu);
						if (player) move.freezeMovement = true;
					}
					else
					{
						pauseMenu.removeGroup();
						if (player) move.freezeMovement = false;
					}
				}
			}
			
			//Note Menu test
			if (Input.pressed(Key.N) && !(FP.world is Menu) && NoteMenu.enabled)
			{
				toggleNoteMenu();
			}
			
			//Item Menu test
			if (Input.pressed(Key.I) && !(FP.world is Menu) && ItemMenu.enabled)
			{
				toggleItemMenu();
			}
		}
		
		public function toggleHouseFronts():void
		{
			if (!HouseDoor.insideHouse)
			{
				hideHouseFronts();
			} else {
				showHouseFronts();
			}
		}
		
		public function hideHouseFronts():void
		{
			var tween:VarTween = new VarTween( function():void { FP.world.removeTween(tween); });
			addTween(tween);
			tween.tween( (tileLoader as TileLoader).houseFront.graphic, "alpha", 0, 0.2);
			
			HouseDoor.insideHouse = true;
			
			FP.console.log(houseFrontLights.size());
			
			for each (var e:Entity in houseFrontLights.getMembers())
			{
				remove(e);
			}
			
			for each (e in insideHouse.getMembers())
			{
				add(e);
			}
			
			remove(houseFrontLights);
			add(insideHouse);
		}
		
		public function showHouseFronts():void
		{
			var tween:VarTween = new VarTween( function():void { FP.world.removeTween(tween); });
			addTween(tween);
			tween.tween( (tileLoader as TileLoader).houseFront.graphic, "alpha", 1, 0.2);
			
			HouseDoor.insideHouse = false;
			
			for each (var e:Entity in houseFrontLights.getMembers())
			{
				add(e);
			}
			
			for each (e in insideHouse.getMembers())
			{
				remove(e);
			}
			
			add(houseFrontLights);
			remove(insideHouse);
		}
		
		public function beginOpenNoteMenu():void
		{
			( player.lookup("anim") as PlayerAnimationController ).play("Rummaging");
			add(new Delayer(1, function():void { openNoteMenu(); } ));
			if (player) ( player.lookup("move") as PlatformerMovement ).freezeMovement = true;
			if (player) player.ignoreControls = true;
		}
		
		public function openNoteMenu():void
		{
			var move:PlatformerMovement = player.lookup("move") as PlatformerMovement;
			
			add(noteMenu);
			if (player) move.freezeMovement = true;
			if (player) player.ignoreControls = true;
		}
		
		public function closeNoteMenu():void
		{
			var move:PlatformerMovement = player.lookup("move") as PlatformerMovement;
			var anim:PlayerAnimationController = player.lookup("anim") as PlayerAnimationController;
			
			noteMenu.removeGroup();
			if (player) move.freezeMovement = false;
			if (player) player.ignoreControls = false;
			anim.play("Stopped")
		}
		
		public function toggleNoteMenu():void
		{
			if (!noteMenu.isAdded)
			{
				beginOpenNoteMenu();
			}
			else
			{
				closeNoteMenu();
			}
		}
		
		public function openItemMenu():void
		{
			var move:PlatformerMovement = player.lookup("move") as PlatformerMovement;
			
			add(itemMenu);
			if (player) move.freezeMovement = true;
			if (player) player.ignoreControls = true;
		}
		
		public function closeItemMenu():void
		{
			var move:PlatformerMovement = player.lookup("move") as PlatformerMovement;
			
			itemMenu.removeGroup();
			if (player) move.freezeMovement = false;
			if (player) player.ignoreControls = false;
		}
		
		public function toggleItemMenu():void
		{
			if (!itemMenu.isAdded)
			{
				openItemMenu();
			}
			else
			{
				closeItemMenu();
			}
		}
		
		/**
		 * Reset the current room. 
		 * 
		 */		
		public function reset():void {
			changeMap(mapName, true, loadOptions);
		}
		
		/**
		 * Begin a cutscene. 
		 * @param scene
		 * 
		 */		
		public function startCutscene(scene:Cutscene, freezePlayer:Boolean=false):void
		{
			log(scene);
			currentCutscene = scene;
			scene.start(this, freezePlayer);
		}
		
		/**
		 * Notify the room of a cutscene ending. 
		 * 
		 */		
		public function endCutscene(save: Boolean = true):void
		{
			currentCutscene.finish(this);
			currentCutscene = null;
			
			if (save) SaveUtil.saveGame();
		}
		
		public function inCutscene(): Boolean
		{
			return (currentCutscene != null);
		}
		
		public function getMembersByType(type: String): Group
		{
			var members:Array = new Array();
			
			this.getType(type, members);
			
			var group:Group = new Group(0, 0);
			group.addAll (members);
			
			return group;
		}
		
		public function getMembersByClass(c: Class): Group
		{
			var members:Array = new Array();
			
			this.getClass(c, members);
			
			var group:Group = new Group(0, 0);
			group.addAll (members);
			
			return group;
		}
		
		public function getMembersByComponent(c: Class): Group
		{
			var members:Array = new Array();
			
			this.getAll(members);
			
			var group:Group = new Group(0, 0);
			
			for each (var e: Entity in members)
			{
				if (e is VEntity)
				{
					var v: VEntity = e as VEntity;
					
					if (v.hasComponent(c))
					{
						group.add(v);
					}
				}
			}
			
			return group;
		}
		
		public function getChargableObjectByIdCode(id: String): Chargable
		{
			var g: Group = getMembersByClass(Chargable);
			
			for each (var c: Chargable in g.getMembers())
			{
				if (c.getIdCode() == id)
				{
					return c;
				}
			}
			
			return null;
		}
		
		public function getAllChargableObjectsByIdCode(id: String): Group
		{
			var g: Group = getMembersByClass(Chargable);
			var ret: Group = new Group(0, 0);
			
			for each (var c: Chargable in g.getMembers())
			{
				if (c.getIdCode() == id)
				{
					ret.add(c as Entity);
				}
			}
			
			return ret;
		}
		
		public function getAllChargeStationsById(id: String): Group
		{
			var g: Group = getMembersByClass(ChargeStation);
			var ret: Group = new Group(0, 0);
			
			for each (var c: Chargable in g.getMembers())
			{
				if (c.getIdCode() == id)
				{
					ret.add(c as Entity);
				}
			}
			
			return ret;
		}
		
		/**
		 * Make all the interactable objects in the scene glow 
		 */
		public function makeInteractableEntitiesFlash(): void
		{
			
			var interactable: Group = V.getRoom().getMembersByClass(Interactable);
			
			for each (var e: Entity in interactable.getMembers())
			{
				var eX: Number, eY: Number;
				
				if (e is Grappleable)
				{
					var p: Grappleable = e as Grappleable;
					eX = e.x + p.getRopeTargetPoint().x;
					eY = e.y + p.getRopeTargetPoint().y;
				} else {
					var i: Interactable = e as Interactable;
					eX = i.getFlashPoint().x;
					eY = i.getFlashPoint().y;
				}
				
				(V.getRoom().create(Floaty, true) as Floaty).init(eX, eY);
				V.getRoom().add(new Flash(eX, eY, 1.5, A.FloorGlow)); 
			}
		}
		
	}
}