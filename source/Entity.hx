import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.ui.FlxBar;
import haxe.Timer;

class Entity extends FlxSprite
{
	public var speed:Float;
	public var maxHealth:Int;
	public var invulnerable:Bool;

	public function new(X:Float = 0, Y:Float = 0, asset:FlxGraphicAsset, group:FlxGroup, speed:Float = 80, maxHealth:Int = 10)
	{
		super(X, Y);
		this.speed = speed;
		this.maxHealth = maxHealth;
		this.invulnerable = false;

		loadGraphic(asset, true, 60, 90);

		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);

		maxVelocity.x = speed;
		maxVelocity.y = speed;
		drag.x = maxVelocity.x * 4;
		drag.y = maxVelocity.y * 4;

		animation.add("lr", [for (x in 10...18) x], 6, false);
		animation.add("u", [for (x in 10...18) x], 6, false);
		animation.add("d", [for (x in 10...18) x], 6, false);
		animation.add("idle", [for (x in 0...8) x], 6, true);

		health = 100;

		var bar = new FlxBar(0, 0, LEFT_TO_RIGHT, 60, 12);
		bar.percent = 100;
		bar.setParent(this, "health", true, 0, 0);
		group.add(bar);

		animation.play("idle");
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
	public function new(X:Float = 0, Y:Float = 0, asset:FlxGraphicAsset, group:FlxGroup)
	{
		super(X, Y, asset, group, 80, 10);
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
