package volticpunk.components
{
	import net.flashpunk.FP;
	
	import volticpunk.util.Logger;
	
	public class Delayer extends Component
	{
		
		public var timer:Number;
		private var action:Function;
		
		private var isActive: Boolean = true;
		private var initialTime: Number;
		private var removeSelf: Boolean;
		private var countFrames: Boolean;
		
		public function Delayer(time:Number, action:Function, removeComponent: Boolean = true, countFrames: Boolean = false)
		{
			super();
			
			timer = time;
			initialTime = time;
			this.action = action;
			this.removeSelf = removeComponent;
			this.countFrames = countFrames;
		}
		
		public function pause():void
		{
			isActive = false;
		}
		
		public function unpause():void
		{
			isActive = true;
		}
		
		public function reset(paused: Boolean = false):void
		{
			timer = initialTime;
			
			if (!paused)
			{
				this.unpause();
			}
			else if (paused)
			{
				this.pause();
			}
		}
		
		public function isCounting():Boolean
		{
			return isActive;
		}
		
		public function forceTime(n:Number=0):void
		{
			timer = n;
		}
		
		public function setTime(n:Number=0):void
		{
			timer = n;
			initialTime = n;
		}
		
		override public function update():void
		{
			super.update();
			
			if (isActive)
			{
				if (countFrames)
				{
					timer -= 1;
				} else {
					timer -= FP.elapsed;	
				}
				
				if (timer <= 0)
				{
					isActive = false;
					action(parent);
					
					if (removeSelf)
					{
						parent.removeComponent(this);
					}
				}
			}
		}
	}
}