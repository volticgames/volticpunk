package volticpunk.entities.util
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	public class Delayer extends Entity
	{
		
		private var timer:Number;
		private var action:Function;
		
		public function Delayer(time:Number, action:Function)
		{
			super(0, 0, null, null);
			
			timer = time;
			this.action = action;
		}
		
		override public function update():void
		{
			timer -= FP.elapsed;
			
			if (timer <= 0)
			{
				action();
				this.world.remove(this);
			}
		}
	}
}