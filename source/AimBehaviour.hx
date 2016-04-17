package;
import TwoColorBulletEmitter;
import TwoColorBulletParticle;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxG;

class AimBehaviour extends TwoColorBulletBehaviour
{	
	var player:FlxSprite;
	var savedBulletColor:BulletColor;
	
	public var FireRate = 0.1;
	public var WaitTime = 0.1;
	var wait:Float = 0.0;
	
	public function new(player:FlxSprite, WaitTime = 0.5, FireRate = 0.1) 
	{
		super();
		this.FireRate = FireRate;
		this.WaitTime = WaitTime;
		this.player = player;
	}
	
	override public function onFire(elapsed:Float, emitter:TwoColorBulletEmitter) 
	{		
		super.onFire(elapsed, emitter);
		
		wait -= elapsed;
		
		if (wait < 0)
		{
			if (t > FireRate)
			{
				FlxG.sound.play(AssetPaths.shoot__wav);
				savedBulletColor = emitter.bulletColor;
				
				if (FlxG.random.bool(75))
				{
					emitter.bulletColor = BulletColor.WHITE;
				}
			
				var playerPoint:FlxPoint = new FlxPoint(player.x + player.width / 2, player.y + player.height / 2);
				var bossPoint:FlxPoint = new FlxPoint(emitter.x, emitter.y);
				var angleBetween:Float = bossPoint.angleBetween(playerPoint) - 90;
			
				emitter.launchAngle.set(angleBetween - 5);
				emitter.emitParticle();
				emitter.launchAngle.set(angleBetween - 10);
				emitter.emitParticle();
				emitter.launchAngle.set(angleBetween + 5);
				emitter.emitParticle();
				emitter.launchAngle.set(angleBetween + 10);
				emitter.emitParticle();
			
				emitter.bulletColor = savedBulletColor;
			
				t = 0;
			}
			
			wait = WaitTime;
		}
	}
	
	override public function reset() 
	{
		super.reset();
	}
}