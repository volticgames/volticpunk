package volticpunk.worlds
{
	import net.flashpunk.graphics.Tilemap;
	
	import volticpunk.entities.VEntity;
	
	public class TileLayer extends VEntity
	{
		protected var map: XML;
		protected var tileset: Class;
		protected var mapData: String;
		protected var mapWidth: Number;
		protected var mapHeight: Number;
		private var tilemap: Tilemap;
		
		public function TileLayer(map: XML, tileset: Class, mapData: String, layer: int, width: Number = -1, height: Number = -1)
		{
			super();
			this.map = map;
			this.tileset = tileset;
			this.mapData = mapData;
			this.mapWidth = width;
			this.mapHeight = height;
			
			if (mapWidth == -1)
			{
				mapWidth = map.@width;
			}
			
			if (mapHeight == -1)
			{
				mapHeight = map.@height;
			}
			
			this.tilemap = new Tilemap(tileset, mapWidth, mapHeight, C.TILE_SIZE, C.TILE_SIZE);
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