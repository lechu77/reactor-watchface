import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

// Main settings menu shown when user selects "Customize" on the watch face
class ReactorSettingsMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => WatchUi.loadResource(Rez.Strings.AppName) as String});

        // 1. Theme Style
        var currentTheme = 0;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("themeStyle");
            if (val != null) { currentTheme = val as Number; }
        }

        var themeLabels = [
            WatchUi.loadResource(Rez.Strings.theme_nixie_cyan) as String,
            WatchUi.loadResource(Rez.Strings.theme_lcd_cyan) as String,
            WatchUi.loadResource(Rez.Strings.theme_lcd_green) as String,
            WatchUi.loadResource(Rez.Strings.theme_lcd_amber) as String,
            WatchUi.loadResource(Rez.Strings.theme_lcd_white) as String,
            WatchUi.loadResource(Rez.Strings.theme_lcd_siemens) as String,
            "","","","",
            WatchUi.loadResource(Rez.Strings.theme_nixie_amber) as String
        ] as Array<String>;

        var subLabel = "";
        if (currentTheme >= 0 && currentTheme < themeLabels.size()) {
            subLabel = themeLabels[currentTheme];
        }
        var styleLabel = WatchUi.loadResource(Rez.Strings.setting_theme_style) as String;
        addItem(new WatchUi.MenuItem(styleLabel, subLabel, :themeStyle, null));

        // 2. Top Battery
        var showTopBatt = true;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("showTopBattery");
            if (val != null) { showTopBatt = val as Boolean; }
        }
        var battLabel = WatchUi.loadResource(Rez.Strings.setting_show_top_battery) as String;
        addItem(new WatchUi.ToggleMenuItem(battLabel, null, :showTopBattery, showTopBatt, null));

        // 3. Left Flank
        var leftMetric = 4;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("leftFlankSlot");
            if (val != null) { leftMetric = val as Number; }
        }
        var leftLabel = WatchUi.loadResource(Rez.Strings.flank_left_label) as String;
        addItem(new WatchUi.MenuItem(leftLabel, getMetricName(leftMetric), :leftFlankSlot, null));

        // 4. Right Flank
        var rightMetric = 5;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("rightFlankSlot");
            if (val != null) { rightMetric = val as Number; }
        }
        var rightLabel = WatchUi.loadResource(Rez.Strings.flank_right_label) as String;
        addItem(new WatchUi.MenuItem(rightLabel, getMetricName(rightMetric), :rightFlankSlot, null));

        // 5. Bottom Slots
        var b1 = 0, b2 = 1, b3 = 2, b4 = 3;
        if (Toybox.Application has :Properties) {
            var v1 = Toybox.Application.Properties.getValue("bottomSlot1"); if(v1 != null) { b1 = v1 as Number; }
            var v2 = Toybox.Application.Properties.getValue("bottomSlot2"); if(v2 != null) { b2 = v2 as Number; }
            var v3 = Toybox.Application.Properties.getValue("bottomSlot3"); if(v3 != null) { b3 = v3 as Number; }
            var v4 = Toybox.Application.Properties.getValue("bottomSlot4"); if(v4 != null) { b4 = v4 as Number; }
        }
        
        var s1L = WatchUi.loadResource(Rez.Strings.slot1_label) as String;
        var s2L = WatchUi.loadResource(Rez.Strings.slot2_label) as String;
        var s3L = WatchUi.loadResource(Rez.Strings.slot3_label) as String;
        var s4L = WatchUi.loadResource(Rez.Strings.slot4_label) as String;

        addItem(new WatchUi.MenuItem(s1L, getMetricName(b1), :bottomSlot1, null));
        addItem(new WatchUi.MenuItem(s2L, getMetricName(b2), :bottomSlot2, null));
        addItem(new WatchUi.MenuItem(s3L, getMetricName(b3), :bottomSlot3, null));
        addItem(new WatchUi.MenuItem(s4L, getMetricName(b4), :bottomSlot4, null));
    }
}

function getMetricName(id as Number) as String {
    var resId = Rez.Strings.metric_steps;
    switch(id) {
        case 0: resId = Rez.Strings.metric_steps; break;
        case 1: resId = Rez.Strings.metric_distance; break;
        case 2: resId = Rez.Strings.metric_calories; break;
        case 3: resId = Rez.Strings.metric_floors; break;
        case 4: resId = Rez.Strings.metric_heartrate; break;
        case 5: resId = Rez.Strings.metric_stress; break;
        case 6: resId = Rez.Strings.metric_battery; break;
        case 7: resId = Rez.Strings.metric_seconds; break;
        case 8: resId = Rez.Strings.metric_time; break;
        case 9: resId = Rez.Strings.metric_date; break;
        case 10: resId = Rez.Strings.metric_body_battery; break;
        case 11: resId = Rez.Strings.metric_hrv; break;
        case 12: resId = Rez.Strings.metric_resting_hr; break;
        case 13: resId = Rez.Strings.metric_pulse_ox; break;
        case 14: resId = Rez.Strings.metric_training_readiness; break;
        case 15: resId = Rez.Strings.metric_recovery_time; break;
        case 16: resId = Rez.Strings.metric_vo2_max; break;
        case 17: resId = Rez.Strings.metric_training_status; break;
        case 18: resId = Rez.Strings.metric_acute_load; break;
        case 19: resId = Rez.Strings.metric_endurance_score; break;
        case 20: resId = Rez.Strings.metric_hill_score; break;
        case 21: resId = Rez.Strings.metric_intensity_minutes; break;
        case 22: resId = Rez.Strings.metric_altitude; break;
        case 23: resId = Rez.Strings.metric_temperature; break;
        case 24: resId = Rez.Strings.metric_weather; break;
        case 25: resId = Rez.Strings.metric_sunrise; break;
        case 26: resId = Rez.Strings.metric_sunset; break;
        case 27: resId = Rez.Strings.metric_moon_phase; break;
        case 28: resId = Rez.Strings.metric_phone_battery; break;
        case 29: resId = Rez.Strings.metric_bluetooth; break;
    }
    return WatchUi.loadResource(resId) as String;
}

// Delegate for the main settings menu
class ReactorSettingsDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
        if (id == :themeStyle) {
            WatchUi.pushView(new ThemePickerMenu(), new ThemePickerDelegate(), WatchUi.SLIDE_LEFT);
        } else if (id == :showTopBattery) {
            var toggleItem = item as WatchUi.ToggleMenuItem;
            if (Toybox.Application has :Properties) {
                Toybox.Application.Properties.setValue("showTopBattery", toggleItem.isEnabled());
            }
        } else if (id == :leftFlankSlot) {
            var title = WatchUi.loadResource(Rez.Strings.flank_left_label) as String;
            WatchUi.pushView(new MetricPickerMenu("leftFlankSlot", title), new MetricPickerDelegate("leftFlankSlot"), WatchUi.SLIDE_LEFT);
        } else if (id == :rightFlankSlot) {
            var title = WatchUi.loadResource(Rez.Strings.flank_right_label) as String;
            WatchUi.pushView(new MetricPickerMenu("rightFlankSlot", title), new MetricPickerDelegate("rightFlankSlot"), WatchUi.SLIDE_LEFT);
        } else if (id == :bottomSlot1) {
            var title = WatchUi.loadResource(Rez.Strings.slot1_label) as String;
            WatchUi.pushView(new BottomMetricPickerMenu("bottomSlot1", title), new MetricPickerDelegate("bottomSlot1"), WatchUi.SLIDE_LEFT);
        } else if (id == :bottomSlot2) {
            var title = WatchUi.loadResource(Rez.Strings.slot2_label) as String;
            WatchUi.pushView(new BottomMetricPickerMenu("bottomSlot2", title), new MetricPickerDelegate("bottomSlot2"), WatchUi.SLIDE_LEFT);
        } else if (id == :bottomSlot3) {
            var title = WatchUi.loadResource(Rez.Strings.slot3_label) as String;
            WatchUi.pushView(new BottomMetricPickerMenu("bottomSlot3", title), new MetricPickerDelegate("bottomSlot3"), WatchUi.SLIDE_LEFT);
        } else if (id == :bottomSlot4) {
            var title = WatchUi.loadResource(Rez.Strings.slot4_label) as String;
            WatchUi.pushView(new BottomMetricPickerMenu("bottomSlot4", title), new MetricPickerDelegate("bottomSlot4"), WatchUi.SLIDE_LEFT);
        }
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}

// Sub-menu listing all theme options
class ThemePickerMenu extends WatchUi.Menu2 {
    function initialize() {
        var title = WatchUi.loadResource(Rez.Strings.setting_theme_style) as String;
        Menu2.initialize({:title => title});
        
        var currentTheme = 0;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("themeStyle");
            if (val != null) { currentTheme = val as Number; }
        }
        
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.theme_nixie_cyan) as String, null, 0, currentTheme == 0, null));
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.theme_lcd_cyan) as String, null, 1, currentTheme == 1, null));
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.theme_lcd_green) as String, null, 2, currentTheme == 2, null));
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.theme_lcd_amber) as String, null, 3, currentTheme == 3, null));
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.theme_lcd_white) as String, null, 4, currentTheme == 4, null));
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.theme_lcd_siemens) as String, null, 5, currentTheme == 5, null));
        addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.theme_nixie_amber) as String, null, 10, currentTheme == 10, null));
    }
}

class ThemePickerDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }
    function onSelect(item as WatchUi.MenuItem) as Void {
        var selected = item.getId() as Number;
        if (Toybox.Application has :Properties) {
            Toybox.Application.Properties.setValue("themeStyle", selected);
        }
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}

// Sub-menu for Flank metrics
class MetricPickerMenu extends WatchUi.Menu2 {
    function initialize(propKey as String, menuTitle as String) {
        Menu2.initialize({:title => menuTitle});
        var currentVal = -1;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue(propKey);
            if (val != null) { currentVal = val as Number; }
        }
        
        var options = [ 6, 0, 4, 5, 10, 3, 21 ];

        for (var i = 0; i < options.size(); i++) {
            var id = options[i] as Number;
            var label = getMetricName(id);
            addItem(new WatchUi.ToggleMenuItem(label, null, id, currentVal == id, null));
        }
    }
}

// Sub-menu for Bottom Slots
class BottomMetricPickerMenu extends WatchUi.Menu2 {
    function initialize(propKey as String, menuTitle as String) {
        Menu2.initialize({:title => menuTitle});
        var currentVal = -1;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue(propKey);
            if (val != null) { currentVal = val as Number; }
        }
        
        var options = [
            8, 9, 0, 1, 2, 3, 21, 4, 12, 11, 13, 5, 10, 14, 17, 15, 18, 16, 19, 20, 22, 24, 23, 25, 26, 27, 6, 28, 29, 7
        ];

        for (var i = 0; i < options.size(); i++) {
            var id = options[i] as Number;
            var label = getMetricName(id);
            addItem(new WatchUi.ToggleMenuItem(label, null, id, currentVal == id, null));
        }
    }
}

// Shared delegate for all metric pickers
class MetricPickerDelegate extends WatchUi.Menu2InputDelegate {
    private var _propKey as String;
    
    function initialize(propKey as String) {
        Menu2InputDelegate.initialize();
        _propKey = propKey;
    }
    
    function onSelect(item as WatchUi.MenuItem) as Void {
        var selected = item.getId() as Number;
        if (Toybox.Application has :Properties) {
            Toybox.Application.Properties.setValue(_propKey, selected);
        }
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
    
    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
