package com.pw282.swf.instructions
{
	import com.pw282.swf.data.BaseInstruction;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-7-22
	 */	
	public class O_urshift extends BaseInstruction
	{
		public function O_urshift(bt:ByteArray=null)
		{
			super(bt);
			this.opcode = 0xa7;
			this.opcodeName = "urshift";
		}
	}
}