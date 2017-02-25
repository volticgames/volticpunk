/**
 * Created by Ben on 20/1/17.
 */
package volticpunk.util {
    import flash.geom.Point;

    import net.flashpunk.FP;

    public class Line {

        private var startPoint: Point;
        private var endPoint: Point;

        public static const MAX_GRADIENT: Number = 100000;

        public function Line(x1: Number, y1: Number, x2: Number, y2: Number) {
            startPoint = new Point(x1, y1);
            endPoint = new Point(x2, y2);
        }

        public function getLength(): Number {
            return FP.distance(startPoint.x, startPoint.y, endPoint.x, endPoint.y);
        }

        public function getGradient(): Number {
            if (startPoint.x == endPoint.x) return MAX_GRADIENT;

            return (endPoint.y - startPoint.y) / (endPoint.x - startPoint.x);
        }

        public function sameGradient(l: Line): Boolean {
            return (Math.abs(l.getGradient() - getGradient()) < 0.0001);
        }

        public function getStart(): Point {
            return startPoint;
        }

        public function getEnd(): Point {
            return endPoint;
        }
    }
}
