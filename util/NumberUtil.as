package volticpunk.util
{
	public class NumberUtil
	{
		public function NumberUtil()
		{
		}
		
		public static function sign(num: Number): Number
		{
			return Math.abs(num) / num;
		}
	}
}