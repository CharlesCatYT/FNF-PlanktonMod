package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import lime.utils.Assets;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.utils.Assets as OpenFlAssets;

#if sys
import sys.io.File;
import sys.FileSystem;
#end
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

typedef PieceFile = 
{
	var position:Array<Float>; //regular stuff
	var scale:Float;
	var flip:Bool;
    var scrollFactor:Array<Float>;
    var aa:Bool;

    var isAnimated:Bool; //animated shit
    var anims:Array<PieceAnims>;
    var animToPlay:String;

    var isDanceable:Bool; //mainly for background bopping sprites
    var animToPlayOnDance:String;

    //var animChangeEvents:Array<AnimChanges>; //extra stuff you can do
    //var posChangeEvents:Array<PosChanges>;  //will add these later
}

typedef PieceAnims = 
{
	var anim:String; 
	var xmlname:String;
	var frameRate:Int;
	var loop:Bool;
}

typedef AnimChanges = 
{
    var step:Int;
    var animToPlay:String;
}
typedef PosChanges = 
{
    var step:Int;
    var pos:Array<Float>;
    var angle:Float;

    var songSpecific:Bool;
    var songsToPlayEvent:Array<String>;

    var useTween:Bool;
    var tweenData:Array<TweenShit>;
}

typedef TweenShit = 
{
    var time:Float;
    var ease:FlxEase;
}

class StagePiece extends FlxSprite
{
    public var part:String = "stageFront";
    public var newx:Float = 0;
    public var newy:Float = 0;
    public var danceable:Bool = false;
    public static var daBeat:Int = 0;

    var danceDir:Bool = false;
    var fastCarCanDrive:Bool = true;
    var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

    var lightnum:Int = 0; //for week 3
    public static var curLight:Int = 0; //also for week 3
	var trainMoving:Bool = false; //why is week 3 so complex????? ahhhhhhhhhhhhhh
	var trainFrameTiming:Float = 0;
	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
    var startedMoving:Bool = false;
    var trainSound:FlxSound;

    public var hasEvents:Bool = false;

    var danceAnim:String = "Bop";

	public function new(x:Float = 0, y:Float = 0, ?piece:String = "stageFront")
        {
            super(x, y); //x and y are optional, so epic for loop can be used


            var tex:FlxAtlasFrames;
            part = piece;
            antialiasing = true;
            switch(part) //where you put each sprite in the stage
            {
                /////////////////////////////////////////////// week 1
                case 'stageBG': 
                    loadGraphic(Paths.image('stageback'));
                    newx = -600;
                    newy = -200;
                    scrollFactor.set(0.9, 0.9);
                    active = false;
                case 'stageFront': 
                    loadGraphic(Paths.image('stagefront'));
                    newx = -650;
                    newy = 600;
                    setGraphicSize(Std.int(width * 1.1));
                    updateHitbox();
                    scrollFactor.set(0.9, 0.9);
                    active = false;
                case 'stageCurtains': 
                    loadGraphic(Paths.image('stagecurtains'));
                    newx = -500;
                    newy = -300;
                    setGraphicSize(Std.int(width * 0.9));
                    updateHitbox();
                    scrollFactor.set(1.3, 1.3);
                    active = false;

                /////////////////////////////////////////////////////// week 2
                case 'halloweenBG': 
                    danceable = true;
                    tex = Paths.getSparrowAtlas('halloween_bg', 'week2');
                    frames = tex;
                    newx = -200;
                    newy = -100;
					animation.addByPrefix('idle', 'halloweem bg0');
					animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
					animation.play('idle');
                /////////////////////////////////////////////////////// week 3

                case "phillyBG": 
                    loadGraphic(Paths.image('philly/sky', 'week3'));
                    scrollFactor.set(0.1, 0.1);
                    newx = -100;
                case "phillyCity": 
                    loadGraphic(Paths.image('philly/city', 'week3'));
                    newx = -10;
					scrollFactor.set(0.3, 0.3);
					setGraphicSize(Std.int(width * 0.85));
					updateHitbox();
                case "phillyCityLight0": 
                    loadGraphic(Paths.image('philly/win0', 'week3'));
                    newx = -10; //x and y
                    scrollFactor.set(0.3, 0.3);
                    visible = false;
                    setGraphicSize(Std.int(width * 0.85));
                    updateHitbox();
                    danceable = true;
                    lightnum = 0;
                case "phillyCityLight1": 
                    loadGraphic(Paths.image('philly/win1', 'week3'));
                    newx = -10; //x and y
                    scrollFactor.set(0.3, 0.3);
                    visible = false;
                    setGraphicSize(Std.int(width * 0.85));
                    updateHitbox();
                    danceable = true;
                    lightnum = 1;
                case "phillyCityLight2": 
                    loadGraphic(Paths.image('philly/win2', 'week3'));
                    newx = -10; //x and y
                    scrollFactor.set(0.3, 0.3);
                    visible = false;
                    setGraphicSize(Std.int(width * 0.85));
                    updateHitbox();
                    danceable = true;
                    lightnum = 2;
                case "phillyCityLight3": 
                    loadGraphic(Paths.image('philly/win3', 'week3'));
                    newx = -10; //x and y
                    scrollFactor.set(0.3, 0.3);
                    visible = false;
                    setGraphicSize(Std.int(width * 0.85));
                    updateHitbox();
                    danceable = true;
                    lightnum = 3;
                case "phillyCityLight4": 
                    loadGraphic(Paths.image('philly/win4', 'week3'));
                    newx = -10; //x and y
                    scrollFactor.set(0.3, 0.3);
                    visible = false;
                    setGraphicSize(Std.int(width * 0.85));
                    updateHitbox();
                    danceable = true;
                    lightnum = 4;
                case "phillySteetBehind": 
                    loadGraphic(Paths.image('philly/behindTrain', 'week3'));
                    newx = -40; //x and y
                    newy = 50;
                case "phillyTrain": 
                    loadGraphic(Paths.image('philly/train', 'week3'));
                    newx = 2000; //x and y
                    newy = 360;
                    trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
					FlxG.sound.list.add(trainSound);
                    danceable = true;
                case "phillyStreet": 
                    loadGraphic(Paths.image('philly/street', 'week3'));
                    newx = -40; //x and y
                    newy = 50;
                //////////////////////////////////////////////////////// week 4

                case 'limoSkyBG': 
                    loadGraphic(Paths.image('limo/limoSunset', 'week4'));
                    newx = -120;
                    newy = -50;
                    scrollFactor.set(0.1, 0.1);
                case 'limoBG': 
                    tex = Paths.getSparrowAtlas('limo/bgLimo', 'week4');
                    frames = tex;
                    newx = -200;
                    newy = 480;
                    animation.addByPrefix('drive', "background limo pink", 24);
					scrollFactor.set(0.4, 0.4);
                    animation.play('drive');
                case 'bgDancer': 
                    danceable = true;
                    tex = Paths.getSparrowAtlas("limo/limoDancer", 'week4');
                    frames = tex;
                    animation.addByIndices('danceLeft', 'bg dancer sketch PINK', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		            animation.addByIndices('danceRight', 'bg dancer sketch PINK', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		            animation.play('danceLeft');
                    newy = 80;
                    newx = 130;
                    scrollFactor.set(0.4, 0.4);
                case 'limoOverlay': 
                    loadGraphic(Paths.image('limo/limoOverlay', 'week4'));
                    newx = -500;
                    newy = -600;
                    alpha = 0.5;
                case 'limo': 
                    tex = Paths.getSparrowAtlas('limo/limoDrive', 'week4');
                    frames = tex;
                    newx = -120;
                    newy = 550;
                    animation.addByPrefix('drive', "Limo stage", 24);
					animation.play('drive');
                case 'fastCar': 
                    danceable = true;
                    loadGraphic(Paths.image('limo/fastCarLol', 'week4'));
                    newx = -300;
                    newy = 160;
                    resetFastCar();
                ///////////////////////////////////////////////////////////// week 5
                case 'mallBG': 
                    loadGraphic(Paths.image('christmas/bgWalls', 'week5'));
                    newx = -1000;
                    newy = -500;
                    scrollFactor.set(0.2, 0.2);
					active = false;
					setGraphicSize(Std.int(width * 0.8));
					updateHitbox();
                case 'mallUpperBoppers':
                    danceable = true;
                    tex = Paths.getSparrowAtlas('christmas/upperBop', 'week5');
                    frames = tex;
                    newx = -240;
                    newy = -90;
                    animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					scrollFactor.set(0.33, 0.33);
					setGraphicSize(Std.int(width * 0.85));
					updateHitbox();
                case 'mallEscalator': 
                    loadGraphic(Paths.image('christmas/bgEscalator', 'week5'));
                    newx = -1100;
                    newy = -600;
                    scrollFactor.set(0.3, 0.3);
					active = false;
					setGraphicSize(Std.int(width * 0.9));
					updateHitbox();
                case 'mallTree': 
                    loadGraphic(Paths.image('christmas/christmasTree', 'week5'));
                    newx = 370;
                    newy = -250;
                    scrollFactor.set(0.40, 0.40);
                case 'mallBottomBoppers': 
                    danceable = true;
                    tex = Paths.getSparrowAtlas('christmas/bottomBop', 'week5');
                    frames = tex;
                    newx = -300;
                    newy = 140;
                    animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					scrollFactor.set(0.9, 0.9);
					setGraphicSize(Std.int(width * 1));
					updateHitbox();
                case 'mallSnow': 
                    loadGraphic(Paths.image('christmas/fgSnow', 'week5'));
                    newx = -600;
                    newy = 700;
                    active = false;
                case 'mallSanta': 
                    danceable = true;
                    tex = Paths.getSparrowAtlas('christmas/santa', 'week5');
                    frames = tex;
                    newx = -840;
                    newy = 150;
                    animation.addByPrefix('bop', 'santa idle in fear', 24, false);
                /////////////////////////////////////////////////////// week 5 (winter horrorland)
                case 'mallEvilBG': 
                    loadGraphic(Paths.image('christmas/evilBG', 'week5'));
                    newx = -400;
                    newy = -500;
                    scrollFactor.set(0.2, 0.2);
                    active = false;
                    setGraphicSize(Std.int(width * 0.8));
                    updateHitbox();
                case 'mallEvilTree': 
                    loadGraphic(Paths.image('christmas/evilTree', 'week5'));
                    newx = 300;
                    newy = -300;
                    scrollFactor.set(0.2, 0.2);
                case 'mallEvilSnow': 
                    loadGraphic(Paths.image("christmas/evilSnow", 'week5'));
                    newx = -200;
                    newy = 700;
                //////////////////////////////////////////////////////// week 6
                case 'school-bgSky':
                    loadGraphic(Paths.image('weeb/weebSky', 'week6'));
                    scrollFactor.set(0.1, 0.1);
                    antialiasing = false;
                    setGraphicSize(Std.int(1866));
				    updateHitbox();
                case 'school-bgSchool': 
                    loadGraphic(Paths.image('weeb/weebSchool', 'week6'));
                    scrollFactor.set(0.6, 0.90);
                    antialiasing = false;
                    newx += -200;
                    setGraphicSize(1866);
                    updateHitbox();
                case 'school-bgStreet': 
                    loadGraphic(Paths.image('weeb/weebStreet', 'week6'));
                    scrollFactor.set(0.95, 0.95);
                    antialiasing = false;
                    newx += -200;
                    setGraphicSize(1866);
                    updateHitbox();
                case 'school-fgTrees': 
                    loadGraphic(Paths.image('weeb/weebTreesBack', 'week6'));
                    scrollFactor.set(0.9, 0.9);
                    newx = 170;
                    newy = 130;
                    antialiasing = false;
                    newx += -200;
                    setGraphicSize(Std.int(1866 * 0.8));
                    updateHitbox();
                case 'school-bgTrees': 
                    tex = Paths.getPackerAtlas('weeb/weebTrees', 'week6');
                    frames = tex;
                    animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
                    animation.play('treeLoop');
                    scrollFactor.set(0.85, 0.85);
                    newx = -380;
                    newy = -800;
                    antialiasing = false;
                    newx += -200;
                    setGraphicSize(Std.int(1866 * 1.4));
                    updateHitbox();
                case 'school-treeLeaves': 
                    tex = Paths.getSparrowAtlas('weeb/petals', 'week6');
                    frames = tex;
                    animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
		            animation.play('leaves');
		            scrollFactor.set(0.85, 0.85);
                    newy = -40;
                    antialiasing = false;
                    newx += -200;
                    setGraphicSize(1866);
                    updateHitbox();
                case 'bgGirls': 
                    tex = Paths.getSparrowAtlas('weeb/bgFreaks', 'week6');
                    frames = tex;
                    animation.addByIndices('danceLeft', 'BG girls group', CoolUtil.numberArray(14), "", 24, false);
                    animation.addByIndices('danceRight', 'BG girls group', CoolUtil.numberArray(30, 15), "", 24, false);
                    animation.play('danceLeft');
                    newx = -100;
                    newy = 190;
                    scrollFactor.set(0.9, 0.9);
                    danceable = true;
                    if (PlayState.SONG.song.toLowerCase() == 'roses')
                    {
                            getScared();
                    }
                    setGraphicSize(Std.int(this.width * PlayState.daPixelZoom));
		            updateHitbox();
                    antialiasing = false;
                ///////////////////////////////////////////////////////////// week 6 (thorns)
                case 'schoolEvilBG': 
                    tex = Paths.getSparrowAtlas('weeb/animatedEvilSchool', 'week6');
                    frames = tex;
                    newx = 400;
                    newy = 200;
                    animation.addByPrefix('idle', 'background 2', 24);
                    animation.play('idle');
                    scrollFactor.set(0.8, 0.9);
                    scale.set(6, 6);
                    antialiasing = false;
                ////////////////////////////////////////////////////////////// your own HARDCODED stage pieces go here

                case "non-animated example": //please use these examples to copy paste for your own
                    loadGraphic(Paths.image('file path here'));
                    newx = -400; //x and y
                    newy = -500;
                    scrollFactor.set(0.2, 0.2); //scroll factor
                    setGraphicSize(Std.int(width * 0.8)); //do this or scale.set
                    updateHitbox();
                    danceable = false; //danceble means it can do something every beat, set this in dance()
                case "animated example": 
                    tex = Paths.getSparrowAtlas('path here');
                    frames = tex;
                    newx = 400;
                    newy = 200;
                    animation.addByPrefix('idle', 'background 2', 24); //set the animations here
                    animation.play('idle');
                    scrollFactor.set(0.8, 0.9);
                    scale.set(6, 6);
                    danceable = false; //danceble means it can do something every beat, set this in dance()

                ///////REMINDER TO MAKE SURE SOMETHING IS DANCEABLE BEFORE COMPLAINING ABOUT IT NOT WORKING
                //////I FORGOT ABOUT IT BEFORE AS WELL



                default: 
                    #if sys
                    var rawJson = File.getContent(Paths.imageJson("customStagePieces/" + part + "/data"));
                    #else
                    var rawJson = Assets.getText(Paths.imageJson("customStagePieces/" + part + "/data"));
                    #end

				    var json:PieceFile = cast Json.parse(rawJson);

                    var imagePath = "assets/images/customStagePieces/" + part + "/" + part + ".png";
                    var imageGraphic:FlxGraphic;

                    if (CacheShit.images[imagePath] == null)
                    {
                        var image:FlxGraphic = FlxGraphic.fromBitmapData(BitmapData.fromFile(imagePath));
                        image.persist = true;
                        CacheShit.images[imagePath] = image;
                        trace("added custom stage piece");
                    }
                    imageGraphic = CacheShit.images[imagePath];
    
                    //imageGraphic.persist = true;

                    if (json.isAnimated)
                    {
                        var xmlPath = "assets/images/customStagePieces/" + part + "/" + part + ".xml";
                        var xml:String;
    
                        if (CacheShit.xmls[xmlPath] != null) //check if xml is stored in cache
                            xml = CacheShit.xmls[xmlPath];
                        else
                        {
                            
                            #if sys
                            xml = File.getContent(xmlPath);
                            #else
                            xml = Assets.getText(xmlPath);
                            #end
                            CacheShit.SaveXml(xmlPath, xml);
                        }
                        var tex = FlxAtlasFrames.fromSparrow(imageGraphic, xml);
                        frames = tex;

                        if (json.anims.length != 0 && frames != null)
                        {
                            for (i in json.anims)
                            {
                                var animname:String = i.anim;
                                var xmlname:String = i.xmlname;
                                var fps:Int = i.frameRate;
                                var loop:Bool = i.loop;
        
                                animation.addByPrefix(animname, xmlname, fps, loop);
                            }
                            animation.play(json.animToPlay); 
                        }
                    }
                    else
                    {
                        loadGraphic(imageGraphic);
                    }
                    flipX = json.flip;
                    antialiasing = json.aa;
                    newx = json.position[0];
                    newy = json.position[1];
                    setGraphicSize(Std.int(this.width * json.scale));
                    scrollFactor.set(json.scrollFactor[0], json.scrollFactor[1]);
                    danceable = json.isDanceable;
                    danceAnim = json.animToPlayOnDance;



            }
            
        }

    public function getScared():Void //only for week 6 bg girls
        {
            animation.addByIndices('danceLeft', 'BG fangirls dissuaded', CoolUtil.numberArray(14), "", 24, false);
            animation.addByIndices('danceRight', 'BG fangirls dissuaded', CoolUtil.numberArray(30, 15), "", 24, false);
            dance();
        }



    public function dance():Void //not always dance, just what the piece does every beat
        {
            if (danceable)
            {
                switch (part)
                {
                    case 'bgGirls' | 'bgDancer':
                        danceDir = !danceDir;
    
                        if (danceDir)
                            animation.play('danceRight', true);
                        else
                            animation.play('danceLeft', true);

                    case 'mallSanta' | 'mallUpperBoppers' | 'mallBottomBoppers': 
                        animation.play("bop", true);
                    case 'fastCar': 
                        if (FlxG.random.bool(10) && fastCarCanDrive)
                            fastCarDrive();
                    case 'halloweenBG': 
                        if (FlxG.random.bool(10) && daBeat > lightningStrikeBeat + lightningOffset)
                            lightningStrikeShit();
                    case "phillyCityLight0" | "phillyCityLight1" | "phillyCityLight2" | "phillyCityLight3" | "phillyCityLight4": 
                        visible = false;
                        if (curLight == lightnum)
                            visible = true;
                    case "phillyTrain": 
                        if (!trainMoving)
                            trainCooldown += 1;
                        if (daBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
                            {
                                trainCooldown = FlxG.random.int(-4, 0);
                                trainStart();
                            }
                    default: 
                        animation.play(danceAnim, true);


                }
            }  
        }

    override function update(elapsed:Float)
        {
            if (part == "phillyTrain" && danceable)
                if (trainMoving)
                    {
                        trainFrameTiming += elapsed;
    
                        if (trainFrameTiming >= 1 / 24)
                        {
                            updateTrainPos();
                            trainFrameTiming = 0;
                        }
                    }



            super.update(elapsed);

        }

    function lightningStrikeShit():Void //for week 2
        {
            FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
            animation.play('lightning');
            lightningStrikeBeat = daBeat;
            lightningOffset = FlxG.random.int(8, 24);
            PlayState.boyfriend.playAnim('scared', true);
            PlayState.gf.playAnim('scared', true);
        }

	function resetFastCar():Void //for week 4
	{
		x = -12600;
		y = FlxG.random.int(140, 250);
		velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive() //for week 4
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

    function trainStart():Void
        {
            trainMoving = true;
            if (!trainSound.playing)
                trainSound.play(true);
        }	
    
    function updateTrainPos():Void
    {
        if (trainSound.time >= 4700)
        {
            startedMoving = true;
            PlayState.gf.playAnim('hairBlow');
        }

        if (startedMoving)
        {
            x -= 400;

            if (x < -2000 && !trainFinishing)
            {
                x = -1150;
                trainCars -= 1;

                if (trainCars <= 0)
                    trainFinishing = true;
            }

            if (x < -4000 && trainFinishing)
                trainReset();
        }
    }

    function trainReset():Void
    {
        PlayState.gf.playAnim('hairFall');
        x = FlxG.width + 200;
        trainMoving = false;
        trainCars = 8;
        trainFinishing = false;
        startedMoving = false;
    }
        
    public static function StageCheck(stage:String)
        {
            var pieces:Array<String> = [];
            var daStage:String = "";
            var zoom:Float = 1.05;
            var offsetMap:Map<String, Array<Dynamic>>;
            offsetMap = new Map<String, Array<Dynamic>>();
            switch (stage)
            {
                case 'halloween':
                    daStage = 'spooky';
                    pieces = ['halloweenBG'];
                ////////////////////////////////////////////////////////////////////////
                case 'philly': 
                    daStage = 'philly';
                    pieces = ['phillyBG', "phillyCity", "phillyCityLight0", "phillyCityLight1", "phillyCityLight2", "phillyCityLight3", "phillyCityLight4", "phillySteetBehind", "phillyTrain", "phillyStreet"];
                ////////////////////////////////////////////////////////////////////////
                case 'limo':
                    daStage = 'limo';
                    zoom = 0.90;
                    offsetMap['bf'] = [260, -220];
                    pieces = ['limoSkyBG', 'limoBG', 'bgDancer', 'bgDancer', 'bgDancer', 'bgDancer', 'bgDancer', 'fastCar'];
                /////////////////////////////////////////////////////////////////////
                case 'mall':
                    daStage = 'mall';
                    zoom = 0.80;
                    offsetMap['bf'] = [200, 0];
                    pieces = ['mallBG', 'mallUpperBoppers', 'mallEscalator', 'mallTree', 'mallBottomBoppers', 'mallSnow', 'mallSanta'];
                ///////////////////////////////////////////////////////////////////
                case 'mallEvil':
                    daStage = 'mallEvil';
                    offsetMap['bf'] = [320, 0];
                    offsetMap['dad'] = [0, -80];
                    pieces = ['mallEvilBG', 'mallEvilTree', 'mallEvilSnow'];
                /////////////////////////////////////////////////////////////////
                case 'school':
                    daStage = 'school';
                    
                    pieces = ['school-bgSky', 'school-bgSchool', 'school-bgStreet', 'school-fgTrees', 'school-bgTrees', 'school-treeLeaves', 'bgGirls'];
                    offsetMap['bf'] = [200, 220];
                    offsetMap['gf'] = [180, 300];
    
                //////////////////////////////////////////////////////////////////////
                case 'schoolEvil':
                    daStage = 'schoolEvil';
                    offsetMap['bf'] = [200, 220];
                    offsetMap['gf'] = [180, 300];
    
                    pieces = ['schoolEvilBG'];
                ////////////////////////////////////////////////////////////////////	
                case "stage": 
                    zoom = 0.9;
                    daStage = "stage";
                    pieces = ['stageBG', 'stageFront', 'stageCurtains'];
                default: 
                    var stageList:Array<String> = CoolUtil.coolTextFile(Paths.txt('stageList'));
                    if (!stageList.contains(stage))
                        return;
    
                    daStage = stage;
                    #if sys
                    var rawJson = File.getContent("assets/data/customStages.json");
                    #else
                    var rawJson = Assets.getText("assets/data/customStages.json");
                    #end
                    var json:PlayState.Stages = cast Json.parse(rawJson);
    
                    if (json.stageList.length != 0)
                        for (i in json.stageList)
                            if (i.name == stage)
                            {
                                pieces = i.pieceArray;
                                zoom = i.camZoom;
    
                                if (i.offsets.length != 0)
                                    for (ii in i.offsets)
                                    {
                                        var type:String = ii.type;
                                        var offsets:Array<Int> = ii.offsets; 
                                        addStageOffset(type, offsets[0], offsets[1], offsetMap);
                                    }
                                break;
                            }
    
            }
            PlayState.stageData = [pieces, daStage, zoom, offsetMap];
            /////////////////////////////////////////////////////////////////////////////
        }
        public static function addStageOffset(name:String, x:Float = 0, y:Float = 0, map:Map<String, Array<Dynamic>>)
        {
            map[name] = [x, y];
        }
}