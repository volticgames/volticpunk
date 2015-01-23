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
	import worlds.util.TileLoader;
	
	public class OgmoLevelLoader extends World
	{		
		public var darknessOverlay:Image;
		public var tileLoader: TileLoader;
		
		public var levelWidth:int;
		public var levelHeight:int;
		public var area:String;
		public var cliffBackground: Boolean;
		public var skyBackground: Boolean;

        protected var fileLoaded:Boolean = false;
		
		public function OgmoLevelLoader()
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
		
		public function getArea(): String
		{
			return area;
		}
		
		override public function begin():void
		{	
			super.begin();
		}
		
		override public function update():void
		{
			super.update();

            if (Input.pressed(Key.DIGIT_9))
            {
                FP.stage.fullScreenSourceRect = new Rectangle(0, 0, 640, 360);
                FP.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            }
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