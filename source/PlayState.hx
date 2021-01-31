package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.plugin.FlxMouseControl;
import flixel.system.scaleModes.RatioScaleMode;
import traps.BoulderTrap;

class PlayState extends FlxState
{
	public var level:DungeonLevel;

	override public function create()
	{
		super.create();
		FlxG.debugger.visible = true;
		FlxG.scaleMode = new RatioScaleMode();

		FlxG.plugins.add(new FlxMouseControl());

		level = new DungeonLevel("assets/tiled/test_map.tmx");

		// Add backgrounds
		add(level.backgroundLayer);

		// Load trap objects
		add(level.trapsLayer);

		add(level.triggerLayer);

		// Load player & enemy objects
		add(level.entitiesLayer);

		// Add foreground tiles after adding level objects, so these tiles render on top of player
		add(level.foregroundTiles);

		// Load Entity info display like health bars
		add(level.entitiesInfoLayer);

		// things that can damage the player
		add(level.boulderLayer);

		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(AssetPaths.GGGAmbience__wav, 1, true);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		level.collideWithLevel(level.player);

		FlxG.overlap(level.triggerLayer, level.entitiesLayer, null, (trigger, entity) ->
		{
			if (FlxG.pixelPerfectOverlap(trigger, entity))
			{
				(cast trigger).addEntity(entity);
			}
			return false;
		});

		FlxG.overlap(level.boulderLayer, level.entitiesLayer, null, (boulder, entity) ->
		{
			if (FlxG.pixelPerfectOverlap(boulder, entity))
			{
				(cast entity).damage(boulder.health);
				BoulderTrap.killBoulder(cast boulder);
			}
			return false;
		});

		level.boulderLayer.forEachAlive((b) -> level.collideWithLevel(b, (level, boulder) ->
		{
			BoulderTrap.killBoulder(cast boulder);
		}));
	}
}
