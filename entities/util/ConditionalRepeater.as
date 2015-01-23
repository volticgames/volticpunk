package volticpunk.entities.util
{
	import volticpunk.entities.VEntity;
	
	public class ConditionalRepeater extends VEntity
	{
		private var repeat: Function;
		private var condition: Function;
		
		public function ConditionalRepeater(repeat: Function, condition: Function)
		{
			super(0, 0);
			
			this.repeat = repeat;
			this.condition = condition;
		}
		
		override public function update():void
		{
			super.update();
			
			if (!condition())
			{
				repeat();
			} else {
				Proof.getRoom().remove(this);
			}
		}
	}
}