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

    function getDrawableId(metricId as Number) as ResourceId {
        if (metricId == STEPS)                 { return Rez.Drawables.IconSteps; }
        if (metricId == DISTANCE)              { return Rez.Drawables.IconDistance; }
        if (metricId == CALORIES)              { return Rez.Drawables.IconCalories; }
        if (metricId == FLOORS)                { return Rez.Drawables.IconFloors; }
        if (metricId == HEARTRATE)             { return Rez.Drawables.IconHeartRate; }
        if (metricId == STRESS)                { return Rez.Drawables.IconStress; }
        if (metricId == BATTERY)               { return Rez.Drawables.IconBattery; }
        if (metricId == SECONDS)               { return Rez.Drawables.IconSeconds; }
        if (metricId == TIME)                  { return Rez.Drawables.IconTime; }
        if (metricId == DATE)                  { return Rez.Drawables.IconDate; }
        if (metricId == BODY_BATTERY)          { return Rez.Drawables.IconBodyBattery; }
        if (metricId == HRV)                   { return Rez.Drawables.IconHRV; }
        if (metricId == RESTING_HR)            { return Rez.Drawables.IconRestingHR; }
        if (metricId == PULSE_OX)              { return Rez.Drawables.IconPulseOx; }
        if (metricId == TRAINING_READINESS)    { return Rez.Drawables.IconTrainingReadiness; }
        if (metricId == RECOVERY_TIME)         { return Rez.Drawables.IconRecoveryTime; }
        if (metricId == VO2_MAX)               { return Rez.Drawables.IconVO2Max; }
        if (metricId == TRAINING_STATUS)       { return Rez.Drawables.IconTrainingStatus; }
        if (metricId == ACUTE_LOAD)            { return Rez.Drawables.IconAcuteLoad; }
        if (metricId == ENDURANCE_SCORE)       { return Rez.Drawables.IconEnduranceScore; }
        if (metricId == HILL_SCORE)            { return Rez.Drawables.IconHillScore; }
        if (metricId == INTENSITY_MINUTES)     { return Rez.Drawables.IconIntensityMinutes; }
        if (metricId == ALTITUDE)              { return Rez.Drawables.IconAltitude; }
        if (metricId == TEMPERATURE)           { return Rez.Drawables.IconTemperature; }
        if (metricId == WEATHER)               { return Rez.Drawables.IconWeather; }
        if (metricId == SUNRISE)               { return Rez.Drawables.IconSunrise; }
        if (metricId == SUNSET)                { return Rez.Drawables.IconSunset; }
        if (metricId == MOON_PHASE)            { return Rez.Drawables.IconMoonPhase; }
        if (metricId == PHONE_BATTERY)         { return Rez.Drawables.IconPhoneBattery; }
        if (metricId == BLUETOOTH)             { return Rez.Drawables.IconBluetooth; }
        
        return Rez.Drawables.IconSteps;
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
