package com.pw282.swf.data
{

	
	import flash.utils.ByteArray;
	import com.pw282.swf.utils.TagTypes;
	
	public class GradRecoed extends BaseData
	{
		public var ShapeType:uint = TagTypes.TAG_DEFINESHAPE4;
		
		public var Ratio:uint;
		public var Color:*;
		public function GradRecoed(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			Ratio = bt.readUnsignedByte();
			if(ShapeType == TagTypes.TAG_DEFINESHAPE || ShapeType == TagTypes.TAG_DEFINESHAPE2){
				Color = new RGB(bt);
			}
			if(ShapeType == TagTypes.TAG_DEFINESHAPE3){
				Color = new RGBA(bt);
			}
		}
		override public function toString():String{
			return "Ratio:" + Ratio + "，Color:" + Color;
		}
	}
}