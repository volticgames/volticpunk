/**
 * Created with IntelliJ IDEA.
 * User: Ben
 * Date: 18/11/2013
 * Time: 12:36 PM
 * To change this template use File | Settings | File Templates.
 */
package volticpunk.components {
import net.flashpunk.graphics.Anim;
import net.flashpunk.graphics.Spritemap;

import volticpunk.util.AnimationLoader;

public class Animator extends Component {

    private var spritemap:Spritemap;
    private var callbacks:Object;
	private var animationLoader:AnimationLoader;

    public function Animator(image:Class, width:uint, height:uint, xmlFile:Class = null, callbacks:Object = null) {

        super();

        spritemap = new Spritemap(image, width, height, animationEnded);
        this.callbacks = callbacks;

		if (xmlFile != null)
		{
			animationLoader = new AnimationLoader(xmlFile, width, height, spritemap.columns, spritemap.rows);
		}
    }
	
	public function getSpritemap(): Spritemap
	{
		return spritemap;
	}
	
	public function setFlipped(yes:Boolean):Boolean
	{
		spritemap.flipped = yes;
		return yes;
	}
	
	public function pauseAnim(): void
	{
		spritemap.rate = 0;
	}
	
	public function unpauseAnim(): void
	{
		spritemap.rate = 1;
	}
	
	public function setAnimFrame(name: String, frame: int): void
	{
		spritemap.setAnimFrame(name, frame);
	}
	
	public function loadAnimation(loadName:String, animName:String, frameRate:Number, loop:Boolean = false):void
	{
		if (animationLoader != null)
		{
			spritemap.add(animName, animationLoader.loadAnimationFrames(loadName), frameRate, loop);
		} else {
			throw new Error("Animation Loader is not initialised");
		}
	}
	
	public function getFrame(name:String, frame:int):int
	{
		if (animationLoader != null)
		{
			return animationLoader.getFrame(name, frame);
		} else {
			throw new Error("Animation Loader is not initialised");
		}
	}
	
	override public function getName():String
	{
		return "animator";
	}
	
	public function getLoader():AnimationLoader
	{
		return animationLoader;
	}

    public function getImage():Spritemap
    {
        return spritemap;
    }

    public function add(name:String, frames:Array, framerate:Number = 0, loop:Boolean = true):Anim
    {
        return spritemap.add(name, frames, framerate, loop);
    }

    public function play(name:String, reset:Boolean = false, frame:uint = 0):Anim
    {
        return spritemap.play(name, reset, frame);
    }

    override public function added():void
    {
        parent.graphic = spritemap;
    }

    private function animationEnded():void
    {
        if (callbacks != null) {
			if ( callbacks[spritemap.currentAnim] != null)
			{
				callbacks[spritemap.currentAnim]();
			}
		}
    }
}
}
