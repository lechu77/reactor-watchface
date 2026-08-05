import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class ReactorApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // New settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, WatchUi.InputDelegates] {
        return [ new ReactorView() ];
    }

    // On-device settings: shows "Customize" in the watch face long-press menu
    function getSettingsView() as [Views] or [Views, WatchUi.InputDelegates] or Null {
        return [ new ReactorSettingsMenu(), new ReactorSettingsDelegate() ];
    }

}

function getApp() as ReactorApp {
    return Application.getApp() as ReactorApp;
}
