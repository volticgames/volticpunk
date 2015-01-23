/**
 * Created with IntelliJ IDEA.
 * User: Ben
 * Date: 18/11/2013
 * Time: 12:58 PM
 * To change this template use File | Settings | File Templates.
 */
package volticpunk.components {
import flash.geom.Point;

public class ArcAndFade extends Component {

    private var velocity:Point;

    public function ArcAndFade(xvel:Number, yvel:Number) {
        velocity = new Point(xvel, yvel);
    }

    public function setVelocity(xvel:Number, yvel:Number):void
    {
        velocity = new Point(xvel, yvel);
    }

    override public function update():void
    {
        velocity.y += 0.05;

        parent.x += velocity.x;
        parent.y += velocity.y;
    }
}
}
