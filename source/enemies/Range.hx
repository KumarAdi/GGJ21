package enemies;

import Entity.EnemyEntity;
import Entity.EnemyMode;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.tweens.motion.LinearPath;

class RangeEntity extends EnemyEntity
{
	var oldFacing:Int;
	var currentPath:LinearPath;

	public function new(X:Float = 0, Y:Float = 0, level:DungeonLevel)
	{
		super(X, Y, level, 40, 4);
		oldFacing = facing;
		pathingKey = "avoidRange";
		visionRange = 150;
		attackRange = 100;

		// TODO replace with the real animation
		loadGraphic(AssetPaths.pharaoh__png, true, 60, 90);

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
			level.player.damage(attackDamage);
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
