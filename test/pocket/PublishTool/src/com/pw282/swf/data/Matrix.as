package com.pw282.swf.data
{
	import flash.utils.ByteArray;
	
	import com.pw282.swf.utils.Tools;
	
	public class Matrix extends BaseData
	{
		public var HasScale:uint;
		public var NScaleBits:uint;
		public var ScaleX:Number;
		public var ScaleY:Number;
		public var HasRotate:uint;
		public var NRotateBits:uint;
		public var RotateSkew0:Number;
		public var RotateSkew1:Number;
		public var NTranslateBits:uint;
		public var TranslateX:int;
		public var TranslateY:int;
		public function Matrix(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			var start:int = bt.position * 8;
			HasScale = Tools.readUBits(bt, start, 1);
			if(HasScale == 1){
				NScaleBits = Tools.readUBits(bt, start + 1, 5);
				ScaleX = Tools.readFBits(bt, start + 6, NScaleBits);
				ScaleY = Tools.readFBits(bt, start + 6 + NScaleBits, NScaleBits);
				start = start + 6 + NScaleBits * 2;
			}
			HasRotate = Tools.readUBits(bt, start, 1);
			if(HasRotate == 1){
				NRotateBits = Tools.readUBits(bt, start + 1, 5);
				RotateSkew0 = Tools.readFBits(bt, start + 6, NRotateBits);
				RotateSkew1 = Tools.readFBits(bt, start + 6 + NRotateBits, NRotateBits);
				start = start + 6 + NRotateBits * 2;
			}
			NTranslateBits = Tools.readUBits(bt, start, 5);
			TranslateX = Tools.readSBits(bt, start + 5, NTranslateBits);
			TranslateY = Tools.readSBits(bt, start + 5 + NTranslateBits, NTranslateBits);
		}
		override public function toString():String{
			return "HasScale:" + HasScale + ",HasRotate:" + HasRotate + ",NTranslateBits:" + NTranslateBits;
		}
	}
}