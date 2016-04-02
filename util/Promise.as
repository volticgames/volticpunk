package volticpunk.util
{
	public class Promise
	{
		private var callbacks: Vector.<Function>;
		private var errors: Vector.<Function>;
		private var isResolved: Boolean = false;
		private var isRejected: Boolean = false;
		
		public function Promise()
		{
			callbacks = new Vector.<Function>();	
			errors = new Vector.<Function>();	
		}
		
		public function error(f: Function): Promise {
			errors.push(f);
			return this;
		}
		
		public function then(f: Function): Promise {
			callbacks.push(f);
			return this;
		}
		
		public function and(p: Promise): Promise {
			return p;
		}
		
		public function resolve(): void {
			if (isResolved) {
				return;
			}
			
			for each (var f: Function in callbacks) {
				f();
			}
			
			isResolved = true;
		}
		
		public function reject(): void {
			if (isRejected) {
				return;
			}
			
			for each (var f: Function in errors) {
				f();
			}
			
			isRejected = true;
		}
		
		
	}
}