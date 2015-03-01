package volticpunk.entities.util
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	import volticpunk.V;
	import volticpunk.components.Repeater;
	import volticpunk.entities.VEntity;
	
	public class ActionQueue extends VEntity
	{
		private var actions: Array;
		private var timeGap: Number;
		private var currentAction: int = 0;
		
		public function ActionQueue(actions: Array, timeGap: Number)
		{
			super(x, y);
			
			this.actions = actions;
			this.timeGap = timeGap;
			
			addComponent( new Repeater(timeGap, nextAction) );
		}
		
		override public function added(): void
		{
			super.added();
			
			trace("");
		}
		
		protected function finished(): void
		{
			
		}
		
		private function nextAction(): void
		{
			actions[currentAction]();
			currentAction++;
			
			if (currentAction >= actions.length)
			{
				finished();
				V.getRoom().remove(this);
			}
		}
	}
}