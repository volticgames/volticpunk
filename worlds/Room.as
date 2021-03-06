package volticpunk.worlds
{
	import flash.geom.Point;

	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;

	import volticpunk.entities.Camera;
	import volticpunk.entities.Group;
	import volticpunk.entities.VEntity;
	
	public class Room extends OverlayedWorld
	{		
		public var cam:Camera;
		
		protected var nextRoom: Room;
		
		protected var shouldFadeIn:Boolean = true;
		protected var fadeEnt:Entity;
		protected var fadeImage:Image;
		protected var fadeTween:VarTween;
		
		private var events: Object = {};
		
		public function Room(fadeIn:Boolean=true)
		{
			super();
			shouldFadeIn = fadeIn;
		}
		
		public function subscribe(event: String, callback: Function): void {
			if (events[event] === undefined) {
				events[event] = [];
			}
			
			events[event].push(callback);
		}
		
		public function dispatch(event: String, ...params): void {
			if (events[event] !== undefined) {
				for each (var cb: Function in events[event]) {
					cb.apply(null, params);
				}
			}
		}
		
		override public function end(): void
		{
			super.end ();
		}
		
		override public function begin():void
		{
			super.begin();
			
			cam = new Camera(0, 0);
			add(cam);
		}
		
		public function save():void
		{
			
		}
		
		public function load(): void
		{
			
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
		public function fadeOutRoom(room: Room = null):void
		{
			fadeImage.alpha = 0;
			add(fadeEnt);
			fadeTween = new VarTween(finishedFadeOut);
			addTween(fadeTween);
			fadeTween.tween(fadeImage, "alpha", 1, C.FADE_TWEEN);
			
			nextRoom = room;
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
			
			if (nextRoom != null)
			{
				changeRoom(nextRoom);
			}
		}
		
		/**
		 * Change the currently loaded map. 
		 * @param map New level to load.
		 * 
		 */		
		public function changeRoom(room: Room):void
		{
			var oldWorld: World = FP.world;
			oldWorld.removeAll();
			FP.world = room;
		}

		public function getMembersByTypes(...types): Group {
			var members:Array = new Array();

			for each (var type: String in types) {
				this.getType(type, members);
			}

			var group:Group = new Group(0, 0);
			group.addAll (members);

			return group;
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
		
		public function getInstanceByClass(c: Class): Entity {
			var members:Array = new Array();
			
			this.getClass(c, members);
			
			return members[0];
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
		
	}
}