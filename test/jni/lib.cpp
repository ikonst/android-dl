extern "C" {

int hiddenfunc()
{
    return 1;
}

__attribute__ ((visibility("default")))
int testfunc()
{
	return 42;
}

__attribute__ ((visibility("default")))
int testfunc_dlcall(int argc, const char* argv)
{
	return argc;
}

}
