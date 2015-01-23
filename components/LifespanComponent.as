package volticpunk.components
{
	import net.flashpunk.FP;

	public class LifespanComponent extends Component
	{
		
		private var seconds:Number;
		private var originalAmount:Number;
		private var callback:Function;
		private var active:Boolean = true;
		private var removeFromWorld:Boolean;
		
		/**
		 * If no callback is given, the entity will be removed from the world when the lifespan is over.
		 */
		public function LifespanComponent(seconds:Number, removeFromWorld:Boolean = true, callback:Function = null)
		{
			super();
			
			this.seconds = seconds;
			this.originalAmount = seconds;
			this.callback = callback;
			this.removeFromWorld = removeFromWorld;
		}
		
		override public function removed():void
		{
			callback = null;
		}
		
		public function reset():void
		{
			active = true;
			seconds = originalAmount;
		}
		
		override public function update():void
		{
			super.update();
			
			if (active)
			{
				seconds -= FP.elapsed;
				
				if (seconds <= 0)
				{
					if (removeFromWorld)
					{
						parent.getRoom().remove(parent);
					}
					
					if (callback != null)
					{
						callback(this.parent);
					}
					
					active = false;
				}
			}
		}
		
		public function getTimeLeft():Number
		{
			return seconds;
		}
		
		public function getOriginalTime():Number
		{
			return originalAmount;
		}
		
		/**
		 * Get the time left as as a 1-0 value. At 0 it expires. 
		 * @return 
		 * 
		 */		
		public function getRemainingPercent():Number
		{
			return getTimeLeft() / getOriginalTime();
		}
		
		/**
		 * Get the time left as as a 0-1 value. At 1 it expires. 
		 * @return 
		 * 
		 */		
		public function getExpirationPercent():Number
		{
			return 1 - (getTimeLeft() / getOriginalTime());
		}
	}
}