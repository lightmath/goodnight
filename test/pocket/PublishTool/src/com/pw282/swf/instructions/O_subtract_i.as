package com.pw282.swf.instructions
{
	import com.pw282.swf.data.BaseInstruction;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-7-22
	 */	
	public class O_subtract_i extends BaseInstruction
	{
		public function O_subtract_i(bt:ByteArray=null)
		{
			super(bt);
			this.opcode = 0xc6;
			this.opcodeName = "subtract_i";
		}
	}
}