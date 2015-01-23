/**
 * Created with IntelliJ IDEA.
 * User: Ben
 * Date: 3/11/13
 * Time: 6:31 PM
 * To change this template use File | Settings | File Templates.
 */
package volticpunk.components {
import net.flashpunk.Entity;
import net.flashpunk.World;

import volticpunk.util.Logger;
import volticpunk.entities.VEntity;

public class Component {

        public var parent:VEntity;

        public function Component() {
        }

		protected function log(...args): void
		{
			if (Logger.enabled)
			{
				Logger.log(this + "(Component)", args);
			}
			
		}
		
        public function added():void
        {

        }
		
		public function getName():String
		{
			return "";
		}

        public function update():void
        {

        }

        public function removed():void
        {

        }

        public function addedToWorld():void
        {

        }

        public function removedFromWorld():void
        {

        }

        public function getWorld():World
        {
            return parent.world;
        }


    }
}
