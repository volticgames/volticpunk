package volticpunk.components
{
	import net.flashpunk.FP;

	public class Repeater extends Component
	{
		
		private var every:Number;
		private var execute:Function;
		private var counter:Number = 0;
		private var paused:Boolean = false;
		
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