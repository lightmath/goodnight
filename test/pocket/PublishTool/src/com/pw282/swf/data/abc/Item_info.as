package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	import com.pw282.swf.utils.Tools;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-6-13
	 */	
	public class Item_info extends BaseData
	{
		public var key:int;
		public var value:int;
		public function Item_info(bt:ByteArray=null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			key = EncodedU32.read(bt);
			value = EncodedU32.read(bt);
		}
		override public function write(bt:ByteArray):void{
			EncodedU32.write(bt, key);
			EncodedU32.write(bt, value);
		}
		override public function toString():String{
//			return "key:" + key
//				+ ",value:" + value
			return "[" + Tools.abcFile.cpool_info.arrString[key == 0 ? 0 : key - 1] + ":" + Tools.abcFile.cpool_info.arrString[value - 1] + "]"
		}
	}
}