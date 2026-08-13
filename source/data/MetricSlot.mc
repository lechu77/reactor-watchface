import Toybox.Lang;
import Toybox.System;

module MetricSlot {

    // Metric ID constants
    const STEPS                 = 0;
    const DISTANCE              = 1;
    const CALORIES              = 2;
    const FLOORS                = 3;
    const HEARTRATE             = 4;
    const STRESS                = 5;
    const BATTERY               = 6;
    const SECONDS               = 7;
    const TIME                  = 8;
    const DATE                  = 9;
    const BODY_BATTERY          = 10;
    const HRV                   = 11;
    const RESTING_HR            = 12;
    const PULSE_OX              = 13;
    const TRAINING_READINESS    = 14;
    const RECOVERY_TIME         = 15;
    const VO2_MAX               = 16;
    const TRAINING_STATUS       = 17;
    const ACUTE_LOAD            = 18;
    const ENDURANCE_SCORE       = 19;
    const HILL_SCORE            = 20;
    const INTENSITY_MINUTES     = 21;
    const ALTITUDE              = 22;
    const TEMPERATURE           = 23;
    const WEATHER               = 24;
    const SUNRISE               = 25;
    const SUNSET                = 26;
    const MOON_PHASE            = 27;
    const PHONE_BATTERY         = 28;
    const BLUETOOTH             = 29;



    function getIconString(metricId as Number) as String {
        var charCode = 0xE536; // fallback directions_walk
        if (metricId == STEPS)                      { charCode = 0xE536; }
        else if (metricId == DISTANCE)              { charCode = 0xE55F; }
        else if (metricId == CALORIES)              { charCode = 0xEF55; }
        else if (metricId == FLOORS)                { charCode = 0xF1A9; }
        else if (metricId == HEARTRATE)             { charCode = 0xE87D; }
        else if (metricId == STRESS)                { charCode = 0xEA0B; }
        else if (metricId == BATTERY)               { charCode = 0xE1A4; }
        else if (metricId == SECONDS)               { charCode = 0xE425; }
        else if (metricId == TIME)                  { charCode = 0xE192; }
        else if (metricId == DATE)                  { charCode = 0xE935; }
        else if (metricId == BODY_BATTERY)          { charCode = 0xE1A3; }
        else if (metricId == HRV)                   { charCode = 0xEAA2; }
        else if (metricId == RESTING_HR)            { charCode = 0xEF44; }
        else if (metricId == PULSE_OX)              { charCode = 0xEFE4; }
        else if (metricId == TRAINING_READINESS)    { charCode = 0xF0CF; }
        else if (metricId == RECOVERY_TIME)         { charCode = 0xE8B3; }
        else if (metricId == VO2_MAX)               { charCode = 0xEFD8; }
        else if (metricId == TRAINING_STATUS)       { charCode = 0xE8E5; }
        else if (metricId == ACUTE_LOAD)            { charCode = 0xEB43; }
        else if (metricId == ENDURANCE_SCORE)       { charCode = 0xE566; }
        else if (metricId == HILL_SCORE)            { charCode = 0xE564; }
        else if (metricId == INTENSITY_MINUTES)     { charCode = 0xE9E4; }
        else if (metricId == ALTITUDE)              { charCode = 0xEA16; }
        else if (metricId == TEMPERATURE)           { charCode = 0xF076; }
        else if (metricId == WEATHER)               { charCode = 0xE2BD; }
        else if (metricId == SUNRISE)               { charCode = 0xE1C6; }
        else if (metricId == SUNSET)                { charCode = 0xEA46; }
        else if (metricId == MOON_PHASE)            { charCode = 0xE51C; }
        else if (metricId == PHONE_BATTERY)         { charCode = 0xE32C; }
        else if (metricId == BLUETOOTH)             { charCode = 0xE1A7; }
        
        return charCode.toChar().toString();
    }

    function getValue(data as DataProvider, metricId as Number) as String {
        if (metricId == STEPS) {
            return data.steps.format("%d");
        } else if (metricId == DISTANCE) {
            return data.distanceValue.format("%.1f");
        } else if (metricId == CALORIES) {
            return data.calories.format("%d");
        } else if (metricId == FLOORS) {
            return data.floorsClimbed.format("%d");
        } else if (metricId == HEARTRATE) {
            return data.heartRate.format("%d");
        } else if (metricId == STRESS) {
            return data.stressLevel.format("%d");
        } else if (metricId == BATTERY) {
            return data.batteryPercent.format("%d") + "%";
        } else if (metricId == SECONDS) {
            return data.seconds.format("%02d");
        } else if (metricId == TIME) {
            var clock = System.getClockTime();
            return clock.hour.format("%02d") + ":" + clock.min.format("%02d");
        }
        
        // Placeholder for advanced metrics to be implemented later
        return "---";
    }

    function getNumericValue(data as DataProvider, metricId as Number) as Number {
        if (metricId == STEPS) { return data.steps; }
        if (metricId == FLOORS) { return data.floorsClimbed; }
        if (metricId == HEARTRATE) { return data.heartRate; }
        if (metricId == STRESS) { return data.stressLevel; }
        if (metricId == BATTERY) { return data.batteryPercent; }
        if (metricId == BODY_BATTERY) { return 0; } // Replace with body battery when implemented in DataProvider
        return 0;
    }

    function getGaugeMin(metricId as Number) as Number {
        if (metricId == HEARTRATE) { return 40; }
        return 0;
    }

    function getGaugeMax(metricId as Number) as Number {
        if (metricId == HEARTRATE) { return 180; }
        if (metricId == STRESS) { return 100; }
        if (metricId == BATTERY) { return 100; }
        if (metricId == BODY_BATTERY) { return 100; }
        if (metricId == STEPS) { 
            var info = Toybox.ActivityMonitor.getInfo();
            if (info != null && info.stepGoal != null) {
                return info.stepGoal as Number;
            }
            return 10000;
        }
        if (metricId == FLOORS) {
            var info = Toybox.ActivityMonitor.getInfo();
            if (info != null && info.floorsClimbedGoal != null) {
                return info.floorsClimbedGoal as Number;
            }
            return 10;
        }
        if (metricId == INTENSITY_MINUTES) {
            var info = Toybox.ActivityMonitor.getInfo();
            if (info != null && info.activeMinutesWeekGoal != null) {
                return info.activeMinutesWeekGoal as Number;
            }
            return 150;
        }
        return 100;
    }
}
