import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class BottomMetricsWidget {

    // Cache loaded bitmaps (keyed by metric ID integer to avoid ResourceId issues)
    private var _bitmapCache as Dictionary<Number, WatchUi.BitmapResource> = {};

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

        // Bottom zone: Y=302..438 (~136px tall)
        var zoneTopY = 302;
        var zoneH    = height - zoneTopY - 16;

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
        var sepBot = height - 29; // 425
        dc.fillRectangle(innerLeft + colW - 1,     sepTop, 2, sepBot - sepTop);
        dc.fillRectangle(innerLeft + colW * 2 - 1, sepTop, 2, sepBot - sepTop);
        dc.fillRectangle(innerLeft + colW * 3 - 1, sepTop, 2, sepBot - sepTop);

        // Vertical centering: icon=40 + gap=4 + text=18 = 62px group
        var iconSize  = 40;
        var groupTopY = zoneTopY + (zoneH - 62) / 2;
        var valY      = groupTopY + iconSize + 4;        drawSlot(dc, data, col1X, groupTopY, iconSize, valY, slot1);
        drawSlot(dc, data, col2X, groupTopY, iconSize, valY, slot2);
        drawSlot(dc, data, col3X, groupTopY, iconSize, valY, slot3);
        drawSlot(dc, data, col4X, groupTopY, iconSize, valY, slot4);
    }

    private function readSlot(key as String, defaultVal as Number) as Number {
        try {
            var val = Application.Properties.getValue(key);
            if (val instanceof Number) { return val as Number; }
        } catch (e) {}
        return defaultVal;
    }

    private function drawSlot(dc as Dc, data as DataProvider, cx as Number, iconTopY as Number, iconSize as Number, valY as Number, metricId as Number) as Void {
        var bmp = loadBitmap(metricId);
        if (bmp != null) {
            var b = bmp as WatchUi.BitmapResource;
            // Icons are 40×40px
            dc.drawBitmap(cx - 20, iconTopY, b);
        }

        var valueStr = MetricSlot.getValue(data, metricId);
        dc.setColor(Theme.COLOR_ICONS, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, valY, Graphics.FONT_TINY, valueStr, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function loadBitmap(metricId as Number) as WatchUi.BitmapResource? {
        if (_bitmapCache.hasKey(metricId)) {
            return _bitmapCache[metricId];
        }
        try {
            var resId = MetricSlot.getDrawableId(metricId);
            var bmp = WatchUi.loadResource(resId) as WatchUi.BitmapResource;
            _bitmapCache[metricId] = bmp;
            return bmp;
        } catch (e) {
            return null;
        }
    }
}
