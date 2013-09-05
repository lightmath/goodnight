package com.pw282.swf.data
{
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-7-5
	 */	
	public class ARGB extends BaseData
	{
		public var Alpha:int;
		public var Red:int;
		public var Green:int;
		public var Blue:int;
		public function ARGB(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			Alpha = bt.readUnsignedByte();
			Red = bt.readUnsignedByte();
			Green = bt.readUnsignedByte();
			Blue = bt.readUnsignedByte();
		}
		override public function toString():String{
			return "Alpha:" + Alpha + ",Red:" + Red + ",Green:" + Green + ",Blue:" + Blue;
		}
	}
}