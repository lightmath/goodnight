package com.pw282.swf.instructions
{
	import com.pw282.swf.data.BaseInstruction;
	import com.pw282.swf.data.EncodedU32;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-7-22
	 */	
	public class O_getdescendants extends BaseInstruction
	{
		public var index:int = 0;
		public function O_getdescendants(bt:ByteArray=null)
		{
			super(bt);
			this.opcode = 0x59;
			this.opcodeName = "getdescendants";
		}
		override public function read(bt:ByteArray):void{
			this.index = EncodedU32.read(bt);
		}
		override public function write(bt:ByteArray):void{
			super.write(bt);
			EncodedU32.write(bt, this.index);
		}
	}
}