package com.pw282.swf.data
{
	import flash.utils.ByteArray;
	
	public class FocalGradient extends BaseData
	{
		public function FocalGradient(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
		}
		override public function toString():String{
			return "FocalGradient";
		}
	}
}