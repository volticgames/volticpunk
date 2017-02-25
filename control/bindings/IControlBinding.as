/**
 * Created by Ben on 25/2/17.
 */
package volticpunk.control.bindings {
    public interface IControlBinding {
        function onReset(): void;

        function update(val: Number): void;
    }
}
