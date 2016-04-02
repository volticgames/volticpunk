package volticpunk.entities
{
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	
	import volticpunk.util.Constrain;
	import volticpunk.util.Diff;
	
	/**
	 * Camera class for the controlling the viewport. 
	 * @author bfollington
	 * 
	 */	
	public class Camera extends VEntity
	{
		
		private var target:Point;
		private var offset:Point;
		private var following:Entity;
		public var panning:Boolean = false;
		
		private var speed:Number = 10.0;
		
		private var panner:MultiVarTween;
		private var panCallback:Function = null;
		
		private var shake:Point;
		private var shaking:Boolean;
		public var shakePower:Number = 0;
		private var shakeDuration:Number = 0;
		private var shakeLengthSoFar:Number = 0;
		
		private var shakeTween: VarTween;
		
		public var amountMovedLastFrame: Point;
		
		public function Camera(x:Number=0, y:Number=0)
		{
			super(x, y, null, null);
			target = new Point(x, y);
			offset = new Point(0, 0);
			shake = new Point(0, 0);
			
			panner = new MultiVarTween(panComplete);
			amountMovedLastFrame = new Point(0, 0);
			shakeTween = new VarTween();
		}
		
		override public function added():void
		{
			super.added();
			addTween(panner);
			addTween(shakeTween);
		}
		
		override public function removed():void
		{
			super.removed();
			removeTween(panner);
			removeTween(shakeTween);
		}
		
		override public function update():void
		{
			var old: Point = new Point(FP.camera.x, FP.camera.y);
			
			super.update();
			
			//If not following an entity
			if (!panning)
			{
				if (following == null)
				{
					if (Diff.diff(this.x, target.x) >= 0.1) this.x -= (this.x - (target.x - C.WIDTH/2))/speed;
					if (Diff.diff(this.y, target.y) >= 0.1) this.y -= (this.y - (target.y - C.HEIGHT/2))/speed;
				} else {
					if (Diff.diff(this.x, following.x) >= 0.1) this.x -= (this.x - (following.x - C.WIDTH/2) + offset.x)/speed;
					if (Diff.diff(this.y, following.y) >= 0.1) this.y -= (this.y - (following.y - C.HEIGHT/2) + offset.y)/speed;
					
					x = Math.round(x);
					y = Math.round(y);
					
					target.x = following.x;
					target.y = following.y;
				}
			} else {

			}
			
			shake.x = Math.random()*shakePower;
			shake.y = Math.random()*shakePower;
			
			if (shakePower > 0)
			{
				
				shakeLengthSoFar += FP.elapsed;
				
				if (shakeLengthSoFar > shakeDuration && shaking)
				{
					shaking = false;
					shakeLengthSoFar = 0;
					shakeDuration = 0;
					shakeTween.tween(this, "shakePower", 0, 0.5);
				}
			}
			
			var extraX: Number = 0;
			var extraY: Number = 0;
			
			setPositionWithConstraints(Math.round(this.x), Math.round(this.y), shake.x, shake.y);
		
		
			amountMovedLastFrame = FP.camera.subtract( old );
			
		}
		
		/**
		 * Positions the camera without it leaving the bounds of the level. 
		 * @param x
		 * @param y
		 * 
		 */		
		private function setPositionWithConstraints(x: Number, y: Number, extraX: Number, extraY: Number): void
		{
			FP.camera.x = Constrain.constrain(x, 0, room.levelWidth - C.WIDTH) + extraX;
			FP.camera.y = Constrain.constrain(y, 0, room.levelHeight - C.HEIGHT) + extraY;
			
		}
		
		/**
		 * Trigger a screenshake 
		 * @param power in pixels
		 * @param duration in seconds
		 * 
		 */		
		public function screenshake(power:Number, duration:Number):void
		{
			if (power < 1) {
				power = 0;
			}
			
			shaking = true;
			shakeTween.tween(this, "shakePower", power, 0.5);
			shakeDuration = duration;
			shakeLengthSoFar = 0;
			shake.x = Math.random()*power;
			shake.y = Math.random()*power;
		}
		
		/**
		 * Is the camera currently shaking? 
		 * @return 
		 * 
		 */		
		public function isShaking(): Boolean
		{
			return shaking;
		}
		
		/**
		 * Get the current shake offset from the camera. 
		 * @return 
		 * 
		 */		
		public function getShakeOffset(): Point
		{
			return shake.clone();
		}
		
		/**
		 * Callback for a completed pan. 
		 * 
		 */		
		private function panComplete():void
		{
			panning = false;
			if (panCallback != null) panCallback();
			log("Pan Complete");
		}
		
		/**
		 * Pan the camera to focus on an Entity. 
		 * @param duration In seconds
		 * @param e Target Entity
		 * 
		 */		
		public function panToEntity(duration:Number, e:Entity, offsetx:Number=0, offsety:Number=0, callback:Function=null):void
		{
			panTo(duration, e.x + offsetx, e.y + offsety, callback);
		}
		
		/**
		 * Pan the camera to focus on a Point. 
		 * @param duration In seconds
		 * @param p Target Point
		 * 
		 */		
		public function panToPoint(duration:Number, p:Point, callback:Function=null):void
		{
			panTo(duration, p.x, p.y, callback);
		}
		
		/**
		 * Pan the camera to focus on specific coordinates. 
		 * @param duration In seconds
		 * @param destx Target X
		 * @param desty Target Y
		 * 
		 */		
		public function panTo(duration:Number, destx:Number, desty:Number, callback:Function=null, ease: Function = null):void
		{
			panCallback = callback;
			panner.tween(this, {x:destx - C.WIDTH/2, y:desty - C.HEIGHT/2}, duration, ease);
			following = null;
			target.x = destx;
			target.y = desty;
			panning = true;
		}
		
		/**
		 * Set the camera to follow and entity as it moves. 
		 * @param e
		 * 
		 */		
		public function follow(e:Entity):void
		{
			log("Follow " + e);
			following = e;
		}
		
		/**
		 * Set the camera target. 
		 * @param x X Coord
		 * @param y Y Coord
		 * 
		 */		
		public function setTarget(x:Number, y:Number):void
		{
			target = new Point(x, y);
			following = null;
		}
		
		/**
		 * Set the camera target. 
		 * @param p Point to look at.
		 * 
		 */		
		public function setTargetPoint(p:Point):void
		{
			target = p;
			following = null;
		}
		
		/**
		 * Snap the camera to a specific Point. 
		 * @param p
		 * 
		 */		
		public function snapToPoint(p:Point):void
		{
			snapTo(p.x, p.y);
		}
		
		/**
		 * Snap the camera to a specific Entity. 
		 * @param e 
		 * 
		 */		
		public function snapToEntity(e:Entity):void
		{
			snapTo(e.x, e.y);
		}
		
		/**
		 * Snap the camera to specific coordinates. 
		 * @param x Target X
		 * @param y Target Y
		 * 
		 */		
		public function snapTo(x:Number, y:Number):void
		{
			log("Told to snap to:", x, y);
			this.x = x - C.WIDTH/2;
			this.y = y - C.HEIGHT/2;
			setPositionWithConstraints(this.x, this.y, 0, 0);
			target.x = this.x;
			target.y = this.y;
			following = null;
		}
		
		/**
		 * No units, just experiment. 
		 * @param s Speed
		 * 
		 */		
		public function setSpeed(s:Number):void
		{
			speed = s*1.0;
		}
		
		/**
		 * Set the following offset. 
		 * @param x
		 * @param y
		 * 
		 */		
		public function setOffset(x:Number, y:Number):void
		{
			offset = new Point(x, y);
		}
	}
}