#include "ida-chooser.h"

using namespace std;


int main(int argc, char** argv)
{

	if (is_first_run())
	{
		string input;
		cout << "Path to IDA folder: ";
		getline(cin, input);
		input = trim(input);
		set_ida_path(input);
	}
	string ida_path = get_ida_path();
	if (get_arch(argv[1]) == 0x8664)
	{
		ida_path = ida_path += "\\ida64.exe\" ";
	}
	else if (get_arch(argv[1]) == 0x14c)
	{
		ida_path = ida_path += "\\ida.exe\"  ";
	}

	system(("\"" + ida_path + argv[1]).c_str());
	return 0;
}






