package com.pw282.swf.data
{
	import flash.utils.ByteArray;
	import com.pw282.swf.utils.TagTypes;

	public class FillStyle extends BaseData
	{
		public var ShapeType:uint = TagTypes.TAG_DEFINESHAPE4;
		
		public var FillStyleType:uint;
		public var Color:*;
		public var GradientMatrix:Matrix;
		public var $Gradient:*;
		public var BitmapId:int;
		public var BitmapMatrix:Matrix;
		public function FillStyle(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			FillStyleType = bt.readUnsignedByte();
			if(FillStyleType == 0){
				if(ShapeType == TagTypes.TAG_DEFINESHAPE){
					Color = new RGBA(bt);
				}
				if(ShapeType == TagTypes.TAG_DEFINESHAPE2 || ShapeType == TagTypes.TAG_DEFINESHAPE3){
					Color = new RGB(bt);
				}
			}
			if(FillStyleType == 0x10 || FillStyleType == 0x12 || FillStyleType == 0x13){
				GradientMatrix = new Matrix(bt);
			}
			if(FillStyleType == 0x10 || FillStyleType == 0x12){
				$Gradient = new Gradient(bt);
			}
			if(FillStyleType == 0x13){
				$Gradient = new FocalGradient(bt);
			}
		}
		override public function toString():String{
			return "FillStyleType:" + FillStyleType
				+ ",Color:" + Color
				+ ",GradientMatrix:" + GradientMatrix
				+ ",Gradient:" + $Gradient
				+ ",BitmapId:" + BitmapId
				+ ",BitmapMatrix:" + BitmapMatrix;
		}
	}
}