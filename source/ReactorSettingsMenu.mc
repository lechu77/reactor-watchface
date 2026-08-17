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

        // Enable AOD
        var useAod = true;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("useAod");
            if (val != null) { useAod = val as Boolean; }
        }
        var aodLabel = WatchUi.loadResource(Rez.Strings.setting_use_aod) as String;
        addItem(new WatchUi.ToggleMenuItem(aodLabel, null, :useAod, useAod, null));

        // Show Top Battery
        var showTopBatt = true;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("showTopBattery");
            if (val != null) { showTopBatt = val as Boolean; }
        }
        var battLabel = WatchUi.loadResource(Rez.Strings.setting_show_top_battery) as String;
        addItem(new WatchUi.ToggleMenuItem(battLabel, null, :showTopBattery, showTopBatt, null));

        // Show Top Charts
        var showTopC = true;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("showTopCharts");
            if (val != null) { showTopC = val as Boolean; }
        }
        var chartsLabel = WatchUi.loadResource(Rez.Strings.setting_show_top_charts) as String;
        addItem(new WatchUi.ToggleMenuItem(chartsLabel, null, :showTopCharts, showTopC, null));

        // Top Chart Left
        var topChartLeft = 4;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("topChartLeft");
            if (val != null) { topChartLeft = val as Number; }
        }
        var topChartLeftLabel = WatchUi.loadResource(Rez.Strings.top_chart_left_label) as String;
        addItem(new WatchUi.MenuItem(topChartLeftLabel, getMetricName(topChartLeft), :topChartLeft, null));

        var topLeftChartType = 0;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("topLeftChartType");
            if (val != null) { topLeftChartType = val as Number; }
        }
        var topLeftChartTypeLabel = WatchUi.loadResource(Rez.Strings.setting_top_left_chart_type) as String;
        addItem(new WatchUi.MenuItem(topLeftChartTypeLabel, getChartStyleName(topLeftChartType), :topLeftChartType, null));

        // Top Chart Right
        var topChartRight = 10;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("topChartRight");
            if (val != null) { topChartRight = val as Number; }
        }
        var topChartRightLabel = WatchUi.loadResource(Rez.Strings.top_chart_right_label) as String;
        addItem(new WatchUi.MenuItem(topChartRightLabel, getMetricName(topChartRight), :topChartRight, null));

        var topRightChartType = 0;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("topRightChartType");
            if (val != null) { topRightChartType = val as Number; }
        }
        var topRightChartTypeLabel = WatchUi.loadResource(Rez.Strings.setting_top_right_chart_type) as String;
        addItem(new WatchUi.MenuItem(topRightChartTypeLabel, getChartStyleName(topRightChartType), :topRightChartType, null));

        // Show Left Bar
        var showLeftB = true;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("showLeftBar");
            if (val != null) { showLeftB = val as Boolean; }
        }
        var leftBLabel = WatchUi.loadResource(Rez.Strings.setting_show_left_bar) as String;
        addItem(new WatchUi.ToggleMenuItem(leftBLabel, null, :showLeftBar, showLeftB, null));

        // Left Bar Metric
        var leftMetric = 4;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("leftFlankSlot");
            if (val != null) { leftMetric = val as Number; }
        }
        var leftLabel = WatchUi.loadResource(Rez.Strings.flank_left_label) as String;
        addItem(new WatchUi.MenuItem(leftLabel, getMetricName(leftMetric), :leftFlankSlot, null));

        // Show Right Bar
        var showRightB = true;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("showRightBar");
            if (val != null) { showRightB = val as Boolean; }
        }
        var rightBLabel = WatchUi.loadResource(Rez.Strings.setting_show_right_bar) as String;
        addItem(new WatchUi.ToggleMenuItem(rightBLabel, null, :showRightBar, showRightB, null));

        // Right Bar Metric
        var rightMetric = 5;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("rightFlankSlot");
            if (val != null) { rightMetric = val as Number; }
        }
        var rightLabel = WatchUi.loadResource(Rez.Strings.flank_right_label) as String;
        addItem(new WatchUi.MenuItem(rightLabel, getMetricName(rightMetric), :rightFlankSlot, null));

        // Bottom Slots
        var b1 = 0, b2 = 1, b3 = 2, b4 = 3;
        var showS1 = true, showS2 = true, showS3 = true, showS4 = true;
        if (Toybox.Application has :Properties) {
            var v1 = Toybox.Application.Properties.getValue("bottomSlot1"); if(v1 != null) { b1 = v1 as Number; }
            var v2 = Toybox.Application.Properties.getValue("bottomSlot2"); if(v2 != null) { b2 = v2 as Number; }
            var v3 = Toybox.Application.Properties.getValue("bottomSlot3"); if(v3 != null) { b3 = v3 as Number; }
            var v4 = Toybox.Application.Properties.getValue("bottomSlot4"); if(v4 != null) { b4 = v4 as Number; }
            
            var sv1 = Toybox.Application.Properties.getValue("showSlot1"); if(sv1 != null) { showS1 = sv1 as Boolean; }
            var sv2 = Toybox.Application.Properties.getValue("showSlot2"); if(sv2 != null) { showS2 = sv2 as Boolean; }
            var sv3 = Toybox.Application.Properties.getValue("showSlot3"); if(sv3 != null) { showS3 = sv3 as Boolean; }
            var sv4 = Toybox.Application.Properties.getValue("showSlot4"); if(sv4 != null) { showS4 = sv4 as Boolean; }
        }
        
        var s1L = WatchUi.loadResource(Rez.Strings.slot1_label) as String;
        var s2L = WatchUi.loadResource(Rez.Strings.slot2_label) as String;
        var s3L = WatchUi.loadResource(Rez.Strings.slot3_label) as String;
        var s4L = WatchUi.loadResource(Rez.Strings.slot4_label) as String;
        
        var tS1L = WatchUi.loadResource(Rez.Strings.setting_show_slot1) as String;
        var tS2L = WatchUi.loadResource(Rez.Strings.setting_show_slot2) as String;
        var tS3L = WatchUi.loadResource(Rez.Strings.setting_show_slot3) as String;
        var tS4L = WatchUi.loadResource(Rez.Strings.setting_show_slot4) as String;

        addItem(new WatchUi.ToggleMenuItem(tS1L, null, :showSlot1, showS1, null));
        addItem(new WatchUi.MenuItem(s1L, getMetricName(b1), :bottomSlot1, null));
        
        addItem(new WatchUi.ToggleMenuItem(tS2L, null, :showSlot2, showS2, null));
        addItem(new WatchUi.MenuItem(s2L, getMetricName(b2), :bottomSlot2, null));
        
        addItem(new WatchUi.ToggleMenuItem(tS3L, null, :showSlot3, showS3, null));
        addItem(new WatchUi.MenuItem(s3L, getMetricName(b3), :bottomSlot3, null));
        
        addItem(new WatchUi.ToggleMenuItem(tS4L, null, :showSlot4, showS4, null));
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
        case 30: resId = Rez.Strings.metric_pressure; break;
        case 31: resId = Rez.Strings.metric_respiration; break;
    }
    return WatchUi.loadResource(resId) as String;
}

function getChartStyleName(id as Number) as String {
    var resId = Rez.Strings.chart_style_solid;
    switch(id) {
        case 0: resId = Rez.Strings.chart_style_solid; break;
        case 1: resId = Rez.Strings.chart_style_dot_matrix; break;
        case 2: resId = Rez.Strings.chart_style_stepped; break;
        case 3: resId = Rez.Strings.chart_style_oscilloscope; break;
        case 4: resId = Rez.Strings.chart_style_lcd; break;
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
        } else if (id == :useAod) {
            var toggleItem = item as WatchUi.ToggleMenuItem;
            if (Toybox.Application has :Properties) {
                Toybox.Application.Properties.setValue("useAod", toggleItem.isEnabled());
            }
        } else if (id == :showTopBattery) {
            var toggleItem = item as WatchUi.ToggleMenuItem;
            if (Toybox.Application has :Properties) {
                Toybox.Application.Properties.setValue("showTopBattery", toggleItem.isEnabled());
            }
        } else if (id == :showTopCharts) {
            var toggleItem = item as WatchUi.ToggleMenuItem;
            if (Toybox.Application has :Properties) {
                Toybox.Application.Properties.setValue("showTopCharts", toggleItem.isEnabled());
            }
        } else if (id == :topChartLeft) {
            var title = WatchUi.loadResource(Rez.Strings.top_chart_left_label) as String;
            WatchUi.pushView(new ChartMetricPickerMenu("topChartLeft", title), new MetricPickerDelegate("topChartLeft"), WatchUi.SLIDE_LEFT);
        } else if (id == :topLeftChartType) {
            var title = WatchUi.loadResource(Rez.Strings.setting_top_left_chart_type) as String;
            WatchUi.pushView(new ChartStylePickerMenu("topLeftChartType", title), new MetricPickerDelegate("topLeftChartType"), WatchUi.SLIDE_LEFT);
        } else if (id == :topChartRight) {
            var title = WatchUi.loadResource(Rez.Strings.top_chart_right_label) as String;
            WatchUi.pushView(new ChartMetricPickerMenu("topChartRight", title), new MetricPickerDelegate("topChartRight"), WatchUi.SLIDE_LEFT);
        } else if (id == :topRightChartType) {
            var title = WatchUi.loadResource(Rez.Strings.setting_top_right_chart_type) as String;
            WatchUi.pushView(new ChartStylePickerMenu("topRightChartType", title), new MetricPickerDelegate("topRightChartType"), WatchUi.SLIDE_LEFT);
        } else if (id == :showLeftBar) {
            var toggleItem = item as WatchUi.ToggleMenuItem;
            if (Toybox.Application has :Properties) {
                Toybox.Application.Properties.setValue("showLeftBar", toggleItem.isEnabled());
            }
        } else if (id == :showRightBar) {
            var toggleItem = item as WatchUi.ToggleMenuItem;
            if (Toybox.Application has :Properties) {
                Toybox.Application.Properties.setValue("showRightBar", toggleItem.isEnabled());
            }
        } else if (id == :showSlot1) {
            var toggleItem = item as WatchUi.ToggleMenuItem;
            if (Toybox.Application has :Properties) {
                Toybox.Application.Properties.setValue("showSlot1", toggleItem.isEnabled());
            }
        } else if (id == :showSlot2) {
            var toggleItem = item as WatchUi.ToggleMenuItem;
            if (Toybox.Application has :Properties) {
                Toybox.Application.Properties.setValue("showSlot2", toggleItem.isEnabled());
            }
        } else if (id == :showSlot3) {
            var toggleItem = item as WatchUi.ToggleMenuItem;
            if (Toybox.Application has :Properties) {
                Toybox.Application.Properties.setValue("showSlot3", toggleItem.isEnabled());
            }
        } else if (id == :showSlot4) {
            var toggleItem = item as WatchUi.ToggleMenuItem;
            if (Toybox.Application has :Properties) {
                Toybox.Application.Properties.setValue("showSlot4", toggleItem.isEnabled());
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

// Sub-menu for Top Charts
class ChartMetricPickerMenu extends WatchUi.Menu2 {
    function initialize(propKey as String, menuTitle as String) {
        Menu2.initialize({:title => menuTitle});
        var currentVal = -1;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue(propKey);
            if (val != null) { currentVal = val as Number; }
        }
        
        var options = [ 4, 5, 10, 13, 22, 23, 30 ];

        for (var i = 0; i < options.size(); i++) {
            var id = options[i] as Number;
            var label = getMetricName(id);
            addItem(new WatchUi.ToggleMenuItem(label, null, id, currentVal == id, null));
        }
    }
}

// Sub-menu for Chart Styles
class ChartStylePickerMenu extends WatchUi.Menu2 {
    function initialize(propKey as String, menuTitle as String) {
        Menu2.initialize({:title => menuTitle});
        var currentVal = -1;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue(propKey);
            if (val != null) { currentVal = val as Number; }
        }
        
        var options = [ 0, 1, 2, 3, 4 ];

        for (var i = 0; i < options.size(); i++) {
            var id = options[i] as Number;
            var label = getChartStyleName(id);
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
