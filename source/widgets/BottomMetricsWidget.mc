import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class BottomMetricsWidget {

    private var _iconFont as WatchUi.FontResource?;

    function initialize() {
    }

    function draw(dc as Dc, data as DataProvider, theme as Theme.ThemeConfig) as Void {
        if (theme.isAod) {
            return;
        }

        var slot1 = readSlot("bottomSlot1", MetricSlot.STEPS);
        var slot2 = readSlot("bottomSlot2", MetricSlot.DISTANCE);
        var slot3 = readSlot("bottomSlot3", MetricSlot.CALORIES);
        var slot4 = readSlot("bottomSlot4", MetricSlot.FLOORS);

        var height = dc.getHeight(); // 454

        // Bottom zone: Y=282..418 (~136px tall)
        var zoneTopY = 282;
        var zoneH    = height - zoneTopY - 36;

        // 4 cols in safe circular band (X 78..376 = 298px, colW=74px)
        var innerLeft = 78;
        var colW      = 74;

        var col1X = innerLeft + colW / 2;
        var col2X = innerLeft + colW + colW / 2;
        var col3X = innerLeft + colW * 2 + colW / 2;
        var col4X = innerLeft + colW * 3 + colW / 2;

        // Vertical separators (Aligned with icon and text)
        dc.setColor(0x506070, Graphics.COLOR_TRANSPARENT);
        // groupTopY is 339, valY is 383. Extended downwards by ~30% total.
        var sepTop = zoneTopY + 38; // 340
        var sepBot = height - 49; // 405
        dc.fillRectangle(innerLeft + colW - 1,     sepTop, 2, sepBot - sepTop);
        dc.fillRectangle(innerLeft + colW * 2 - 1, sepTop, 2, sepBot - sepTop);
        dc.fillRectangle(innerLeft + colW * 3 - 1, sepTop, 2, sepBot - sepTop);

        // Vertical centering: icon=40 + gap=4 + text=18 = 62px group
        var iconSize  = 40;
        var groupTopY = zoneTopY + (zoneH - 62) / 2;
        var valY      = groupTopY + iconSize + 4;        
        if (theme.showSlot1) { drawSlot(dc, data, col1X, groupTopY, iconSize, valY, slot1); }
        if (theme.showSlot2) { drawSlot(dc, data, col2X, groupTopY, iconSize, valY, slot2); }
        if (theme.showSlot3) { drawSlot(dc, data, col3X, groupTopY, iconSize, valY, slot3); }
        if (theme.showSlot4) { drawSlot(dc, data, col4X, groupTopY, iconSize, valY, slot4); }

        if (theme.currentStyle == Theme.THEME_LCD_SIEMENS) {
            try {
                var logo = WatchUi.loadResource(Rez.Drawables.SiemensLogo) as WatchUi.BitmapResource;
                // Center at X=227, Y=431 (very close to bottom edge)
                dc.drawBitmap(227 - (logo.getWidth() / 2), 431, logo);
            } catch (e) {}
        }
    }

    private function readSlot(key as String, defaultVal as Number) as Number {
        try {
            var val = Application.Properties.getValue(key);
            if (val instanceof Number) { return val as Number; }
        } catch (e) {}
        return defaultVal;
    }

    private function drawSlot(dc as Dc, data as DataProvider, cx as Number, iconTopY as Number, iconSize as Number, valY as Number, metricId as Number) as Void {
        var iconChar = MetricSlot.getIconString(metricId);
        var font = getIconFont();
        dc.setColor(Theme.COLOR_ICONS, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, iconTopY + 24, font, iconChar, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        var valueStr = MetricSlot.getValue(data, metricId);
        dc.setColor(Theme.COLOR_ICONS, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, valY + 2, Graphics.FONT_XTINY, valueStr, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function getIconFont() as WatchUi.FontResource {
        if (_iconFont == null) {
            _iconFont = WatchUi.loadResource(Rez.Fonts.MetricsIconsFont) as WatchUi.FontResource;
        }
        return _iconFont;
    }
}
