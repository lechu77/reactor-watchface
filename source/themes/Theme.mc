import Toybox.Graphics;
import Toybox.Lang;

module Theme {
    // Official MONOLITH Palette Tokens
    const COLOR_BG = 0x0A0A0A;          // Pure AMOLED Black
    const COLOR_LCD_CYAN = 0x5ED7D2;    // Primary LCD / Nixie Cyan
    const COLOR_ACCENT = 0x009E9A;      // Cyan Accent
    const COLOR_ICONS = 0xD7D7D7;       // Light Gray Icons
    const COLOR_SECONDARY = 0x666666;   // Dim Secondary Text
    const COLOR_SEGMENT_OFF = 0x1C202B;  // Dim Unlit Segment

    // Clock Frame & Background Styles
    enum Style {
        THEME_NIXIE_CYAN = 0,
        THEME_LCD_CYAN = 1,
        THEME_LCD_GREEN = 2,
        THEME_LCD_AMBER = 3,
        THEME_LCD_WHITE = 4,
        THEME_LCD_SIEMENS = 5,
        THEME_NIXIE_AMBER = 10
    }

    class ThemeConfig {
        public var currentStyle as Style = THEME_NIXIE_CYAN;
        public var isAod as Boolean = false;
        public var useAod as Boolean = true;
        public var showTopBattery as Boolean = true;
        public var showLeftBar as Boolean = true;
        public var showRightBar as Boolean = true;
        public var showSlot1 as Boolean = true;
        public var showSlot2 as Boolean = true;
        public var showSlot3 as Boolean = true;
        public var showSlot4 as Boolean = true;
        public var leftFlankSlot as Number = 4; // HeartRate
        public var rightFlankSlot as Number = 5; // Stress

        function initialize() {
            loadProperties();
        }

        function loadProperties() as Void {
            if (Toybox.Application has :Properties) {
                var tColor = Toybox.Application.Properties.getValue("themeStyle");
                if (tColor != null) {
                    currentStyle = tColor as Style;
                }
                var sTopBatt = Toybox.Application.Properties.getValue("showTopBattery");
                if (sTopBatt != null) {
                    showTopBattery = sTopBatt as Boolean;
                }
                var sUseAod = Toybox.Application.Properties.getValue("useAod");
                if (sUseAod != null) {
                    useAod = sUseAod as Boolean;
                }
                var sLBar = Toybox.Application.Properties.getValue("showLeftBar");
                if (sLBar != null) { showLeftBar = sLBar as Boolean; }
                
                var sRBar = Toybox.Application.Properties.getValue("showRightBar");
                if (sRBar != null) { showRightBar = sRBar as Boolean; }
                
                var sS1 = Toybox.Application.Properties.getValue("showSlot1");
                if (sS1 != null) { showSlot1 = sS1 as Boolean; }
                
                var sS2 = Toybox.Application.Properties.getValue("showSlot2");
                if (sS2 != null) { showSlot2 = sS2 as Boolean; }
                
                var sS3 = Toybox.Application.Properties.getValue("showSlot3");
                if (sS3 != null) { showSlot3 = sS3 as Boolean; }
                
                var sS4 = Toybox.Application.Properties.getValue("showSlot4");
                if (sS4 != null) { showSlot4 = sS4 as Boolean; }
                var leftF = Toybox.Application.Properties.getValue("leftFlankSlot");
                if (leftF != null) {
                    leftFlankSlot = leftF as Number;
                }
                var rightF = Toybox.Application.Properties.getValue("rightFlankSlot");
                if (rightF != null) {
                    rightFlankSlot = rightF as Number;
                }
            }
        }

        function getPrimaryColor() as Number {
            switch (currentStyle) {
                case THEME_LCD_GREEN:
                    return 0x43E038;
                case THEME_LCD_AMBER:
                    return 0xFFB000;
                case THEME_LCD_WHITE:
                    return 0xFFFFFF;
                case THEME_LCD_SIEMENS:
                    return 0x00A3A3;
                case THEME_NIXIE_AMBER:
                    return 0xFF7A00;
                case THEME_LCD_CYAN:
                case THEME_NIXIE_CYAN:
                default:
                    return COLOR_LCD_CYAN;
            }
        }

        function getBackgroundColor() as Number {
            return COLOR_BG;
        }

        function getFrameBorderColor() as Number {
            if (isAod) {
                return 0x1A3A3A;
            }
            return getPrimaryColor();
        }
    }
}
