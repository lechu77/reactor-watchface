import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.SensorHistory;
import Toybox.System;
import Toybox.Lang;

class ChartWidget {

    function initialize() {
    }

    function draw(dc as Dc, data as DataProvider, theme as Theme.ThemeConfig) as Void {
        if (theme.isAod || !theme.showTopCharts) {
            return;
        }

        if (!(Toybox has :SensorHistory)) {
            return;
        }

        var numBars = 30;
        var barW = 3;
        var barGap = 2;
        var chartW = numBars * (barW + barGap) - barGap; // 148px
        var gap = 18;
        
        var cx = dc.getWidth() / 2;
        var chartTopY = 44;
        var chartH = 64;
        
        var primaryCol = theme.getPrimaryColor();
        var dimCol = Theme.COLOR_SEGMENT_OFF;

        // Left Chart: Heart Rate
        if (Toybox.SensorHistory has :getHeartRateHistory) {
            var hrIter = Toybox.SensorHistory.getHeartRateHistory({:period => numBars});
            drawChart(dc, hrIter, numBars, cx - chartW - (gap / 2), chartTopY, chartH, barW, barGap, primaryCol, dimCol);
        }

        // Right Chart: Body Battery
        if (Toybox.SensorHistory has :getBodyBatteryHistory) {
            var bbIter = Toybox.SensorHistory.getBodyBatteryHistory({:period => numBars});
            drawChart(dc, bbIter, numBars, cx + (gap / 2), chartTopY, chartH, barW, barGap, primaryCol, dimCol);
        }
    }

    private function drawChart(dc as Dc, iter as Toybox.SensorHistory.SensorHistoryIterator?, numBars as Number, startX as Number, startY as Number, height as Number, barW as Number, barGap as Number, primaryCol as Number, dimCol as Number) as Void {
        if (iter == null) {
            return;
        }

        var samples = new [numBars] as Array<Number?>;
        var count = 0;
        var sample = iter.next();
        
        while (sample != null && count < numBars) {
            if (sample.data != null) {
                samples[count] = sample.data as Number;
            }
            count++;
            sample = iter.next();
        }

        if (count == 0) {
            return;
        }

        var localMin = 999 as Number;
        var localMax = -999 as Number;
        for (var i = 0; i < count; i++) {
            if (samples[i] != null) {
                var s = samples[i] as Number;
                if (s < localMin) { localMin = s; }
                if (s > localMax) { localMax = s; }
            }
        }
        
        if (localMin > 10) { localMin -= 10; }
        if (localMax < 245) { localMax += 10; }
        if (localMin >= localMax) {
            localMax = localMin + 1;
        }

        var range = (localMax - localMin).toFloat();
        var chartBottomY = startY + height;

        for (var i = 0; i < count; i++) {
            var val = samples[count - 1 - i];
            var x = startX + (i * (barW + barGap));
            
            dc.setColor(dimCol, Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(x, startY, barW, height);
            
            if (val != null) {
                var v = val as Number;
                var ratio = (v - localMin).toFloat() / range;
                if (ratio > 1.0) { ratio = 1.0; }
                if (ratio < 0.0) { ratio = 0.0; }
                
                var fillH = (ratio * height.toFloat()).toNumber();
                if (fillH > 0) {
                    dc.setColor(primaryCol, Graphics.COLOR_TRANSPARENT);
                    dc.fillRectangle(x, chartBottomY - fillH, barW, fillH);
                }
            }
        }
    }
}
