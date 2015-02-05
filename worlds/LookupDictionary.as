package volticpunk.worlds
{
	/**
	 * Entity lookup class, creates entities on level load 
	 */	
	import flash.utils.getDefinitionByName;
	
	import entities.loadable.E;
	
	import net.flashpunk.World;
	
	import volticpunk.errors.LevelLoadError;

	public class LookupDictionary
	{
		public var dict:Object = new Object();

		public function LookupDictionary()
		{
		}
		
		
		public function create(n:XML, world:World):void
		{
			// DO NOT DELETE, forces import of all classes
			E;
			
			var c: Class;
			
			if (dict[n.name()])
			{
				var lookup: Object = dict[n.name()];
				
				if (lookup is Function)
				{
					try {
						lookup(n, world);
					} catch (e: Error)
					{
						throw new LevelLoadError("Load Error when calling custom function." + e.message);
					}
					
				} else {
					c = lookup as Class;
					c.create(n, world);
				}
			} else {
				try {
					
					var name: String = "entities.loadable." + n.name();
					trace("Loading... " + name);
					c = getDefinitionByName(name) as Class;	
					
				} catch (e: Error)
				{
					throw new LevelLoadError("Load Error when dynamically searching for class, did you forget to put your entity in entities.loadable? or did you forget to run Generate Entities? \n" + e.message);
				}
				
				try {
					trace("Class: " + c);
					c.create(n, world);
					trace("Called.");
				} catch (e: Error)
				{
					throw new LevelLoadError("Load error when calling create() on a class, have you created a load handler? " + e.name + ": " + e.message + "(" + e.getStackTrace() + ")");
				}
			}
			
			
			
		}
	}
}