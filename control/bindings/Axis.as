/**
 * Created by Ben on 25/2/17.
 */
package volticpunk.control.bindings {
    public class Axis implements IControlBinding {

        private var value: Number;

        public static const DEADZONE: Number = 0.2;

        public function Axis() {

        }

        public function getValue(): Number {
            if (Math.abs(value) > Axis.DEADZONE) {
                return value;
            }

            return 0;
        }

        public function onReset(): void {

        }

        public function update(val: Number): void {
            value = val;
        }
    }
}
