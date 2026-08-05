import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

// Main settings menu shown when user selects "Customize" on the watch face
class ReactorSettingsMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => "REACTOR"});

        // Theme Style
        var currentTheme = 0;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("themeStyle");
            if (val != null) {
                currentTheme = val as Number;
            }
        }

        var themeLabels = [
            "Nixie (Cyan)",
            "LCD (Cyan)",
            "LCD (Verde)",
            "LCD (Ambar)",
            "LCD (Blanco)",
            "LCD (Siemens)"
        ] as Array<String>;

        var subLabel = "";
        if (currentTheme >= 0 && currentTheme < themeLabels.size()) {
            subLabel = themeLabels[currentTheme];
        }

        addItem(new WatchUi.MenuItem("Estilo", subLabel, :themeStyle, null));
    }
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
        }
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}

// Sub-menu listing all 6 theme options
class ThemePickerMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => "Estilo"});

        var currentTheme = 0;
        if (Toybox.Application has :Properties) {
            var val = Toybox.Application.Properties.getValue("themeStyle");
            if (val != null) {
                currentTheme = val as Number;
            }
        }

        addItem(new WatchUi.ToggleMenuItem("Nixie (Cyan)", null, 0, currentTheme == 0, null));
        addItem(new WatchUi.ToggleMenuItem("LCD (Cyan)", null, 1, currentTheme == 1, null));
        addItem(new WatchUi.ToggleMenuItem("LCD (Verde)", null, 2, currentTheme == 2, null));
        addItem(new WatchUi.ToggleMenuItem("LCD (Ambar)", null, 3, currentTheme == 3, null));
        addItem(new WatchUi.ToggleMenuItem("LCD (Blanco)", null, 4, currentTheme == 4, null));
        addItem(new WatchUi.ToggleMenuItem("LCD (Siemens)", null, 5, currentTheme == 5, null));
    }
}

// Delegate for theme picker: saves selection and pops back
class ThemePickerDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var selected = item.getId() as Number;

        // Save the new theme
        if (Toybox.Application has :Properties) {
            Toybox.Application.Properties.setValue("themeStyle", selected);
        }

        // Pop back to settings menu, then back to watch face
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
