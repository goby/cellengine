package com.cell.gameedit.output
{
	import com.cell.gameedit.OutputLoader;
	import com.cell.gameedit.object.ImagesSet;
	import com.cell.gameedit.object.MapSet;
	import com.cell.gameedit.object.SpriteSet;
	import com.cell.gameedit.object.WorldSet;
	import com.cell.gameedit.object.worldset.MapObject;
	import com.cell.gameedit.object.worldset.RegionObject;
	import com.cell.gameedit.object.worldset.SpriteObject;
	import com.cell.gameedit.object.worldset.WaypointObject;
	import com.cell.gfx.game.CCD;
	import com.cell.gfx.game.CImage;
	import com.cell.gfx.game.CMap;
	import com.cell.gfx.game.CSprite;
	import com.cell.gfx.game.IImages;
	import com.cell.io.TextDeserialize;
	import com.cell.io.TextReader;
	import com.cell.io.UrlManager;
	import com.cell.util.Arrays;
	import com.cell.util.Map;
	import com.cell.util.NumberReference;
	import com.cell.util.StringUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.getClassByAlias;
	import flash.utils.ByteArray;

	public class XmlEmbedOutputLoader extends XmlOutputLoader
	{
		protected var xml:XML;
		protected var class_name_map:Map;
		
		public function XmlEmbedOutputLoader(xml:XML, class_name_map:Map)
		{
			this.xml = xml;
			this.class_name_map = class_name_map;
		}
		
		public function toString() : String
		{
			return "[XmlEmbedOutputLoader:]";
		}
		
		override public function load(complete:Function) : void
		{
			super.load(complete);
			init(xml);
		}
		
		override public function createCImages(img:ImagesSet) : IImages
		{
			if (img != null) {
				var tiles : XmlCTiles = new XmlCTiles(this, img);
				var src : Bitmap = getImageClass(img);
				tiles.initAllImages(src.bitmapData);
				return tiles;
			}
			return null;
		}
		
		protected function getImageClass(img:ImagesSet) : Bitmap
		{
			var cls : Class = class_name_map.get(img.getName());
			return new cls() as Bitmap;
		}
	}
}