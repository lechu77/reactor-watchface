import Toybox.Graphics;
import Toybox.Lang;

class TimeWidget {
    private var _vfdDrawables as Array<Toybox.WatchUi.BitmapResource>?;
    private var _vfdSmallDrawables as Array<Toybox.WatchUi.BitmapResource>?;

    function initialize() {
    }

    function draw(dc as Dc, data as DataProvider, theme as Theme.ThemeConfig) as Void {
        var cx = dc.getWidth() / 2; // 227

        // Frame Box Dimensions (324px wide, 178px height, Y=115 to Y=293)
        var frameWidth = 324;  
        var frameHeight = 178; 
        var frameX = cx - (frameWidth / 2); // 65
        var frameY = 138;                  // Top edge at Y=138 (Centered on Y=227)

        var borderCol = theme.getFrameBorderColor(); // #5ED7D2 Cyan
        var primaryCol = theme.getPrimaryColor();     // #5ED7D2 Cyan
        var unlitCol = Theme.COLOR_SEGMENT_OFF;      // #1C202B Dark Unlit LCD Shadow

        // Date row colors: text in white, day number in clock cyan
        var dateTextCol = Theme.COLOR_ICONS;           // White (#D7D7D7) for MAR and AGO
        var dateDayCol = primaryCol;                   // Same cyan as clock for day number (04)
        var windowBgCol = 0x0A161A;                   // Deep dark subtle background
        var windowBorderCol = 0x14343A;               // Subtle thin window border

        // 1. Draw Outer SOLID Heavy Cyan Frame Border (4px solid stroke)
        dc.setColor(borderCol, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < 4; i++) {
            dc.drawRoundedRectangle(frameX + i, frameY + i, frameWidth - (i * 2), frameHeight - (i * 2), 14 - i);
        }

        // 2. TOP DATE COMPARTMENT - SUBTLE & MUTED (MAR + 04 + AGO)
        var dateTopY = frameY + 12; // Match the 12px winMargin for symmetrical padding
        var dateWindowH = 30;
        var winW = 92;
        var winGap = 12;
        var winMargin = 12;

        // Window 1: Left (MAR)
        var win1X = frameX + winMargin; // 77
        dc.setColor(windowBgCol, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(win1X, dateTopY, winW, dateWindowH, 4);
        dc.setColor(windowBorderCol, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(win1X, dateTopY, winW, dateWindowH, 4);
        CompactFont.drawText(dc, win1X + (winW / 2), dateTopY + 8, data.dayName, 14, dateTextCol, Graphics.TEXT_JUSTIFY_CENTER);

        // Window 2: Center (04 Day Number in Muted 7-Segment Teal)
        var win2X = win1X + winW + winGap; // 181
        dc.setColor(windowBgCol, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(win2X, dateTopY, winW, dateWindowH, 4);
        dc.setColor(windowBorderCol, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(win2X, dateTopY, winW, dateWindowH, 4);
        
        // Parse Day Number
        var d1 = 0;
        var d2 = 4;
        if (data.dayNumber.length() >= 2) {
            var s1 = data.dayNumber.substring(0, 1);
            var s2 = data.dayNumber.substring(1, 2);
            if (s1 != null) {
                var v1 = s1.toNumber();
                if (v1 != null) { d1 = v1; }
            }
            if (s2 != null) {
                var v2 = s2.toNumber();
                if (v2 != null) { d2 = v2; }
            }
        }
        
        // Draw 7-Segment Day Number "04" centered inside Window 2 in same cyan as clock
        var numX = win2X + (winW / 2) - 12; // 215
        if (theme.digitStyle == 1) {
            if (_vfdSmallDrawables == null) {
                _vfdSmallDrawables = new [10] as Array<Toybox.WatchUi.BitmapResource>;
                _vfdSmallDrawables[0] = Application.loadResource(Rez.Drawables.VfdSmall0) as Toybox.WatchUi.BitmapResource;
                _vfdSmallDrawables[1] = Application.loadResource(Rez.Drawables.VfdSmall1) as Toybox.WatchUi.BitmapResource;
                _vfdSmallDrawables[2] = Application.loadResource(Rez.Drawables.VfdSmall2) as Toybox.WatchUi.BitmapResource;
                _vfdSmallDrawables[3] = Application.loadResource(Rez.Drawables.VfdSmall3) as Toybox.WatchUi.BitmapResource;
                _vfdSmallDrawables[4] = Application.loadResource(Rez.Drawables.VfdSmall4) as Toybox.WatchUi.BitmapResource;
                _vfdSmallDrawables[5] = Application.loadResource(Rez.Drawables.VfdSmall5) as Toybox.WatchUi.BitmapResource;
                _vfdSmallDrawables[6] = Application.loadResource(Rez.Drawables.VfdSmall6) as Toybox.WatchUi.BitmapResource;
                _vfdSmallDrawables[7] = Application.loadResource(Rez.Drawables.VfdSmall7) as Toybox.WatchUi.BitmapResource;
                _vfdSmallDrawables[8] = Application.loadResource(Rez.Drawables.VfdSmall8) as Toybox.WatchUi.BitmapResource;
                _vfdSmallDrawables[9] = Application.loadResource(Rez.Drawables.VfdSmall9) as Toybox.WatchUi.BitmapResource;
            }
            // Small digits are 16x24. The old vector ones were 10x18.
            // Adjust X to center properly. 16px wide each, so total 32px wide + gap? No, we just place them adjacently.
            var sw = 16;
            var sY = dateTopY + 3; // Center vertically in 30px window
            var sX = win2X + (winW / 2) - sw;
            dc.drawBitmap(sX, sY, _vfdSmallDrawables[d1]);
            dc.drawBitmap(sX + sw, sY, _vfdSmallDrawables[d2]);
        } else {
            SegmentRenderer.drawDigit(dc, numX, dateTopY + 6, 10, 18, 2, d1, dateDayCol, unlitCol, 0);
            SegmentRenderer.drawDigit(dc, numX + 14, dateTopY + 6, 10, 18, 2, d2, dateDayCol, unlitCol, 0);
        }

        // Window 3: Right (AGO)
        var win3X = win2X + winW + winGap; // 285
        dc.setColor(windowBgCol, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(win3X, dateTopY, winW, dateWindowH, 4);
        dc.setColor(windowBorderCol, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(win3X, dateTopY, winW, dateWindowH, 4);
        CompactFont.drawText(dc, win3X + (winW / 2), dateTopY + 8, data.monthName, 14, dateTextCol, Graphics.TEXT_JUSTIFY_CENTER);

        // 3. HORIZONTAL SEPARATOR LINE between Date and Clock
        var sepY = dateTopY + dateWindowH + 5; // 156
        dc.setColor(0x14343A, Graphics.COLOR_TRANSPARENT);
        // Line spanning exactly from the left edge of MAR box to the right edge of AGO box
        dc.drawLine(win1X, sepY, win3X + winW, sepY);

        // 4. LOWER CLOCK COMPARTMENT - Bold 7-Segment Digits
        var hours = data.hours;
        var minutes = data.minutes;

        var lowerCenterY = sepY + 2 + ((frameY + frameHeight - sepY - 2) / 2); // 224

        if (theme.digitStyle == 1) {
            if (_vfdDrawables == null) {
                _vfdDrawables = new [11] as Array<Toybox.WatchUi.BitmapResource>;
                _vfdDrawables[0] = Application.loadResource(Rez.Drawables.Vfd0) as Toybox.WatchUi.BitmapResource;
                _vfdDrawables[1] = Application.loadResource(Rez.Drawables.Vfd1) as Toybox.WatchUi.BitmapResource;
                _vfdDrawables[2] = Application.loadResource(Rez.Drawables.Vfd2) as Toybox.WatchUi.BitmapResource;
                _vfdDrawables[3] = Application.loadResource(Rez.Drawables.Vfd3) as Toybox.WatchUi.BitmapResource;
                _vfdDrawables[4] = Application.loadResource(Rez.Drawables.Vfd4) as Toybox.WatchUi.BitmapResource;
                _vfdDrawables[5] = Application.loadResource(Rez.Drawables.Vfd5) as Toybox.WatchUi.BitmapResource;
                _vfdDrawables[6] = Application.loadResource(Rez.Drawables.Vfd6) as Toybox.WatchUi.BitmapResource;
                _vfdDrawables[7] = Application.loadResource(Rez.Drawables.Vfd7) as Toybox.WatchUi.BitmapResource;
                _vfdDrawables[8] = Application.loadResource(Rez.Drawables.Vfd8) as Toybox.WatchUi.BitmapResource;
                _vfdDrawables[9] = Application.loadResource(Rez.Drawables.Vfd9) as Toybox.WatchUi.BitmapResource;
                _vfdDrawables[10] = Application.loadResource(Rez.Drawables.VfdColon) as Toybox.WatchUi.BitmapResource;
            }
            
            var w = 54; // Image width
            var h = 100; // Image height
            var totalW = w * 5; // 270
            var vfdStartX = cx - (totalW / 2);
            var vfdStartY = lowerCenterY - (h / 2);
            
            dc.drawBitmap(vfdStartX, vfdStartY, _vfdDrawables[hours / 10]);
            dc.drawBitmap(vfdStartX + w, vfdStartY, _vfdDrawables[hours % 10]);
            dc.drawBitmap(vfdStartX + w * 2, vfdStartY, _vfdDrawables[10]);
            dc.drawBitmap(vfdStartX + w * 3, vfdStartY, _vfdDrawables[minutes / 10]);
            dc.drawBitmap(vfdStartX + w * 4, vfdStartY, _vfdDrawables[minutes % 10]);
        } else {
            var digitW = 46;
            var digitH = 92;
            var thick = 9;
            var gap = 10;

            var totalClockW = (digitW * 4) + (gap * 2) + 20 + thick; // 233px
            var startX = cx - (totalClockW / 2);                      // 110
            var startY = lowerCenterY - (digitH / 2);                     // 178

            // Draw Clean Bold Chamfered 7-Segment Digits
            SegmentRenderer.drawTime(dc, startX, startY, digitW, digitH, thick, gap, hours, minutes, primaryCol, unlitCol, 0);
        }
    }
}
