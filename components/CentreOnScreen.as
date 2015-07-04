package volticpunk.components
{
	public class CentreOnScreen extends Component
	{
		private var width: Number;
		private var height: Number;
		
		public function CentreOnScreen(width: Number = Number.NaN, height: Number = Number.NaN)
		{
			super();
			
			if (width == Number.NaN)
			{
				width = parent.width;
			}
			
			if (height == Number.NaN)
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