import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class FlankWidget {

    // Cache loaded bitmaps
    private var _bitmapCache as Dictionary<Number, WatchUi.BitmapResource> = {};

    function initialize() {
    }

    function draw(dc as Dc, data as DataProvider, theme as Theme.ThemeConfig) as Void {
        if (theme.isAod) {
            return; // Hide flanks in low-power AOD mode
        }

        var leftX = 40;
        var rightX = dc.getWidth() - 40; // 414 on 454x454
        
        var leftMetric = theme.leftFlankSlot;
        var rightMetric = theme.rightFlankSlot;
        
        // Left Flank
        var leftVal = MetricSlot.getNumericValue(data, leftMetric);
        var leftMin = MetricSlot.getGaugeMin(leftMetric);
        var leftMax = MetricSlot.getGaugeMax(leftMetric);
        drawGauge(dc, data, leftX, leftMetric, leftVal, leftMin, leftMax);

        // Right Flank
        var rightVal = MetricSlot.getNumericValue(data, rightMetric);
        var rightMin = MetricSlot.getGaugeMin(rightMetric);
        var rightMax = MetricSlot.getGaugeMax(rightMetric);
        drawGauge(dc, data, rightX, rightMetric, rightVal, rightMin, rightMax);
    }

    private function drawGauge(dc as Dc, data as DataProvider, x as Number, metricId as Number, value as Number, minVal as Number, maxVal as Number) as Void {
        var numSegments = 10;
        
        var segWidth = 26;  // Long width
        var segHeight = 7;  // Thicker height
        var segSpacing = 6; // Spacing between ticks
        
        var totalGaugeHeight = (numSegments * segHeight) + ((numSegments - 1) * segSpacing); // 124px
        var startY = 171; // Top tick starts cleanly at Y=171

        // 1. Vector Metric Icon (Moved slightly higher to match text gap visually)
        var iconY = 143; // Center Y = 143 (gives ~8px extra breathing room)
        var bmp = loadBitmap(metricId);
        if (bmp != null) {
            dc.drawBitmap(x - 20, iconY - 20, bmp);
        }

        // Calculate active segments count (0 to 10)
        var activeCount = 0;
        if (value > minVal) {
            var ratio = (value - minVal).toFloat() / (maxVal - minVal).toFloat();
            if (ratio > 1.0) { ratio = 1.0; }
            if (ratio < 0.0) { ratio = 0.0; }
            activeCount = (ratio * numSegments).toNumber();
        }

        // 2. Draw 10 vertical segments: Active = WHITE (#D7D7D7), Unlit = DIM (#1C202B)
        for (var i = 0; i < numSegments; i++) {
            var segY = startY + totalGaugeHeight - ((i + 1) * (segHeight + segSpacing));
            
            if (i < activeCount) {
                dc.setColor(Theme.COLOR_ICONS, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(Theme.COLOR_SEGMENT_OFF, Graphics.COLOR_TRANSPARENT);
            }
            
            dc.fillRectangle(x - (segWidth / 2), segY, segWidth, segHeight);
        }

        // 3. Clean native text under the bottom tick
        dc.setColor(Theme.COLOR_ICONS, Graphics.COLOR_TRANSPARENT);
        var valStr = MetricSlot.getValue(data, metricId);
        var valY = startY + totalGaugeHeight + 3; // Clear gap under bottom tick
        
        // Render cleanly using native font (removed fake bold)
        dc.drawText(x, valY, Graphics.FONT_XTINY, valStr, Graphics.TEXT_JUSTIFY_CENTER);
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
