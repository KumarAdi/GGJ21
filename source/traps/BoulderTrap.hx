package traps;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import traps.ITrap.TriggerEvent;

class BoulderTrap extends FlxObject implements ITrap
{
	private final SPEED = 180;

	private var level:FlxSpriteGroup;
	private var direction:FlxPoint;

	public function new(x, y, level:FlxSpriteGroup, direction:String)
	{
		super(x, y);
		this.level = level;
		switch (direction)
		{
			case "left":
				this.direction = new FlxPoint(-1, 0);
			case "right":
				this.direction = new FlxPoint(1, 0);
			case "up":
				this.direction = new FlxPoint(0, -1);
			case "down":
				this.direction = new FlxPoint(0, 1);
		}
		this.direction.scale(SPEED);
	}

	public function triggerEvent(event:TriggerEvent)
	{
		if (event == Pressed)
		{
			var boulder = new FlxSprite(this.x, this.y);
			boulder.loadGraphic(AssetPaths.boulder__png, true, 90, 90);
			boulder.animation.add("roll", [for (i in 0...16) i], 32, true);
			boulder.animation.add("break", [for (x in 16...21) x], 32, false);
			boulder.velocity = new FlxPoint(this.direction.x, this.direction.y);
			boulder.health = 1;
			this.level.add(boulder);
			boulder.animation.play("roll");
		}
	}

	public static function killBoulder(boulder:FlxSprite)
	{
		boulder.animation.play("break");
		boulder.animation.finishCallback = (_) -> boulder.kill();
	}
}
