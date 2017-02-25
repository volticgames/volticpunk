/**
 * Created by Ben on 25/2/17.
 */
package volticpunk.control {
    import flash.events.Event;
    import flash.ui.GameInputControl;
    import flash.ui.GameInputDevice;

    public class GamepadDeviceManager {

        private var device: GameInputDevice;
        private var deviceMap: GameController;

        public function GamepadDeviceManager(device: GameInputDevice) {
            this.device = device;
            this.deviceMap = new GameController(device);
        }

        public function init(): void {

            var control: GameInputControl;

            for(var i:Number = 0; i<device.numControls; ++i){
                control = device.getControlAt(i);
                control.addEventListener(Event.CHANGE, onControlChange);//capture change
                //what buttons does it have (names)
                trace("CONTROLS: "+control.id);
            }
        }

        public function getController(): GameController {
            return deviceMap;
        }

        public function update(): void {
            deviceMap.onReset();
        }

        private function onControlChange(event: Event): void {
            var control: GameInputControl = event.target as GameInputControl;
            //To get the value of the press you can use .value, or minValue and maxValue for on/off
            //var num_val:Number = control.value;
            //
            //constant stream (Axis is very sensitive)
            //trace("control.id=" + control.id);
            //trace("control.value=" + control.value + " (" + control.minValue+" .. " + control.maxValue+")");
            //
            //trace just on/off to see each button
            if (control.value >= control.maxValue){
                trace("control.id=" + control.id +" has been pressed");
            }

            deviceMap.map(event, control);
        }
    }
}
