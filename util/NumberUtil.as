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
		
		public static function closeTo(input: Number, target: Number, range: Number): Boolean
		{
			return (input > target - range) && (input < target + range);
		}
	}
}