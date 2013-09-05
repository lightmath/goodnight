package com.pw282.swf.instructions
{
	import com.pw282.swf.data.BaseInstruction;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-7-22
	 */	
	public class O_convert_s extends BaseInstruction
	{
		public function O_convert_s(bt:ByteArray=null)
		{
			super(bt);
			this.opcode = 0x70;
			this.opcodeName = "convert_s";
		}
	}
}