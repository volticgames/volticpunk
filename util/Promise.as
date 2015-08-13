package volticpunk.util
{
	public class Promise
	{
		private var callbacks: Vector.<Function>;
		private var errors: Vector.<Function>;
		
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
			for each (var f: Function in callbacks) {
				f();
			}
		}
		
		public function reject(): void {
			for each (var f: Function in errors) {
				f();
			}
		}
		
		
	}
}