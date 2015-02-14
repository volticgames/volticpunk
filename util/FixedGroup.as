package volticpunk.util
{
	import flash.utils.Dictionary;
	
	import net.flashpunk.Entity;
	
	import volticpunk.entities.Group;
	
	public class FixedGroup extends Group
	{
		private var positions: Dictionary;
		
		public function FixedGroup(x:int, y:int)
		{
			super(x, y);
			
			positions = new Dictionary();
		}
		
		override public function add(e:Entity, addToWorld:Boolean=false):Entity
		{
			super.add(e, addToWorld);
			
			positions[e] = {x: e.x, y: e.y};
			
			return e;
		}
		
		override public function update():void
		{
			super.update();
			
			doToEachObject( function(e: Entity): void {
				e.x = this.x + positions[e].x;
				e.y = this.y + positions[e].y;
			});
		}
	}
}