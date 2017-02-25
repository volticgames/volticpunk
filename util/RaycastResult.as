package volticpunk.util
{
	import flash.geom.Point;
	
	import net.flashpunk.Entity;

	public class RaycastResult
	{
		public var wasBlocked: Boolean;
		public var blockedBy: Entity;
		public var finalPosition: Point;
		public var timedOut: Boolean;
		public var reachedDestination: Boolean;
		
		public function RaycastResult()
		{
		}
	}
}