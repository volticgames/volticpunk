package volticpunk.components
{
	import net.flashpunk.FP;
	import net.flashpunk.tweens.misc.MultiVarTween;
	
	public class Tweener extends Component
	{
		
		private var tweener:MultiVarTween;
		private var frameDependent: Boolean;
		
		public function Tweener(callback:Function = null, convertTimeToFrames: Boolean = false)
		{
			super();
			
			tweener = new MultiVarTween(callback);
			this.frameDependent = convertTimeToFrames;
		}
		
		override public function getName():String
		{
			return "tweener";
		}
		
		public function cancel(): void
		{
			tweener.cancel();
			parent.addTween(tweener);
		}
		
		public function pause(): void
		{
			tweener.active = false;
		}
		
		public function unpause(): void
		{
			tweener.active = true;
		}
		
		override public function added():void
		{
			parent.addTween(tweener);
		}
		
		public function isActive(): Boolean
		{
			return tweener.active;
		}
		
		override public function removed():void
		{
			parent.removeTween(tweener);
		}
		
		public function setCallback(f:Function):void
		{
			tweener.complete = f;
		}
		
		public function tween(object:Object, values:Object, duration:Number, ease:Function = null, delay:Number = 0):void
		{
			if (frameDependent)
			{
				trace(FP.frameRate);
				tweener.tween(object, values, duration / FP.frameRate, ease, delay);
			} else {
				tweener.tween(object, values, duration, ease, delay);	
			}
			
		}
		
		public function getCompletion():Number
		{
			return tweener.percent;
		}
	}
}
import volticpunk.components;

