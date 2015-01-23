package volticpunk.worlds
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import assets.A;
	
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
		protected var layer: int;
		protected var width: Number;
		protected var height: Number;
		
		public function CollisionLayer(map: XML, tileset: Class, mapData: String, width: Number = -1, height: Number = -1)
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
			
			load();
		}
		
		private function load(): void
		{
			var rows:Vector.<String> = Vector.<String>(mapData.split("\n"));
			var cols:Array;
			var i:Number, j:Number;
			
			
			var tileset: Class = A.CollisionTileset;
			var collisionTilemap: Tilemap;
			
			//Set tilemap
			collisionTilemap = new Tilemap(tileset, map.@width, map.@height, C.TILE_SIZE, C.TILE_SIZE);
			
			//Load tiles
			for (i = 0; i < rows.length; i++)
			{
				cols = rows[i].split(",");
				for (j = 0; j < cols.length; j++)
				{
					var temp:int = int(cols[j]);
					if (temp >= 0) collisionTilemap.setTile(j, i, int(cols[j]));
				}
			}
			
			log("Iterating through tilemap");
			
			var bitmap: Bitmap = new tileset;
			var tilebitmap: BitmapData = bitmap.bitmapData;
			var maskbitmap: BitmapData = new BitmapData(C.TILE_SIZE, C.TILE_SIZE, true, 0);
			var tRows: uint = collisionTilemap.width / collisionTilemap.tileWidth;
			var tCols: uint = collisionTilemap.height / collisionTilemap.tileHeight;
			
			for (var xx:uint = 0; xx < tRows; xx++) {
				for (var yy:uint = 0; yy < tCols; yy++) {
					var tile:int = collisionTilemap.getTile(xx, yy);
					if (tile != 0) {
						//log(tile, xx, yy);
						maskbitmap.fillRect(maskbitmap.rect, 0);
						maskbitmap.copyPixels(tilebitmap, convertFromTileIndexToRect(tile), new Point(0,0));
						var mask:Pixelmask = new Pixelmask(maskbitmap.clone());
						var type:String = C.DEFAULT_COLLISION_TYPE;
						var xxx:int = xx * collisionTilemap.tileWidth;
						var yyy:int = yy * collisionTilemap.tileHeight;
						
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