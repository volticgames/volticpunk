package volticpunk.entities
{
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    
    import volticpunk.util.Range;

	public class Group extends VEntity
	{
		private var contents:Vector.<Entity>;
		private var graphics:Vector.<Graphic>;
		private var graphicEntities:Vector.<Entity>;
		public var isAdded:Boolean = false;
		
		public function Group(x:int, y:int)
		{
			super(x, y);
			
			this.x = x;
			this.y = y;
			contents = new Vector.<Entity>();
			graphics = new Vector.<Graphic>();
		}
		
		/**
		 * Add a new Entity to the group.
		 * @param e Entity
		 * 
		 */		
		public function add(e:Entity, addToWorld:Boolean=false): Entity
		{
			if (contents.indexOf(e) == -1) contents.push(e);
            if (addToWorld && world) world.add(e);
			
			return e;
		}
		
		/**
		 * Add a new graphic to the group. 
		 * @param g Graphic
		 * @param layer Layer
		 * @param x X Pos
		 * @param y Y Pos
		 * 
		 */		
		public function addGraphicalEntity(g:Graphic, layer:int, x:int, y:int, addToWorld: Boolean = false): VEntity
		{
			var e: VEntity = new VEntity(x, y, g);
			e.layer = layer;
			
			add(e, addToWorld);
			return e;
		}
		
		override public function update():void
		{
			super.update();
			
			for each (var e:Entity in contents)
			{
				updateMember(e);
			}
		}
		
		public function contains(e: Entity): Boolean
		{
			return (contents.indexOf(e) >= 0);
		}
		
		/**
		 * Update a member of the group, override this. 
		 * @param e Which member is being updated
		 * 
		 */		
		public function updateMember(e:Entity):void
		{

		}
		
		/**
		 * Called when the group is added to the world. 
		 * 
		 */		
		override public function added():void
		{
			super.added();
			isAdded = true;
			
			for each (var e:Entity in contents)
			{
				FP.world.add(e);
			}
		}
		
		public function addAll(list: Array): void {
			for each (var e: Entity in list)
			{
				this.add(e);
			}
		}
		
		public function filterXInRange(range: Range): Group
		{
			var g: Group = new Group(0, 0);
			
			for each (var e:Entity in this.getMembers())
			{
				if (range.contains (e.x))
				{
					g.add(e);
				}
			}
			
			return g;
		}
		
		public function filterYInRange(range: Range): Group
		{
			var g: Group = new Group(0, 0);
			
			for each (var e:Entity in this.getMembers())
			{
				if (range.contains (e.y))
				{
					g.add(e);
				}
			}
			
			return g;
		}
		
		public function filterByType(type: String): Group
		{
			var g: Group = new Group(0, 0);
			
			for each (var e:Entity in this.getMembers())
			{
				if (e.type == type)
				{
					g.add(e);
				}
			}
			
			return g;
		}
		
		/**
		 * Called when the group is removed from the world. 
		 * 
		 */		
		override public function removed():void
		{
			isAdded = false;
			
			for each (var e:Entity in contents)
			{
				FP.world.remove(e);
			}
			super.removed();
		}

        /**
         * Number of members
         * @return
         */
        public function size():int
        {
            return contents.length;
        }
		
		/**
		 * Remove an entity from the group. 
		 * @param e The Entity to remove
		 * 
		 */		
		public function remove(e:Entity, removeFromWorld:Boolean=false):void
		{
			var index: int = contents.indexOf(e);

            // Only remove from group if it's ACTUALLY IN IT!!
			if (index >= 0) {
                contents.splice(contents.indexOf(e), 1);
                if (removeFromWorld && world) world.remove(e);
			}
		}
		
		public function removeAll(removeFromWorld: Boolean=false): void
		{
			for each (var e: Entity in contents)
			{
				remove(e, removeFromWorld);
			}
		}
		
		/**
		 * Return a list of all the members of the group. 
		 * @return The list
		 */		
		public function getMembers():Vector.<Entity>
		{
			return contents;
		}
		
		public function count(): int
		{
			return contents.length;
		}
		
		/**
		 * Run the supplied closure on each member. 
		 * @param func
		 * 
		 */		
		public function doToEachObject(func:Function):void
		{
			for each (var e:Entity in contents)
			{
				func(e);
			}
		}
		
	}
}