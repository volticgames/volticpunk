/**
 * Created by Ben on 25/2/17.
 */
package volticpunk.control.bindings {
    public class Button implements IControlBinding {

        private var pressedThisFrame: Boolean = false;
        private var releasedThisFrame: Boolean = false;
        private var currentlyHeld: Boolean = false;

        public function Button() {

        }

        public function getPressed(): Boolean {
            return pressedThisFrame;
        }

        public function getReleased(): Boolean {
            return releasedThisFrame;
        }

        public function getHeld(): Boolean {
            return currentlyHeld;
        }

        public function onReset(): void {
            pressedThisFrame = false;
            releasedThisFrame = false;
        }

        public function update(val: Number): void {
            if (!pressedThisFrame) {
                pressedThisFrame = val == 1;
            }

            if (!releasedThisFrame) {
                releasedThisFrame = val == 0;
            }

            currentlyHeld = val == 1;
        }
    }
}
