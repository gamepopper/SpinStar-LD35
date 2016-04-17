package;
import TwoColorBulletEmitter;
import TwoColorBulletParticle;
import flixel.FlxG;

class AlternateTwoColorBurstBehaviour extends BurstDelayBehaviour
{
	var savedBulletColor:BulletColor;
	
	public function new(Directions:Int=1, DelayRate=0.5,  FireRate=0.1) 
	{
		super(Directions, FireRate, DelayRate);	
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
			savedBulletColor = emitter.bulletColor;
			if (t > FireRate)
			{
				FlxG.sound.play(AssetPaths.shoot__wav);
				for (i in 0...numDirections)
				{
					if (i % 2 == 0)
					{
						emitter.bulletColor = BulletColor.RED;
					}
					else
					{
						emitter.bulletColor = BulletColor.BLUE;
					}
				
					emitter.launchAngle.set((i * anglePerDir) + rotate);
					emitter.emitParticle();
					
					emitter.launchAngle.set((i * anglePerDir) + rotate + 10);
					emitter.emitParticle();
					
					emitter.launchAngle.set((i * anglePerDir) + rotate - 10);
					emitter.emitParticle();
				}
			
				t = 0;
			}
			emitter.bulletColor = savedBulletColor;
		}
	}
}