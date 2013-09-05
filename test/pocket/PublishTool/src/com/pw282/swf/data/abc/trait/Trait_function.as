package com.pw282.swf.data.abc.trait
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-6-13
	 */	
	public class Trait_function extends BaseData
	{
		public var slot_id:int;
		public var function_v:int;
		public function Trait_function(bt:ByteArray=null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			slot_id = EncodedU32.read(bt);
			function_v = EncodedU32.read(bt);
		}
		override public function write(bt:ByteArray):void{
			EncodedU32.write(bt, slot_id);
			EncodedU32.write(bt, function_v);
		}
		override public function toString():String{
			return "\t Trait_function:"
				+ "\n\t\t  slot_id:" + slot_id
				+ "\n\t\t  function_v:" + function_v
		}
	}
}