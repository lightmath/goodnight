package com.pw282.swf.data
{
	import flash.utils.ByteArray;
	
	import com.pw282.swf.utils.Tools;
	
	public class ShapeWithStyle extends BaseData
	{
		public var FillStyles:FillStyleArray;
		public var LineStyles:LineStyleArray;
		public var NumFillBits:uint;
		public var NumLineBits:uint;
		public var ShapeRecords:Array;
		public function ShapeWithStyle(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			FillStyles = new FillStyleArray(bt);
			LineStyles = new LineStyleArray(bt);
			NumFillBits = Tools.readUBits(bt, bt.position * 8, 4);
			NumLineBits = Tools.readUBits(bt, bt.position * 8 + 4, 4);
		}
		override public function toString():String{
			return "FillStyles:" + FillStyles
				+ ",LineStyles:" + LineStyles
				+ ",NumFillBits:" + NumFillBits
				+ ",NumLineBits:" + NumLineBits
				+ ",ShapeRecords:" + ShapeRecords;
		}
	}
}