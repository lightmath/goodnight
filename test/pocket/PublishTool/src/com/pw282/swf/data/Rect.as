package com.pw282.swf.data
{
	import flash.utils.ByteArray;
	
	import com.pw282.swf.utils.Tools;

	public class Rect extends BaseData
	{
		public var length:uint;
		public var xMinTwips:int;
		public var xMaxTwips:int;
		public var yMinTwips:int;
		public var yMaxTwips:int;
		public function Rect(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			var start:int = bt.position * 8;
			length = Tools.readUBits(bt, start, 5);
			
			xMinTwips = Tools.readSBits(bt, start + 5, length);
			xMaxTwips = Tools.readSBits(bt, start + 5 + length, length);
			yMinTwips = Tools.readSBits(bt, start + 5 + length * 2, length);
			yMaxTwips = Tools.readSBits(bt, start + 5 + length * 3, length);
		}
		override public function write(bt:ByteArray):void{
			var start:int = bt.position * 8;
			Tools.wirteBits(bt, start, 5, length);
			
			Tools.wirteBits(bt, start + 5, length, xMinTwips);
			Tools.wirteBits(bt, start + 5 + length, length, xMaxTwips);
			Tools.wirteBits(bt, start + 5 + length * 2, length, yMinTwips);
			Tools.wirteBits(bt, start + 5 + length * 3, length, yMaxTwips);
		}
		override public function toString():String{
			return "xTwipMin:" + xMinTwips + "，xTwipMax:" + xMaxTwips + "，yTwipMin:" + yMinTwips + "，yTwipMax:" + yMaxTwips;
		}
		public function toPixelsString():String{
			return "xPixelMin:" + xMinTwips / 20 + "，xPixelMax:" + xMaxTwips / 20 + "，yPixelMin:" + yMinTwips / 20 + "，yPixelMax:" + yMaxTwips / 20;
		}
	}
}