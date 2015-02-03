package volticpunk.util
{
	import flash.geom.Point;
	
	import net.flashpunk.graphics.Image;

	public class ImageUtil
	{
		public function ImageUtil()
		{
		}
		
		public static function setPivotPoint(image: Image, point: Point): Image
		{
			image.originX = point.x;
			image.originY = point.y;
			image.x = point.x;
			image.y = point.y;
			
			return image;
		}
		
		public static function centerPivotPoint(image: Image): Image
		{
			return setPivotPoint(image, new Point(image.width / 2, image.height / 2));
		}
	}
}