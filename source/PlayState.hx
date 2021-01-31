package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.plugin.FlxMouseControl;
import flixel.group.FlxGroup;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.tweens.FlxTween.FlxTweenManager;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.NumTween;
import traps.BoulderTrap;

class PlayState extends FlxState
{
	public var level:DungeonLevel;
	public var projectiles:FlxGroup;

	override public function create()
	{
		super.create();
		projectiles = new FlxGroup();
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

		// things that can damage the player
		add(level.boulderLayer);

		// Add foreground tiles after adding level objects, so these tiles render on top of player
		add(level.foregroundTiles);

		add(level.pitLayer);

		// Load Entity info display like health bars
		add(level.entitiesInfoLayer);

		add(projectiles);

		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(AssetPaths.GGGAmbience__wav, 1, true);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		level.collideWithLevel(level.player);

		FlxG.overlap(level.pitLayer, level.entitiesLayer, null, (pit, entity) ->
		{
			FlxTween.tween(entity, {
				x: pit.x,
				y: pit.y
			}, 0.4);
			FlxTween.tween(entity.scale, {
				x: 0,
				y: 0
			}, 0.4);
			return false;
		});

		FlxG.overlap(level.pitLayer, level.boulderLayer, null, (pit, entity) ->
		{
			FlxTween.tween(entity, {
				x: pit.x,
				y: pit.y
			}, 0.4);
			FlxTween.tween(entity.scale, {
				x: 0,
				y: 0
			}, 0.4);
			return false;
		});

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

		// Projectile overlap
		FlxG.overlap(projectiles, level.player, null, (projectile, player) ->
		{
			if (FlxG.pixelPerfectOverlap(projectile, player))
			{
				(cast player).damage(projectile.health);
				projectile.destroy();
			}
			return false;
		});
	}
}
