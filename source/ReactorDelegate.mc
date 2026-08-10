import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class ReactorDelegate extends WatchUi.WatchFaceDelegate {

    private var _themeConfig as Theme.ThemeConfig;

    function initialize(themeConfig as Theme.ThemeConfig) {
        WatchFaceDelegate.initialize();
        _themeConfig = themeConfig;
    }

    function onPress(clickEvent as WatchUi.ClickEvent) as Boolean {
        if (!(Toybox has :Complications)) {
            return false;
        }

        var coords = clickEvent.getCoordinates();
        var x = coords[0];
        var y = coords[1];

        // 1. Check Flanks (Y: 143 to 295 approx)
        if (y > 140 && y < 300) {
            if (x < 70) {
                // Left Flank
                return launchComplication(_themeConfig.leftFlankSlot);
            } else if (x > 380) {
                // Right Flank
                return launchComplication(_themeConfig.rightFlankSlot);
            }
        }

        // 2. Check Bottom Slots (Y: 340 to 410 approx)
        if (y > 330 && y < 420) {
            var colW = 74;
            var innerLeft = 78;
            if (x > innerLeft && x < innerLeft + colW) {
                return launchComplication(Toybox.Application.Properties.getValue("bottomSlot1") as Number);
            } else if (x > innerLeft + colW && x < innerLeft + colW * 2) {
                return launchComplication(Toybox.Application.Properties.getValue("bottomSlot2") as Number);
            } else if (x > innerLeft + colW * 2 && x < innerLeft + colW * 3) {
                return launchComplication(Toybox.Application.Properties.getValue("bottomSlot3") as Number);
            } else if (x > innerLeft + colW * 3 && x < innerLeft + colW * 4) {
                return launchComplication(Toybox.Application.Properties.getValue("bottomSlot4") as Number);
            }
        }

        return false;
    }

    private function launchComplication(metricId as Number) as Boolean {
        var compId = getComplicationId(metricId);
        if (compId != null) {
            try {
                var id = new Toybox.Complications.Id(compId as Toybox.Complications.Type);
                Toybox.Complications.exitTo(id);
                return true;
            } catch (e) {
                return false;
            }
        }
        return false;
    }

    private function getComplicationId(metricId as Number) as Toybox.Complications.Type? {
        if (metricId == MetricSlot.STEPS) { return Toybox.Complications.COMPLICATION_TYPE_STEPS; }
        if (metricId == MetricSlot.CALORIES) { return Toybox.Complications.COMPLICATION_TYPE_CALORIES; }
        if (metricId == MetricSlot.HEARTRATE) { return Toybox.Complications.COMPLICATION_TYPE_HEART_RATE; }
        if (metricId == MetricSlot.BATTERY) { return Toybox.Complications.COMPLICATION_TYPE_BATTERY; }
        if (metricId == MetricSlot.FLOORS) { return Toybox.Complications.COMPLICATION_TYPE_FLOORS_CLIMBED; }
        if (metricId == MetricSlot.INTENSITY_MINUTES) { return Toybox.Complications.COMPLICATION_TYPE_INTENSITY_MINUTES; }
        if (metricId == MetricSlot.STRESS) { return Toybox.Complications.COMPLICATION_TYPE_STRESS; }
        if (metricId == MetricSlot.BODY_BATTERY) { return Toybox.Complications.COMPLICATION_TYPE_BODY_BATTERY; }
        if (metricId == MetricSlot.TRAINING_STATUS) { return Toybox.Complications.COMPLICATION_TYPE_TRAINING_STATUS; }
        if (metricId == MetricSlot.RECOVERY_TIME) { return Toybox.Complications.COMPLICATION_TYPE_RECOVERY_TIME; }
        
        return null;
    }
}
