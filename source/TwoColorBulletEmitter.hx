package;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.effects.particles.FlxEmitter.FlxEmitterMode;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import TwoColorBulletParticle;

class TwoColorBulletBehaviour
{
	var t:Float = 0.0;
	public var rotate = 0.0;
	
	public function new() {}
	public function onFire(elapsed:Float, emitter:TwoColorBulletEmitter) 
	{
		t += elapsed;
	}	
	public function reset() 
	{
		t = 0.0;
		rotate = 0.0;
	}	
}

class TwoColorBulletEmitter extends FlxTypedEmitter<TwoColorBulletParticle>
{
	public var bulletColor:BulletColor = BulletColor.RED;
	public var behaviours:Array<TwoColorBulletBehaviour> = new Array<TwoColorBulletBehaviour>();
	public var rotateSpeed:Float = 0.0;
	public var rotate:Float = 0.0;
	public var currentBehaviour:Int = 0;
	var wait:Float = 0.5;
	
	public function new(X:Float=0, Y:Float=0, Size:Int=0) 
	{
		super(X, Y, Size);
		particleClass = TwoColorBulletParticle;
		launchMode = FlxEmitterMode.CIRCLE;
		solid = true;		
		exists = true;
		visible = true;

	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		wait -= elapsed;
		if (wait < 0 && currentBehaviour < behaviours.length)
		{
			rotate += rotateSpeed * elapsed;
			
			if (rotate < 0)
				rotate += 360;
			if (rotate > 360)
				rotate -= 360;
			
			behaviours[currentBehaviour].rotate = rotate;
			behaviours[currentBehaviour].onFire(elapsed, this);
			wait = 0;
		}
	}
	
	public function onFire(elapsed:Float) { }

	public function switchBehaviour()
	{
		if (behaviours.length > 1)
		{
			var pick:Int = Std.random(behaviours.length);
		
			while (pick == currentBehaviour)
			{
				pick = Std.random(behaviours.length);
			}
		
			behaviours[currentBehaviour].reset();
			currentBehaviour = pick;
		}
		
		wait = 0.5;
	}
	
	override public function emitParticle():Void 
	{
		//Copying all this because I cannot find a direct way of accessing particles that have been recently emitted.
		
		var particle:TwoColorBulletParticle = cast recycle(cast particleClass);
		
		particle.reset(0, 0); // Position is set later, after size has been calculated
		
		particle.blend = blend;
		particle.immovable = immovable;
		particle.solid = solid;
		particle.allowCollisions = allowCollisions;
		particle.autoUpdateHitbox = autoUpdateHitbox;
		
		// Particle velocity/launch angle settings
		particle.velocityRange.active = !particle.velocityRange.start.equals(particle.velocityRange.end);
		var particleAngle:Float = 0.0;
		if (launchMode == FlxEmitterMode.CIRCLE)
		{
			particleAngle = FlxG.random.float(launchAngle.min, launchAngle.max);
			// Calculate launch velocity
			_point = FlxVelocity.velocityFromAngle(particleAngle, FlxG.random.float(speed.start.min, speed.start.max));
			particle.velocity.x = _point.x;
			particle.velocity.y = _point.y;
			particle.velocityRange.start.set(_point.x, _point.y);
			// Calculate final velocity
			_point = FlxVelocity.velocityFromAngle(particleAngle, FlxG.random.float(speed.end.min, speed.end.max));
			particle.velocityRange.end.set(_point.x, _point.y);
		}
		else
		{
			particle.velocityRange.start.x = FlxG.random.float(velocity.start.min.x, velocity.start.max.x);
			particle.velocityRange.start.y = FlxG.random.float(velocity.start.min.y, velocity.start.max.y);
			particle.velocityRange.end.x = FlxG.random.float(velocity.end.min.x, velocity.end.max.x);
			particle.velocityRange.end.y = FlxG.random.float(velocity.end.min.y, velocity.end.max.y);
			particle.velocity.x = particle.velocityRange.start.x;
			particle.velocity.y = particle.velocityRange.start.y;
		}
		
		// Particle angular velocity settings
		particle.angularVelocityRange.active = angularVelocity.start != angularVelocity.end;
		
		if (!ignoreAngularVelocity)
		{
			particle.angularAcceleration = FlxG.random.float(angularAcceleration.start.min, angularAcceleration.start.max);

			particle.angularVelocityRange.start = FlxG.random.float(angularVelocity.start.min, angularVelocity.start.max);
			particle.angularVelocityRange.end = FlxG.random.float(angularVelocity.end.min, angularVelocity.end.max);
			particle.angularVelocity = particle.angularVelocityRange.start;

			particle.angularDrag = FlxG.random.float(angularDrag.start.min, angularDrag.start.max);
		}
		else
		{
			particle.angularVelocity = (FlxG.random.float(angle.end.min, angle.end.max) - FlxG.random.float(angle.start.min, angle.start.max)) / FlxG.random.float(lifespan.min, lifespan.max);
			particle.angularVelocityRange.active = false;
		}
		
		// Particle angle settings
		particle.angle = FlxG.random.float(angle.start.min, angle.start.max);
		
		// Particle lifespan settings
		particle.lifespan = FlxG.random.float(lifespan.min, lifespan.max);
		
		// Particle scale settings
		particle.scaleRange.start.x = FlxG.random.float(scale.start.min.x, scale.start.max.x);
		particle.scaleRange.start.y = keepScaleRatio ? particle.scaleRange.start.x : FlxG.random.float(scale.start.min.y, scale.start.max.y);
		particle.scaleRange.end.x = FlxG.random.float(scale.end.min.x, scale.end.max.x);
		particle.scaleRange.end.y = keepScaleRatio ? particle.scaleRange.end.x : FlxG.random.float(scale.end.min.y, scale.end.max.y);
		particle.scaleRange.active = !particle.scaleRange.start.equals(particle.scaleRange.end);
		particle.scale.x = particle.scaleRange.start.x;
		particle.scale.y = particle.scaleRange.start.y;
		if (particle.autoUpdateHitbox) particle.updateHitbox();
		
		// Particle alpha settings
		particle.alphaRange.start = FlxG.random.float(alpha.start.min, alpha.start.max);
		particle.alphaRange.end = FlxG.random.float(alpha.end.min, alpha.end.max);
		particle.alphaRange.active = particle.alphaRange.start != particle.alphaRange.end;
		particle.alpha = particle.alphaRange.start;
		
		// Particle color settings
		particle.colorRange.start = FlxG.random.color(color.start.min, color.start.max);
		particle.colorRange.end = FlxG.random.color(color.end.min, color.end.max);
		particle.colorRange.active = particle.colorRange.start != particle.colorRange.end;
		particle.color = particle.colorRange.start;
		
		// Particle drag settings
		particle.dragRange.start.x = FlxG.random.float(drag.start.min.x, drag.start.max.x);
		particle.dragRange.start.y = FlxG.random.float(drag.start.min.y, drag.start.max.y);
		particle.dragRange.end.x = FlxG.random.float(drag.end.min.x, drag.end.max.x);
		particle.dragRange.end.y = FlxG.random.float(drag.end.min.y, drag.end.max.y);
		particle.dragRange.active = !particle.dragRange.start.equals(particle.dragRange.end);
		particle.drag.x = particle.dragRange.start.x;
		particle.drag.y = particle.dragRange.start.y;
		
		// Particle acceleration settings
		particle.accelerationRange.start.x = FlxG.random.float(acceleration.start.min.x, acceleration.start.max.x);
		particle.accelerationRange.start.y = FlxG.random.float(acceleration.start.min.y, acceleration.start.max.y);
		particle.accelerationRange.end.x = FlxG.random.float(acceleration.end.min.x, acceleration.end.max.x);
		particle.accelerationRange.end.y = FlxG.random.float(acceleration.end.min.y, acceleration.end.max.y);
		particle.accelerationRange.active = !particle.accelerationRange.start.equals(particle.accelerationRange.end);
		particle.acceleration.x = particle.accelerationRange.start.x;
		particle.acceleration.y = particle.accelerationRange.start.y;
		
		// Particle elasticity settings
		particle.elasticityRange.start = FlxG.random.float(elasticity.start.min, elasticity.start.max);
		particle.elasticityRange.end = FlxG.random.float(elasticity.end.min, elasticity.end.max);
		particle.elasticityRange.active = particle.elasticityRange.start != particle.elasticityRange.end;
		particle.elasticity = particle.elasticityRange.start;
		
		var point:FlxPoint = new FlxPoint(width / 2, 0);
		point.rotate(new FlxPoint(), particleAngle);
		
		// Set position
		particle.x = x + point.x;
		particle.y = y + point.y;
		
		// Restart animation
		if (particle.animation.curAnim != null)
		{
			particle.animation.curAnim.restart();
		}
		
		particle.onEmit();
		
		particle.bulletColor = bulletColor;
	}
}