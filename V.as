package volticpunk
{
	import net.flashpunk.FP;
	import volticpunk.worlds.Room;

	public class V
	{
		private static var variables: Object = {};
		
		public function V()
		{
		}
		
		public static function getRoom(): Room
		{
			return FP.world as Room;
		}
		
		public static function changeRoom(r: Room): Room
		{
			FP.world = r;
			return r;
		}
		
		public static function setGlobal(name: String, value: Number): Number
		{
			variables[name] = value;
			
			return value;
		}
		
		public static function setBoolean(name: String, bool: Boolean): Boolean
		{
			variables[name] = bool;
			
			return bool;
		}
		
		public static function getBoolean(name: String): Boolean
		{
			return variables[name];
		}
		
		public static function storeReference(name: String, obj: Object): Object
		{
			variables[name] = obj;
			return obj;
		}
		
		public static function getReference(name: String): Object
		{
			return variables[name];
		}
		
		public static function deleteReference(name: String): Object
		{
			var old: Object = variables[name];
			
			delete variables[name];
			
			return old;
		}

		public static function getGlobal(name: String): Number
		{
			return variables[name];
		}
	}
}