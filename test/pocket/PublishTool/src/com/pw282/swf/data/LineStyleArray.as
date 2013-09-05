package com.pw282.swf.data
{
	import flash.utils.ByteArray;
	
	public class LineStyleArray extends BaseData
	{
		public function LineStyleArray(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			
		}
		override public function toString():String{
			return "LineStyleArray ？";
		}
	}
}