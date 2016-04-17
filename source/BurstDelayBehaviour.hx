package;
import TwoColorBulletEmitter;
import TwoColorBulletParticle;
import flixel.FlxG;

class BurstDelayBehaviour extends TwoColorBulletBehaviour
{
	public var FireRate = 0.1;
	public var DelayRate = 0.5;
	
	var anglePerDir:Float = 360.0;
	var numDirections:Int = 1;
	var delay:Float = 0.0;
	var fire:Bool = true;
	
	public function new(Directions:Int = 1, FireRate = 0.1, DelayRate = 0.5) 
	{
		super();
		this.FireRate = FireRate;
		this.DelayRate = DelayRate;
		numDirections = Directions;
		anglePerDir = 360.0 / numDirections;
	}
	
	override public function onFire(elapsed:Float, emitter:TwoColorBulletEmitter) 
	{
		super.onFire(elapsed, emitter);
		
		delay += elapsed;
		if (delay > DelayRate)
		{
			fire = !fire;
			delay = 0;
		}
		
		if (fire)
		{
			if (t > FireRate)
			{
				FlxG.sound.play(AssetPaths.shoot__wav);
				for (i in 0...numDirections)
				{
					emitter.launchAngle.set((i * anglePerDir) + rotate);
					emitter.emitParticle();
					
					emitter.launchAngle.set((i * anglePerDir) + rotate + 10);
					emitter.emitParticle();
					
					emitter.launchAngle.set((i * anglePerDir) + rotate - 10);
					emitter.emitParticle();
				}
			
				t = 0;
			}
		}
	}
	
	override public function reset() 
	{
		super.reset();
		delay = 0.0;
	}
}