import Toybox.Graphics;
import Toybox.Lang;

module SegmentRenderer {

    // Segment Bitmasks (A=1, B=2, C=4, D=8, E=16, F=32, G=64)
    const DIGIT_MASKS as Array<Number> = [
        0x3F, // 0: A B C D E F
        0x06, // 1: B C
        0x5B, // 2: A B D E G
        0x4F, // 3: A B C D G
        0x66, // 4: B C F G
        0x6D, // 5: A C D F G
        0x7D, // 6: A C D E F G
        0x07, // 7: A B C
        0x7F, // 8: A B C D E F G
        0x6F  // 9: A B C D F G
    ];

    function drawTime(dc as Dc, startX as Number, startY as Number, digitWidth as Number, digitHeight as Number, thickness as Number, gap as Number, hours as Number, minutes as Number, activeColor as Number, unlitColor as Number, digitStyle as Number) as Void {
        var h1 = hours / 10;
        var h2 = hours % 10;
        var m1 = minutes / 10;
        var m2 = minutes % 10;

        var currX = startX;

        // Hour Tens (h1)
        drawDigit(dc, currX, startY, digitWidth, digitHeight, thickness, h1, activeColor, unlitColor, digitStyle);
        currX += digitWidth + gap;

        // Hour Ones (h2)
        drawDigit(dc, currX, startY, digitWidth, digitHeight, thickness, h2, activeColor, unlitColor, digitStyle);
        currX += digitWidth + (gap * 2);

        // Colon (:)
        drawColon(dc, currX - (gap / 2), startY, digitHeight, thickness, activeColor, unlitColor, digitStyle);
        currX += thickness + (gap * 2);

        // Minute Tens (m1)
        drawDigit(dc, currX, startY, digitWidth, digitHeight, thickness, m1, activeColor, unlitColor, digitStyle);
        currX += digitWidth + gap;

        // Minute Ones (m2)
        drawDigit(dc, currX, startY, digitWidth, digitHeight, thickness, m2, activeColor, unlitColor, digitStyle);
    }

    function drawDigit(dc as Dc, x as Number, y as Number, w as Number, h as Number, t as Number, digit as Number, activeColor as Number, unlitColor as Number, digitStyle as Number) as Void {
        var mask = (digit >= 0 && digit <= 9) ? DIGIT_MASKS[digit] : 0;
        var halfH = h / 2;

        // 1. Draw Unlit Background Segments (88) Shadow
        if (unlitColor != Graphics.COLOR_TRANSPARENT) {
            dc.setColor(unlitColor, Graphics.COLOR_TRANSPARENT);
            drawChamferedSegments(dc, x, y, w, h, t, halfH, 0x7F);
        }

        // 2. Draw Active Solid Cyan Segments
        if (mask > 0) {
            dc.setColor(activeColor, Graphics.COLOR_TRANSPARENT);
            drawChamferedSegments(dc, x, y, w, h, t, halfH, mask);
        }
    }

    function drawChamferedSegments(dc as Dc, x as Number, y as Number, w as Number, h as Number, t as Number, halfH as Number, mask as Number) as Void {
        var c = t - 1; // 45-degree corner chamfer offset

        // Segment A (Top Horizontal Chamfered Polygon)
        if ((mask & 0x01) != 0) {
            dc.fillPolygon([
                [x + c, y],
                [x + w - c, y],
                [x + w - (c * 2), y + t],
                [x + (c * 2), y + t]
            ]);
        }
        // Segment B (Top Right Vertical Chamfered Polygon)
        if ((mask & 0x02) != 0) {
            dc.fillPolygon([
                [x + w, y + c],
                [x + w, y + halfH - (c / 2)],
                [x + w - t, y + halfH - c],
                [x + w - t, y + (c * 2)]
            ]);
        }
        // Segment C (Bottom Right Vertical Chamfered Polygon)
        if ((mask & 0x04) != 0) {
            dc.fillPolygon([
                [x + w, y + halfH + (c / 2)],
                [x + w, y + h - c],
                [x + w - t, y + h - (c * 2)],
                [x + w - t, y + halfH + c]
            ]);
        }
        // Segment D (Bottom Horizontal Chamfered Polygon)
        if ((mask & 0x08) != 0) {
            dc.fillPolygon([
                [x + c, y + h],
                [x + w - c, y + h],
                [x + w - (c * 2), y + h - t],
                [x + (c * 2), y + h - t]
            ]);
        }
        // Segment E (Bottom Left Vertical Chamfered Polygon)
        if ((mask & 0x10) != 0) {
            dc.fillPolygon([
                [x, y + halfH + (c / 2)],
                [x, y + h - c],
                [x + t, y + h - (c * 2)],
                [x + t, y + halfH + c]
            ]);
        }
        // Segment F (Top Left Vertical Chamfered Polygon)
        if ((mask & 0x20) != 0) {
            dc.fillPolygon([
                [x, y + c],
                [x, y + halfH - (c / 2)],
                [x + t, y + halfH - c],
                [x + t, y + (c * 2)]
            ]);
        }
        // Segment G (Middle Horizontal Hexagonal Polygon)
        if ((mask & 0x40) != 0) {
            dc.fillPolygon([
                [x + c, y + halfH],
                [x + (c * 2), y + halfH - (t / 2)],
                [x + w - (c * 2), y + halfH - (t / 2)],
                [x + w - c, y + halfH],
                [x + w - (c * 2), y + halfH + (t / 2)],
                [x + (c * 2), y + halfH + (t / 2)]
            ]);
        }
    }

    function drawColon(dc as Dc, x as Number, y as Number, h as Number, t as Number, activeColor as Number, unlitColor as Number, digitStyle as Number) as Void {
        var dotSize = t + 1;
        var quarterH = h / 4;

        if (unlitColor != Graphics.COLOR_TRANSPARENT) {
            dc.setColor(unlitColor, Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(x, y + quarterH, dotSize, dotSize);
            dc.fillRectangle(x, y + (quarterH * 3), dotSize, dotSize);
        }

        dc.setColor(activeColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(x, y + quarterH, dotSize, dotSize);
        dc.fillRectangle(x, y + (quarterH * 3), dotSize, dotSize);
    }
}
