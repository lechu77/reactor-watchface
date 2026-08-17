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

        // Left Chart
        drawChartForMetric(dc, theme.topChartLeft, theme.topLeftChartType, numBars, cx - chartW - (gap / 2), chartTopY, chartH, barW, barGap, primaryCol, dimCol);

        // Right Chart
        drawChartForMetric(dc, theme.topChartRight, theme.topRightChartType, numBars, cx + (gap / 2), chartTopY, chartH, barW, barGap, primaryCol, dimCol);
    }

    private function drawChartForMetric(dc as Dc, metric as Number, chartType as Number, numBars as Number, startX as Number, startY as Number, height as Number, barW as Number, barGap as Number, primaryCol as Number, dimCol as Number) as Void {
        var iter = null;
        if (metric == 4 && Toybox.SensorHistory has :getHeartRateHistory) {
            iter = Toybox.SensorHistory.getHeartRateHistory({:period => numBars});
        } else if (metric == 10 && Toybox.SensorHistory has :getBodyBatteryHistory) {
            iter = Toybox.SensorHistory.getBodyBatteryHistory({:period => numBars});
        } else if (metric == 5 && Toybox.SensorHistory has :getStressHistory) {
            iter = Toybox.SensorHistory.getStressHistory({:period => numBars});
        } else if (metric == 13 && Toybox.SensorHistory has :getOxygenSaturationHistory) {
            iter = Toybox.SensorHistory.getOxygenSaturationHistory({:period => numBars});
        } else if (metric == 22 && Toybox.SensorHistory has :getElevationHistory) {
            iter = Toybox.SensorHistory.getElevationHistory({:period => numBars});
        } else if (metric == 23 && Toybox.SensorHistory has :getTemperatureHistory) {
            iter = Toybox.SensorHistory.getTemperatureHistory({:period => numBars});
        } else if (metric == 30 && Toybox.SensorHistory has :getPressureHistory) {
            iter = Toybox.SensorHistory.getPressureHistory({:period => numBars});
        }

        if (iter != null) {
            drawChart(dc, iter, chartType, numBars, startX, startY, height, barW, barGap, primaryCol, dimCol);
        }
    }

    private function drawChart(dc as Dc, iter as Toybox.SensorHistory.SensorHistoryIterator?, chartType as Number, numBars as Number, startX as Number, startY as Number, height as Number, barW as Number, barGap as Number, primaryCol as Number, dimCol as Number) as Void {
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
        
        var prevX = -1;
        var prevY = -1;
        
        if (dc has :setPenWidth) {
            if (chartType == 2 || chartType == 3) {
                dc.setPenWidth(2);
            }
        }

        for (var i = 0; i < count; i++) {
            var val = samples[count - 1 - i];
            var x = startX + (i * (barW + barGap));
            var fillH = 0;
            var yPos = chartBottomY;
            
            if (val != null) {
                var v = val as Number;
                var ratio = (v - localMin).toFloat() / range;
                if (ratio > 1.0) { ratio = 1.0; }
                if (ratio < 0.0) { ratio = 0.0; }
                fillH = (ratio * height.toFloat()).toNumber();
                yPos = chartBottomY - fillH;
            }
            
            if (chartType == 0) {
                // Type 0: Solid
                dc.setColor(dimCol, Graphics.COLOR_TRANSPARENT);
                dc.fillRectangle(x, startY, barW, height);
                if (val != null && fillH > 0) {
                    dc.setColor(primaryCol, Graphics.COLOR_TRANSPARENT);
                    dc.fillRectangle(x, yPos, barW, fillH);
                }
            } else if (chartType == 1) {
                // Type 1: Dot Matrix
                var dotSize = barW;
                var dotGap = 1;
                var stepY = dotSize + dotGap;
                var dotsCount = height / stepY;
                var activeDots = (val != null && fillH > 0) ? (fillH / stepY) : 0;
                
                for (var d = 0; d < dotsCount; d++) {
                    var dotY = chartBottomY - (d * stepY) - dotSize;
                    if (d < activeDots) {
                        dc.setColor(primaryCol, Graphics.COLOR_TRANSPARENT);
                    } else {
                        dc.setColor(dimCol, Graphics.COLOR_TRANSPARENT);
                    }
                    dc.fillRectangle(x, dotY, barW, dotSize);
                }
            } else if (chartType == 2) {
                // Type 2: Stepped Line
                if (val != null) {
                    dc.setColor(primaryCol, Graphics.COLOR_TRANSPARENT);
                    if (prevX != -1 && prevY != -1) {
                        dc.drawLine(prevX, prevY, x, prevY);
                        dc.drawLine(x, prevY, x, yPos);
                    } else {
                        dc.drawLine(x, yPos, x + barW, yPos);
                    }
                    dc.drawLine(x, yPos, x + barW, yPos);
                    prevX = x + barW;
                    prevY = yPos;
                } else {
                    prevX = -1;
                    prevY = -1;
                }
            } else if (chartType == 3) {
                // Type 3: Oscilloscope
                if (val != null) {
                    dc.setColor(primaryCol, Graphics.COLOR_TRANSPARENT);
                    if (prevX != -1 && prevY != -1) {
                        dc.drawLine(prevX, prevY, x, yPos);
                    } else {
                        dc.drawLine(x, yPos, x + barW, yPos);
                    }
                    dc.drawLine(x, yPos, x + barW, yPos);
                    prevX = x + barW;
                    prevY = yPos;
                } else {
                    prevX = -1;
                    prevY = -1;
                }
            } else if (chartType == 4) {
                // Type 4: LCD Outline
                dc.setColor(dimCol, Graphics.COLOR_TRANSPARENT);
                dc.drawRectangle(x, startY, barW, height);
                if (val != null && fillH > 0) {
                    dc.setColor(primaryCol, Graphics.COLOR_TRANSPARENT);
                    dc.fillRectangle(x, yPos, barW, fillH);
                }
            }
        }
        
        if (dc has :setPenWidth) {
            dc.setPenWidth(1);
        }
    }
}
