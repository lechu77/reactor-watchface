import Toybox.Graphics;
import Toybox.Lang;

module CompactFont {

    function drawText(dc as Dc, x as Number, y as Number, text as String, height as Number, color as Number, align as Number) as Void {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        
        var charWidth = (height * 0.65).toNumber();
        if (charWidth < 4) { charWidth = 4; }
        var gap = 2;
        
        var strLength = text.length();
        var totalWidth = (strLength * charWidth) + ((strLength - 1) * gap);
        
        var startX = x;
        if (align == Graphics.TEXT_JUSTIFY_CENTER) {
            startX = x - (totalWidth / 2);
        } else if (align == Graphics.TEXT_JUSTIFY_RIGHT) {
            startX = x - totalWidth;
        }

        var currX = startX;
        var chars = text.toCharArray();
        
        for (var i = 0; i < chars.size(); i++) {
            drawChar(dc, currX, y, chars[i], charWidth, height);
            currX += charWidth + gap;
        }
    }

    function drawChar(dc as Dc, x as Number, y as Number, ch as Char, w as Number, h as Number) as Void {
        var t = 2; // Stroke thickness
        var halfH = h / 2;

        if (ch == 'M') {
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x + w - t, y, t, h);
            dc.fillPolygon([[x, y], [x + (w/2), y + halfH], [x + (w/2) + t, y + halfH], [x + t, y]]);
            dc.fillPolygon([[x + w, y], [x + (w/2), y + halfH], [x + (w/2) - t, y + halfH], [x + w - t, y]]);
        } else if (ch == 'A') {
            dc.fillRectangle(x, y + t, t, h - t);
            dc.fillRectangle(x + w - t, y + t, t, h - t);
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y + halfH, w, t);
        } else if (ch == 'R') {
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y + halfH, w, t);
            dc.fillRectangle(x + w - t, y, t, halfH);
            dc.fillPolygon([[x + t, y + halfH], [x + w, y + h], [x + w - t, y + h], [x + t, y + halfH + t]]);
        } else if (ch == 'G') {
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x, y + h - t, w, t);
            dc.fillRectangle(x + w - t, y + halfH, t, halfH);
            dc.fillRectangle(x + (w/2), y + halfH, w/2, t);
        } else if (ch == 'O') {
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x + w - t, y, t, h);
            dc.fillRectangle(x, y + h - t, w, t);
        } else if (ch == 'S') {
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y, t, halfH);
            dc.fillRectangle(x, y + halfH - (t/2), w, t);
            dc.fillRectangle(x + w - t, y + halfH, t, halfH);
            dc.fillRectangle(x, y + h - t, w, t);
        } else if (ch == 'E') {
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y + halfH - (t/2), w - t, t);
            dc.fillRectangle(x, y + h - t, w, t);
        } else if (ch == 'F') {
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y + halfH - (t/2), w - t, t);
        } else if (ch == 'G') {
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x, y + h - t, w, t);
            dc.fillRectangle(x + w - t, y + halfH, t, halfH);
            dc.fillRectangle(x + (w/2), y + halfH, w/2, t);
        } else if (ch == 'H') {
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x + w - t, y, t, h);
            dc.fillRectangle(x, y + halfH - (t/2), w, t);
        } else if (ch == 'I') {
            dc.fillRectangle(x + (w/2) - (t/2), y, t, h);
        } else if (ch == 'K') {
            dc.fillRectangle(x, y, t, h);
            dc.drawLine(x + t, y + halfH, x + w, y);
            dc.drawLine(x + t, y + halfH + 1, x + w, y + 1);
            dc.drawLine(x + t, y + halfH, x + w, y + h);
            dc.drawLine(x + t, y + halfH + 1, x + w, y + h - 1);
        } else if (ch == 'N') {
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x + w - t, y, t, h);
            dc.drawLine(x, y, x + w, y + h);
        } else if (ch == 'D') {
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x, y, w - t, t);
            dc.fillRectangle(x, y + h - t, w - t, t);
            dc.fillRectangle(x + w - t, y + t, t, h - (t*2));
        } else if (ch == 'J') {
            dc.fillRectangle(x + w - t, y, t, h);
            dc.fillRectangle(x, y + h - t, w, t);
            dc.fillRectangle(x, y + halfH, t, halfH);
        } else if (ch == 'L') {
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x, y + h - t, w, t);
        } else if (ch == 'U') {
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x + w - t, y, t, h);
            dc.fillRectangle(x, y + h - t, w, t);
        } else if (ch == 'V') {
            dc.drawLine(x, y, x + (w/2), y + h);
            dc.drawLine(x + (w/2), y + h, x + w, y);
        } else if (ch == 'W') {
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x + w - t, y, t, h);
            dc.fillPolygon([[x, y + h], [x + (w/2), y + halfH], [x + (w/2) + t, y + halfH], [x + t, y + h]]);
            dc.fillPolygon([[x + w, y + h], [x + (w/2), y + halfH], [x + (w/2) - t, y + halfH], [x + w - t, y + h]]);
        } else if (ch == 'X') {
            dc.drawLine(x, y, x + w, y + h);
            dc.drawLine(x + 1, y, x + w + 1, y + h);
            dc.drawLine(x + w, y, x, y + h);
            dc.drawLine(x + w - 1, y, x - 1, y + h);
        } else if (ch == 'P') {
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y + halfH, w, t);
            dc.fillRectangle(x + w - t, y, t, halfH);
        } else if (ch == 'Q') {
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x + w - t, y, t, h);
            dc.fillRectangle(x, y + h - t, w, t);
            dc.fillRectangle(x + w - (t*2), y + h - (t*2), t*2, t*2);
        } else if (ch == 'B') {
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x, y, w - t, t);
            dc.fillRectangle(x, y + halfH - (t/2), w - t, t);
            dc.fillRectangle(x, y + h - t, w - t, t);
            dc.fillRectangle(x + w - t, y + t, t, halfH - t);
            dc.fillRectangle(x + w - t, y + halfH, t, halfH - t);
        } else if (ch == 'F') {
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y + halfH - (t/2), w - t, t);
        } else if (ch == 'C') {
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x, y + h - t, w, t);
        } else if (ch == 'Y') {
            dc.fillRectangle(x, y, t, halfH);
            dc.fillRectangle(x + w - t, y, t, h);
            dc.fillRectangle(x, y + halfH - (t/2), w, t);
            dc.fillRectangle(x, y + h - t, w, t);
        } else if (ch == 'Z') {
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y + h - t, w, t);
            dc.drawLine(x + w, y, x, y + h);
            dc.drawLine(x + w - 1, y, x + 1, y + h);
        } else if (ch == 'T') {
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x + (w/2) - (t/2), y, t, h);
        } else if (ch == '0') {
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x + w - t, y, t, h);
            dc.fillRectangle(x, y + h - t, w, t);
        } else if (ch == '1') {
            dc.fillRectangle(x + w - t, y, t, h);
        } else if (ch == '2') {
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x + w - t, y, t, halfH);
            dc.fillRectangle(x, y + halfH - (t/2), w, t);
            dc.fillRectangle(x, y + halfH, t, halfH);
            dc.fillRectangle(x, y + h - t, w, t);
        } else if (ch == '3') {
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x + w - t, y, t, h);
            dc.fillRectangle(x, y + halfH - (t/2), w, t);
            dc.fillRectangle(x, y + h - t, w, t);
        } else if (ch == '4') {
            dc.fillRectangle(x, y, t, halfH);
            dc.fillRectangle(x, y + halfH - (t/2), w, t);
            dc.fillRectangle(x + w - t, y, t, h);
        } else if (ch == '5') {
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y, t, halfH);
            dc.fillRectangle(x, y + halfH - (t/2), w, t);
            dc.fillRectangle(x + w - t, y + halfH, t, halfH);
            dc.fillRectangle(x, y + h - t, w, t);
        } else if (ch == '6') {
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x, y + halfH - (t/2), w, t);
            dc.fillRectangle(x + w - t, y + halfH, t, halfH);
            dc.fillRectangle(x, y + h - t, w, t);
        } else if (ch == '7') {
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x + w - t, y, t, h);
        } else if (ch == '8') {
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y, t, h);
            dc.fillRectangle(x + w - t, y, t, h);
            dc.fillRectangle(x, y + halfH - (t/2), w, t);
            dc.fillRectangle(x, y + h - t, w, t);
        } else if (ch == '9') {
            dc.fillRectangle(x, y, w, t);
            dc.fillRectangle(x, y, t, halfH);
            dc.fillRectangle(x + w - t, y, t, h);
            dc.fillRectangle(x, y + halfH - (t/2), w, t);
            dc.fillRectangle(x, y + h - t, w, t);
        } else if (ch == '%') {
            dc.fillRectangle(x, y, t*2, t*2); 
            dc.fillRectangle(x + w - t*2, y + h - t*2, t*2, t*2); 
            dc.drawLine(x, y + h, x + w, y);
            dc.drawLine(x+1, y + h, x + w + 1, y);
        } else if (ch == '.') {
            dc.fillRectangle(x + (w/2) - (t/2), y + h - t, t, t);
        } else {
            // Default block character fallback
            dc.fillRectangle(x, y, w, h);
        }
    }
}
