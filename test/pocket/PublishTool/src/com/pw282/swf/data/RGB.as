package com.pw282.swf.data
{
	import flash.utils.ByteArray;

	public class RGB extends BaseData
	{
		public var red:int;
		public var green:int;
		public var blue:int;
		public function RGB(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			red = bt.readUnsignedByte();
			green = bt.readUnsignedByte();
			blue = bt.readUnsignedByte();
		}
		override public function write(bt:ByteArray):void{
			bt.writeByte(red);
			bt.writeByte(green);
			bt.writeByte(blue);
		}
		override public function toString():String{
			return "red:" + red + ",green:" + green + ",blue:" + blue;
		}
	}
}