package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxTimer;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.util.FlxStringUtil;

class MenuState extends FlxState
{
	var difficulty:Int = 0;
	var player:FlxSprite;
	var logo:FlxSprite;
	var logoStar:FlxSprite;
	
	var helpText:FlxTypeText;
	var helpStrings:Array<String> = new Array<String>();
	var helpTimer:FlxTimer = new FlxTimer();
	var currentHelp:Int = -1;
	
	var disableInput:Float = 3.0;
	
	override public function create():Void
	{
		super.create();
		
		FlxG.mouse.useSystemCursor = true;
		
		var easyText:FlxTypeText = new FlxTypeText(100, 240, FlxG.width - 200, "EASY", 16);
		var mediText:FlxTypeText = new FlxTypeText(  0, 260, FlxG.width, "MEDIUM", 16);
		var hardText:FlxTypeText = new FlxTypeText(100, 240, FlxG.width - 200, "HARD", 16);
		
		easyText.alignment = FlxTextAlign.LEFT;
		mediText.alignment = FlxTextAlign.CENTER;
		hardText.alignment = FlxTextAlign.RIGHT;
		
		easyText.start(0.1);
		mediText.start(0.1);
		hardText.start(0.1);
		
		var easyTextTime:FlxTypeText = new FlxTypeText(100, 240, FlxG.width - 200, "", 10);
		var mediTextTime:FlxTypeText = new FlxTypeText(  0, 260, FlxG.width, "", 10);
		var hardTextTime:FlxTypeText = new FlxTypeText(100, 240, FlxG.width - 200, "", 10);
		
		easyTextTime.alignment = FlxTextAlign.LEFT;
		mediTextTime.alignment = FlxTextAlign.CENTER;
		hardTextTime.alignment = FlxTextAlign.RIGHT;
		
		var time:Float = 0;
		var score:Float = 0;
		
		if (FlxG.save.bind("Easy"))
		{
			time = FlxG.save.data.time;
			score = FlxG.save.data.score;
			
			if (time > 0)
				easyTextTime.resetText("Time: " + FlxStringUtil.formatTime(time, true) + " - " + score);
			else
			{	
				FlxG.save.data.time = 0;
				FlxG.save.data.score = 0;
			}
			
			FlxG.save.flush();
		}
		FlxG.save.close();
		
		if (FlxG.save.bind("Medium"))
		{
			time = FlxG.save.data.time;
			score = FlxG.save.data.score;
			
			if (time > 0)
				mediTextTime.resetText("Time: " + FlxStringUtil.formatTime(time, true) + " - " + score);
			else
			{	
				FlxG.save.data.time = 0;
				FlxG.save.data.score = 0;
			}
			
			FlxG.save.flush();
		}
		FlxG.save.close();
		
		if (FlxG.save.bind("Hard"))
		{
			time = FlxG.save.data.time;
			score = FlxG.save.data.score;
			
			if (time > 0)
				hardTextTime.resetText("Time: " + FlxStringUtil.formatTime(time, true) + " - " + score);
			else
			{	
				FlxG.save.data.time = 0;
				FlxG.save.data.score = 0;
			}
			
			FlxG.save.flush();
		}
		FlxG.save.close();
		
		easyTextTime.start(0.1);
		mediTextTime.start(0.1);
		hardTextTime.start(0.1);
		
		var gamepopperText:FlxTypeText = new FlxTypeText(10, 5, FlxG.width - 20, "GAMEPOPPER - LD35", 12);
		gamepopperText.alignment = FlxTextAlign.RIGHT;
		gamepopperText.start(0.05);
		
		player = new FlxSprite();
		player.loadGraphic(AssetPaths.Ship__png, true, 32, 32);
		player.animation.add("ship", [0, 1, 2, 3], 12, true);
		player.animation.play("ship");
		player.setPosition(140 - player.width, 280);
		player.angle = 90;
		player.color = FlxColor.TRANSPARENT;
		
		logoStar = new FlxSprite();
		logoStar.loadGraphic(AssetPaths.Star__png);
		logoStar.angularVelocity = 10.0;
		
		logo = new FlxSprite();
		logo.loadGraphic(AssetPaths.logo__png);
		logo.setPosition(FlxG.width / 2 - logo.width / 2, 80);
		
		FlxTween.linearMotion(logo, FlxG.width / 2 - logo.width / 2, -150, FlxG.width / 2 - logo.width / 2, 80, 3.0, true, { ease : FlxEase.bounceOut } );
		FlxTween.linearMotion(player, 140 - player.width, 480, 140 - player.width, 280, 3.0, true, { ease : FlxEase.quadOut } );
		FlxTween.linearMotion(easyText, 100, 480, 100, 240, 3.0, true, { ease : FlxEase.backOut } );
		FlxTween.linearMotion(mediText,   0, 480,   0, 260, 3.0, true, { ease : FlxEase.backOut } );
		FlxTween.linearMotion(hardText, 100, 480, 100, 240, 3.0, true, { ease : FlxEase.backOut } );
		FlxTween.linearMotion(easyTextTime, 100, 480, 100, 220, 3.0, true, { ease : FlxEase.backOut } );
		FlxTween.linearMotion(mediTextTime,   0, 480,   0, 240, 3.0, true, { ease : FlxEase.backOut } );
		FlxTween.linearMotion(hardTextTime, 100, 480, 100, 220, 3.0, true, { ease : FlxEase.backOut } );
		
		var backgroundWave:FlxWaveEffect = new FlxWaveEffect(FlxWaveMode.ALL, 4, 0.5, 1, 3);		
		var background = new FlxEffectSprite(new FlxSprite().loadGraphic(AssetPaths.background__png), [backgroundWave]);
		//var background = new FlxSprite(0, 0, AssetPaths.background__png);
		background.scale.set(1.2, 1.2);
		
		helpText = new FlxTypeText(10, 380, FlxG.width - 20, "", 14);
		helpText.alignment = FlxTextAlign.CENTER;
		
		helpStrings.push("Hold LEFT/RIGHT to move, UP/DOWN to move slower.");
		helpStrings.push("Press Q/E to change shape.");
		helpStrings.push("Press W to change color, absorb bullets of matching colour.");
		helpStrings.push("Bigger ship is faster, smaller ship has smaller weak point.");
		helpStrings.push("White bullets are evil!");
		helpTimer.start(3, ChangeText, 1);
		
		add(background);
		add(player);
		add(logoStar);
		add(logo);
		add(easyText);
		add(mediText);
		add(hardText);
		add(easyTextTime);
		add(mediTextTime);
		add(hardTextTime);
		add(gamepopperText);
		add(helpText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		logoStar.setPosition(logo.x + 200.0, logo.y + 16.0);
		
		disableInput -= elapsed;
		if (disableInput < 0)
		{
			player.color = FlxColor.WHITE;		
			if (FlxG.keys.justPressed.RIGHT)
			{
				difficulty++;
				difficulty = difficulty % 3;
			
				if (difficulty == 0)
				{
					player.setPosition(140 - player.width, 280);
				}
				else if (difficulty == 1)
				{
					player.setPosition(FlxG.width / 2 - player.width / 2, 300);
				}
				else if (difficulty == 2)
				{
					player.setPosition(FlxG.width - 140, 280);
				}
				
				FlxG.sound.play(AssetPaths.select__wav);
			}
		
			if (FlxG.keys.justPressed.LEFT)
			{
				difficulty--;
				difficulty = difficulty < 0 ? difficulty + 3 : difficulty;
			
				if (difficulty == 0)
				{
					player.setPosition(140 - player.width, 280);
				}
				else if (difficulty == 1)
				{
					player.setPosition(FlxG.width / 2 - player.width / 2, 300);
				}
				else if (difficulty == 2)
				{
					player.setPosition(FlxG.width - 140, 280);
				}
				
				FlxG.sound.play(AssetPaths.select__wav);
			}
			
			if (FlxG.keys.justPressed.SPACE || 
				FlxG.keys.justPressed.ENTER ||
				FlxG.keys.justPressed.W)
			{
				FlxG.camera.fade(FlxColor.WHITE, 0.5, false, TimeToPlay);
			}
		}
	}
	
	private function TimeToPlay()
	{
		FlxG.switchState(new PlayState(difficulty));
	}
	
	private function ChangeText(timer:FlxTimer)
	{
		if (helpText.text == "")
		{
			currentHelp = 0;
			helpText.resetText(helpStrings[currentHelp]);
			helpText.start(0.03);
		}
		else
		{
			currentHelp = (currentHelp + 1) % helpStrings.length;
			helpText.erase( 0.01, false, [], StartTyping);
		}
		
		helpTimer.start(5, ChangeText, 1);
	}
	
	private function StartTyping()
	{
		helpText.resetText(helpStrings[currentHelp]);
		helpText.start(0.03);		
	}
}
