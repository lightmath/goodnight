package com.pw282.swf.data
{
	import flash.utils.ByteArray;
	
	public class RGBA extends BaseData
	{
		public var Red:int;
		public var Green:int;
		public var Blue:int;
		public var Alpha:int;
		public function RGBA(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			Red = bt.readUnsignedByte();
			Green = bt.readUnsignedByte();
			Blue = bt.readUnsignedByte();
			Alpha = bt.readUnsignedByte();
		}
		override public function toString():String{
			return "Red:" + Red + ",Green:" + Green + ",Blue:" + Blue + ",Alpha:" + Alpha;
		}
	}
}