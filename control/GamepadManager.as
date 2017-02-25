/**
 * Created by Ben on 25/2/17.
 */
package volticpunk.control {
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.GameInputEvent;
    import flash.ui.GameInput;
    import flash.ui.GameInputDevice;

    public class GamepadManager {

        private var gameInput: GameInput;
        private var device: GamepadDeviceManager;
        private var stage: Stage;

        public function GamepadManager(stage: Stage) {
            this.stage = stage;
        }

        public function init(): void {

            if (!GameInput.isSupported) {
                throw new Error("Gamepad input is not supported!");
            }

            gameInput = new GameInput();
            gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, controllerAdded);
            gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, controllerRemoved);
            gameInput.addEventListener(GameInputEvent.DEVICE_UNUSABLE, controllerProblem);
        }

        /**
         * Call update on gamepad manager last
         */
        public function update(): void {
            device.update();
        }

        public function getDevice(index: int = 0): GamepadDeviceManager {
            if (index == 0) {
                return device;
            }

            throw Error("Only one device supported at this time.");
        }

        private function controllerAdded(e: GameInputEvent)
        {
            trace(GameInput.numDevices);//tells you how many gamepads are plugged in
            var myDevice = GameInput.getDeviceAt(0);//1st gamepad is "0" - more gamepads would be "1", "2", "3", etc.
            trace(myDevice.numControls); //tells you how many inputs/controls the device has
            myDevice.enabled = true; //enables the device
            var cont = myDevice.getControlAt(0);//input reference (AXIS STICK, BUTTON, TRIGGER, etc) "0" is the 1st input
            trace("id: "+cont.id);//the name of this control. Ex: "AXIS_0"
            trace("value: " + cont.value); //value of this control - Axis: -1 to 1, Button: 0 OR 1, Trigger: 0 to 1
            trace("cont: " + cont.device.name); //the name of the device. ie: "XBOX 360 Controller"
            trace("device: " + cont.device);
            trace("minValue: " + cont.minValue);//the minimum possible value for the control/input
            trace("maxValue: " + cont.maxValue);//the maximum possible value for the control/input

            configureDevice(myDevice);
        }

        private function configureDevice(device: GameInputDevice): void {
            this.device = new GamepadDeviceManager(device);
            this.device.init();
        }


        private function controllerRemoved(e: GameInputEvent)
        {
            //put code here to handle when a device is removed
        }


        private function controllerProblem(e: GameInputEvent)
        {
            //put code here to handle when there is a problem with the controller
        }
    }
}
