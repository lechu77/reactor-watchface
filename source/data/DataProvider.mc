import Toybox.ActivityMonitor;
import Toybox.Lang;
import Toybox.SensorHistory;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;

class DataProvider {

    // Pre-allocated metrics data structure to avoid allocations in update loop
    public var hours as Number = 0;
    public var minutes as Number = 0;
    public var seconds as Number = 0;
    public var is24Hour as Boolean = true;
    public var ampm as String = "AM";
    
    public var dayName as String = "MAR";
    public var dayNumber as String = "04";
    public var monthName as String = "AGO";
    
    public var batteryPercent as Number = 100;
    public var heartRate as Number = 0;
    public var stressLevel as Number = 0;
    
    public var steps as Number = 0;
    public var distanceValue as Float = 0.0;  // in device units (km or mi)
    public var distanceUnit as String = "km"; // "km" or "mi"
    public var distanceKm as Float = 0.0;     // always km (legacy, kept for compatibility)
    public var calories as Number = 0;
    public var floorsClimbed as Number = 0;

    private var _months as Array<String> = ["ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO", "SEP", "OCT", "NOV", "DIC"];
    private var _days as Array<String> = ["DOM", "LUN", "MAR", "MIE", "JUE", "VIE", "SAB"];

    function initialize() {
    }

    function updateMetrics() as Void {
        // Time & Date
        var clockTime = System.getClockTime();
        hours = clockTime.hour;
        minutes = clockTime.min;
        seconds = clockTime.sec;
        is24Hour = System.getDeviceSettings().is24Hour;
        
        if (!is24Hour) {
            ampm = (hours >= 12) ? "PM" : "AM";
            hours = hours % 12;
            if (hours == 0) {
                hours = 12;
            }
        } else {
            ampm = "";
        }

        var now = Time.now();
        var dateInfo = Gregorian.info(now, Time.FORMAT_SHORT);
        
        var dow = dateInfo.day_of_week;
        if (dow != null) {
            var dayIdx = (dow as Number) - 1;
            if (dayIdx >= 0 && dayIdx < _days.size()) {
                dayName = _days[dayIdx];
            }
        }
        
        var m = dateInfo.month;
        if (m != null) {
            var monthIdx = (m as Number) - 1;
            if (monthIdx >= 0 && monthIdx < _months.size()) {
                monthName = _months[monthIdx];
            }
        }
        
        var d = dateInfo.day;
        if (d != null) {
            dayNumber = (d as Number).format("%02d");
        }

        // Battery
        var sysStats = System.getSystemStats();
        if (sysStats != null && sysStats.battery != null) {
            batteryPercent = (sysStats.battery as Float).toNumber();
        }

        // Activity Monitor Metrics
        var actInfo = ActivityMonitor.getInfo();
        if (actInfo != null) {
            var st = actInfo.steps;
            if (st != null) {
                steps = st as Number;
            }
            var dist = actInfo.distance;
            if (dist != null) {
                var distCm = (dist as Number).toFloat();
                distanceKm = distCm / 100000.0; // cm → km always
                // Use device unit system
                var devSettings = System.getDeviceSettings();
                if (devSettings != null && devSettings.distanceUnits == System.UNIT_STATUTE) {
                    distanceValue = distCm / 160934.0; // cm → miles
                    distanceUnit = "mi";
                } else {
                    distanceValue = distCm / 100000.0; // cm → km
                    distanceUnit = "km";
                }
            }
            var cal = actInfo.calories;
            if (cal != null) {
                calories = cal as Number;
            }
            var fl = actInfo.floorsClimbed;
            if (fl != null) {
                floorsClimbed = fl as Number;
            }
        }

        // Heart Rate
        var hrIter = ActivityMonitor.getHeartRateHistory(1, true);
        if (hrIter != null) {
            var sample = hrIter.next();
            if (sample != null) {
                var hrVal = sample.heartRate;
                if (hrVal != null && hrVal != ActivityMonitor.INVALID_HR_SAMPLE) {
                    heartRate = (hrVal as Number);
                }
            }
        }

        // Stress Level
        if (Toybox has :SensorHistory && SensorHistory has :getStressHistory) {
            var stressIter = SensorHistory.getStressHistory({:period => 1, :order => SensorHistory.ORDER_NEWEST_FIRST});
            if (stressIter != null) {
                var stressSample = stressIter.next();
                if (stressSample != null) {
                    var sData = stressSample.data;
                    if (sData != null) {
                        stressLevel = (sData as Number);
                    }
                }
            }
        }
    }
}
