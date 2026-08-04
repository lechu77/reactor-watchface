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
        STYLE_NIXIE_CYAN,
        STYLE_LCD_STN,
        STYLE_LCD_GREEN,
        STYLE_LCD_GRAY
    }

    class ThemeConfig {
        public var currentStyle as Style = STYLE_NIXIE_CYAN;
        public var isAod as Boolean = false;
        public var digitStyle as Number = 0; // 0 = Solid, 1 = Tube
        public var showTopBattery as Boolean = true;
        public var leftFlankSlot as Number = 4; // HeartRate
        public var rightFlankSlot as Number = 5; // Stress

        function initialize() {
            loadProperties();
        }

        function loadProperties() as Void {
            if (Toybox.Application has :Properties) {
                var dStyle = Toybox.Application.Properties.getValue("digitStyle");
                if (dStyle != null) {
                    digitStyle = dStyle as Number;
                }
                var sTopBatt = Toybox.Application.Properties.getValue("showTopBattery");
                if (sTopBatt != null) {
                    showTopBattery = sTopBatt as Boolean;
                }
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
                case STYLE_LCD_GREEN:
                    return 0x80E263;
                case STYLE_LCD_GRAY:
                    return 0xD4D4D4;
                case STYLE_NIXIE_CYAN:
                case STYLE_LCD_STN:
                default:
                    return COLOR_LCD_CYAN;
            }
        }

        function getBackgroundColor() as Number {
            if (currentStyle == STYLE_LCD_STN) {
                return 0x103233;
            } else if (currentStyle == STYLE_LCD_GREEN) {
                return 0x1A2C16;
            } else if (currentStyle == STYLE_LCD_GRAY) {
                return 0x22262E;
            }
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
