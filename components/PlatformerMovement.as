package volticpunk.components
{
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	public class PlatformerMovement extends Component
	{
		/** Movement toggle */
		public var freezeMovement:Boolean = false;
		
		/** Current Speed */
		public var velocity:Point;
		public var tempVelocity:Point;
		
		/** Set acceleration */
		public var acceleration:Point;
		
		/** Set decelleration */
		public var friction:Point;
		
		/** Limit velocities */
		public var maxSpeed:Point;

        /** Counts pixels moved in both directions, needs to be reset by subclasses */
        public var movedAmount:Point = new Point(0, 0);

		/** Is entity standing on the ground? */
		public var onGround:Boolean = true;
		private var lastOnGround:Boolean = true;

        private var landingCallback:Function;
        private var wallCallback:Function;
		
		/** The types this component checks collisions with */
		private var collisionTypes:Array;
		
		private var startedFallingY: Number = -1;
		
		private var adaptToTimeDelta: Boolean;
		
		private var againstWall: Boolean = false;
		
		public function PlatformerMovement(acceleration:Point=null, friction:Point=null, maxSpeed:Point=null, adaptToTimeDelta: Boolean = true)
		{
			//Initialise
            this.velocity = new Point(0, 0);
			this.acceleration = (acceleration == null) ? new Point(0, 0.2) : acceleration;
			tempVelocity = new Point(0, 0);
            this.friction = (friction == null) ? new Point(1.15, 1) : friction;
            this.maxSpeed = (maxSpeed == null) ? new Point(5, 5) : maxSpeed;
			this.adaptToTimeDelta = adaptToTimeDelta;
			
			this.collisionTypes = C.COLLISION_TYPES;
		}
		
		public function setXVelocityWhileCheckingForCollisions(velocity: Number): void
		{	
			var dir: Number = velocity / Math.abs(velocity);
			
			if (!parent.collideTypes(collisionTypes, parent.x + dir * C.GRID, parent.y))
			{
				this.velocity.x = velocity;	
			}
		}
		
		public function collide(x: Number, y: Number): Entity
		{
			return parent.collideTypes(collisionTypes, x, y);
		}
		
		/**
		 * Sets the collision types for this component, does a shallow copy. 
		 * @param types
		 * 
		 */		
		public function setCollisionTypes(types:Array):void
		{
			this.collisionTypes = types.slice();
		}
		
		public function getCollisionTypes():Array
		{
			return this.collisionTypes.slice();
		}
		
		private function collisionBottom():Boolean
		{
			onGround = false;
			
			var specialCollisionTypes: Array = collisionTypes.slice();
			specialCollisionTypes.push("jump_through");
			
			if (parent.collideTypes(specialCollisionTypes, parent.x, parent.y + 1))
			{
				onGround = true;
				return true;
			}
			
			return false;
		}

        public function setLandingCallback(f:Function):void
        {
            landingCallback = f;
        }

		public function setWallCallback(f:Function):void
		{
			wallCallback = f;
		}
		
		/**
		 * Handle the actual interpolation using velocity etc. of the object. 
		 * 
		 */		
		private function moveObject():void
		{
			if (adaptToTimeDelta)
			{
				tempVelocity.x += Math.abs(velocity.x * (FP.elapsed / (1.0/60.0)));
				tempVelocity.y += Math.abs(velocity.y * (FP.elapsed / (1.0/60.0)));	
			} else {
				tempVelocity.x += Math.abs(velocity.x);
				tempVelocity.y += Math.abs(velocity.y);
			}

			var horizontalDirection:int;
			var verticalDirection:int;
			
			if (velocity.x > 0) horizontalDirection = 1;
			else				horizontalDirection = -1;
			
			if (velocity.y > 0) verticalDirection = 1;
			else				verticalDirection = -1;
						
			while (tempVelocity.y >= 1)
			{
				moveY(verticalDirection);
				tempVelocity.y--;
			}
			
			while (tempVelocity.x >= 1)
			{
				if (moveX(horizontalDirection))
				{
					tempVelocity.x--;
				} else {
					break;
				}
				
			}
			
		}
		
		/**
		 * Move the object 1px horizontally safely 
		 * 
		 */		
		public function moveX(dir:int): Boolean
		{
			var specialCollisionTypes: Array = collisionTypes.slice();
			
			specialCollisionTypes.push("jump_through");

			againstWall = false;
			
            movedAmount.x += 1;
            if (!parent.collideTypes(specialCollisionTypes, parent.x + dir, parent.y))
			{
				if (!parent.collideTypes(specialCollisionTypes, parent.x + dir, parent.y + 1) && parent.collideTypes(specialCollisionTypes, parent.x, parent.y + 1))
				{
					parent.y++;
				}
				
                parent.x += dir;
			}
			//Slope check case 
			else if (!parent.collideTypes(specialCollisionTypes, parent.x + dir, parent.y - 1) && parent.collideTypes(specialCollisionTypes, parent.x, parent.y + 1))
			{
                parent.x += dir;
                parent.y--;
			} else {
				hitWall();
				return false;
			}
			
			return true;

		}
		
		private function hitWall(): void
		{
			tempVelocity.x = 0;
			velocity.x = 0;
			if (wallCallback != null) wallCallback();
			againstWall = true;
		}

        /**
         * Move the object 1px vertically safely
         *
         */
        public function moveY(dir:int):void
		{
			var specialCollisionTypes: Array = collisionTypes.slice();
			
			if (dir > 0)
			{
				specialCollisionTypes.push("jump_through");
			}
			
            movedAmount.y += 1;
			if (!parent.collideTypes(specialCollisionTypes, parent.x, parent.y + dir))
			{
                parent.y += dir;

			}
			
			if (parent.collideTypes(specialCollisionTypes, parent.x, parent.y - 1))
			{
				velocity.y = 0;
			}
		}
		
		public function resetFallDistance(): void
		{
			startedFallingY = -1;
		}
		
		public function getFallDistance(): Number
		{
			if (startedFallingY >= 0)
			{
				return parent.y - startedFallingY;
			} else {
				return 0;
			}
		}
		
		override public function update():void
		{			
			super.update();

			if (lastOnGround != onGround && velocity.y >= 0)
			{
				if (lastOnGround == false)
				{
					onLanding();
					startedFallingY = -1;
				}
                //else velocity.y = 0;
				lastOnGround = onGround;
			}
			
			//Check for standing on ground
			collisionBottom();

			//Handle basic physics
			if (!freezeMovement) {
				velocity.x += acceleration.x;
				
				if (!onGround)
				{
					if (velocity.y >= 0 && startedFallingY == -1)
					{
						startedFallingY = parent.y;
					}
					
					velocity.y += acceleration.y;
				}
				
				velocity.x /= friction.x;
				
                if (!onGround)
				{
					velocity.y /= friction.y;
				}
			}
			
			if (Math.abs(velocity.x) < 0.001) velocity.x = 0;
			if (Math.abs(velocity.y) < 0.001) velocity.y = 0;
			
			
			
			//Apply velocity to object
			if (!freezeMovement) moveObject();
			
			//Restrict speed to acceptable values
			clampSpeed();
			
		}
		
		/**
		 * Ensure speed stays within the defined range. 
		 * 
		 */		
		private function clampSpeed():void 
		{
			//Clamp X speeds to within maxSpeed
			if (velocity.x > 0) {
				velocity.x = Math.min(velocity.x, maxSpeed.x);
			} else {
				velocity.x = Math.max(velocity.x, maxSpeed.x*-1);
			}
			
			//Same for Y
			if (velocity.y > 0) {
				velocity.y = Math.min(velocity.y, maxSpeed.y);
			} else {
				velocity.y = Math.max(velocity.y, maxSpeed.y*-1);
			}
		}
		
		public function forceLandingCallback(): void
		{
			onLanding();
		}
		
		public function isAgainstWall(): Boolean {
			return againstWall;
		}
		
		/**
		 * Called when the Entity lands on the ground. 
		 * 
		 */		
		protected function onLanding():void
		{
			if (landingCallback != null) landingCallback();
			velocity.y = 0;
		}
		
	}
}