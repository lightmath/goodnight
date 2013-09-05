package com.pw282.swf.tags.binary
{
	import com.pw282.swf.tags.Tag;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class DefineBinaryDataTag extends Tag
	{
		public var tag:uint;
		public var Reserved:uint;
		public var Data:ByteArray;
		public function DefineBinaryDataTag()
		{
			super();
		}
		override public function parse():void{
			super.parse();
			
			if(!allowChildParse){
				return;
			}
			tag = bt.readUnsignedShort();
			Reserved = bt.readUnsignedInt();
			Data = new ByteArray();
			bt.readBytes(Data);
		}
		override public function toString():String{
			return super.toString() + "\n tag:" + tag
				+ "\n Reserved:" + Reserved
				+ "\n Data.length:" + Data.length
		}
		override public function encode():void{
			if(allowChildEncode){
				bt = new ByteArray();
				bt.endian = Endian.LITTLE_ENDIAN;
				bt.writeShort(tag);
				bt.writeUnsignedInt(Reserved);
				bt.writeBytes(Data);
			}
			
			super.encode();
		}
	}
}