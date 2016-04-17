package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import TwoColorBulletParticle;

class Player extends FlxSprite
{
	public var playerColor:BulletColor = BulletColor.RED;
	public var bodyType:Int = 0;
	var playerAngle:Float = 0.0;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		loadGraphic(AssetPaths.Ship__png, true, 32, 32);
		color = TwoColorBulletParticle.RedColor;
		animation.add("Mode1Color", [3, 0, 1, 2, 3], 12, false, true);
		animation.add("Mode2Color", [6, 7, 8, 9, 6], 12, false, true);
		animation.add("Transform12", [3, 4, 5, 6], 12, false, true);
		animation.add("Transform21", [6, 5, 4, 3], 12, false, true);
		
		animation.play("Mode1Color");	
		
		setSize(24, 24);
		offset.set(4, 4);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		var speed:Float = FlxG.keys.pressed.DOWN || FlxG.keys.pressed.UP ? 100 : 180;
		if (bodyType == 1)
			speed *= 0.6;
		
		if (FlxG.keys.justPressed.W)
		{
			FlxG.sound.play(AssetPaths.switch__wav);
			if (playerColor == BulletColor.RED)
			{
				playerColor = BulletColor.BLUE;
				FlxTween.color(this, 1, TwoColorBulletParticle.RedColor, TwoColorBulletParticle.BlueColor, { ease: FlxEase.elasticOut } );
			}
			else
			{
				playerColor = BulletColor.RED;
				FlxTween.color(this, 1, TwoColorBulletParticle.BlueColor, TwoColorBulletParticle.RedColor, { ease: FlxEase.elasticOut });
			}
			
			if (bodyType == 0)
			{
				animation.play("Mode1Color");					
			}
			else
			{
				animation.play("Mode2Color");						
			}
		}
		
		if (FlxG.keys.justPressed.Q || FlxG.keys.justPressed.E)
		{
			FlxG.sound.play(AssetPaths.something__wav);
			bodyType = (bodyType + 1) % 2;
			
			if (bodyType == 0)
			{
				animation.play("Transform21");
				setSize(24, 24);
				offset.set(4, 4);
			}
			else
			{
				animation.play("Transform12");
				setSize(16, 16);
				offset.set(8, 8);
			}
		}
		
		if (FlxG.keys.pressed.LEFT)
		{
			playerAngle -= speed * elapsed;
		}
		else if  (FlxG.keys.pressed.RIGHT)
		{
			playerAngle += speed * elapsed;
		}
		
		if (playerAngle < 0)
		{
			playerAngle += 360;
		}
		
		if (playerAngle > 360)
		{
			playerAngle -= 360;
		}
		
		var screenCentre:FlxPoint = new FlxPoint(FlxG.width / 2, FlxG.height / 2);
		var playerPoint = new FlxPoint(200, 0);
		playerPoint.rotate(new FlxPoint(), playerAngle);
		
		setPosition(playerPoint.x + screenCentre.x - (width / 2), playerPoint.y + screenCentre.y - (height / 2));
		angle = playerAngle + 180;
	}
}