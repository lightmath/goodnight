package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	
	import flash.utils.ByteArray;
	
	public class Option_info extends BaseData
	{
		public var option_count:int;
		public var arrOption:Array;
		public function Option_info(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			option_count = EncodedU32.read(bt);
			var i:int = 0;
			arrOption = [];
			for(i = 0; i < option_count; i++){
				arrOption.push(new Option_detail(bt));
			}
		}
		override public function write(bt:ByteArray):void{
			EncodedU32.write(bt, option_count);
			var i:int = 0;
			for(i = 0; i < option_count; i++){
				(arrOption[i] as BaseData).write(bt);
			}
		}
		override public function toString():String{
//			return "option_count:" + option_count + ",arrOption:" + arrOption;
			return toFullString();
		}
		public function toFullString():String{
			var strOptions:String = "";
			var i:int = 0;
			for(i = 0; i < option_count; i++){
				strOptions += (arrOption[i] as Option_detail).toFullString();
			}
			return strOptions
		}
	}
}