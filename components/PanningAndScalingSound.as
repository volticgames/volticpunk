/**
 * Created with IntelliJ IDEA.
 * User: Ben
 * Date: 18/11/2013
 * Time: 2:46 PM
 * To change this template use File | Settings | File Templates.
 */
package volticpunk.components {
import net.flashpunk.FP;
import net.flashpunk.Sfx;

import volticpunk.util.Constrain;

import volticpunk.util.Range;

public class PanningAndScalingSound extends Component {

    private var sound:Sfx;
    private var minVol:Number;
    private var maxVol:Number;

    public function PanningAndScalingSound(sound:Class, maxVol:Number = 1, minVol:Number = 0) {

        this.sound = new Sfx(sound);

        this.minVol = minVol;
        this.maxVol = maxVol;

    }

    override public function update():void
    {

        sound.volume = 1.0 / ( parent.distanceToPoint(FP.camera.x + C.WIDTH / 2, FP.camera.y + C.HEIGHT / 2) / 50.0 );

        sound.volume = Constrain.constrain(sound.volume, minVol, maxVol);

        sound.pan = (parent.x - (FP.camera.x + C.WIDTH)) / 300.0;
    }

    public function play():void
    {
        Proof.getSound().play(sound, sound.volume, sound.pan);
    }

    public function loop():void
    {
        Proof.getSound().loop(sound, sound.volume, sound.pan);
    }

    public function stop():void
    {
        Proof.getSound().stop(sound);
    }
}
}
