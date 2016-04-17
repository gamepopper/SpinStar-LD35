package;

import TwoColorBulletParticle;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxEmitter;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import flixel.util.FlxSave;
import flixel.tweens.FlxEase;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.effects.chainable.FlxEffectSprite;

class PlayState extends FlxState
{
	var uiCamera:FlxCamera;
	var gameOverlay:FlxSprite;
	var background:FlxSprite;
	
	var gameOverText:FlxText;
	var continueText:FlxText;
	
	var cameraRotation = 300.0;
	var cameraRotationMult = 0.0;
	
	var boss:FlxSprite;
	var bossEmitter:TwoColorBulletEmitter;
	
	var player:Player;
	var playerEmitter:FlxEmitter;
	
	var scoreText:FlxText;
	var timeText:FlxText;
	
	var colorSwitchTimer:FlxTimer = new FlxTimer();
	var behaviourSwitchTimer:FlxTimer = new FlxTimer();
	var rotateSwitchTimer:FlxTimer = new FlxTimer();
	var time:Float = 0.0;
	var score:Int = 0;
	var difficulty:Int = 0;
	
	var bossAnims:Array<String> = new Array<String>();
	
	public function new(difficulty:Int = 0)
	{
		super();
		this.difficulty = difficulty;
	}
	
	override public function create():Void
	{
		super.create();
		FlxG.camera.flash(FlxColor.WHITE, 0.5);
		
		FlxG.debugger.drawDebug = true;
		FlxG.debugger.toggleKeys = [ FlxKey.F1 ];
		
		uiCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		uiCamera.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(uiCamera);
		
		scoreText = new FlxText(5.0, 5.0, FlxG.width - 10.0, "", 12);
		scoreText.alignment = FlxTextAlign.LEFT;
		scoreText.scrollFactor.set(0, 0);
		scoreText.cameras = [ uiCamera ];
		
		timeText = new FlxText(5.0, 5.0, FlxG.width - 10.0, "", 12);
		timeText.alignment = FlxTextAlign.RIGHT;
		timeText.scrollFactor.set(0,0);
		timeText.cameras = [ uiCamera ];
		
		gameOverText = new FlxText(0.0, -100, FlxG.width, "GAME OVER", 18);
		gameOverText.alignment = FlxTextAlign.CENTER;
		gameOverText.scrollFactor.set(0, 0);
		gameOverText.cameras = [ uiCamera ];
		
		continueText = new FlxText(0.0, -100.0, FlxG.width, "Press R to Restart, Q to return to Main Menu", 14);
		continueText.alignment = FlxTextAlign.CENTER;
		continueText.scrollFactor.set(0,0);
		continueText.cameras = [ uiCamera ];
		
		player = new Player();
		player.cameras = [ FlxG.camera ];
		
		playerEmitter = new FlxEmitter();
		playerEmitter.makeParticles(2, 2, FlxColor.WHITE);
		
		boss = new FlxSprite();
		boss.loadGraphic(AssetPaths.Boss__png, true, 48, 48);
		boss.animation.add("4Way", [0, 3, 2, 1], 12, false);
		boss.animation.add("8Way", [0, 6, 5, 4], 12, false);
		boss.animation.add("Barrage", [0, 9, 8, 7], 12, false);
		boss.animation.play("4Way");
		boss.setPosition(FlxG.width / 2 - boss.width / 2, FlxG.height / 2 - boss.height / 2);
		boss.scale.set(3, 3);
		boss.cameras = [ FlxG.camera ];
		
		bossEmitter = new TwoColorBulletEmitter();
		bossEmitter.setPosition(FlxG.width / 2, FlxG.height / 2);
		bossEmitter.setSize(48 * 1.5, 48 * 1.4);
		bossEmitter.loadParticles(AssetPaths.Bullet__png, 400);
		bossEmitter.lifespan.set(2.0);
		
		if (difficulty == 0)
		{
			bossEmitter.speed.set(200.0);
			bossEmitter.rotateSpeed = 50.0;
			bossEmitter.behaviours.push(new AlternateOneColourBehaviour(2, 0.3));
			bossEmitter.behaviours.push(new AlternateTwoColourBehaviour(4, 1, 0.3));
			bossEmitter.behaviours.push(new BurstDelayBehaviour(2, 0.3));
			bossEmitter.behaviours.push(new AlternateTwoColorBurstBehaviour(2, 0.5, 0.6));
			bossEmitter.behaviours.push(new AlternateTwoColourBehaviour(4, 2, 0.3));
			
			bossAnims.push("4Way");
			bossAnims.push("4Way");
			bossAnims.push("Barrage");
			bossAnims.push("Barrage");
			bossAnims.push("4Way");
			
			boss.color = 0xffcc66cc;
			
			FlxG.sound.playMusic(AssetPaths.easy__ogg);
		}
		else if (difficulty == 1)
		{
			bossEmitter.speed.set(200.0);
			bossEmitter.rotateSpeed = 100.0;
			bossEmitter.behaviours.push(new AlternateOneColourBehaviour(4, 0.2));
			bossEmitter.behaviours.push(new AlternateTwoColourBehaviour(8, 1, 0.2));
			bossEmitter.behaviours.push(new AimBehaviour(player, 0.3, 0.2));
			bossEmitter.behaviours.push(new BurstDelayBehaviour(4, 0.2));
			bossEmitter.behaviours.push(new AlternateTwoColorBurstBehaviour(4, 0.5, 0.4));
			bossEmitter.behaviours.push(new AlternateTwoColourBehaviour(8, 2, 0.2));
			
			bossAnims.push("4Way");
			bossAnims.push("Barrage");
			bossAnims.push("Barrage");
			bossAnims.push("Barrage");
			bossAnims.push("8Way");
			
			boss.color = 0xffcccc66;
			
			FlxG.sound.playMusic(AssetPaths.medium__ogg);
		}
		else
		{
			bossEmitter.speed.set(300.0);
			bossEmitter.rotateSpeed = 150.0;
			bossEmitter.behaviours.push(new AlternateOneColourBehaviour(4, 0.1));
			bossEmitter.behaviours.push(new AlternateTwoColourBehaviour(8, 1, 0.1));
			bossEmitter.behaviours.push(new AimBehaviour(player, 0.2, 0.1));
			bossEmitter.behaviours.push(new FanBehaviour(4, 20, 0.1));
			bossEmitter.behaviours.push(new BurstDelayBehaviour(4, 0.1));
			bossEmitter.behaviours.push(new AlternateTwoColorBurstBehaviour(4, 0.5, 0.1));
			bossEmitter.behaviours.push(new AlternateTwoColourBehaviour(16, 2, 0.2));
						
			bossAnims.push("4Way");
			bossAnims.push("8Way");
			bossAnims.push("Barrage");
			bossAnims.push("Barrage");
			bossAnims.push("Barrage");
			
			boss.color = 0xffcc6666;
			
			FlxG.sound.playMusic(AssetPaths.hard__ogg);
		}
		
		bossEmitter.cameras = [ FlxG.camera ];
		
		gameOverlay = new FlxSprite();
		gameOverlay.makeGraphic(FlxG.width, FlxG.height);
		gameOverlay.color = FlxColor.TRANSPARENT;
		gameOverlay.kill();
		
		var backgroundWave:FlxWaveEffect = new FlxWaveEffect(FlxWaveMode.ALL, 4, 0.5, 1, 3);		
		var background = new FlxEffectSprite(new FlxSprite().loadGraphic(AssetPaths.background__png), [backgroundWave]);
		//background = new FlxSprite(0, 0, AssetPaths.background__png);
		background.scale.set(1.5, 1.6);
		background.cameras = [ FlxG.camera ];		
		
		colorSwitchTimer.start(5, switchColor, 0);
		behaviourSwitchTimer.start(10, switchBulletBehavior, 0);
		rotateSwitchTimer.start(10, switchRotation);
		
		add(background);
		add(bossEmitter);
		add(boss);
		add(player);
		add(playerEmitter);
		add(gameOverlay);
		add(gameOverText);
		add(continueText);
		add(scoreText);
		add(timeText);
	}
	
	override public function destroy():Void 
	{
		super.destroy();		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (player.alive)
			time += elapsed;
		else
		{
			if (FlxG.keys.justPressed.R)
			{
				FlxG.camera.fade(FlxColor.WHITE, 0.5, false, restartState);
			}
			if (FlxG.keys.justPressed.Q)
			{
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, BackToMenu);
			}
		}
		
		scoreText.text = "" + score;
		timeText.text = FlxStringUtil.formatTime(time, true);
		
		camera.angle += (cameraRotation * cameraRotationMult) * elapsed;
		boss.angle = bossEmitter.rotate;
		
		FlxG.overlap(player, bossEmitter, playerTouchBullet);
	}
	
	private function restartState()
	{
		camera.angle = 0;
		score = 0;
		time = 0;
		FlxG.switchState(new PlayState(difficulty));
	}
	
	private function BackToMenu()
	{
		FlxG.sound.music.stop();
		FlxG.switchState(new MenuState());
	}
	
	private function switchColor(timer:FlxTimer)
	{
		if (FlxG.random.bool(10 + (difficulty * 10)))
		{
			bossEmitter.bulletColor = BulletColor.WHITE;
		}
		else
		{
			if (bossEmitter.bulletColor == BulletColor.RED)
			{
				bossEmitter.bulletColor = BulletColor.BLUE;
			}
			else
			{
				bossEmitter.bulletColor = BulletColor.RED;
			}
		}
	}
	
	private function switchRotation(timer:FlxTimer)
	{
		if (difficulty == 0)
			bossEmitter.rotateSpeed = 50.0 + Std.random(80);
		else if (difficulty == 1)
			bossEmitter.rotateSpeed = 100.0 + Std.random(40);
		else
			bossEmitter.rotateSpeed = 140.0 + Std.random(40);
		
		if (Std.random(100) > 50)
		{
			bossEmitter.rotateSpeed *= -1;
		}
		
		timer.start(3.0 + Std.random(8), switchRotation);
		
		cameraRotation *= -1;
		cameraRotationMult += 0.001;
	}
	
	private function switchBulletBehavior(timer:FlxTimer)
	{
		boss.animation.play(bossAnims[bossEmitter.currentBehaviour], true, true);
		bossEmitter.switchBehaviour();
		boss.animation.finishCallback = bossAnimFinish;
	}
	
	private function bossAnimFinish(animName:String)
	{
		boss.animation.play(bossAnims[bossEmitter.currentBehaviour]);
		boss.animation.finishCallback = null;
	}
	
	private function playerTouchBullet(player:Player, bullet:TwoColorBulletParticle)
	{
		bullet.kill();
		
		if (bullet.bulletColor != player.playerColor)
		{
			FlxG.sound.play(AssetPaths.explosion__wav);
			
			player.kill();
			playerEmitter.color.set(player.playerColor == BulletColor.RED ? TwoColorBulletParticle.RedColor : TwoColorBulletParticle.BlueColor);
			playerEmitter.setPosition(player.x - (player.width / 2), player.y - (player.height / 2));
			playerEmitter.start(true, 0.01);
			
			gameOverlay.revive();
			
			FlxTween.color(gameOverlay, 2, FlxColor.TRANSPARENT, 0xA0000000);
			FlxTween.linearMotion(gameOverText, 0, -25, 0, 200, 2, true, { ease: FlxEase.bounceOut } );
			FlxTween.linearMotion(continueText, 0, -25, 0, 225, 2, true, { ease: FlxEase.bounceOut } );
			
			if (difficulty == 0)
			{
				FlxG.save.bind("Easy");
			}
			else if (difficulty == 1)
			{
				FlxG.save.bind("Medium");
			}
			else if (difficulty == 2)
			{
				FlxG.save.bind("Hard");
			}
			
			var currentTime:Float = FlxG.save.data.time;
			
			if (time > currentTime)
			{
				FlxG.save.data.time = time;
				FlxG.save.data.score = score;
				FlxG.save.flush();
			}
			FlxG.save.close();
		}
		else
		{
			score++;
		}
	}
}
