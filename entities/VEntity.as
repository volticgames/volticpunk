package volticpunk.entities {
	
	import flash.utils.Dictionary;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	import volticpunk.components.Animator;
	import volticpunk.components.CentreOnScreen;
	import volticpunk.components.Component;
	import volticpunk.components.PlatformerMovement;
	import volticpunk.components.Tweener;
	import volticpunk.util.Logger;
	import volticpunk.worlds.Room;
	
	public class VEntity extends Entity {
	
	    private var componentList:Vector.<Component>;
		private var componentLookup:Dictionary;
		
		private var firstUpdate: Boolean = false;
		
		private var shakeCountDown: Number;
		private var shakePower: Number;
		
		public var groupX: Number;
		public var groupY: Number;
		
	    public function VEntity(x:Number = 0,y:Number = 0,graphic:net.flashpunk.Graphic = null,mask:net.flashpunk.Mask = null) {
	
	        super(x, y, graphic, mask);
			
			groupX = x;
			groupY = y;
			
	        componentList = new Vector.<Component>();
			componentLookup = new Dictionary();
	
	    }
		
		protected function log(...args): void
		{
			if (Logger.enabled)
			{
				Logger.log(this + "", "[" + args.join("] [") + "]");
			}
			
		}
		
		public function getText(): Text
		{
			return graphic as Text;
		}
		
		public function getCentring(): CentreOnScreen
		{
			return getComponent(CentreOnScreen) as CentreOnScreen;
		}
		
		public function shakeImage(power: Number, duration: Number): void
		{
			shakeCountDown = duration;
			shakePower = power;
		}
		
		public function getImage(): Image
		{
			if (graphic is Image)
			{
				return graphic as Image;
			} else {
				throw new Error("Graphic type is not Image");
			}
			
		}
	
	    /**
	     * Get a component of the given type, returns null if none exist.
	     * @param type The component type
	     * @return The first component of the given type
	     */
	    public function getComponent(type:Class):Component
	    {
	        for each (var c:Component in componentList)
	        {
	            if (c is type) return ((c as type) as Component);
	        }
	
	        return null;
	    }
		
		/**
		 * Does the entitiy have a component of the given type? 
		 * @param clazz
		 * @return 
		 * 
		 */		
		public function hasComponent(clazz: Class): Boolean
		{
			for each (var c:Component in componentList)
			{
				if (c is clazz)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function lookup(name:String):Component
		{
			return this.componentLookup[name];
		}
		
		public function get room(): Room {
			return FP.world as Room;
		}
		
		public function getRoom(): Room
		{
			return room;
		}
	
	    public function addComponent(c:Component, name:String = null):Component
	    {
	        componentList.push(c);
	        c.parent = this;
	        c.added();
			
			if (name)
			{
				componentLookup[name] = c;
			} else if (c.getName() != "" && !componentLookup[c.getName()] )
			{
				componentLookup[c.getName()] = c;
			}
	
	        return c;
	    }
	
		public function getAnimator(): Animator
		{
			return ( getComponent(Animator) as Animator);
		}
		
		public function getPlatformMovement(): PlatformerMovement
		{
			return ( getComponent(PlatformerMovement)) as PlatformerMovement;
		}
		
		public function setAlpha(alpha: Number): void
		{
			getImage().alpha = alpha;
		}
		
		public function getTweener(): Tweener
		{
			var tweener: Tweener = ( getComponent(Tweener) as Tweener);
			
			if (!tweener)
			{
				return this.addComponent( new Tweener() ) as Tweener;
			} else {
				return tweener;
			}
		}
		
	    public function removeComponent(c:Component):Component
	    {
			componentList.splice(componentList.indexOf(c), 1);
	        c.removed();
	        c.parent = null;
	
	        return c;
	    }
		
		public function removeComponentByName(name:String):Component
		{
			return removeComponent(lookup(name));
		}
	
	    public function removeComponentType(type:Class):Component
	    {
	        for each (var c:Component in componentList)
	        {
	            if (c is type)
	            {
					componentList.splice(componentList.indexOf(c), 1);
	                c.removed();
	                c.parent = null;
	                return ((c as type) as Component);
	            }
	        }
	
	        return null;
	    }
		
		public function firstUpdateCycle(): void
		{
			
		}
	
	    override public function update():void
	    {
			if (!firstUpdate)
			{
				firstUpdate = true;
				firstUpdateCycle();
			}
			
	        super.update();
			
	        for each (var c:Component in componentList)
	        {
	            c.update();
	        }
	    }
		
		public function removeFromWorld(): VEntity
		{
			if (world != null) world.remove(this);
			return this;
		}
	
	    override public function added():void
	    {
	        super.added();
	
	        for each (var c:Component in componentList)
	        {
	            c.addedToWorld();
	        }
			
			firstUpdate = false;
	    }
	
	    override public function removed():void
	    {
	        super.removed();
	
	        for each (var c:Component in componentList)
	        {
	            c.removedFromWorld();
	        }
	    }
	
	    /**
	     * Set the origin of the Entity and its Image in one go.
	     * @param x
	     * @param y
	     *
	     */
	    public function setBothOrigin(x:Number, y:Number):void
	    {
	        originX = x;
	        originY = y;
	        (graphic as Image).originX = x;
	        (graphic as Image).originY = y;
	    }
	}
}
