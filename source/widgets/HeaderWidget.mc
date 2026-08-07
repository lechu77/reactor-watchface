import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class HeaderWidget {

    function initialize() {
        // No longer need bitmap resource
    }

    function draw(dc as Dc, data as DataProvider, theme as Theme.ThemeConfig) as Void {
        if (!theme.showTopBattery) {
            return;
        }

        var cx = dc.getWidth() / 2; // 227 on 454x454
        
        // TOP: Centered between top edge (0) and chartTopY (44)
        var battY = 14; 
        
        var battPercent = data.batteryPercent;
        var battPercentStr = battPercent.format("%d") + "%";
        var battW = 32;
        var battH = 17;
        var nubW = 3;
        var nubH = 8;
        var padding = 2;
        var spacing = 4;
        
        var font = Graphics.FONT_XTINY;
        var textWidth = dc.getTextWidthInPixels(battPercentStr, font);
        var textHeight = dc.getFontHeight(font);
        
        var totalWidth = battW + nubW + spacing + textWidth;
        var startX = cx - (totalWidth / 2);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // 1. Draw Battery Outer Shell (2px thick)
        dc.setPenWidth(2);
        dc.drawRoundedRectangle(startX, battY, battW, battH, 2);
        dc.setPenWidth(1);

        // 2. Draw Battery Nub
        dc.fillRectangle(startX + battW, battY + (battH - nubH) / 2, nubW, nubH);

        // 3. Draw Battery Fill (Dynamic)
        var maxFillW = battW - (padding * 2);
        var fillW = (maxFillW * (battPercent / 100.0)).toNumber();
        if (fillW > 0) {
            dc.fillRectangle(startX + padding, battY + padding, fillW, battH - (padding * 2));
        }

        // 4. Draw Battery Percentage Text
        // Center text vertically with the battery icon using precise font height
        var textY = battY + (battH / 2) - (textHeight / 2) - 1; // -1 for optical baseline adjustment
        dc.drawText(startX + battW + nubW + spacing, textY, font, battPercentStr, Graphics.TEXT_JUSTIFY_LEFT);
    }
}
