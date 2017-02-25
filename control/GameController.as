/**
 * Created by Ben on 25/2/17.
 */
package volticpunk.control {
    import flash.events.Event;
    import flash.geom.Point;
    import flash.ui.GameInputControl;
    import flash.ui.GameInputDevice;

    import volticpunk.control.bindings.Axis;

    import volticpunk.control.bindings.Button;
    import volticpunk.control.bindings.IControlBinding;
    import volticpunk.control.data.DeviceToControllerMapData;

    public class GameController {

        private var rawControls: Object;
        private var controls: Object;

        private var nullButton: Button;
        private var nullAxis: Axis;

        private var mapping: Object;

        public function GameController(device: GameInputDevice) {
            rawControls = {};
            controls = {};

            nullButton = new Button();
            nullAxis = new Axis();

            mapping = DeviceToControllerMapData.map(device);
        }

        public function getControl(key: String): IControlBinding {
            return controls[key];
        }

        public function getButton(key: String): Button {

            if (!getControl(key)) return nullButton;

            return getControl(key) as Button;
        }

        public function getAxis(key: String): Axis {

            if (!getControl(key)) return nullAxis;

            return getControl(key) as Axis;
        }

        private function storeControlValue(id: String, val: Number): void {

            if (!mapping.controls[id]) {
                throw new Error("Unmappable control ID: " + id);
            }

            rawControls[mapping.controls[id].target] = val;

            var binding: IControlBinding = controls[mapping.controls[id].target];

            // No rich binding yet
            if (!binding) {
                if (id.indexOf("AXIS") >= 0) {
                    binding = new Axis();
                } else {
                    binding = new Button();
                }
            }

            binding.update(val);
            controls[mapping.controls[id].target] = binding;
        }

        public function map(e: Event, control: GameInputControl): void {
            storeControlValue(control.id, control.value);
        }

        public function onReset(): void {
            for (var key: String in controls) {
                (controls[key] as IControlBinding).onReset();
            }
        }

    }
}
