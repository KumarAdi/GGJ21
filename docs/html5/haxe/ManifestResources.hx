package;


import haxe.io.Bytes;
import lime.utils.AssetBundle;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

		}

		if (rootPath == null) {

			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif android
			rootPath = "";
			#elseif console
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_fonts_history_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_fonts_roman_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__flixel_fonts_monsterrat_ttf);
		
		#end

		var data, manifest, library, bundle;

		#if kha

		null
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("null", library);

		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("null");

		#else

		data = '{"name":null,"assets":"aoy4:pathy34:assets%2Fdata%2Fdata-goes-here.txty4:sizezy4:typey4:TEXTy2:idR1y7:preloadtgoR2i134128R3y4:FONTy9:classNamey33:__ASSET__assets_fonts_history_ttfR5y28:assets%2Ffonts%2Fhistory.ttfR6tgoR2i120208R3R7R8y31:__ASSET__assets_fonts_roman_ttfR5y26:assets%2Ffonts%2Froman.ttfR6tgoR0y29:assets%2Fimages%2Fboulder.pngR2i40842R3y5:IMAGER5R13R6tgoR0y26:assets%2Fimages%2Fexp2.jpgR2i3349R3R14R5R15R6tgoR0y36:assets%2Fimages%2Fimages-go-here.txtR2zR3R4R5R16R6tgoR0y29:assets%2Fimages%2Fpharaoh.pngR2i17046R3R14R5R17R6tgoR0y27:assets%2Fimages%2Fproj2.pngR2i1509R3R14R5R18R6tgoR0y27:assets%2Fimages%2Fproj3.pngR2i1284R3R14R5R19R6tgoR0y32:assets%2Fimages%2Fprojectile.pngR2i884R3R14R5R20R6tgoR0y35:assets%2Fimages%2Frocks_rotated.pngR2i17468R3R14R5R21R6tgoR0y28:assets%2Fimages%2Fscarab.pngR2i19830R3R14R5R22R6tgoR0y30:assets%2Fimages%2Fscorpion.pngR2i11623R3R14R5R23R6tgoR0y29:assets%2Fimages%2Funknown.pngR2i435688R3R14R5R24R6tgoR0y27:assets%2Fimages%2Fweigh.jpgR2i91307R3R14R5R25R6tgoR2i40060754R3y5:SOUNDR5y32:assets%2Fmusic%2FGGGAmbience.wavy9:pathGroupaR27hR6tgoR0y36:assets%2Fmusic%2Fmusic-goes-here.txtR2zR3R4R5R29R6tgoR0y36:assets%2Fsounds%2Fsounds-go-here.txtR2zR3R4R5R30R6tgoR0y54:assets%2Ftiled%2F0x72_16x16DungeonTileset_walls.v1.tmxR2i29248R3R4R5R31R6tgoR0y31:assets%2Ftiled%2Fdungeon.v1.pngR2i3083R3R14R5R32R6tgoR0y31:assets%2Ftiled%2Fdungeon.v4.pngR2i21280R3R14R5R33R6tgoR0y27:assets%2Ftiled%2Fplayer.pngR2i1876R3R14R5R34R6tgoR0y28:assets%2Ftiled%2FShooler.tmxR2i44644R3R4R5R35R6tgoR0y29:assets%2Ftiled%2Ftest_map.tmxR2i83177R3R4R5R36R6tgoR0y26:assets%2Ftiled%2Ftiles.pngR2i11359R3R14R5R37R6tgoR0y32:assets%2Ftiled%2Ftiles_final.tsxR2i1052R3R4R5R38R6tgoR0y37:assets%2Ftiled%2Ftile_placeholder.pngR2i33230R3R14R5R39R6tgoR0y26:assets%2Ftiled%2Ftraps.tsxR2i370R3R4R5R40R6tgoR0y32:assets%2Ftiled%2Fworking_map.tmxR2i106913R3R4R5R41R6tgoR2i2114R3y5:MUSICR5y26:flixel%2Fsounds%2Fbeep.mp3R28aR43y26:flixel%2Fsounds%2Fbeep.ogghR6tgoR2i39706R3R42R5y28:flixel%2Fsounds%2Fflixel.mp3R28aR45y28:flixel%2Fsounds%2Fflixel.ogghR6tgoR2i5794R3R26R5R44R28aR43R44hgoR2i33629R3R26R5R46R28aR45R46hgoR2i15744R3R7R8y35:__ASSET__flixel_fonts_nokiafc22_ttfR5y30:flixel%2Ffonts%2Fnokiafc22.ttfR6tgoR2i29724R3R7R8y36:__ASSET__flixel_fonts_monsterrat_ttfR5y31:flixel%2Ffonts%2Fmonsterrat.ttfR6tgoR0y33:flixel%2Fimages%2Fui%2Fbutton.pngR2i519R3R14R5R51R6tgoR0y36:flixel%2Fimages%2Flogo%2Fdefault.pngR2i3280R3R14R5R52R6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

		#end

	}


}


#if kha

null

#else

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_fonts_history_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_fonts_roman_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_boulder_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_exp2_jpg extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_pharaoh_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_proj2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_proj3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_projectile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_rocks_rotated_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_scarab_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_scorpion_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_unknown_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_weigh_jpg extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_gggambience_wav extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_tiled_0x72_16x16dungeontileset_walls_v1_tmx extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_tiled_dungeon_v1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_tiled_dungeon_v4_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_tiled_player_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_tiled_shooler_tmx extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_tiled_test_map_tmx extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_tiled_tiles_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_tiled_tiles_final_tsx extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_tiled_tile_placeholder_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_tiled_traps_tsx extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_tiled_working_map_tmx extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:file("assets/data/data-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_data_data_goes_here_txt extends haxe.io.Bytes {}
@:keep @:font("docs/html5/obj/webfont/history.ttf") @:noCompletion #if display private #end class __ASSET__assets_fonts_history_ttf extends lime.text.Font {}
@:keep @:font("docs/html5/obj/webfont/roman.ttf") @:noCompletion #if display private #end class __ASSET__assets_fonts_roman_ttf extends lime.text.Font {}
@:keep @:image("assets/images/boulder.png") @:noCompletion #if display private #end class __ASSET__assets_images_boulder_png extends lime.graphics.Image {}
@:keep @:image("assets/images/exp2.jpg") @:noCompletion #if display private #end class __ASSET__assets_images_exp2_jpg extends lime.graphics.Image {}
@:keep @:file("assets/images/images-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_images_images_go_here_txt extends haxe.io.Bytes {}
@:keep @:image("assets/images/pharaoh.png") @:noCompletion #if display private #end class __ASSET__assets_images_pharaoh_png extends lime.graphics.Image {}
@:keep @:image("assets/images/proj2.png") @:noCompletion #if display private #end class __ASSET__assets_images_proj2_png extends lime.graphics.Image {}
@:keep @:image("assets/images/proj3.png") @:noCompletion #if display private #end class __ASSET__assets_images_proj3_png extends lime.graphics.Image {}
@:keep @:image("assets/images/projectile.png") @:noCompletion #if display private #end class __ASSET__assets_images_projectile_png extends lime.graphics.Image {}
@:keep @:image("assets/images/rocks_rotated.png") @:noCompletion #if display private #end class __ASSET__assets_images_rocks_rotated_png extends lime.graphics.Image {}
@:keep @:image("assets/images/scarab.png") @:noCompletion #if display private #end class __ASSET__assets_images_scarab_png extends lime.graphics.Image {}
@:keep @:image("assets/images/scorpion.png") @:noCompletion #if display private #end class __ASSET__assets_images_scorpion_png extends lime.graphics.Image {}
@:keep @:image("assets/images/unknown.png") @:noCompletion #if display private #end class __ASSET__assets_images_unknown_png extends lime.graphics.Image {}
@:keep @:image("assets/images/weigh.jpg") @:noCompletion #if display private #end class __ASSET__assets_images_weigh_jpg extends lime.graphics.Image {}
@:keep @:file("assets/music/GGGAmbience.wav") @:noCompletion #if display private #end class __ASSET__assets_music_gggambience_wav extends haxe.io.Bytes {}
@:keep @:file("assets/music/music-goes-here.txt") @:noCompletion #if display private #end class __ASSET__assets_music_music_goes_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/sounds/sounds-go-here.txt") @:noCompletion #if display private #end class __ASSET__assets_sounds_sounds_go_here_txt extends haxe.io.Bytes {}
@:keep @:file("assets/tiled/0x72_16x16DungeonTileset_walls.v1.tmx") @:noCompletion #if display private #end class __ASSET__assets_tiled_0x72_16x16dungeontileset_walls_v1_tmx extends haxe.io.Bytes {}
@:keep @:image("assets/tiled/dungeon.v1.png") @:noCompletion #if display private #end class __ASSET__assets_tiled_dungeon_v1_png extends lime.graphics.Image {}
@:keep @:image("assets/tiled/dungeon.v4.png") @:noCompletion #if display private #end class __ASSET__assets_tiled_dungeon_v4_png extends lime.graphics.Image {}
@:keep @:image("assets/tiled/player.png") @:noCompletion #if display private #end class __ASSET__assets_tiled_player_png extends lime.graphics.Image {}
@:keep @:file("assets/tiled/Shooler.tmx") @:noCompletion #if display private #end class __ASSET__assets_tiled_shooler_tmx extends haxe.io.Bytes {}
@:keep @:file("assets/tiled/test_map.tmx") @:noCompletion #if display private #end class __ASSET__assets_tiled_test_map_tmx extends haxe.io.Bytes {}
@:keep @:image("assets/tiled/tiles.png") @:noCompletion #if display private #end class __ASSET__assets_tiled_tiles_png extends lime.graphics.Image {}
@:keep @:file("assets/tiled/tiles_final.tsx") @:noCompletion #if display private #end class __ASSET__assets_tiled_tiles_final_tsx extends haxe.io.Bytes {}
@:keep @:image("assets/tiled/tile_placeholder.png") @:noCompletion #if display private #end class __ASSET__assets_tiled_tile_placeholder_png extends lime.graphics.Image {}
@:keep @:file("assets/tiled/traps.tsx") @:noCompletion #if display private #end class __ASSET__assets_tiled_traps_tsx extends haxe.io.Bytes {}
@:keep @:file("assets/tiled/working_map.tmx") @:noCompletion #if display private #end class __ASSET__assets_tiled_working_map_tmx extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/4,8,1/assets/sounds/beep.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_mp3 extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/4,8,1/assets/sounds/flixel.mp3") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_mp3 extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/4,8,1/assets/sounds/beep.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_beep_ogg extends haxe.io.Bytes {}
@:keep @:file("C:/HaxeToolkit/haxe/lib/flixel/4,8,1/assets/sounds/flixel.ogg") @:noCompletion #if display private #end class __ASSET__flixel_sounds_flixel_ogg extends haxe.io.Bytes {}
@:keep @:font("docs/html5/obj/webfont/nokiafc22.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font {}
@:keep @:font("docs/html5/obj/webfont/monsterrat.ttf") @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel/4,8,1/assets/images/ui/button.png") @:noCompletion #if display private #end class __ASSET__flixel_images_ui_button_png extends lime.graphics.Image {}
@:keep @:image("C:/HaxeToolkit/haxe/lib/flixel/4,8,1/assets/images/logo/default.png") @:noCompletion #if display private #end class __ASSET__flixel_images_logo_default_png extends lime.graphics.Image {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__assets_fonts_history_ttf') @:noCompletion #if display private #end class __ASSET__assets_fonts_history_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/fonts/history"; #else ascender = 750; descender = -250; height = 1000; numGlyphs = 69; underlinePosition = -100; underlineThickness = 50; unitsPerEM = 1000; #end name = "Historycal Inline"; super (); }}
@:keep @:expose('__ASSET__assets_fonts_roman_ttf') @:noCompletion #if display private #end class __ASSET__assets_fonts_roman_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/fonts/roman"; #else ascender = 667; descender = 333; height = 359; numGlyphs = 225; underlinePosition = -70; underlineThickness = 10; unitsPerEM = 1000; #end name = "Roman Antique"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_nokiafc22_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/nokiafc22"; #else ascender = 2048; descender = -512; height = 2816; numGlyphs = 172; underlinePosition = -640; underlineThickness = 256; unitsPerEM = 2048; #end name = "Nokia Cellphone FC Small"; super (); }}
@:keep @:expose('__ASSET__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__flixel_fonts_monsterrat_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "flixel/fonts/monsterrat"; #else ascender = 968; descender = -251; height = 1219; numGlyphs = 263; underlinePosition = -150; underlineThickness = 50; unitsPerEM = 1000; #end name = "Monsterrat"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__assets_fonts_history_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_fonts_history_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_fonts_history_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__assets_fonts_roman_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_fonts_roman_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_fonts_roman_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__assets_fonts_history_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_fonts_history_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_fonts_history_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__assets_fonts_roman_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_fonts_roman_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_fonts_roman_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_nokiafc22_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_nokiafc22_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_nokiafc22_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__flixel_fonts_monsterrat_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__flixel_fonts_monsterrat_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__flixel_fonts_monsterrat_ttf ()); super (); }}

#end

#end
#end

#end
