package;

import Entity.PlayerEntity;
import enemies.Melee.MeleeEntity;
import enemies.Range.RangeEntity;
import enemies.Test.TestEnemy;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledImageTile;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTilePropertySet;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.tile.FlxTileSpecial;
import flixel.addons.tile.FlxTilemapExt;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.tile.FlxTilemap;
import haxe.io.Path;

class DungeonLevel extends TiledMap
{
	inline static var c_PATH_LEVEL_TILESHEETS = "assets/tiled/";

	public var foregroundTiles:FlxGroup;
	public var entitiesInfoLayer:FlxGroup;
	public var trapsLayer:FlxSpriteGroup;
	public var entitiesLayer:FlxSpriteGroup;
	public var backgroundLayer:FlxGroup;

	public var player:PlayerEntity;

	public var collidableTileLayers:Array<FlxTilemap>;
	public var pathing:Map<String, FlxTilemap>;

	public function new(tiledLevel:FlxTiledMapAsset)
	{
		super(tiledLevel);

		foregroundTiles = new FlxGroup();
		entitiesInfoLayer = new FlxGroup();
		trapsLayer = new FlxSpriteGroup();
		entitiesLayer = new FlxSpriteGroup();
		backgroundLayer = new FlxGroup();

		FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);
		FlxG.camera.zoom = 3;

		loadData();
	}

	private function loadData()
	{
		for (layer in layers)
		{
			switch (layer.type)
			{
				case TiledLayerType.OBJECT:
					loadObjects(layer);
				case TiledLayerType.TILE:
					loadTileMaps(layer);
				default:
			}
		}
	}

	public function loadObjects(layer:TiledLayer)
	{
		if (layer.type != TiledLayerType.OBJECT)
			return;
		var objectLayer:TiledObjectLayer = cast layer;

		for (o in objectLayer.objects)
		{
			loadObject(o, objectLayer);
		}
	}

	function loadObject(o:TiledObject, g:TiledObjectLayer)
	{
		var x:Int = o.x;
		var y:Int = o.y;

		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;

		switch (o.type.toLowerCase())
		{
			case "player_start":
				this.player = new PlayerEntity(x, y, AssetPaths.player__png, this);
				FlxG.camera.follow(player);
				entitiesLayer.add(player);

			case "floor_trap":
				var trap = new FlxSprite(x, y);
				trap.loadGraphic("assets/tiled/tile_placeholder.png", true, 16, 16);
				trap.animation.add("normal", [3], 60, false);
				trap.animation.add("pressed", [2], 60, false);
				trap.animation.play("normal");
				trapsLayer.add(trap);

			case "enemy_spawn":
				switch (o.properties.get("type"))
				{
					case "melee":
						entitiesLayer.add(new MeleeEntity(x, y, AssetPaths.player__png, this));
					case "range":
						entitiesLayer.add(new RangeEntity(x, y, AssetPaths.player__png, this));
					case "test":
						// entitiesLayer.add(new TestEnemy(x, y, AssetPaths.player__png, this));
				}
		}
	}

	public function loadTileMaps(layer:TiledLayer)
	{
		if (layer.type != TiledLayerType.TILE)
			return;
		var tileLayer:TiledTileLayer = cast layer;

		var tileSheetName:String = tileLayer.properties.get("tileset");

		if (tileSheetName == null)
			throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";

		var tileSet:TiledTileSet = null;
		for (ts in tilesets)
		{
			if (ts.name == tileSheetName)
			{
				tileSet = ts;
				break;
			}
		}

		if (tileSet == null)
			throw "Tileset '" + tileSheetName + " not found. Did you misspell the 'tilesheet' property in " + tileLayer.name + "' layer?";

		var imagePath = new Path(tileSet.imageSource);
		var processedPath = c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;

		// could be a regular FlxTilemap if there are no animated tiles
		var tilemap = new FlxTilemapExt();
		tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath, tileSet.tileWidth, tileSet.tileHeight, OFF, tileSet.firstGID, 1, 1);

		if (tileLayer.properties.contains("pathing"))
		{
			if (pathing == null)
				pathing = new Map<String, FlxTilemap>();

			pathing[tileLayer.name] = tilemap;
			return;
		}

		if (tileLayer.properties.contains("animated"))
		{
			var tileset = tilesets["level"];
			var specialTiles:Map<Int, TiledTilePropertySet> = new Map();
			for (tileProp in tileset.tileProps)
			{
				if (tileProp != null && tileProp.animationFrames.length > 0)
				{
					specialTiles[tileProp.tileID + tileset.firstGID] = tileProp;
				}
			}
			var tileLayer:TiledTileLayer = cast layer;
			tilemap.setSpecialTiles([
				for (tile in tileLayer.tiles)
					if (tile != null && specialTiles.exists(tile.tileID)) getAnimatedTile(specialTiles[tile.tileID], tileset) else null
			]);
		}

		if (tileLayer.properties.contains("nocollide"))
		{
			backgroundLayer.add(tilemap);
		}
		else
		{
			if (collidableTileLayers == null)
				collidableTileLayers = new Array<FlxTilemap>();

			foregroundTiles.add(tilemap);
			if (!tileLayer.properties.contains("above"))
			{
				collidableTileLayers.push(tilemap);
			}
		}
	}

	function getAnimatedTile(props:TiledTilePropertySet, tileset:TiledTileSet):FlxTileSpecial
	{
		var special = new FlxTileSpecial(1, false, false, 0);
		var n:Int = props.animationFrames.length;
		var offset = Std.random(n);
		special.addAnimation([
			for (i in 0...n)
				props.animationFrames[(i + offset) % n].tileID + tileset.firstGID
		], (1000 / props.animationFrames[0].duration));
		return special;
	}

	public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool
	{
		if (collidableTileLayers == null)
			return false;

		for (map in collidableTileLayers)
		{
			// IMPORTANT: Always collide the map with objects, not the other way around.
			//            This prevents odd collision errors (collision separation code off by 1 px).
			if (FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate))
			{
				return true;
			}
		}
		return false;
	}
}
