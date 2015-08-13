package volticpunk.util
{
	public class ConditionAsync
	{
		private var toExecute: Function;
		
		public function ConditionAsync(initial: Function = null)
		{
			toExecute = initial;
			
			if (toExecute == null) {
				toExecute = function(): Boolean {
					return true;
				}
			}
		}
		
		public function and(bool: Boolean): ConditionAsync {
						
			return new ConditionAsync(function(): Boolean {
				return (toExecute() && function(): Boolean { return bool });
			});
		}
		
		public function also(cond: ConditionAsync): ConditionAsync {
			
			return new ConditionAsync(function(): Boolean {
				return (toExecute() && cond.eval());
			});
		}
		
		public function or(bool: Boolean): ConditionAsync {
			return new ConditionAsync(function(): Boolean {
				return (toExecute() || function(): Boolean { return bool });
			});
		}
		
		public function alternatively(cond: ConditionAsync): ConditionAsync {
			return new ConditionAsync(function(): Boolean {
				return (toExecute() || cond.eval());
			});
		}
		
		public function eval(): Boolean {
			return toExecute();
		}
	}
}