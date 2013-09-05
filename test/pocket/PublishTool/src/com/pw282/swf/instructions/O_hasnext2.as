package com.pw282.swf.instructions
{
	import com.pw282.swf.data.BaseInstruction;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-7-22
	 */	
	public class O_hasnext2 extends BaseInstruction
	{
		public var object_reg:int = 0;
		public var index_reg:int = 0;
		public function O_hasnext2(bt:ByteArray=null)
		{
			super(bt);
			this.opcode = 0x32;
			this.opcodeName = "hasnext2";
		}
		override public function read(bt:ByteArray):void{
			this.object_reg = bt.readUnsignedInt();
			this.index_reg = bt.readUnsignedInt();
		}
		override public function write(bt:ByteArray):void{
			super.write(bt);
			bt.writeUnsignedInt(object_reg);
			bt.writeUnsignedInt(index_reg);
		}
	}
}