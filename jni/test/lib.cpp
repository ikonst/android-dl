extern "C" {

int hiddenfunc()
{
}

__attribute__ ((visibility("default")))
int testfunc()
{
	return 42;
}

}
