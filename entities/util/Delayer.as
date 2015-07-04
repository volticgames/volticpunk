package volticpunk.entities.util
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	import volticpunk.components.Delayer;
	import volticpunk.entities.VEntity;
	
	public class Delayer extends VEntity
	{
		
		private var timer:Number;
		private var action:Function;
		private var delayer: volticpunk.components.Delayer;
		private var removeSelf: Boolean;
		
		public function Delayer(time:Number, action:Function, removeSelf: Boolean = true)
		{
			super(0, 0, null, null);
			
			delayer = new volticpunk.components.Delayer(time, done);
			addComponent( new volticpunk.components.Delayer(time, done) );
			
			this.removeSelf = removeSelf;
			
			this.action = action;
		}
		
		public function getDelayer(): volticpunk.components.Delayer
		{
			return delayer;
		}
		
		private function done(e: Entity = null):void
		{
			action();
			if (removeSelf)
			{
				this.world.remove(this);	
			}
		}
	}
}