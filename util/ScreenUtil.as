package volticpunk.util
{
    import net.flashpunk.Entity;
    import net.flashpunk.FP;

	public class ScreenUtil
	{
		public function ScreenUtil()
		{
		}
		
		public static function onScreen(x:Number, y:Number):Boolean
		{
			return x > FP.camera.x && x < FP.camera.x + C.WIDTH && y > FP.camera.y && y < FP.camera.y + C.HEIGHT;
		}

        public static function objectOnScreen(e: Entity):Boolean
        {
            return e.left > FP.camera.x && e.right < FP.camera.x + C.WIDTH && e.top > FP.camera.y && e.bottom < FP.camera.y + C.HEIGHT;
        }
    }
}