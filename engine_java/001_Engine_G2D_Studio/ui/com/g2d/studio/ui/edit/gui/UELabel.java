package com.g2d.studio.ui.edit.gui;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.g2d.display.ui.Label;
import com.g2d.studio.ui.edit.UIEdit;

public class UELabel extends Label implements SavedComponent
{
	public UELabel() {
	}
	
	@Override
	public void onRead(UIEdit edit, Element e, Document doc) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onWrite(UIEdit edit, Element e, Document doc) throws Exception
	{
		
	}
	@Override
	public void readComplete(UIEdit edit) {}
	@Override
	public void writeBefore(UIEdit edit) {}
}