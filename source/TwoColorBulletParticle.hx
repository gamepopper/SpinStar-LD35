package;

import flixel.effects.particles.FlxParticle;
import flixel.util.FlxColor;
import flixel.FlxG;

enum BulletColor
{
	RED;
	BLUE;
	WHITE;
}

class TwoColorBulletParticle extends FlxParticle
{
	public var bulletColor:BulletColor = BulletColor.RED;
	public static var RedColor:FlxColor = 0xffd91616;
	public static var BlueColor:FlxColor = 0xff3db6f2;
	
	public function new() 
	{
		super();
		cameras = [ FlxG.camera ];
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (bulletColor == BulletColor.RED)
		{
			color = RedColor;
		}
		else if (bulletColor == BulletColor.BLUE)
		{
			color = BlueColor;
		}
		else if (bulletColor == BulletColor.WHITE)
		{
			color = FlxColor.WHITE;
		}
	}
}