import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.tweens.motion.LinearPath;
import flixel.ui.FlxBar;
import haxe.Timer;

class Entity extends FlxSprite
{
	public var speed:Float;
	public var maxHealth:Int;
	public var level:DungeonLevel;
	public var invulnerable:Bool;

	public function new(X:Float = 0, Y:Float = 0, level:DungeonLevel, speed:Float = 80, maxHealth:Int = 10)
	{
		super(X, Y);
		this.speed = speed;
		this.maxHealth = maxHealth;
		this.level = level;
		this.invulnerable = false;

		health = 100;

		maxVelocity.x = speed;
		maxVelocity.y = speed;
		drag.x = maxVelocity.x * 4;
		drag.y = maxVelocity.y * 4;

		var bar = new FlxBar(0, 0, LEFT_TO_RIGHT, 60, 12);
		bar.percent = 100;
		bar.setParent(this, "health", true, 0, 0);
		level.entitiesInfoLayer.add(bar);
	}

	public function damage(amount:Int)
	{
		if (!invulnerable)
		{
			health -= (100 / maxHealth) * amount;
			invulnerable = true;
			Timer.delay(() -> invulnerable = false, 500);
		}
	}
}

class PlayerEntity extends Entity
{
	public function new(X:Float = 0, Y:Float = 0, asset:FlxGraphicAsset, level:DungeonLevel)
	{
		super(X, Y, level, 80, 10);

		loadGraphic(asset, true, 60, 90);

		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);

		animation.add("lr", [for (x in 10...18) x], 10, false);
		animation.add("u", [for (x in 10...18) x], 10, false);
		animation.add("d", [for (x in 10...18) x], 10, false);
		animation.add("idle", [for (x in 0...8) x], 10, true);

		animation.play("idle");
	}

	override function update(elapsed:Float)
	{
		updateMovement();
		super.update(elapsed);
	}

	function updateMovement()
	{
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);

		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;

		if (up || down || left || right)
		{
			var newAngle:Float = 0;
			if (up)
			{
				newAngle = -90;
				if (left)
					newAngle -= 45;
				else if (right)
					newAngle += 45;
				facing = FlxObject.UP;
			}
			else if (down)
			{
				newAngle = 90;
				if (left)
					newAngle += 45;
				else if (right)
					newAngle -= 45;
				facing = FlxObject.DOWN;
			}
			else if (left)
			{
				newAngle = 180;
				facing = FlxObject.LEFT;
			}
			else if (right)
			{
				newAngle = 0;
				facing = FlxObject.RIGHT;
			}

			// determine our velocity based on angle and speed
			velocity.set(speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), newAngle);

			// if the player is moving (velocity is not 0 for either axis), we need to change the animation to match their facing
			if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
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
			}
		}
		else
		{
			if (velocity.x == 0 && velocity.y == 0)
			{
				animation.play("idle", false);
			}
		}
	}
}

enum EnemyMode
{
	Idle;
	MovingTowards(path:FlxPoint, changed:Bool);
	Attacking;
}

class EnemyEntity extends Entity
{
	var pathingKey:String = "avoidMelee";
	var pathing:FlxTilemap;
	var visionRange:Float = 100;
	var attackRange:Float = 10;
	var attackDamage:Int = 1;
	var attackCooldown:Float = 1;
	var attackCountdown:Float = 0;
	// var moveSensitivty:Float = 10;
	var mode:EnemyMode = Idle;

	public function new(X:Float = 0, Y:Float = 0, level:DungeonLevel, speed:Float, maxHealth:Int)
	{
		super(X, Y, level, speed, maxHealth);
		mode = EnemyMode.Idle;
	}

	override function update(elapsed:Float)
	{
		if (pathing == null)
			if (level.pathing.exists(pathingKey))
				pathing = level.pathing[pathingKey];
		updateMode(elapsed);
		updateAttackCountdown(elapsed);
	}

	function updateMode(elapsed:Float)
	{
		var myPos = getPosition();
		var playerPos = level.player.getPosition();

		var distanceToPlayer = myPos.distanceTo(playerPos);
		FlxG.watch.addQuick("distanceToPlayer", distanceToPlayer);
		if (distanceToPlayer <= visionRange && distanceToPlayer > attackRange)
		{
			switch (mode)
			{
				case MovingTowards(pos, changed):
					if (pos.equals(playerPos))
					{
						return;
					}
				default:
			}
			if (level.collidableTileLayers[0].ray(myPos, playerPos))
			{
				mode = MovingTowards(playerPos, true);
				return;
			}
		}
		else if (distanceToPlayer < attackRange)
		{
			mode = Attacking;
			return;
		}
		mode = EnemyMode.Idle;
	}

	function updateAttackCountdown(elapsed:Float)
	{
		if (attackCountdown > 0)
		{
			attackCountdown -= elapsed;
		}
	}
}
