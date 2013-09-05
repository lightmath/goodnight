package com.pw282.swf.instructions
{
	import com.pw282.swf.data.BaseInstruction;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-7-22
	 */	
	public class O_convert_o extends BaseInstruction
	{
		public function O_convert_o(bt:ByteArray=null)
		{
			super(bt);
			this.opcode = 0x77;
			this.opcodeName = "convert_o";
		}
	}
}