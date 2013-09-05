package com.pw282.swf.tags.bitmaps
{
	import com.pw282.swf.tags.Tag;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class DefineBitsJPEG3Tag extends Tag
	{
		public var CharacterID:int = 0;
		public var AlphaDataOffset:int = 0;
		public var ImageData:ByteArray;
		public var BitmapAlphaData:ByteArray;
		public function DefineBitsJPEG3Tag()
		{
			super();
		}
		override public function parse():void{
			super.parse();
			if(!allowChildParse){
				return;
			}
			CharacterID = bt.readShort();
			AlphaDataOffset = bt.readInt();
			
			ImageData = new ByteArray();
			ImageData.endian = Endian.LITTLE_ENDIAN;
			bt.readBytes(ImageData, 0, AlphaDataOffset - bt.position);
			
			BitmapAlphaData = new ByteArray();
			BitmapAlphaData.endian = Endian.LITTLE_ENDIAN;
			bt.readBytes(BitmapAlphaData);
		}
		override public function encode():void{
			if(allowChildEncode){
				bt = new ByteArray();
				bt.endian = Endian.LITTLE_ENDIAN;
				bt.writeShort(CharacterID);
				bt.writeInt(AlphaDataOffset);
				
				bt.writeBytes(ImageData);
				bt.writeBytes(BitmapAlphaData);
			}
			super.encode();
		}
		override public function toString():String{
			return super.toString() + "CharacterID:" + CharacterID
				+ ",AlphaDataOffset:" + AlphaDataOffset
				+ ",ImageData:" + ImageData.length
				+ ",BitmapAlphaData:" + BitmapAlphaData.length
		}
	}
}