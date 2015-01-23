/**
 * Created with IntelliJ IDEA.
 * User: Ben
 * Date: 3/11/13
 * Time: 6:43 PM
 * To change this template use File | Settings | File Templates.
 */
package volticpunk.components {

    public class PrintComponent extends Component {
        public function PrintComponent() {
        }

        override public function added():void
        {
            log("Added Component");
        }

        override public function update():void
        {
            log("Updated Component");
        }

        override public function removed():void
        {
            log("Removed Component");
        }

        public function testPrint():void
        {
            log("DDDDDDD");
        }
    }
}
