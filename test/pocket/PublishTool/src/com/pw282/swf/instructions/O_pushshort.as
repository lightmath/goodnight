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
	public class O_pushshort extends BaseInstruction
	{
		public var value:int = 0;
		public function O_pushshort(bt:ByteArray=null)
		{
			super(bt);
			this.opcode = 0x25;
			this.opcodeName = "pushshort";
		}
		override public function read(bt:ByteArray):void{
			this.value = EncodedU32.read(bt);
		}
		override public function write(bt:ByteArray):void{
			super.write(bt);
			EncodedU32.write(bt, this.value);
		}
	}
}