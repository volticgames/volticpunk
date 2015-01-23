package volticpunk.util
{
	public class Choose
	{
		/**
		 * Given a list of inputs, will return a random one of them. Good for making discrete decisions.
		 * Be careful of your types while using this.
		 * @param input Array of inputs
		 * @return 
		 * 
		 */		
		public static function choose(...input):*
		{
			var index:int = int(Math.random()*(input.length));
			return input[index];
		}
	}
}