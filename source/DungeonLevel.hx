package;

import Entity.PlayerEntity;
import flixel.FlxG;
import flixel.FlxObject;
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
import haxe.ds.IntMap;
import haxe.io.Path;
import traps.BoulderTrap;
import traps.ITrap;
import traps.PressurePlate;

class DungeonLevel extends TiledMap
{
	inline static var c_PATH_LEVEL_TILESHEETS = "assets/tiled/";

	public var foregroundTiles:FlxGroup;
	public var entitiesInfoLayer:FlxGroup;
	public var triggerLayer:FlxSpriteGroup;
	public var trapsLayer:FlxGroup;
	public var entitiesLayer:FlxSpriteGroup;
	public var backgroundLayer:FlxGroup;
	public var boulderLayer:FlxSpriteGroup;

	private var trapMap:Map<String, ITrap>;

	public var player:PlayerEntity;

	var collidableTileLayers:Array<FlxTilemap>;

	public function new(tiledLevel:FlxTiledMapAsset)
	{
		super(tiledLevel);

		foregroundTiles = new FlxGroup();
		entitiesInfoLayer = new FlxGroup();
		triggerLayer = new FlxSpriteGroup();
		trapsLayer = new FlxGroup();
		entitiesLayer = new FlxSpriteGroup();
		backgroundLayer = new FlxGroup();
		boulderLayer = new FlxSpriteGroup();

		this.trapMap = new Map();
		FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);

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
				this.player = new PlayerEntity(x, y, AssetPaths.pharaoh__png, entitiesInfoLayer);
				FlxG.camera.follow(player);
				entitiesLayer.add(player);

			case "floor_trap":
				var trap = new PressurePlate(x, y, o.properties.get("trap"), trapMap);
				triggerLayer.add(trap);

			case "boulder_trap":
				var trap = new BoulderTrap(x, y, boulderLayer, o.properties.get("direction"));
				trapsLayer.add(trap);
				trapMap.set(o.name, trap);
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
