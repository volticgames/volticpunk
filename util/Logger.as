package volticpunk.util
{
	
	import flash.system.Capabilities;
	
	public class Logger
	{
		
		public static var enabled: Boolean = true;
		
		public function Logger()
		{
		}
		
		public static function log(name: String, ...args): void
		{
			if (enabled)
			{
				trace("<" + name + ">", args, name + ".as:" + lineNumber(3));
			}
			
		}
		
		/**
		 * Returns the positive line number from which the function is called, if
		 * available, otherwise returns a negative number.
		 */
		public static function lineNumber(level: int): String {
			var ret:int = -1;
			if (Capabilities.isDebugger) {
				ret = new Error().getStackTrace().match(/(?<=:)[0-9]*(?=])/g)[level];
			}
			return ret.toString();
		}
		
		public static function stackTrace(): String {
			var ret: String = "";
			if (Capabilities.isDebugger) {
				ret = new Error().getStackTrace();
			}
			return ret;
		}
	}
}