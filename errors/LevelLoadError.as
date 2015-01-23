package volticpunk.errors
{
	public class LevelLoadError extends Error
	{
		public function LevelLoadError(message:*="", id:*=0)
		{
			super(message, id);
		}
	}
}