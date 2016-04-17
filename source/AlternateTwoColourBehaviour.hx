package;
import TwoColorBulletEmitter;
import TwoColorBulletParticle;
import flixel.FlxG;

class AlternateTwoColourBehaviour extends TwoColorBulletBehaviour
{
	var anglePerDir:Float = 360.0;
	var numDirections:Int = 1;
	var directionDivider = 1;
	
	var savedBulletColor:BulletColor;
	
	public var FireRate = 0.1;
	
	public function new(Directions:Int = 1, Divider = 1, FireRate = 0.1) 
	{
		super();
		this.FireRate = FireRate;
		numDirections = Directions;
		directionDivider = Divider;
		anglePerDir = 360.0 / numDirections;
	}
	
	override public function onFire(elapsed:Float, emitter:TwoColorBulletEmitter) 
	{		
		super.onFire(elapsed, emitter);
		
		if (t > FireRate)
		{
			FlxG.sound.play(AssetPaths.shoot__wav);
			savedBulletColor = emitter.bulletColor;
			
			for (i in 0...numDirections)
			{
				if (Std.int(i / directionDivider) % 2 == 0)
				{
					emitter.bulletColor = savedBulletColor;
				}
				else
				{
					emitter.bulletColor = savedBulletColor == BulletColor.RED ? BulletColor.BLUE : BulletColor.RED;
				}
				
				emitter.launchAngle.set((i * anglePerDir) + rotate);
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