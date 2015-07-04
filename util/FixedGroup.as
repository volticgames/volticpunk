package volticpunk.util
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	
	import volticpunk.entities.Group;
	import volticpunk.entities.VEntity;
	
	public class FixedGroup extends Group
	{
		private var scroll: Number;
		protected var controlLayers: Boolean = true;
		
		public function FixedGroup(x:int, y:int, scroll: Number = 1, layer: int = 0, controlLayers: Boolean = true)
		{
			super(x, y);
			
			this.controlLayers = controlLayers;
			
			this.scroll = scroll;
			this.layer = layer;
			
			if (graphic != null)
			{
				graphic.scrollX = scroll;
				graphic.scrollY = scroll;
			}
		}
		
		override public function add(e:Entity, addToWorld:Boolean=false): Entity
		{
			super.add(e, addToWorld);
			
			if (!(e is VEntity))
			{
				e.name = e.x + "," + e.y;
			}
			
			updatePositions();
			
			return e;
		}
		
		override public function added():void
		{
			super.added();
			
			updatePositions();
		}
		
		private function updatePositions(): void
		{
			var me: FixedGroup = this;
			
			for each (var e: Entity in getMembers())
			{
				if (e.graphic != null)
				{
					e.graphic.scrollX = scroll;
					e.graphic.scrollY = scroll;
				}
				
				if (controlLayers)
				{
					if (e.layer > layer)
					{
						e.layer = layer;
					}
				}
				
				if (e is FixedGroup)
				{
					(e as FixedGroup).scroll = scroll;
				}
				
				if (e is VEntity)
				{	
					var v: VEntity = e as VEntity;
					v.x = me.x + v.groupX;
					v.y = me.y + v.groupY;
				} else {
					e.x = me.x + Number(e.name.split(",")[0]);
					e.y = me.y + Number(e.name.split(",")[1]);
				}
			}
		}
		
		override public function update():void
		{
			super.update();
			updatePositions();
		}
	}
}