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

	public function new(X:Float = 0, Y:Float = 0, asset:FlxGraphicAsset, level:DungeonLevel)
	{
		super(X, Y, asset, level, 40, 4);
		oldFacing = facing;
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
		if (currentPath != null && !currentPath.finished)
		{
			currentPath.cancelChain();
		}
	}

	function moveTowards(pos:FlxPoint, changed:Bool)
	{
		if (changed)
		{
			if (currentPath != null && !currentPath.finished)
			{
				currentPath.cancelChain();
			}

			var path = pathing.findPath(getPosition(), pos);
			if (path != null && path.length > 1)
			{
				currentPath = FlxTween.linearPath(this, path, speed, false);
			}
		}
	}

	function attack()
	{
		if (currentPath != null && !currentPath.finished)
		{
			currentPath.cancelChain();
		}
		if (attackCountdown <= 0)
		{
			// TODO: play the animation
			level.player.damage(attackDamage);
			attackCountdown = attackCooldown;
		}
	}
}
