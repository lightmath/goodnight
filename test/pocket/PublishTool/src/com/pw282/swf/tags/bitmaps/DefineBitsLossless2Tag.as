package com.pw282.swf.tags.bitmaps
{

	import com.pw282.swf.tags.Tag;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class DefineBitsLossless2Tag extends Tag
	{
		public var CharacterID:int = 0;
		public var BitmapFormat:int = 0;
		public var BitmapWidth:int = 0;
		public var BitmapHeight:int = 0;
		public var BitmapColorTableSize:int = 0;
		public var ColorTableRGB:Array = [];//BitmapFormat == 3
		public var ColormapPixelData:Array = [];//BitmapFormat == 3
		public var BitmapPixelData:Array = [];//BitmapFormat == 4 or 5
		
		public var bitmapData:BitmapData;
		public function DefineBitsLossless2Tag()
		{
			super();
		}
		override public function parse():void{
			super.parse();
			if(!allowChildParse){
				return;
			}
			CharacterID = bt.readShort();
			BitmapFormat = bt.readByte();
			BitmapWidth = bt.readShort();
			BitmapHeight = bt.readShort();
			if(BitmapFormat == 3){
				BitmapColorTableSize = bt.readByte();
			}
			
			var tempPosition:int = bt.position;
			var tempBt:ByteArray = new ByteArray();
			tempBt.endian = Endian.BIG_ENDIAN;
			bt.readBytes(tempBt);
			bt.position = tempPosition;
			tempBt.uncompress();
			
			if(BitmapFormat == 3){
				
			}else if(BitmapFormat == 4 || BitmapFormat == 5){
				
				bitmapData = new BitmapData(BitmapWidth, BitmapHeight);
				var rect:Rectangle = new Rectangle(0, 0, BitmapWidth, BitmapHeight);
				bitmapData.setPixels(rect, tempBt);
				
			}
			tempBt.length = 0;
		}
		override public function encode():void{
			if(allowChildEncode){
				var btRemain:ByteArray = new ByteArray();
				btRemain.endian = Endian.LITTLE_ENDIAN;
				bt.readBytes(btRemain);
				
				bt = new ByteArray();
				bt.endian = Endian.LITTLE_ENDIAN;
				bt.writeShort(CharacterID);
				bt.writeByte(BitmapFormat);
				bt.writeShort(BitmapWidth);
				bt.writeShort(BitmapHeight);
				if(BitmapFormat == 3){
					bt.writeByte(BitmapColorTableSize);
				}
				
				bt.writeBytes(btRemain);
			}
			super.encode();
		}
		override public function toString():String{
			return super.toString() + "CharacterID:" + CharacterID
				+ ",BitmapFormat:" + BitmapFormat
				+ ",BitmapWidth:" + BitmapWidth
				+ ",BitmapHeight:" + BitmapHeight
				+ ",BitmapColorTableSize:" + BitmapColorTableSize
		}
	}
}