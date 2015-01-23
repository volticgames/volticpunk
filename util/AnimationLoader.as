package volticpunk.util
{
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	

	public class AnimationLoader
	{
		
		private var lookup:XML;
		private var cache:Dictionary = new Dictionary();
		private var spriteDims: Point;
		private var spritemapDims: Point;
		
		/**
		 * Load an ogmo editor level, NOTE: add more layer loading here! 
		 * @param map Which map to load
		 */
		public function AnimationLoader(file:Class, spriteWidth: uint, spriteHeight: uint, spritemapWidth: uint, spritemapHeight: uint)
		{
			var bytes:ByteArray = new file();
			lookup = new XML(bytes.readUTFBytes(bytes.length));
			spriteDims = new Point(spriteWidth, spriteHeight);
			spritemapDims = new Point(spritemapWidth, spritemapHeight);
		}

		/**
		 * Get the frame at the specified index of the specified animation 
		 * @param name Which Animation
		 * @param frame Which Frame
		 * @return The Global Frame Index
		 * 
		 */		
		public function getFrame(name:String, frame:int):int
		{
			return loadAnimationFrames(name)[frame];
		}
		
		/**
		 * Look up the frames for a given animation name. 
		 * @param name The Animation
		 * @return Frames List
		 * 
		 */		
		public function loadAnimationFrames(name:String):Array
		{
			name += ".png";
			
			//We want to cache the result for lookups in the future.
			if (cache[name] != null) return cache[name];
			
			var result:Array = null;
			var start:int;
			var width:int;
			var end:int;
			var row:int;
			var col: int;

			for each (var n:XML in lookup.sprite)
			{	
				if (n.@n == name)
				{
					var x: int = n.@x;
					var y: int = n.@y;
					var w: int = n.@w;
					
					col = x / spriteDims.x;
					row = y / spriteDims.y;
					width = w / spriteDims.x;
					start = col + row * spritemapDims.x;
					end = start + width - 1;
					
					result = Range.range(start, end);
					cache[name] = result;
					
					break;
				}
			}
			
			if (result == null)
			{
				throw Error("Could not look up animation");
			}
			
			return result;
			
		}
	}
}