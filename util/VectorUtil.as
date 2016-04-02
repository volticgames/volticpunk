/**
 * Created by Ben on 2/04/2016.
 */
package volticpunk.util {
    public class VectorUtil {
        public static function toArray(iterable:*):Array {
            var ret:Array = [];
            for each (var elem:* in iterable) ret.push(elem);
            return ret;
        }
    }
}
