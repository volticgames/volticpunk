package volticpunk.worlds
{
	import net.flashpunk.graphics.Tilemap;
	
	import volticpunk.entities.VEntity;
	
	public class TileLayer extends VEntity
	{
		protected var map: XML;
		protected var tileset: Class;
		protected var mapData: String;
		protected var WIDTH: Number;
		protected var HEIGHT: Number;
		private var tilemap: Tilemap;
		
		public function TileLayer(map: XML, tileset: Class, mapData: String, layer: int, WIDTH: Number = -1, HEIGHT: Number = -1)
		{
			super();
			this.map = map;
			this.tileset = tileset;
			this.mapData = mapData;
			this.WIDTH = WIDTH;
			this.HEIGHT = HEIGHT;
			
			if (WIDTH == -1)
			{
				WIDTH = map.@width;
			}
			
			if (HEIGHT == -1)
			{
				HEIGHT = map.@height;
			}
			
			this.tilemap = new Tilemap(tileset, WIDTH, HEIGHT, C.TILE_SIZE, C.TILE_SIZE);
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