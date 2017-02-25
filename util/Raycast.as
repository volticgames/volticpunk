package volticpunk.util
{
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.masks.Hitbox;
	
	import volticpunk.V;

	public class Raycast
	{
		private static var e: Entity;
		public static var MAX_INTERATIONS: uint = 100;
		
		public static function castToPoint(types: Array, xStart: Number, yStart: Number, xEnd: Number, yEnd: Number, stepSize: uint = 2): RaycastResult {
			return castToAngle(types, xStart, yStart, FP.angle(xStart, yStart, xEnd, yEnd), FP.distance(xStart, yStart, xEnd, yEnd), stepSize);
		}
		
		public static function castToAngle(types: Array, xStart: Number, yStart: Number, angle: Number, distance: Number, stepSize: uint = 2): RaycastResult {
		
			var iters: uint = 0;
			var px: Number = xStart;
			var py: Number = yStart;
			var e: Entity;
			
			angle *= -1;
			
			while (iters < MAX_INTERATIONS) {
				iters++;
				
				px += stepSize * Math.cos(angle * Math.PI / 180);
				py += stepSize * Math.sin(angle * Math.PI / 180);
				
				e = step(types, px, py);
				if (e) {
					break;
				}
				
				if ( Math.abs(FP.distance(xStart, yStart, px, py)) > Math.abs(distance)) {
					break;
				}
			}
			
			var timedOut: Boolean = false;
			var reached: Boolean = true;
			
			if ( Math.abs(FP.distance(xStart, yStart, px, py)) > Math.abs(distance)) {
				reached = true;
			} else {
				timedOut = true;
			}
			
			var result: RaycastResult = new RaycastResult();
			
			result.wasBlocked = (e !== null);
			result.blockedBy = e;
			result.finalPosition = new Point(px, py);
			result.timedOut = timedOut;
			result.reachedDestination = reached;
			return result;
		}
		
		private static function step(types: Array, px: Number, py: Number): Entity {
			
			return getEntity().collideTypes(types, px, py);
		}
		
		private static function getEntity(): Entity {
			
			if (e == null) {
				e = new Entity();
				e.mask = new Hitbox(1, 1);	
			}
			
			if (e.world != V.getRoom()) {
				if (e.world != null) e.world.remove(e);
				V.getRoom().add(e);
			}
			
			return e;
		}
	}
}