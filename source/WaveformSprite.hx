import lime.utils.ArrayBuffer;
import openfl.geom.Rectangle;
import openfl.media.Sound;
import flixel.system.FlxSound;
import lime.media.AudioBuffer;
import flixel.FlxSprite;

@:keep
class WaveformSprite extends FlxSprite {
    var buffer:AudioBuffer;
    var sound:Sound;
    var peak:Float = 0;
    public function new(x:Float, y:Float, buffer:Dynamic, w:Int, h:Int) {
        super(x,y);
        this.buffer = null;
        if (Std.isOfType(buffer, FlxSound)) {
            @:privateAccess
            this.buffer = cast(buffer, FlxSound)._sound.__buffer;
            @:privateAccess
            this.sound = cast(buffer, FlxSound)._sound;
        } else if (Std.isOfType(buffer, Sound)) {
            @:privateAccess
            this.buffer = cast(buffer, Sound).__buffer;
            this.sound = cast(buffer, Sound);
        } else if (Std.isOfType(buffer, AudioBuffer)) {
            @:privateAccess
            this.buffer = cast(buffer, AudioBuffer);
        } else {
            throw 'Invalid type';
            return;
        }
        trace(buffer);
        trace(buffer.data);
        for(i in 0...Math.floor(buffer.data.length / buffer.bitsPerSample)) {
            var pos = i * buffer.bitsPerSample;
            var thing = getNumberFromBuffer(Std.int(pos), 1);
            var data = 0;
            if ((data = thing) > peak) peak = data;
        }
        trace(buffer.bitsPerSample);
        makeGraphic(w, h, 0x00000000); // transparent
    }

    public function generate(startPos:Int, endPos:Int) {
        pixels.lock();
        pixels.fillRect(new Rectangle(0, 0, pixels.width, pixels.height), 0); 
        var diff = endPos - startPos;
        for(y in 0...pixels.height) {
            var d = Math.floor(diff * (y / pixels.height));
            d -= d % buffer.bitsPerSample;
            var pos = startPos + d;
            var thing = getNumberFromBuffer(pos, 1);
            var w = (thing) / peak * pixels.width;
            pixels.fillRect(new Rectangle((pixels.width / 2) - (w / 2), y, w, 1), 0xFFFFFFFF);
        }
        pixels.unlock();
    }

    public function generateFlixel(startPos:Float, endPos:Float) {
        var rateFrequency = (1 / buffer.sampleRate);
        var multiplicator = 1 / rateFrequency; // 1 hz/s
        multiplicator *= buffer.bitsPerSample;
        multiplicator -= multiplicator % buffer.bitsPerSample;

        generate(Math.floor(startPos * multiplicator / 4000), Math.floor(endPos * multiplicator / 4000));
    }

    public function getNumberFromBuffer(pos:Int, bytes:Int):Int {
        var am = 0;
        for(i in 0...bytes) {
            var val = buffer.data.buffer.get(pos + i);
            if (val < 0) val += 256;
            for(i2 in 0...(bytes-i)) val *= 256;
            am += val;
        }
        return am;
    }
}