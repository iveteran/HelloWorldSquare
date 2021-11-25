#include <iostream>
#include <map>
#include <functional>
using namespace std;
 
// 普通函数
int add(int i, int j) { return i + j; }

// lambda表达式
auto mod = [](int i, int j){return i % j; };

// 函数对象类
struct divide
{
	int operator() (int denominator, int divisor)
	{
		return denominator / divisor;
	}
};
 
int main(int argc, char *argv[])
{
	// 受限的map
	map<char, int(*)(int, int)> binops_limit;
	binops_limit.insert({ '+', add });
	binops_limit.insert({ '%', mod });
	// binops_limit.insert({ '%', divide() });
 
	// 更灵活的map
	map<char, function<int(int, int)>> binops = 
	{
		{ '+', add },
		{ '-', minus<int>() },
		{ '*', [](int i, int j) {return i * j; } },
		{ '/', divide() },
		{ '%', mod },
	};
	cout << binops['+'](10, 5) << endl;
	cout << binops['-'](10, 5) << endl;
	cout << binops['*'](10, 5) << endl;
	cout << binops['/'](10, 5) << endl;
	cout << binops['%'](10, 5) << endl;

	return 0;
}
