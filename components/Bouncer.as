/**
 * Created with IntelliJ IDEA.
 * User: Ben
 * Date: 18/11/2013
 * Time: 12:47 PM
 * To change this template use File | Settings | File Templates.
 */
package volticpunk.components {
import flash.geom.Point;

import net.flashpunk.FP;

import volticpunk.util.ScreenUtil;

public class Bouncer extends Component {

    private var velocity:Point;
	
	private var paused: Boolean = false;

	private var bounceCallback: Function;
	
    public function Bouncer(xvel:Number, yvel:Number) {

        velocity = new Point(xvel, yvel);

    }
	
	public function pause(): void
	{
		paused = true;
	}
	
	public function unpause(): void
	{
		paused = false;
	}
	
	public function isPaused(): Boolean
	{
		return paused;
	}
	
	public function setBounceCallback(f: Function): void
	{
		this.bounceCallback = f;
	}

    override public function update():void
    {
		super.update();
		
		if (!paused)
		{
			
	        parent.x += velocity.x * FP.elapsed * 60;
	        parent.y += velocity.y * FP.elapsed * 60;
	
	        velocity.y += 0.1 * FP.elapsed * 60;
	
	        if (parent.collideTypes(C.COLLISION_TYPES, parent.x, parent.y + 1))
	        {
	            parent.y -= velocity.y * 2;
				velocity.x *= 0.75;
	            velocity.y *= -0.5;
	            if (Math.abs(velocity.y) < 0.5) getWorld().remove(parent);
				else {
					if (bounceCallback != null)
					{
						bounceCallback();
					}
				}
				
	        }
			
			if (parent.collideTypes(C.COLLISION_TYPES, parent.x + 1, parent.y) || parent.collideTypes(C.COLLISION_TYPES, parent.x - 1, parent.y))
			{
				parent.x -= velocity.x * 2;
				velocity.x *= -0.1;
			}
			
			if (!ScreenUtil.onScreen(parent.x, parent.y))
			{
				getWorld().remove(parent);
			}
		
		}
    }
}
}
