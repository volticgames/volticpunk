package volticpunk.util
{
	public class Condition
	{
		private var currentResult: Boolean;
		
		public function Condition(initial: Boolean = true)
		{
			currentResult = initial;
		}
		
		public function and(bool: Boolean): Condition {
			return new Condition(currentResult && bool);
		}
		
		public function also(cond: Condition): Condition {
			return new Condition(cond.eval() && currentResult);
		}
		
		public function or(bool: Boolean): Condition {
			return new Condition(currentResult || bool);
		}
		
		public function alternatively(cond: Condition): Condition {
			return new Condition(cond.eval() || currentResult);
		}
		
		public function eval(): Boolean {
			return currentResult;
		}
	}
}