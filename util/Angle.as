package volticpunk.util
{
	public class Angle
	{
		public function Angle()
		{
		}
		
		public static function radToDeg(rad: Number): Number {
			return rad / (2*Math.PI) * 180;
		}
		
		public static function degToRad(deg: Number): Number {
			return deg / 180 * 2 * Math.PI;
		}
	}
}