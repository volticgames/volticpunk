package volticpunk.worlds
{
	import flash.display.BlendMode;
	import flash.display.StageDisplayState;
	import flash.geom.Rectangle;
	
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import volticpunk.util.Logger;
	
	public class OverlayedWorld extends World
	{		
		public var darknessOverlay:Image;
		
		public var levelWidth:int;
		public var levelHeight:int;
		
		public function OverlayedWorld()
		{
			super();
			createDarknessOverlay();
			
		}
		
		protected function log(...args): void
		{
			if (Logger.enabled)
			{
				Logger.log("Room", args);
			}
			
		}
		
		override public function begin():void
		{	
			super.begin();
		}
		
		override public function update():void
		{
			super.update();
		}
		
		protected function disableDarknessOverlay(): void
		{
			darknessOverlay.alpha = 0;
		}
		
		/**
		 * Create the moody darkness overlay. 
		 */
		private function createDarknessOverlay():void
		{
			darknessOverlay = Image.createRect(C.WIDTH, C.HEIGHT, 0x777777);
			darknessOverlay.blend = BlendMode.SUBTRACT;
			darknessOverlay.scrollX = darknessOverlay.scrollY = 0;
			darknessOverlay.alpha = 0.6;
			addGraphic(darknessOverlay, -5);
		}
		
		/**
		 * Change the tint of the overlay on the screen 
		 * @param c Color ( 0xFFFFFF etc.)
		 * 
		 */		
		public function changeOverlayColor(c:uint):void
		{
			darknessOverlay.color = c;
		}
		
		/**
		 * Change the alpha of the darkness overlay 
		 * @param a Alpha (0 - 1)
		 * 
		 */		
		public function changeOverlayAlpha(a:Number):void{
			darknessOverlay.alpha = a;
		}
	}
}