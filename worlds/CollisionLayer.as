package volticpunk.worlds
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Pixelmask;
	
	import volticpunk.entities.VEntity;
	
	public class CollisionLayer extends VEntity
	{
		protected var map: XML;
		protected var tileset: Class;
		protected var mapData: String;
		protected var layerWidth: Number;
		protected var layerHeight: Number;
		
		private var tilemap: Tilemap;
		
		public function CollisionLayer(map: XML, tileset: Class, mapData: String, type: String = "level", width: Number = -1, height: Number = -1)
		{
			super();
			this.map = map;
			this.tileset = tileset;
			this.mapData = mapData;
			this.layerWidth = width;
			this.layerHeight = height;
			this.type = type;
			
			if (this.layerWidth == -1)
			{
				this.layerWidth = map.@width;
			}
			
			if (this.layerHeight == -1)
			{
				this.layerHeight = map.@height;
			}
			
			//Set tilemap
			tilemap = new Tilemap(tileset, map.@width, map.@height, C.TILE_SIZE, C.TILE_SIZE);
			
			load();
		}
		
		private function load(): void
		{
			var rows:Vector.<String> = Vector.<String>(mapData.split("\n"));
			var cols:Array;
			var i:Number, j:Number;
			
			//Load tiles
			for (i = 0; i < rows.length; i++)
			{
				cols = rows[i].split(",");
				for (j = 0; j < cols.length; j++)
				{
					var temp:int = int(cols[j]);
					if (temp >= 0)
					{
						tilemap.setTile(j, i, int(cols[j]));
					}
				}
			}
			
			log("Iterating through tilemap");
			
			var bitmap: Bitmap = new tileset;
			var tilebitmap: BitmapData = bitmap.bitmapData;
			var maskbitmap: BitmapData = new BitmapData(C.TILE_SIZE, C.TILE_SIZE, true, 0);
			var tRows: uint = tilemap.width / tilemap.tileWidth;
			var tCols: uint = tilemap.height / tilemap.tileHeight;
			
			for (var xx:uint = 0; xx < tRows; xx++) {
				for (var yy:uint = 0; yy < tCols; yy++) {
					var tile:int = tilemap.getTile(xx, yy);
					if (tile != 0) {
						//log(tile, xx, yy);
						maskbitmap.fillRect(maskbitmap.rect, 0);
						maskbitmap.copyPixels(tilebitmap, convertFromTileIndexToRect(tile), new Point(0,0));
						var mask:Pixelmask = new Pixelmask(maskbitmap.clone());
						var type:String = C.DEFAULT_COLLISION_TYPE;
						var xxx:int = xx * tilemap.tileWidth;
						var yyy:int = yy * tilemap.tileHeight;
						
						var e:Entity = new Entity(xxx, yyy, null, mask);
						e.collidable = true;
						e.layer = 0;
						e.type = type;
						FP.world.add(e);
						//log(e, mask, type, xxx, yyy);
					}
				}
			}
		}
		
		private function convertFromTileIndexToRect(index:int):Rectangle
		{
			//Dims 8 x 2
			
			var x:int = (index % 8) * C.TILE_SIZE;
			var y:int = int(index / 8) * C.TILE_SIZE;
			
			return new Rectangle(x, y, C.TILE_SIZE, C.TILE_SIZE);
		}
	}
}