package enemies;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.tweens.motion.LinearPath;
import openfl.display.Sprite;

class RangeEntity extends Entity
{
	var oldFacing:Int;
	var pathing:FlxTilemap;
	var visionRange:Float = 150;
	var attackRange:Float = 100;
	var attackDamage:Int = 1;
	var attackProjectileSpeed:Float = 100;
	var attackCooldown:Float = 1;
	var attackCountdown:Float = 1;
	var currentPath:LinearPath;
	var currentDest:FlxPoint;

	public function new(X:Float = 0, Y:Float = 0, asset:FlxGraphicAsset, level:DungeonLevel)
	{
		super(X, Y, asset, level, 40, 4);
		oldFacing = facing;
	}

	override function update(elapsed:Float)
	{
		if (pathing == null)
			if (level.pathing.exists("avoidRange"))
				pathing = level.pathing["avoidRange"];

		if (facing != oldFacing)
		{
			switch (facing)
			{
				case FlxObject.LEFT, FlxObject.RIGHT:
					animation.play("lr");
				case FlxObject.UP:
					animation.play("u");
				case FlxObject.DOWN:
					animation.play("d");
			}
			oldFacing = facing;
		}

		if (attackCountdown > 0)
		{
			attackCountdown -= elapsed;
		}

		findAndAttackPlayer();
		super.update(elapsed);
	}

	function findAndAttackPlayer()
	{
		var myPos = new FlxPoint(x, y);
		var playerPos = new FlxPoint(level.player.x, level.player.y);
		var distance = playerPos.distanceTo(myPos);

		if (currentDest == null)
			currentDest = playerPos;

		if (distance <= visionRange && level.collidableTileLayers[0].ray(myPos, playerPos))
		{
			if (distance <= attackRange)
			{
				if (attackCountdown < 0)
				{
					// TODO: do attack animation
					var projectile = new FlxSprite(16, 16);
					projectile.makeGraphic(16, 16, 0xFF0000);
					// FlxVelocity.moveTowardsPoint(this, playerPos);
					FlxG.state.add(projectile);
					// level.player.damage(attackDamage);
					attackCountdown = attackCooldown;
				}
			}
			if (currentPath == null || currentPath.finished || !currentDest.equals(playerPos))
			{
				if (currentPath != null && !currentPath.finished && !currentDest.equals(playerPos))
				{
					currentPath.cancelChain();
				}
				var path = pathing.findPath(myPos, playerPos);
				trace(path);
				if (path != null && path.length > 1)
				{
					currentPath = FlxTween.linearPath(this, path, speed, false);
					currentDest = playerPos;
				}
			}
		}
		else if (currentPath != null && !currentPath.finished)
		{
			currentPath.cancelChain();
		}
	}
}
