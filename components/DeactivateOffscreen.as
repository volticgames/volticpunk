package volticpunk.components
{
	import net.flashpunk.FP;

	public class DeactivateOffscreen extends Component
	{
		private var width: Number;
		private var height: Number;
		private var shouldUpdate: Boolean = true;
		
		private var activationDistance: Number;
		
		public function DeactivateOffscreen(width: Number, height: Number, activationDistance: Number)
		{
			super();
			
			this.width = width;
			this.height = height;
			this.activationDistance = activationDistance;
		}
		
		public function shouldBeActive(): Boolean {
			return shouldUpdate;
		}
		
		override public function update():void {
			super.update();
			
			if (parent.x < FP.camera.x + width + activationDistance &&
				parent.x > FP.camera.x - activationDistance &&
				parent.y > FP.camera.y - activationDistance &&
				parent.y < FP.camera.y + height + activationDistance) {
				
				shouldUpdate = true;
				parent.visible = true;
			} else {
				shouldUpdate = false;
				parent.visible = false;
			}
		}
	}
}