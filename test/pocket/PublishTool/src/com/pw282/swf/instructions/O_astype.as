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
	public class O_astype extends BaseInstruction
	{
		public var index:int;
		public function O_astype(bt:ByteArray=null)
		{
			super(bt);
			this.opcode = 0x86;
			this.opcodeName = "astype";
		}
		override public function read(bt:ByteArray):void{
			super.read(bt);
			this.index = EncodedU32.read(bt);
		}
	}
}