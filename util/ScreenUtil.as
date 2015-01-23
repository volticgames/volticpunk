package volticpunk.util
{
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
	}
}