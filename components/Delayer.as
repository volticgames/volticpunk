package volticpunk.components
{
	import net.flashpunk.FP;
	
	public class Delayer extends Component
	{
		
		private var timer:Number;
		private var action:Function;
		
		private var active: Boolean = true;
		private var initialTime: Number;
		private var removeSelf: Boolean;
		
		public function Delayer(time:Number, action:Function, removeComponent: Boolean = true)
		{
			super();
			
			timer = time;
			initialTime = time;
			this.action = action;
			this.removeSelf = removeComponent;
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
			
			if (active)
			{
				timer -= FP.elapsed;
				
				if (timer <= 0)
				{
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