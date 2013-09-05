package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-7-1
	 */	
	public class Exception_info extends BaseData
	{
		public var from:int = 0;
		public var to:int = 0;
		public var target:int = 0;
		public var exc_type:int = 0;
		public var var_name:int = 0;
		
		public function Exception_info(bt:ByteArray=null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			from = EncodedU32.read(bt);
			to = EncodedU32.read(bt);
			target = EncodedU32.read(bt);
			exc_type = EncodedU32.read(bt);
			var_name = EncodedU32.read(bt);
		}
		override public function write(bt:ByteArray):void{
			EncodedU32.write(bt, from);
			EncodedU32.write(bt, to);
			EncodedU32.write(bt, target);
			EncodedU32.write(bt, exc_type);
			EncodedU32.write(bt, var_name);
		}
		override public function toString():String{
			return "from:" + from
				+ ",to:" + to
				+ ",target:" + target
				+ ",exc_type:" + exc_type
				+ ",var_name:" + var_name
		}
	}
}