package volticpunk
{
	import com.alexomara.ane.AIRControl.AIRControl;
	import com.alexomara.ane.AIRControl.events.AIRControlControllerEvent;
	import com.alexomara.ane.AIRControl.events.AIRControlEvent;

	public class ControlManager
	{		
		private var inputMap: Object;
		
		public function ControlManager()
		{
			inputMap = {};
		}
		
		public function bindAirControlEvents(): void {
			
			trace("Binding controller events");
			trace(AIRControl.controllersTotal);
			
			if (AIRControl.controllersTotal > 0) {
				
			}
			
			AIRControl.addEventListener(AIRControlEvent.CONTROLLER_ATTACH, onControlledAttached); 
		}
		
		private function onControlledAttached(e: AIRControlEvent): void {
			trace("Controller Attached!");
			trace(e);
		}
		
		public function addBinding(key: String): void {
			inputMap[key] = inputMap[key] || [];
			
			
		}
	}
}