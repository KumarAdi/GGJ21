package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	public var level:DungeonLevel;

	public var player:FlxSprite;
	public var floor:FlxObject;

	override public function create()
	{
		super.create();

		level = new DungeonLevel("assets/tiled/0x72_16x16DungeonTileset_walls.v1.tmx", this);

		// Add backgrounds
		add(level.backgroundLayer);

		// Add static images
		add(level.imagesLayer);

		// Load player objects
		add(level.objectsLayer);

		// Add foreground tiles after adding level objects, so these tiles render on top of player
		add(level.foregroundTiles);
	}

	override public function update(elapsed:Float)
	{
		player.acceleration.x = 0;
		player.acceleration.y = 0;
		if (FlxG.keys.anyPressed([LEFT, A]))
		{
			player.acceleration.x -= player.maxVelocity.x * 4;
		}
		if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			player.acceleration.x += player.maxVelocity.x * 4;
		}
		if (FlxG.keys.anyPressed([W, UP]))
		{
			player.acceleration.y -= player.maxVelocity.y * 4;
		}
		if (FlxG.keys.anyPressed([S, DOWN]))
		{
			player.acceleration.y += player.maxVelocity.y * 4;
		}
		super.update(elapsed);

		level.collideWithLevel(player);
	}
}
