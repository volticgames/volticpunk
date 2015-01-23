package volticpunk.util
{
	public class Range
	{
		
		private var start: int;
		private var end: int;
	
		public function Range(start: int, end: int)
		{
			this.start = start;
			this.end = end;
		}
		
		public function getNumbers(): Array
		{
			var result: Array = [];
			
			for (var i: int = start; i < end; i++)
			{
				result.push(i);
			}
			
			return result;
		}
		
		public function contains(x: Number): Boolean
		{
			return (x >= start && x <= end);
		}
		
		/**
		 * Returns an inclusive array of numbers between start and end. 
		 * @param start
		 * @param end
		 * @return Array of Numbers
		 * 
		 */
		public static function range(start:int, end:int):Array
		{
			var arr:Array = [];
			
			for (var i:int = start; i <= end; i++)
			{
				arr.push(i);
			}
			
			return arr;
		}
		
		/**
		 * Given an array, shift it around as if it was circular. 
		 * @param arr
		 * @param amount
		 * @return 
		 * 
		 */		
		public static function shiftLeft(arr:Array, amount:int):Array
		{
			var temp:Array = [];
			
			for each (var i:int in arr.slice(amount)) temp.push(i);
			for each (i in arr.slice(0, amount)) temp.push(i);
			
			return temp;
		}
		
		/**
		 * Given an array, shift it around as if it was circular. 
		 * @param arr
		 * @param amount
		 * @return 
		 * 
		 */	
		public static function shiftRight(arr:Array, amount:int):Array
		{
			var temp:Array = [];
			
			for each (var i:int in arr.slice(arr.length - amount)) temp.push(i);
			for each (i in arr.slice(0, arr.length - amount)) temp.push(i);
			
			return temp;
		}
		
		
		/**
		 * Divide an entire array by an amount, because I'm lazy. 
		 * @param arr The array to modify
		 * @param divideBy The divisor
		 * @return 
		 * 
		 */		
		public static function divide(arr:Array, divideBy:int):Array
		{
			var result:Array = new Array();
			
			for each (var i:int in arr)
			{
				result.push(i/divideBy);	
			}
			
			return result;
		}
	}
}