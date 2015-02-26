package volticpunk.util
{
	import net.flashpunk.Entity;
	
	import volticpunk.entities.Group;
	
	public class FixedGroup extends Group
	{
		public function FixedGroup(x:int, y:int)
		{
			super(x, y);
		}
		
		override public function add(e:Entity, addToWorld:Boolean=false):Entity
		{
			super.add(e, addToWorld);
			
			e.name = e.x + "," + e.y;
			
			return e;
		}
		
		override public function update():void
		{
			super.update();
			
			var me: FixedGroup = this;
			
			doToEachObject( function(e: Entity): void {
				e.x = me.x + Number(e.name.split(",")[0]);
				e.y = me.y + Number(e.name.split(",")[1]);
			});
		}
	}
}