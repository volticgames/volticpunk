package volticpunk.worlds
{
	import net.flashpunk.graphics.Tilemap;
	
	import volticpunk.entities.VEntity;
	
	public class TileLayer extends VEntity
	{
		protected var map: XML;
		protected var tileset: Class;
		protected var mapData: String;
		protected var width: Number;
		protected var height: Number;
		private var tilemap: Tilemap;
		
		public function TileLayer(map: XML, tileset: Class, mapData: String, layer: int, width: Number = -1, height: Number = -1)
		{
			super();
			this.map = map;
			this.tileset = tileset;
			this.mapData = mapData;
			this.width = width;
			this.height = height;
			
			if (width == -1)
			{
				width = map.@width;
			}
			
			if (height == -1)
			{
				height = map.@height;
			}
			
			this.tilemap = new Tilemap(tileset, width, height, C.TILE_SIZE, C.TILE_SIZE);
			this.graphic = tilemap;
			this.layer = layer;
			
			load();
		}
		
		public function load(): void
		{
			log("My layer is ", layer);
			
			var rows:Vector.<String> = Vector.<String>(mapData.split("\n"));
			
			//Load tiles
			for (var i:int = 0; i < rows.length; i++)
			{
				var cols:Array = rows[i].split(",");
				for (var j:int = 0; j < cols.length; j++)
				{
					if (int(cols[j]) != -1) tilemap.setTile(j, i, int(cols[j]));
				}
			}
		}
	}
}