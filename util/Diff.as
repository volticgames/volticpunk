package volticpunk.util
{
	public class Diff
	{
		public function Diff()
		{
		}
		
		/**
		 * Calculate the absolute difference between two numbers. 
		 * @param a
		 * @param b
		 * @return The difference
		 * 
		 */		
		public static function diff(a:Number, b:Number):Number
		{
			return Math.abs(a - b);
		}
	}
}