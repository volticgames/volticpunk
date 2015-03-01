package volticpunk.util
{
	import flash.utils.ByteArray;

	public class XMLUtil
	{
		public function XMLUtil()
		{
		}
		
		public static function loadXml(c: Class): XML
		{
			var bytes:ByteArray = new c();
			return new XML(bytes.readUTFBytes(bytes.length));
		}
	}
}