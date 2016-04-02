package volticpunk.components
{
	public class CentreOnScreen extends Component
	{
		private var width: Number;
		private var height: Number;
		
		public function CentreOnScreen(width: Number = Number.NEGATIVE_INFINITY, height: Number = Number.NEGATIVE_INFINITY)
		{
			super();
			
			if (width == Number.NEGATIVE_INFINITY)
			{
				width = parent.width;
			}
			
			if (height == Number.NEGATIVE_INFINITY)
			{
				height = parent.height;
			}
			
			this.width = width;
			this.height = height;
		}
		
		public function centreX(): void
		{
			parent.x = (C.WIDTH - this.width) / 2;
		}
		
		public function centreY(): void
		{
			parent.y = (C.HEIGHT - this.height) / 2;
		}
		
		public function centre(): void
		{
			centreX();
			centreY();
		}
		
	}
}