package com.pw282.swf.tags.bitmaps
{
	import com.pw282.swf.tags.Tag;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class DefineBitsJPEG2Tag extends Tag
	{
		public var CharacterID:int = 0;
		public var ImageData:ByteArray;
		public function DefineBitsJPEG2Tag()
		{
			super();
		}
		override public function parse():void{
			super.parse();
			if(!allowChildParse){
				return;
			}
			CharacterID = bt.readShort();
			
			ImageData = new ByteArray();
			ImageData.endian = Endian.LITTLE_ENDIAN;
			bt.readBytes(ImageData);
			
		}
		override public function encode():void{
			if(allowChildEncode){
				bt = new ByteArray();
				bt.endian = Endian.LITTLE_ENDIAN;
				bt.writeShort(CharacterID);
				
				bt.writeBytes(ImageData);
			}
			super.encode();
		}
		override public function toString():String{
			return super.toString() + "CharacterID:" + CharacterID
				+ ",ImageData:" + ImageData.length
		}
	}
}