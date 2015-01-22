package z_spark.necessaryrescoper
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.TextField;
	import flash.utils.ByteArray;

	public class Utils
	{
		/////////////////////////File//////////////////////////////
		public static function read(filename:String):String{
			var f:File=new File(filename);
			var fs:FileStream=new FileStream();
			fs.open(f,FileMode.READ);
			var s:String=fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			return s;
		}
		
		public static function exists(filename:String):Boolean{
			var f:File=new File(filename);
			return f.exists;
		}
		
		public static function readByteArray(filename:String):ByteArray{
			var f:File=new File(filename);
			var fs:FileStream=new FileStream();
			fs.open(f,FileMode.READ);
			var br:ByteArray=new ByteArray();
			fs.readBytes(br);
			fs.close();
			return br;
		}
		
		public static function writeByteArray(filename:String,bytes:ByteArray):void{
			var f:File=new File(filename);
			var fs:FileStream=new FileStream();
			fs.open(f,FileMode.WRITE);
			fs.writeBytes(bytes);
			fs.close();
		}
		
		public static function getDirectoryListing(directoryName:String):Array{
			var f:File=new File(directoryName);
			return f.getDirectoryListing();
		}
		
		public static function createDirectory(directoryName:String):void{
			var f:File=new File(directoryName);
			f.createDirectory()
			
		}
		
		
		/////////////////////////html//////////////////////////////////
		public static function color(txt:String,color:String):String{
			return "<font color=\""+color+"\">"+txt+"</font>";
		}
		
		public static function size(txt:String,fontSize:uint):String{
			return "<font size=\""+size+"\">"+txt+"</font>";
		}
		
		
		///////////////////////////////others////////////////////////////////////
		public static function isExtensionRight(fileName:String,ext:String):Boolean{
			return fileName.substr(fileName.indexOf('.')+1)===ext;
		}
		
		
		
		
	}
}