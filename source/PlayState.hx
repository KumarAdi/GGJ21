package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.plugin.FlxMouseControl;
import flixel.ui.FlxBar;
import flixel.util.FlxSort;
import haxe.display.Display.Package;
import traps.PressurePlate;

class PlayState extends FlxState
{
	public var level:DungeonLevel;

	override public function create()
	{
		super.create();

		FlxG.plugins.add(new FlxMouseControl());

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

		// things that can damage the player
		add(level.damageLayer);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		level.collideWithLevel(level.player);
		FlxG.overlap(level.trapsLayer, level.player, null, (trap, player) ->
		{
			trap.addEntity(level.entitiesLayer);
			return false;
		});

		FlxG.overlap(level.damageLayer, level.entitiesLayer, null, (damager, damagee) ->
		{
			damagee.damage(damager.health);
			return false;
		});
	}
}
