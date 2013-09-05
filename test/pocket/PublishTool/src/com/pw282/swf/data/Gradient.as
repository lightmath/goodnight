package com.pw282.swf.data
{

	
	import flash.utils.ByteArray;
	
	public class Gradient extends BaseData
	{
		public var SpreadMode:uint;
		public var InterpolationMode:uint;
		public var NumGradients:uint;
//		public var GradientRecords:GradientRecords;
		public function Gradient(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
		}
		override public function toString():String{
			return "SpreadMode:" + SpreadMode
				+ "，InterpolationMode:" + InterpolationMode
				+ "，NumGradients:" + NumGradients
//				+ "，GradientRecords:" + GradientRecords;
		}
	}
}