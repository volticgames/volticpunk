package volticpunk.components
{
	import net.flashpunk.FP;

	public class Repeater extends Component
	{
		
		private var every: Number;
		private var execute: Function;
		private var counter: Number = 0;
		private var paused: Boolean = false;
		
		public function Repeater(every:Number, execute:Function)
		{
			super();
			
			this.every = every;
			this.execute = execute;
		}
		
		public function pause():void
		{
			paused = true;
		}
		
		public function reset():void
		{
			counter = 0;
		}
		
		public function unpause():void
		{
			paused = false;
		}
		
		public function togglePaused():void
		{
			paused = !paused;
		}
		
		public function getTimeLeft():Number
		{
			return every - counter;
		}
		
		public function getOriginalTime():Number
		{
			return every;
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
		
		override public function update():void
		{
			super.update();

			if (!paused) counter += FP.elapsed;
	
			if (counter > every)
			{
				execute();
				counter = 0;
			}
			
		}
	}
}