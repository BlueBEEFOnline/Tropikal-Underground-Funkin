package options;

import options.screens.OptionMain;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;

class OptionScreen extends MusicBeatState {
    public var options:Array<FunkinOption> = [];

    public var emptyTxt:FlxText;
    public var canSelect:Bool = true;
    public var curSelected:Int = 0;

    public static inline var speedMultiplier:Float = 0.75;

    var spawnedOptions:Array<OptionSprite> = [];
    var optionsPanel:FlxSpriteGroup = new FlxSpriteGroup();
    public function new() {
        super();
    }
    public override function create() {
        super.create();
        CoolUtil.playMenuMusic();
        if (subState != null) subState.close();
        var bg = CoolUtil.addBG(this);
        if (options.length <= 0) {
            emptyTxt = new FlxText(0, 0, 0, "Oops! Seems like this menu is empty.\nPress [Esc] to go back.\n");
            emptyTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            emptyTxt.antialiasing = true;
            emptyTxt.scrollFactor.set();
            emptyTxt.screenCenter();
            emptyTxt.offset.y = 50;
            emptyTxt.alpha = 0;
            add(emptyTxt);
        } else {
            for(o in options) {
                var option = new OptionSprite(o);
                spawnedOptions.push(option);
                optionsPanel.add(option);
            }
        }
        add(optionsPanel);
    }

    var time:Float = 0;
    var flickerId:Int = -1;
    var flickerTime:Float = 0;
    var flickerCallback:Void->Void = null;
    public override function update(elapsed:Float) {
        super.update(elapsed);
        time += elapsed;
        FlxG.camera.y = FlxMath.lerp(-FlxG.height, 0, FlxEase.quartOut(FlxMath.bound(time / speedMultiplier, 0, 1)));
        if (controls.BACK) onExit();
        if (options.length <= 0) {
            var l = FlxEase.quintOut(FlxMath.bound(time, 0, 1));
            emptyTxt.offset.y = FlxMath.lerp(50, 0, l);
            emptyTxt.alpha = FlxMath.lerp(0, 1, l);
            return;   
        }
        for(k=>o in spawnedOptions) {
            var i = k - curSelected;
            o.x = FlxMath.lerp(o.x, 0 + (i * 10), 0.125 * elapsed * 60);
            o.y = FlxMath.lerp(o.y, ((FlxG.height / 2) - 50) + (i * 125), 0.125 * elapsed * 60);
            o.alpha = FlxMath.lerp(o.alpha, k == curSelected ? 1 : 0.3, 0.125 * elapsed * 60);
        }
        if (spawnedOptions[curSelected] != null) {
            if (spawnedOptions[curSelected].onUpdate != null) spawnedOptions[curSelected].onUpdate(elapsed);
        }
        if (canSelect) {
            var oldCur = curSelected;
            if (controls.DOWN_P)
                curSelected++;
            if (controls.UP_P)
                curSelected--;
            if (curSelected != oldCur) {
                while(curSelected < 0) curSelected += spawnedOptions.length;
                curSelected %= spawnedOptions.length;
                CoolUtil.playMenuSFX(0);
            }
            if (controls.ACCEPT) {
                if (spawnedOptions[curSelected] != null) {
                    if (spawnedOptions[curSelected].onSelect != null) spawnedOptions[curSelected].onSelect(spawnedOptions[curSelected]);
                    onSelect(curSelected);
                }
            }
        }
        if (flickerId != -1) {
            var flickerTime = time - flickerTime;
            for(k=>o in spawnedOptions) {
                if (flickerId < 0) {

                } else if (k == flickerId) {
                    o.alpha = (Std.int(flickerTime * 5) % 2) != 0 ? 1 : 0;
                } else {
                    o.alpha = 0;
                }
                if (flickerTime > speedMultiplier) {
                    flickerId = -1;
                    FlxTransitionableState.skipNextTransOut = true;
                    FlxTransitionableState.skipNextTransIn = true;
                    flickerCallback();
                }
            }
            FlxG.camera.y = FlxMath.lerp(0, FlxG.height, FlxEase.quartIn(FlxMath.bound(flickerTime / speedMultiplier, 0, 1)));
        }
    }

    public function onExit() {
        doFlickerAnim(-2, function() {
            FlxG.switchState(new OptionMain(0, 0));
        });
    }

    public function onSelect(id:Int) {

    }
    
    public function doFlickerAnim(id:Int, callback:Void->Void) {
        canSelect = false;
        flickerId = id;
        flickerTime = time;
        flickerCallback = callback;
        CoolUtil.playMenuSFX(1);
    }
}