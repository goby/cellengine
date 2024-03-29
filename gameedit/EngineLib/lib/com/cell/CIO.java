/**
 * 版权所有[2006][张翼飞]
 *
 * 根据2.0版本Apache许可证("许可证")授权；
 * 根据本许可证，用户可以不使用此文件。
 * 用户可从下列网址获得许可证副本：
 * http://www.apache.org/licenses/LICENSE-2.0
 * 除非因适用法律需要或书面同意，
 * 根据许可证分发的软件是基于"按原样"基础提供，
 * 无任何明示的或暗示的保证或条件。
 * 详见根据许可证许可下，特定语言的管辖权限和限制。
 */

package com.cell;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.microedition.lcdui.Image;
import javax.microedition.rms.RecordStore;

/**
 * util file function.</br> 
 * 常用文件和RMS管理方法
 * @author WAZA
 * @since 2006-11-28 
 * @version 1.0
 */
public class CIO extends CObject{

	//  ----------------------------------------------------------------------------------------------------------
	//  文件处理 部分

	private static byte resNum; 	 //资源文件数
	private static byte[][] resData; //资源文件数据
	private static String[] resName; //资源文件名
	private static String ImgPakName;//
	
	
	/**
	 * load a file form res to byte[]
	 * @param fileName
	 * @return 
	 */
	public static byte[] loadFile(String fileName) {
		int len = 0;
		InputStream is = null;
		try {
			is = fileName.getClass().getResourceAsStream(fileName);
			len = (int)is.skip(Integer.MAX_VALUE);
			is.close();
		} catch (IOException e) {
		}
		byte[] data = new byte[len];
		try {
			is = fileName.getClass().getResourceAsStream(fileName);
			is.read(data);
			is.close();
		} catch (IOException e) {
		}
		if (data == null) {
		    println("Can not Load File '" + fileName + "' -_-!");
		} else {
		    println("Loaded File '" + fileName + "' " + data.length + " bytes ^_^!");
		}
		
		return data;
		
	}

	//  载入资源包,存放至byte[][]resData，文件名存至String[] resName
	/**
	 * open a pack file
	 * @param pakFile 
	 */
	public static void openPakFile(String pakFile) {
		int[] resOffset = null;
		int[] resSize = null;
		CIO.println("Load PakFile '" + pakFile + "' 0_0?");
		try {
			InputStream is = pakFile.getClass().getResourceAsStream(pakFile);
			DataInputStream dis = new DataInputStream(is);
			//            System.out.println("The Pak "+dis.available());
			resNum = dis.readByte();
			resName = new String[resNum];
			resData = new byte[resNum][];
			resOffset = new int[resNum];
			resSize = new int[resNum];
			int namelen = 0;
			byte[] tmp = null;
			for (int i = 0; i < resNum; i++) {
				namelen = dis.readByte();
				tmp = new byte[namelen];
				dis.read(tmp);
				resName[i] = new String(tmp);
				resOffset[i] = dis.readShort();
				resSize[i] = dis.readShort();
			}
			dis.close();
		} catch (Exception ex) {
		}
		InputStream tis = pakFile.getClass().getResourceAsStream(pakFile);
		try {
			tis.skip(resOffset[0]);
			for (int k = 0; k < resNum; k++) {
				resData[k] = new byte[resSize[k]];
				tis.read(resData[k], 0, resSize[k]);
			}
			tis.close();
		} catch (Exception ex) {
		}
	}

	/**
	 * load a file form opened pack
	 * @param file
	 * @return 
	 */
	public static byte[] loadPakFile(String file) {
		int k = 0;
		for (; k < resNum; k++) {
			if (resName[k].equals(file)) {
				break;
			}
		}
		if (k < resNum)
			return resData[k];
		else
			return null;
	}

	/**
	 * close current pack 
	 */
	public static void closePakFile() {
		CIO.println("Close PakFile '" + ImgPakName + "' !");
		resNum = 0; //资源文件数
		resData = null; //资源文件数据
		resName = null; //资源文件名
		ImgPakName = null;
	}


	/**
	 * load a file that is a image stream form pack
	 * @param pakName
	 * @param imageName
	 * @return 
	 */
	final static public Image loadImage(String pakName, String imageName) {
		byte data[];
		if (ImgPakName == null
				|| (ImgPakName != null && !ImgPakName.equals(pakName))) {
			closePakFile();
			ImgPakName = pakName;
			openPakFile(ImgPakName);
			data = loadPakFile(imageName);
		} else {
			data = loadPakFile(imageName);
		}
		if (data != null) {
			CIO.println("Load Image '" + imageName + "' at '" + pakName
					+ "' ^_^!");
		} else {
			CIO.println("Can not Load Image '" + imageName + "' at '"
					+ pakName + "' -_-!");
		}
		Image ret = Image.createImage(data, 0, data.length);
		if (ret == null) {
			CIO.println("Can not Create Image '" + imageName + "' at '"
					+ pakName + "' -_-!");
		}
		return ret;
	}

	/**
	 * load all files that some images form pack file
	 * @param pakName
	 * @return 
	 */
	final static public Image[] loadImages(String pakName) {
		byte[][] data = unpackFiles(pakName);
		Image[] ret = new Image[data.length];
		for(int i=0;i<data.length;i++){
			ret[i] = Image.createImage(data[i], 0, data[i].length);
		}
		return ret;
	}
	
	/**
	 * 实时处理包，从中解出需要的文件</br>
	 * load a file form pack file
	 * @param File
	 * @param SubFile
	 * @return byte[]
	 */
	final static public byte[] unpackFile(String File, String SubFile) {
		byte[] data = null;
		byte fileNum = 0;
		String[] fileName = null;
		int[] fileOff = null;
		int[] fileSize = null;

		try {
			InputStream is = File.getClass().getResourceAsStream(File);
			DataInputStream dis = new DataInputStream(is);
			fileNum = dis.readByte();
			fileName = new String[fileNum];
			fileOff = new int[fileNum];
			fileSize = new int[fileNum];
			int namelen = 0;
			byte[] tmp = null;
			for (int i = 0; i < fileNum; i++) {
				namelen = (int) (dis.readByte() & 0x0000ffff);
				tmp = new byte[namelen];
				dis.read(tmp);
				fileName[i] = new String(tmp);
				fileOff[i] = (int) (dis.readShort() & 0x0000ffff);
				fileSize[i] = (int) (dis.readShort() & 0x0000ffff);
			}
			dis.close();
		} catch (Exception ex) {
			CIO.println("Error Load '" + SubFile + "' at '" + File
					+ "' -_-!");
			ex.printStackTrace();
		}

		for (int k = 0; k < fileNum; k++) {
			if (fileName[k].equals(SubFile)) {
				try {
					InputStream tis = File.getClass().getResourceAsStream(File);
					data = new byte[fileSize[k]];
					tis.skip(fileOff[k]);
					tis.read(data, 0, fileSize[k]);
					tis.close();
				} catch (Exception ex) {
					CIO.println("Error Load '" + SubFile + "' at '" + File
							+ "' -_-!");
					ex.printStackTrace();
				}
				break;
			}
		}
		if (data == null) {
			CIO.println("Can not Load File '" + SubFile + "' at '" + File
					+ "' -_-!");
		} else {
			CIO.println("Loaded File '" + SubFile + "' " + data.length
					+ " bytes ^_^!");
		}
		return data;
	}
	
	/**
	 * load all files form pack file
	 * @param File
	 * @return 
	 */
	final static public byte[][] unpackFiles(String File) {
		byte[][] data ;
		byte fileNum = 0;
		String[] fileName = null;
		int[] fileOff = null;
		int[] fileSize = null;

		try {
			InputStream is = File.getClass().getResourceAsStream(File);
			DataInputStream dis = new DataInputStream(is);
			fileNum = dis.readByte();
			fileName = new String[fileNum];
			fileOff = new int[fileNum];
			fileSize = new int[fileNum];
			int namelen = 0;
			byte[] tmp = null;
			for (int i = 0; i < fileNum; i++) {
				namelen = (int) (dis.readByte() & 0x0000ffff);
				tmp = new byte[namelen];
				dis.read(tmp);
				fileName[i] = new String(tmp);
				fileOff[i] = (int) (dis.readShort() & 0x0000ffff);
				fileSize[i] = (int) (dis.readShort() & 0x0000ffff);
			}
			dis.close();
		} catch (Exception ex) {
			CIO.println("Error Load '" + "' at '" + File
					+ "' -_-!");
			ex.printStackTrace();
		}
		data=new byte[fileNum][];
		
		for (int k = 0; k < fileNum; k++) {
			try {
				InputStream tis = File.getClass().getResourceAsStream(File);
				data[k] = new byte[fileSize[k]];
				tis.skip(fileOff[k]);
				tis.read(data[k], 0, fileSize[k]);
				tis.close();
			} catch (Exception ex) {
				CIO.println("Error Load '" + "' at '" + File
						+ "' -_-!");
				ex.printStackTrace();
			}
		}
		closePakFile();
		return data;
	}

	/**
	 * get the pack file's sub file list
	 * @param File
	 * @return 
	 */
	final static public String[] getPakFileNameList(String File) {

		byte fileNum = 0;
		String[] fileName = null;
		int[] fileOff = null;
		int[] fileSize = null;

		try {
			InputStream is = File.getClass().getResourceAsStream(File);
			DataInputStream dis = new DataInputStream(is);
			fileNum = dis.readByte();
			fileName = new String[fileNum];
			fileOff = new int[fileNum];
			fileSize = new int[fileNum];
			int namelen = 0;
			byte[] tmp = null;
			for (int i = 0; i < fileNum; i++) {
				namelen = (int) (dis.readByte() & 0x0000ffff);
				tmp = new byte[namelen];
				dis.read(tmp);
				fileName[i] = new String(tmp);
				fileOff[i] = (int) (dis.readShort() & 0x0000ffff);
				fileSize[i] = (int) (dis.readShort() & 0x0000ffff);
			}
			dis.close();
		} catch (Exception ex) {
			CIO.println("Error Load  '" + File + "' -_-!");
			ex.printStackTrace();
		}
		if (fileName == null) {
			println("Can not get FileList at '" + File + "' -_-!");
		} else {
			println("FileList :");
			for (int i = 0; i < fileName.length; i++) {
				CIO.println(" FileName:" + fileName[i] + " Offset:"
						+ fileOff[i] + " Size:" + fileSize[i] + " ^_^");
			}
		}

		return fileName;

	}


	/**
	 * get byte[] form RMS storage specify name
	 * @param name
	 * @return byte[]
	 */
	final static public byte[] getRMSSave(String name) {
		RecordStore rs;
		byte[] SaveData = null;
		try {
			rs = RecordStore.openRecordStore(name, true);
			try {
				SaveData = rs.getRecord(1);
			} catch (Exception Err) {
			}
			rs.closeRecordStore();
		} catch (Exception Err) {
			CIO.println("Exception: " + Err.getMessage());
		}
		return SaveData;
	}

	/**
	 * save byte[] to RMS storage specify name
	 * @param name
	 * @param SaveData
	 */
	final static public void putRMSSave(byte[] SaveData,String name) {
		RecordStore rs;
		try {
			RecordStore.deleteRecordStore(name);
			rs = RecordStore.openRecordStore(name, true);
			rs.addRecord(SaveData, 0, SaveData.length);
			rs.closeRecordStore();
		} catch (Exception Err) {
			//System.out.println("Exception: " + Err.getMessage());
		}
	}

	/**
	 * @param Bytes
	 * @param Start
	 * @return short
	 */
	final static public short readShort(byte[] Bytes, int Start) {
		short l, h;
		l = (short) ((Bytes[Start + 0] << 0) & 0x00ff);
		h = (short) ((Bytes[Start + 1] << 8) & 0xff00);
		return (short) (h | l);
	}

	/**
	 * @param Bytes
	 * @param Start
	 * @param Val
	 */
	final static public void writeShort(byte[] Bytes, int Start, short Val) {
		byte h = (byte) (0x00ff & (Val >> 8));
		byte l = (byte) (0x00ff & (Val >> 0));
		Bytes[Start + 0] = l;
		Bytes[Start + 1] = h;
	}


	/**
	 * @param TheByte
	 * @return int
	 */
	final static public int toUnSignByte(int TheByte) {
		int NumBuffer = TheByte;
		if (NumBuffer < 0) {
			NumBuffer += 256;
		}
		return NumBuffer;
	}

	/**
	 * load a image directly specify filename
	 * @param FilePath
	 * @return 
	 */
	final static public Image loadImage(String FilePath) {
		
		Image Imagetemp = null;
		try {
			Imagetemp = Image.createImage(FilePath);
		} catch (java.io.IOException Err) {
			Imagetemp = null;
		}
		if (Imagetemp == null) {
			CIO.println("Can not Load Image : " + FilePath + " -_-!");
		}else{
			CIO.println("Load Image '" + FilePath + "' ^_^!");
		}
		return Imagetemp;

	}

	/**
	 * 功能描述
	 * @param Bytes
	 * @param Start
	 * @return 
	 */
	final static public short ReadShort(byte[] Bytes, int Start) {
		short b1, b2;
		b1 = Bytes[Start];
		b2 = Bytes[Start + 1];
		if (b1 < 0) {
			b1 += 256;
		}
		if (b2 < 0) {
			b2 += 256;
		}
		return (short) (b1 | (b2 << 8));
	}


	static public void putShort(byte[] data,int pos,short value){
		data[pos+0] = (byte)((value>>> 0)&0xff);
		data[pos+1] = (byte)((value>>> 8)&0xff);
	}
	
	static public short getShort(byte[] data,int pos){
		short ret = 0;
		ret |= ((((short)0xff)&data[pos+0])<< 0);
		ret |= ((((short)0xff)&data[pos+1])<< 8);
		return ret;
	}
	
	static public void putInt(byte[] data,int pos,int value){
		data[pos+0] = (byte)((value>>> 0)&0xff);
		data[pos+1] = (byte)((value>>> 8)&0xff);
		data[pos+2] = (byte)((value>>>16)&0xff);
		data[pos+3] = (byte)((value>>>24)&0xff);
		
	}
	
	static public int getInt(byte[] data,int pos){
		int ret = 0;
		ret |= ((((int)0xff)&data[pos+0])<< 0);
		ret |= ((((int)0xff)&data[pos+1])<< 8);
		ret |= ((((int)0xff)&data[pos+2])<<16);
		ret |= ((((int)0xff)&data[pos+3])<<24);
		return ret;
	}
	
	static public void putLong(byte[] data,int pos,long value){
		data[pos+0] = (byte)((value>>> 0)&0xff);
		data[pos+1] = (byte)((value>>> 8)&0xff);
		data[pos+2] = (byte)((value>>>16)&0xff);
		data[pos+3] = (byte)((value>>>24)&0xff);
		data[pos+4] = (byte)((value>>>32)&0xff);
		data[pos+5] = (byte)((value>>>40)&0xff);
		data[pos+6] = (byte)((value>>>48)&0xff);
		data[pos+7] = (byte)((value>>>56)&0xff);
	}
	
	static public long getLong(byte[] data,int pos){
		long ret = 0;
		ret |= ((((long)0xff)&data[pos+0])<< 0);
		ret |= ((((long)0xff)&data[pos+1])<< 8);
		ret |= ((((long)0xff)&data[pos+2])<<16);
		ret |= ((((long)0xff)&data[pos+3])<<24);
		ret |= ((((long)0xff)&data[pos+4])<<32);
		ret |= ((((long)0xff)&data[pos+5])<<40);
		ret |= ((((long)0xff)&data[pos+6])<<48);
		ret |= ((((long)0xff)&data[pos+7])<<56);
		return ret;
	}
	
}