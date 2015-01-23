package volticpunk.util
{
	public class StringManipulation
	{
		public function StringManipulation()
		{
		}
		
		public static function isFirstLetterUpperCase(s: String): Boolean
		{
			return s.substr(0,1).toUpperCase() == s.substr(0,1);
		}
		
		public static function hasNoSpaces(s: String): Boolean
		{
			return s.indexOf(" ") < 0;
		}
		
		public static function isTitleCase(s: String): Boolean
		{
			var parts: Array = s.split(" ");
			
			for each (var part: String in parts)
			{
				if (!isFirstLetterUpperCase(part))
				{
					return false;
				}
			}
			
			return true;
		}
		
		public static function formatFilename(s: String): String
		{
			var spacePattern: RegExp = /\s/g;
			var underscorePattern: RegExp = /\_/g;
			var dotPattern: RegExp = /\./g;
			var slashPattern: RegExp = /\//g;
			
			s = s.replace(underscorePattern," ").replace(slashPattern," ").replace(dotPattern," ");
			
			if (s.length != 0 && isFirstLetterUpperCase(s) && hasNoSpaces(s))
			{
				return s;
			}
			
			
			if (hasNoSpaces(s))
			{
				return toTitleCase(s);
			}
			
			if (s.length == 0 || !isTitleCase(s))
			{
				return toTitleCase(s).replace(spacePattern, "");
			}
			
			return s.replace(spacePattern, "");
		}
		
		public static function toTitleCase(txt: String): String
		{
			txt = txt.split(" ").map(
				function(myElement: String, myIndex: int, myArr: Array): String
				{
					return myElement.substr(0, 1).toLocaleUpperCase() + myElement.substr(1);
				}
			).join(" ");
			
			return txt;
		}
	}
}