package volticpunk.components
{
	import net.flashpunk.tweens.misc.MultiVarTween;

	public class Tweener extends Component
	{
		
		private var tweener:MultiVarTween;
		
		public function Tweener(callback:Function = null)
		{
			super();
			
			tweener = new MultiVarTween(callback);
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
			tweener.tween(object, values, duration, ease, delay);
		}
		
		public function getCompletion():Number
		{
			return tweener.percent;
		}
	}
}