package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxBar;
import flixel.util.FlxSort;

class PlayState extends FlxState
{
	public var level:DungeonLevel;

	override public function create()
	{
		super.create();

		level = new DungeonLevel("assets/tiled/0x72_16x16DungeonTileset_walls.v1.tmx");

		// Add backgrounds
		add(level.backgroundLayer);

		// Load trap objects
		add(level.trapsLayer);

		// Load player & enemy objects
		add(level.entitiesLayer);

		// Add foreground tiles after adding level objects, so these tiles render on top of player
		add(level.foregroundTiles);

		// Load Entity info display like health bars
		add(level.entitiesInfoLayer);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		level.collideWithLevel(level.player);
		FlxG.overlap(level.trapsLayer, level.player, null, (trap, player) ->
		{
			var trapSprite:FlxSprite = cast trap;
			trapSprite.animation.play("pressed", true);
			trapSprite.animation.finishCallback = (name) ->
			{
				if (FlxG.overlap(trapSprite, player))
					return;
				trapSprite.animation.play("normal");
				trapSprite.animation.finishCallback = null;
			};
			return false;
		});
	}
}
