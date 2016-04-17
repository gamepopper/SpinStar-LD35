package;
import TwoColorBulletEmitter;
import flixel.FlxG;

class AlternateOneColourBehaviour extends TwoColorBulletBehaviour
{
	var anglePerDir:Float = 360.0;
	var numDirections:Int = 1;
	
	public var FireRate = 0.1;
	
	public function new(Directions:Int = 1, FireRate = 0.1) 
	{
		super();
		this.FireRate = FireRate;
		numDirections = Directions;
		anglePerDir = 360.0 / numDirections;
	}
	
	override public function onFire(elapsed:Float, emitter:TwoColorBulletEmitter) 
	{
		super.onFire(elapsed, emitter);
		
		if (t > FireRate)
		{
			FlxG.sound.play(AssetPaths.shoot__wav);
			for (i in 0...numDirections)
			{
				emitter.launchAngle.set((i * anglePerDir) + rotate);
				emitter.emitParticle();
			}
			
			t = 0;
		}
	}
	
	override public function reset() 
	{
		super.reset();
	}
}