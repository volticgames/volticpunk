package volticpunk.components
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;

	public class RandomFlasher extends Component
	{
		private var tweener: Tweener;
		
		private var timer: Number = 0;
		private var goal: Number = 0;
		private var randomFactor: Number;
		private var minDuration: Number;
		
		public function RandomFlasher(randomFactor: Number = 0.6, minDuration: Number = 0.1)
		{
			super();
			
			this.randomFactor = randomFactor;
			this.minDuration = minDuration;
		}
		
		override public function added():void
		{
			super.added();
			
			tweener = parent.addComponent( new Tweener(), "random_tweener" ) as Tweener;
		}
		
		override public function getName():String
		{
			return "random_flasher";
		}
		
		override public function update():void
		{
			var img: Image = parent.graphic as Image;
			
			timer += FP.elapsed;
			
			if (timer > goal)
			{
				goal = Math.random() * randomFactor + minDuration;
				timer = 0;
				
				tweener.tween(img, {alpha: Math.random()}, minDuration);
			}
		}
	}
}