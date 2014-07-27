package com.github.ikonst.android_dl.test;

import junit.framework.Assert;

import com.github.ikonst.android_dl.AndroidDl;

import android.test.AndroidTestCase;

public class AndroidDlTest extends AndroidTestCase {
	String libDir;
	
	long handle;
	
	@Override
	protected void setUp() {
		libDir = getContext().getApplicationInfo().nativeLibraryDir;
		
		assertTrue(AndroidDl.initialize(libDir));
		
		handle = AndroidDl.dlopen("libandroid-dl_testlib.so");
	}
	
	public void testInitializeInvalidArgument()
	{
		try {
			AndroidDl.initialize(null);
			Assert.fail();
		}
		catch(IllegalArgumentException ex) {}
	}
	
	public void testDlopenFail() {
		try {
			AndroidDl.dlopen("libnonexistent.so");
			Assert.fail();
		}
		catch(UnsatisfiedLinkError ex) {}
	}
	
	public void testDlcall() {
	    long testfunc = AndroidDl.dlsym(handle, "testfunc_dlcall");
	    
	    // Call the function
	    String[] testfuncArgs = new String[] { "foo", "bar", "baz" };
		long ret = AndroidDl.dlcall(testfunc, testfuncArgs);
	    assertEquals(ret, testfuncArgs.length);
	}
	
	public void testDlsymNonexistent() {
		try {
		    // This function does not exist in the compilation unit
			AndroidDl.dlsym(handle, "nonexistentfunc");
			Assert.fail();
		}
		catch(UnsatisfiedLinkError ex) {}
	}
	
	public void testDlsymHidden() {
		try {
		    // This symbol is hidden in the compilation unit
			AndroidDl.dlsym(handle, "hiddenfunc");
			Assert.fail();
		}
		catch(UnsatisfiedLinkError ex) {}
	}
	
	public void testDlNeeds() {
		String[] needs = AndroidDl.dlneeds(libDir + "/libandroid-dl.so");
		assertEquals(5, needs.length);
		assertEquals("liblog.so", needs[0]);
		assertEquals("libstdc++.so", needs[1]);
		assertEquals("libm.so", needs[2]);
		assertEquals("libc.so", needs[3]);
		assertEquals("libdl.so", needs[4]);
	}
	
	public void testDlNeedsInvalidArgument() {
		try {
			AndroidDl.dlneeds(null);
			Assert.fail();
		}
		catch(IllegalArgumentException ex) {}
	}
}
