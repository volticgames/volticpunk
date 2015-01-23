package volticpunk.util
{
	public class Constrain
	{
		
		/**
		 * Constrain a value between two bounds. 
		 * @param val The Value Itself
		 * @param min
		 * @param max
		 * @return Constrained Value
		 * 
		 */		
		public static function constrain(val:Number, min:Number, max:Number):Number
		{
			if (val <= min) return min;
			if (val >= max) return max;
			return val;
		}
	}
}