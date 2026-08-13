import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class FlankWidget {

    private var _iconFont as WatchUi.FontResource?;

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
        
        if (theme.showLeftBar) {
            var leftVal = MetricSlot.getNumericValue(data, leftMetric);
            var leftMin = MetricSlot.getGaugeMin(leftMetric);
            var leftMax = MetricSlot.getGaugeMax(leftMetric);
            drawGauge(dc, data, theme, leftX, leftMetric, leftVal, leftMin, leftMax);
        }

        if (theme.showRightBar) {
            var rightVal = MetricSlot.getNumericValue(data, rightMetric);
            var rightMin = MetricSlot.getGaugeMin(rightMetric);
            var rightMax = MetricSlot.getGaugeMax(rightMetric);
            drawGauge(dc, data, theme, rightX, rightMetric, rightVal, rightMin, rightMax);
        }
    }

    private function drawGauge(dc as Dc, data as DataProvider, theme as Theme.ThemeConfig, x as Number, metricId as Number, value as Number, minVal as Number, maxVal as Number) as Void {
        var numSegments = 10;
        
        var segWidth = 26;  // Long width
        var segHeight = 7;  // Thicker height
        var segSpacing = 6; // Spacing between ticks
        
        var totalGaugeHeight = (numSegments * segHeight) + ((numSegments - 1) * segSpacing); // 124px
        var startY = 171; // Top tick starts cleanly at Y=171

        // 1. Vector Metric Icon (Moved slightly higher to match text gap visually)
        var iconY = 143; // Center Y = 143 (gives ~8px extra breathing room)
        var iconChar = MetricSlot.getIconString(metricId);
        var font = getIconFont();
        dc.setColor(Theme.COLOR_ICONS, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, iconY, font, iconChar, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Calculate active segments count (0 to 10)
        var activeCount = 0;
        if (value > minVal) {
            var ratio = (value - minVal).toFloat() / (maxVal - minVal).toFloat();
            if (ratio > 1.0) { ratio = 1.0; }
            if (ratio < 0.0) { ratio = 0.0; }
            activeCount = (ratio * numSegments).toNumber();
        }

        // 2. Draw 10 vertical segments
        for (var i = 0; i < numSegments; i++) {
            var segY = startY + totalGaugeHeight - ((i + 1) * (segHeight + segSpacing));
            
            if (i < activeCount) {
                var color = getSegmentColor(metricId, i, theme);
                dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(Theme.COLOR_SEGMENT_OFF, Graphics.COLOR_TRANSPARENT);
            }
            
            dc.fillRectangle(x - (segWidth / 2), segY, segWidth, segHeight);
        }

        dc.setColor(Theme.COLOR_ICONS, Graphics.COLOR_TRANSPARENT);
        var valStr = MetricSlot.getValue(data, metricId);
        var valY = startY + totalGaugeHeight + 3; // Clear gap under bottom tick
        
        dc.drawText(x, valY, Graphics.FONT_XTINY, valStr, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function getSegmentColor(metricId as Number, index as Number, theme as Theme.ThemeConfig) as Number {
        // index goes from 0 (bottom) to 9 (top)
        
        if (metricId == MetricSlot.BATTERY || metricId == MetricSlot.BODY_BATTERY || metricId == MetricSlot.PHONE_BATTERY) {
            if (index <= 1) { return 0xFF0000; } // Red (0-20%)
            if (index <= 3) { return 0xFFB000; } // Amber/Yellow (20-40%)
            return 0x43E038; // Green (40-100%)
        }
        
        if (metricId == MetricSlot.HEARTRATE) {
            if (index <= 4) { return 0x43E038; } // Green (Z1-Z3)
            if (index <= 7) { return 0xFFB000; } // Amber (Z4)
            return 0xFF0000; // Red (Z5)
        }
        
        if (metricId == MetricSlot.STRESS) {
            if (index <= 2) { return 0x00AAFF; } // Blue (Rest)
            if (index <= 5) { return 0x43E038; } // Green (Low)
            if (index <= 7) { return 0xFFB000; } // Amber (Med)
            return 0xFF0000; // Red (High)
        }
        
        // Default for steps, floors, etc: Use the theme's primary color
        return theme.getPrimaryColor();
    }

    private function getIconFont() as WatchUi.FontResource {
        if (_iconFont == null) {
            _iconFont = WatchUi.loadResource(Rez.Fonts.MetricsIconsFont) as WatchUi.FontResource;
        }
        return _iconFont;
    }
}
