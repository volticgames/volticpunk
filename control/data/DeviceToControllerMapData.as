/**
 * Created by Ben on 25/2/17.
 */
package volticpunk.control.data {
    import flash.system.Capabilities;
    import flash.ui.GameInputDevice;

    import volticpunk.control.data.GamepadControlsData;

    public class DeviceToControllerMapData {
        public function DeviceToControllerMapData() {
        }

        public static function map(device: GameInputDevice): Object {

            var data: Object =  GamepadControlsData.getControllerData();

            var os: String = Capabilities.os;
            var man: String = Capabilities.manufacturer;
            var ver: String = Capabilities.version;

            var platformKey: String = (Capabilities.os.indexOf("Mac") >= 0) ? "osx" : "windows";
            var platformSpecificData: Object = data["platforms"][platformKey]["gamepads"];

            for (var key: String in platformSpecificData) {
                // Filter controller by name
                for each (var filter: String in platformSpecificData[key].filters.name) {
                    if (device.name.indexOf(filter) >= 0) {
                        return platformSpecificData[key]
                    }
                }
            }

            return null;
        }
    }
}
