package volticpunk.util
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class JSONAnimationLoader
	{
		
		private var data: Object;
		private var cache:Dictionary = new Dictionary();
		private var spriteDims: Point;
		private var spritemapDims: Point;
		
		/**
		 * Load an ogmo editor level, NOTE: add more layer loading here! 
		 * @param map Which map to load
		 */
		public function JSONAnimationLoader(file:Class, spriteWidth: uint, spriteHeight: uint, spritemapWidth: uint, spritemapHeight: uint)
		{
			var json: String = new file();
			data = JSON.parse(json);
			
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
		
		private function getFrameId(frameData: Object): int {
			var col: int= frameData.frame.x / frameData.frame.w;
			var row: int = frameData.frame.y / frameData.frame.h;
			var start: int = col + row * spritemapDims.x;
			
			return start;
		}
		
		private function getAnimationNameData(frame: String): Object {
			var split: Array = frame.split("_");
			var animName: String = split.slice(0, split.length - 1).join("_");
			var frameNumber: String = split[split.length - 1];
			
			return {
				baseName: animName,
				frameNumber: frameNumber
			};
		}
		
		/**
		 * Look up the frames for a given animation name. 
		 * @param name The Animation
		 * @return Frames List
		 * 
		 */		
		public function loadAnimationFrames(name:String):Array
		{
			//We want to cache the result for lookups in the future.
			if (cache[name] != null) return cache[name];
			
			var result:Array = null;
			
			var animMap: Object = {};
			
			if (data.meta.frameTags && data.meta.frameTags.length > 0) {
				// Use tags rather than various files to load animations
				
				var nameStub: String = getAnimationNameData(ObjectUtil.keys(data.frames)[0]).baseName;
				
				for each (var tagData: Object in data.meta.frameTags) {
					var range: Array = Range.range(tagData.from, tagData.to);
					
					animMap[tagData.name] = range.map(function(frame:int, index:int, array:Array): int {
						var frameSuffix: String;

                        // Special case for handling when there is only one animation frame
						if (ObjectUtil.keys(data.frames).length == 1) {
							frameSuffix = "";
						} else {
							frameSuffix = frame.toString();
						}

						return getFrameId(data.frames[nameStub + "_" + frameSuffix]);
					});
				}
				
				result = animMap[name];
				
			} else {
				for (var frame: String in data.frames) {
					var split: Array = frame.split("_");
					
					var animationData: Object = getAnimationNameData(frame);
					var animName: String = animationData.baseName;
					var frameNumber: int = animationData.frameNumber;
					
					animMap[animName] = animMap[animName] || {};
					animMap[animName][frameNumber] = {};
					animMap[animName][frameNumber].originalData = data.frames[frame];
					
					animMap[animName][frameNumber].spritemapIndex = getFrameId(data.frames[frame]);
				}
				
				result = [];
				for (var num: String in animMap[name]) {
					result.push(animMap[name][num].spritemapIndex);
				}
				
			}
			
			if (result == null || result.length == 0)
			{
				throw Error("Could not look up animation");
			}
			
			cache[name] = result;
			
			return result;
			
		}
	}
}