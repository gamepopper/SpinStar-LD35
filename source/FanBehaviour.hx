package;
import TwoColorBulletEmitter;
import TwoColorBulletParticle;
import flixel.math.FlxPoint;
import flixel.FlxG;

class FanBehaviour extends TwoColorBulletBehaviour
{
	var anglePerDir:Float = 360.0;
	var numDirections:Int = 1;
	var savedBulletColor:BulletColor;
	
	public var FireRate = 0.1;
	
	public function new(Directions:Int = 1, Range = 20, FireRate = 0.1) 
	{
		super();
		this.FireRate = FireRate;
		numDirections = Directions;
		anglePerDir = Range / Math.ceil(numDirections / 2.0);
	}
	
	override public function onFire(elapsed:Float, emitter:TwoColorBulletEmitter) 
	{
		super.onFire(elapsed, emitter);
		
		if (t > FireRate)
		{
			FlxG.sound.play(AssetPaths.shoot__wav);
			savedBulletColor = emitter.bulletColor;
			
			if (FlxG.random.bool(50))
			{
				emitter.bulletColor = BulletColor.WHITE;
			}
			
			emitter.launchAngle.set(rotate);
			emitter.emitParticle();
			
			for (i in 1...Std.int(Math.ceil(numDirections / 2.0)))
			{
				emitter.launchAngle.set((i * anglePerDir) + rotate);
				emitter.emitParticle();
				
				emitter.launchAngle.set(-(i * anglePerDir) + rotate);
				emitter.emitParticle();
			}
			
			var point:FlxPoint = new FlxPoint( -Math.cos(rotate), Math.sin(rotate));
			var oppositeAngle = point.angleBetween(new FlxPoint());
			
			emitter.launchAngle.set(oppositeAngle);
			emitter.emitParticle();
			
			for (i in 1...Std.int(Math.ceil(numDirections / 2.0)))
			{
				emitter.launchAngle.set((i * anglePerDir) + oppositeAngle);
				emitter.emitParticle();
				
				emitter.launchAngle.set(-(i * anglePerDir) + oppositeAngle);
				emitter.emitParticle();
			}
			
			emitter.bulletColor = savedBulletColor;
			
			t = 0;
		}
	}
	
	override public function reset() 
	{
		super.reset();
	}
}