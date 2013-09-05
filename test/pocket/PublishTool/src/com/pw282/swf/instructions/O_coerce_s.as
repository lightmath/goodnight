package com.pw282.swf.instructions
{
	import com.pw282.swf.data.BaseInstruction;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-7-22
	 */	
	public class O_coerce_s extends BaseInstruction
	{
		public function O_coerce_s(bt:ByteArray=null)
		{
			super(bt);
			this.opcode = 0x85;
			this.opcodeName = "coerce_s";
		}
	}
}