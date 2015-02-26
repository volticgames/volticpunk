package volticpunk.components
{
	import net.flashpunk.FP;
	
	import volticpunk.util.Logger;
	
	public class Delayer extends Component
	{
		
		public var timer:Number;
		private var action:Function;
		
		private var active: Boolean = true;
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
			active = false;
		}
		
		public function unpause():void
		{
			active = true;
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
			
			if (active)
			{
				if (countFrames)
				{
					timer -= 1;
				} else {
					timer -= FP.elapsed;	
				}
				
				
				if (timer <= 0)
				{
					action(parent);
					active = false;
					
					if (removeSelf)
					{
						parent.removeComponent(this);
					}
				}
			}
		}
	}
}