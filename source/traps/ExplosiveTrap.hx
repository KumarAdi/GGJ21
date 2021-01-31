package traps;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import traps.ITrap.TriggerEvent;

class ExplosiveTrap extends FlxObject implements ITrap
{
	private var level:FlxGroup;

	public function new(x, y, level:FlxGroup)
	{
		super(x, y);
		this.level = level;
	}

	public function triggerEvent(event:TriggerEvent)
	{
		if (event == Pressed)
		{
			var explosion = new FlxSprite(this.x, this.y);
			explosion.loadGraphic("assets/images/exp2.jpg", true, 16, 16);
			explosion.animation.add("explode", [for (i in 0...16) 15 - i], 32, false);
			explosion.animation.finishCallback = (_) ->
			{
				explosion.kill();
			};
			explosion.health = 1;
			this.level.add(explosion);
			explosion.animation.play("explode");
		}
	}
}
