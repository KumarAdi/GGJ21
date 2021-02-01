package enemies;

import Entity.EnemyEntity;
import Entity.EnemyMode;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.tweens.motion.LinearPath;

class RangeEntity extends EnemyEntity
{
	var oldFacing:Int;
	var currentPath:LinearPath;
	var projectileSpeed:Float = 150;
	var minAttackRange:Float = 400;

	public function new(X:Float = 0, Y:Float = 0, level:DungeonLevel)
	{
		super(X, Y, level, 40, 4);
		oldFacing = facing;
		pathingKey = "avoidRange";
		visionRange = 500;
		attackRange = 300;

		// TODO replace with the real animation
		loadGraphic(AssetPaths.scorpion__png, true, 60, 90);

		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);

		maxVelocity.x = speed;
		maxVelocity.y = speed;
		drag.x = maxVelocity.x * 4;
		drag.y = maxVelocity.y * 4;

		animation.add("lr", [for (x in 10...18) x], 10, false);
		animation.add("u", [for (x in 10...18) x], 10, false);
		animation.add("d", [for (x in 10...18) x], 10, false);
		animation.add("idle", [for (x in 0...8) x], 10, true);

		halfHitbox();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		switch (mode)
		{
			case EnemyMode.Idle:
				idle();
			case EnemyMode.MovingTowards(pos, changed):
				if (pathing != null)
					moveTowards(pos, changed);
			case EnemyMode.Attacking:
				attack();
		}
	}

	function idle()
	{
		clearCurrentPath();
	}

	function moveTowards(pos:FlxPoint, changed:Bool)
	{
		if (getPosition().distanceTo(pos) < minAttackRange)
		{
			attack();
		}

		if (changed)
		{
			clearCurrentPath();

			var path = pathing.findPath(getPosition(), pos);
			if (path != null && path.length > 1)
			{
				currentPath = FlxTween.linearPath(this, path, speed, false);
			}
		}
	}

	function attack()
	{
		clearCurrentPath();
		if (attackCountdown <= 0)
		{
			// TODO: play the animation
			var projectile = new FlxSprite(x, y);
			projectile.loadGraphic(AssetPaths.projectile__png, false, 60, 60);
			FlxVelocity.moveTowardsObject(projectile, level.player, projectileSpeed);
			projectile.angle = getPosition().angleBetween(level.player.getPosition()) + 90;
			FlxG.watch.addQuick("Velocity", velocity);
			FlxG.watch.addQuick("angle", projectile.angle);
			(cast FlxG.state).projectiles.add(projectile);
			// level.player.damage(attackDamage);
			attackCountdown = attackCooldown;
		}
	}

	function clearCurrentPath()
	{
		if (currentPath != null && !currentPath.finished)
		{
			currentPath.cancelChain();
		}
	}
}
