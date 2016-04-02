package volticpunk.util
{
	public class ObjectUtil
	{
		public function ObjectUtil()
		{
			
		}
		
		public static function keys(obj: Object): Array {
			var result: Array = [];
			
			for (var i: String in obj) {
				if (obj.hasOwnProperty(i)) {
					result.push(i);
				}
			}
			
			return result;
		}
	}
}