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

class MeleeEntity extends EnemyEntity
{
	var oldFacing:Int;
	var currentPath:LinearPath;

	public function new(X:Float = 0, Y:Float = 0, level:DungeonLevel)
	{
		super(X, Y, level, 40, 4);
		oldFacing = facing;
		visionRange = 400;
		attackRange = 50;

		loadGraphic(AssetPaths.scarab__png, true, 60, 90);

		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);

		animation.add("lr", [for (x in 10...18) x], 10, false);
		animation.add("u", [for (x in 10...18) x], 10, false);
		animation.add("d", [for (x in 10...18) x], 10, false);
		animation.add("idle", [for (x in 0...8) x], 10, true);
		animation.add("dead", [for (x in 24...32) x], 10, true);
		animation.add("attack", [for (x in 36...45) x], 10, true);

		animation.play("attack");

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
			case EnemyMode.Dead:
				dead();
		}
	}

	function idle()
	{
		clearCurrentPath();

		// if (animation.curAnim.name != "idle")
		// {
		// 	animation.play("idle");
		// }
	}

	function moveTowards(pos:FlxPoint, changed:Bool)
	{
		// if (animation.curAnim.name != "u")
		// {
		// 	animation.play("u");
		// }
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
			animation.play("attack");
			level.player.damage(attackDamage);
			attackCountdown = attackCooldown;
		}
	}

	function dead()
	{
		if (animation.curAnim.name != "dead")
		{
			animation.play("dead");
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
